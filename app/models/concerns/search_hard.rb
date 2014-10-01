module SearchHard
  extend ActiveSupport::Concern
  include SearchHelper

  #####  Запуск ЖЕСТКОГО поиска

  def start_hard_search # Запуск жесткого поиска для объединения

    connected_author_arr = self.get_connected_users # Состав объединенного дерева в виде массива id
    author_tree_arr = get_connected_tree(connected_author_arr) # Массив объединенного дерева из Tree
 #   qty_of_tree_profiles = author_tree_arr.map {|p| p[4] }.uniq.size # Кол-во профилей в объед-ном дереве - для отображения на Главной

    #author_tree_arr = # DEBUGG_TO_VIEW
    # [ # from 3 to 4
    #[3, 16, 123, 0, 16, 123, 1, false],
    #[3, 16, 123, 1, 17, 123, 1, false],
    #[3, 16, 123, 2, 18, 98, 0, false],
    #    [3, 16, 123, 5, 19, 130, 1, false],
    #[3, 16, 123, 5, 20, 125, 1, false],
    #[3, 16, 123, 8, 21, 84, 0, false],
    #[3, 16, 123, 3, 22, 123, 1, false],
    #[3, 16, 123, 3, 23, 125, 1, false]
    #   ]
    #     [  # # from 4 to 3
    #         [4, 24, 98, 0, 24, 98, 0, false],
    #         [4, 24, 98, 1, 25, 123, 1, false]
    #     #    [4, 24, 98, 2, 26, 98, 0, false],
    #    [4, 24, 98, 7, 27, 123, 1, false],
    #    [4, 24, 98, 3, 28, 123, 1, false],
    #    [4, 24, 98, 3, 29, 125, 1, false],
    #    [4, 24, 98, 3, 30, 130, 1, false],
    #    [4, 29, 125, 8, 31, 48, 0, false],
    #    [4, 28, 123, 8, 34, 84, 0, false],
    #    [4, 28, 123, 3, 35, 125, 1, false]
    #]

    logger.info "======================= RUN start_search ========================= "
    logger.info "Общее задание на поиск от зарег-го Юзера - весь массив заданий (author_tree_arr)"
    logger.info "#{author_tree_arr}"

    hard_search_profiles_from_tree(connected_author_arr, author_tree_arr) # Основной поиск по дереву Автора среди деревьев в ProfileKeys.

    results = {
        final_hard_profiles_to_connect_hash: @final_hard_profiles_to_connect_hash,
        final_pos_profiles_arr: @final_pos_profiles_arr,
        final_profiles_searched_arr: @final_profiles_searched_arr,
        final_profiles_found_arr: @final_profiles_found_arr,
        final_search_profiles_step_arr: @final_search_profiles_step_arr,
        final_found_profiles_step_arr: @final_found_profiles_step_arr
    }

    return results
  end

  #####  Запуск ЖЕСТКОГО поиска
  # Основной поиск по дереву Автора - Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def hard_search_profiles_from_tree(connected_users_arr, tree_arr)

    @tree_arr_len = tree_arr.length  # DEBUGG TO VIEW
    @tree_to_display = []
    @tree_row = []

    ##### Будущие результаты поиска? Исп-ся в hard_search - может еще где

    ############### Используется в Search_Hard #########################
    @final_pos_profiles_arr = []            # # # Широкий Массив совпадений профилей
    @final_neg_profiles_arr = []            # # # Широкий Массив НЕ совпадений профилей
    @final_searched_and_found_profiles_arr = []  # ????? На выходе - Зачем так?
    #  @final_searched_and_found_profiles_arr = [{17=>27, 16=>28, 20=>29, 19=>30, 18=>24}, {19=>30, 17=>27, 18=>24, 16=>28, 20=>29}]
    @final_profiles_searched_arr = []       # # #
    @final_profiles_found_arr = []          # # #

    ################ Передается To connection#############################################
    @final_hard_profiles_to_connect_hash = {}   # # # Итоговый ХЭШ профилей для соединения после search_hard
    @final_search_profiles_step_arr = []        # To connection
    @final_found_profiles_step_arr = []         # To connection
    #####################################################################

    logger.info "======================= Запуск цикла ЖЕСТКОГО поиска по всему массиву заданий ========================= "
    if !tree_arr.blank?
      for i in 0 .. tree_arr.length-1
        # Структура эл-та массива   32, 212, 419, 1, 213, 196, 1, false]
        #                               1        3   4
        from_profile_searching = tree_arr[i][1] # От какого профиля осущ-ся Поиск
        name_id_searched = tree_arr[i][2] # Имя Профиля
        relation_id_searched = tree_arr[i][3] # Искомое relation_id К_Профиля
        profile_id_searched = tree_arr[i][4] # Поиск по ID К_Профиля
        is_name_id_searched = tree_arr[i][5] # Искомое Имя К_Профиля
        logger.info " "
        logger.info "***** ПОИСК: #{i+1}-я ИТЕРАЦИЯ in search_profiles_from_tree*** Ищем по этому элементу из дерева Юзера: tree_arr[i] = #{tree_arr[i]}"
        logger.info "***** из дерева (объед-х деревьев): #{connected_users_arr}; От профиля: #{from_profile_searching};  Ищем профиль: #{profile_id_searched};"
        logger.info "***** от имени (name_id): #{name_id_searched}; ищем отношение (relation_id) = #{relation_id_searched}, Ищем имя (is_name_id) = #{is_name_id_searched}  "

        ###############  ЗАПУСК ЖЕСТКОГО ПОИСКА ДЛЯ ОБЪЕДИНЕНИЯ ДЕРЕВЬЕВ
        hard_search_match(connected_users_arr, from_profile_searching, profile_id_searched, relation_id_searched)       # На выходе:
        ################################################################
      end
    end

    logger.info ""
    logger.info "=========== После всего цикла по tree_arr - итоговый результат поиска: @final_pos_profiles_arr = #{@final_pos_profiles_arr}"
    logger.info "=========== ПЕРЕД ПЕРЕХОДОМ В CONNECTION "

    ####  ОБРАБОТКА РЕЗУЛЬТАТОВ ПОИСКА:
    if !@final_pos_profiles_arr.blank?  # Если были найдены полож-е рез-ты

      # Итоговый массив жестко УСПЕШНО позитивно проверенных по БК профилей ДЛЯ ОДНОЙ ИТЕРАЦИИ
      @final_pos_profiles_arr = @final_pos_profiles_arr.flatten(1)
      logger.info "********** @final_pos_profiles_arr = #{@final_pos_profiles_arr}"
      logger.info "********** @final_searched_and_found_profiles_arr = #{@final_searched_and_found_profiles_arr}"

      # Сбор массивов пар профилей из итогового Хэша по итогам search_hard
      profiles_searched_arr = []     #
      profiles_found_arr  = []     #
      @final_searched_and_found_profiles_arr.each do |one_hash|
          profiles_searched_arr << one_hash.keys
          profiles_found_arr << one_hash.values
      end

      # Выравнивание массивов
      profiles_searched_arr = profiles_searched_arr.flatten(1)
      profiles_found_arr = profiles_found_arr.flatten(1)
      logger.info "********** profiles_searched_arr = #{profiles_searched_arr}, profiles_found_arr = #{profiles_found_arr}, "

      # Исключение повторов пар искомых-найденных профилей в массивах
      profiles_searched_arr.each_with_index do |one_profile, index|
        if !@final_profiles_searched_arr.include?(one_profile)
          @final_profiles_searched_arr << one_profile
          @final_profiles_found_arr << profiles_found_arr[index]
          @final_hard_profiles_to_connect_hash.merge!({one_profile => profiles_found_arr[index]}) # make new el-t of hash
        end
      end
      logger.info ""
      logger.info "********** @final_pos_profiles_arr = #{@final_pos_profiles_arr}"
      logger.info "********** @final_profiles_searched_arr = #{@final_profiles_searched_arr}, @final_profiles_found_arr = #{@final_profiles_found_arr}, "
      logger.info "********** @final_hard_profiles_to_connect_hash = #{@final_hard_profiles_to_connect_hash}"

      @final_search_profiles_step_arr, @final_found_profiles_step_arr = get_step_arrs(@final_pos_profiles_arr, @final_hard_profiles_to_connect_hash)
      logger.info "@final_search_profiles_step_arr = #{@final_search_profiles_step_arr}, @final_found_profiles_step_arr = #{@final_found_profiles_step_arr}"

    else
      @final_pos_profiles_arr = []
      @profiles_searched_arr = []
      @profiles_found_arr = []
      logger.info "********** @profiles_searched_arr = #{@profiles_searched_arr}, @profiles_found_arr = #{@profiles_found_arr}, "
    end

  end


  #####  Запуск ЖЕСТКОГО поиска
  # ЖЕСТКИЙ Поиск совпадений для одного из профилей БК current_user
  # Берем параметр: profile_id из массива  = profiles_tree_arr[i][6].
  # Единый подход к поиску для всех relation_id
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # На выходе: @all_match_arr по данному виду родства
  def hard_search_match(connected_users, from_profile_searching, profile_id_searched, relation_id_searched)

    # Текущие Хэши - для одной итерации поиска
    #hard_search_profiles_hash = Hash.new  # Хэш найденных профилей
    #hard_search_relations_hash = Hash.new # Хэш найденных отношений - соответствущий Хэшу профилей
    searched_and_found_profiles_hash = Hash.new    #  Главный ХАШ соответствия профилей для перезаписи
    #final_trees_search_results_hash = Hash.new    # Хэш соответствий Искомого профиля - найденным. Для использования при объединении
    # По идее - не должно быть массива найденных профилей - для одного искомого
    # Это и есть некорректность, ведущая к дублированию (?).
    # Структура Хэша - { tree.id => [ { profile_searched => [ result_profile1,result_profile1] } ] }
    # New Структура Хэша - { profile_searched => [ result_profile1]} }

    logger.info " "
    logger.info "-------- СТАРТ hard_search_match для одной итерации ---------"
    all_profile_rows = ProfileKey.where(:user_id => connected_users).where(:profile_id => profile_id_searched).order('relation_id')#.select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id, :id)
    # поиск массива записей ближнего круга для каждого профиля в дереве Юзера
    logger.info "Ближний круг - Все записи об ИСКОМОМ ПРОФИЛЕ = #{profile_id_searched.inspect} в ИСХОДНОМ (объединенном) дереве зарег-го Юзера"
    show_in_logger(all_profile_rows, "all_profile_rows - запись" )  # DEBUGG_TO_LOGG

    all_profile_rows_No = 1 # текущий номер записи из all_profile_rows - для Logger
    if !all_profile_rows.blank?
      @all_profile_rows_len = all_profile_rows.length if !all_profile_rows.blank? #DEBUGG_TO_LOGG
      # размер ближнего круга профиля в дереве current_user.id
      logger.info "кол-во записей об ИСКОМОМ ПРОФИЛЕ = #{@all_profile_rows_len}"
      #res_hash = Hash.new  # Hash найденных профилей = {profile_id => qty}
      #trees_res_hash = Hash.new  # Hash найденных профилей = {tree => {profile_id => qty}} для одной записи из all_profile_rows
      go_on_all_profile_rows = true  # Признак того, что в одном из relation_match_arr не было рез-тата (blank?), значит - надо выходить из метода и итерации

      # Для исключения повторов:
      neg_profiles_arr = []# Массив профилей проверенных ДЛЯ ОДНОЙ ИТЕРАЦИИ по БК НЕ УСПЕШНО или для кот. не найден БК
      pos_profiles_arr = [] # Массив профилей проверенных ДЛЯ ОДНОЙ ИТЕРАЦИИ по БК УСПЕШНО

      all_profile_rows.each do |relation_row|
        if go_on_all_profile_rows  # ПРОВЕРКА НА ТО, ЧТО НАДО ПРЕКРАЩАТЬ ДАЛЕЕ ЦИКЛ ПО all_profile_rows
          # Т.К. НА ПРЕДЫД. ЦИКЛЕ НЕ БЫЛО хотя бы одного РЕЗ-ТА ПОИСКА В relation_match_arr/
          logger.info " "
          logger.info "=== ПОИСК ПРОФИЛЯ < #{profile_id_searched.inspect} > по записи о нем № #{all_profile_rows_No}: #{relation_row.attributes.inspect}"
          logger.info "=== ИЩЕМ: Имя = #{relation_row.name_id.inspect} --- Отношение = #{relation_row.relation_id} --- К Имени = #{relation_row.is_name_id}  "

          @search_exclude_users = [] # временный массив исключения косых юзеров из поиска DEBUGG_TO_LOGG
          relation_match_arr = ProfileKey.where.not(user_id: @search_exclude_users).where.not(user_id: connected_users).where(:name_id => relation_row.name_id, :relation_id => relation_row.relation_id, :is_name_id => relation_row.is_name_id).select(:id, :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
          if !relation_match_arr.blank?  # Значит, есть совпадения(е)  в пространстве поиска ProfileKey для 1 записи из all_profile_rows.
            show_in_logger(relation_match_arr, "=== РЕЗУЛЬТАТ ПОИСКА" )  # DEBUGG_TO_LOGG
            qty_of_results = 1  # Счетчик кол-ва циклов по найденным результатам DEBUGG_TO_LOGG
            # ОСНОВНОЙ ЦИКЛ ПОИСКА - НЕ Автора
            relation_match_arr.each do |tree_row|  # Цикл по найденным профилям (рядам из ProfileKey)
              logger.info " "
              logger.info "НАЙДЕН ПРОФИЛЬ #{tree_row.profile_id} В ДЕРЕВЕ #{tree_row.user_id} ДЛЯ ИСКОМОГО ПРОФИЛЯ #{profile_id_searched.inspect} -  "
              if !(neg_profiles_arr + pos_profiles_arr).include?(tree_row.profile_id)# Этот профиль уже проверялся ранее

                found_profile_circle = get_one_profile_BK(tree_row.profile_id, tree_row.user_id)
                #найти БК для найденного профиля tree_row.profile_id в дереве tree_row.user_id

                if !found_profile_circle.blank? # Если БК - найден
                  logger.info "=== БЛИЖНИЙ КРУГ НАЙДЕННОГО ПРОФИЛЯ = #{tree_row.profile_id} "
                  show_in_logger(found_profile_circle, "= ряд " )  # DEBUGG_TO_LOGG
                  # Преобразования БК в массивы Хэшей по аттрибутам
                  search_bk_arr, search_bk_is_profiles_arr = make_arr_hash_BK(all_profile_rows)
                  found_bk_arr, found_bk_is_profiles_arr = make_arr_hash_BK(found_profile_circle)
                  # Метод сравнения 2-х БК профилей
                  compare_rezult, rez_bk_arr = compare_two_BK(found_bk_arr,search_bk_arr)
                else
                  logger.info "БК найденного профиля - НЕ НАЙДЕН! (ПЕРЕД СРАВНЕНИЕМ ДВУХ БЛИЖНИХ КРУГОВ)"
                  compare_rezult = false  # Отрицательный рез-тат для поиска
                  logger.info "=== ОТРИЦАТЕЛЬНЫЙ результат поиска профиля #{tree_row.profile_id} "
                  logger.info "= Для профиля #{tree_row.profile_id} не найден БК - этот профиль заносим в список НЕ УСПЕШНО проверенных (с отриц.рез-том) для исключения повтора ПОИСКА"
                  neg_profiles_arr << tree_row.profile_id #
                  logger.info "=== Список НЕ УСПЕШНО проверенных профилей: neg_profiles_arr = #{neg_profiles_arr}"
                end

                if compare_rezult # БК профилей - одинаковые
                  #logger.info "   After compare_rezult CHECK"
                  logger.info "=== ПОЛОЖИТЕЛЬНЫЙ результат поиска профиля #{tree_row.profile_id} по сравнению БК с профилем #{profile_id_searched}. Оба БК - равны. Этот профиль заносим в РЕЗУЛЬТАТ и в список УСПЕШНО проверенных для исключения повтора ПОИСКА"

                  # Наполняем Главный ХАШ соответствия профилей для перезаписи
                  # Основная запись найденного профиля по совпадению БК
                  searched_and_found_profiles_hash.merge!( profile_id_searched  => tree_row.profile_id  ) # Главный ХАШ соответствия профилей для перезаписи
                  logger.info "searched_and_found_profiles_hash = #{searched_and_found_profiles_hash}"

                  # Находим массивы значений полей is_profile для обоих БК
                  # Считаем, что массивы значений полей is_profile тоже должны совпадать,
                  # как и профили с совпвшими БК.
                  searched_is_profile_arr, found_is_profile_arr = get_fields_arrays_from_bk(search_bk_is_profiles_arr, found_bk_is_profiles_arr )
                  searched_is_profile_arr = searched_is_profile_arr.flatten(1) # массив значений полей is_profile рядов БК Искомого профиля
                  found_is_profile_arr = found_is_profile_arr.flatten(1) # массив значений полей is_profile рядов БК Найденного профиля
                  logger.info "searched_is_profile_arr = #{searched_is_profile_arr}"
                  logger.info "found_is_profile_arr = #{found_is_profile_arr}"

                  def collect_equal_profiles_in_hash(found_bk_is_profiles_arr,search_bk_is_profiles_arr)
                    search_n_find_profiles_hash = Hash.new
                    search_bk_is_profiles_arr.each_with_index do |arr_el, index|
                      search_n_find_profiles_hash.merge!( { arr_el  => found_bk_is_profiles_arr[index] } ) # Главный ХАШ соответствия профилей для перезаписи
                    end
                    return search_n_find_profiles_hash
                  end

                  # Получаем Главный ХАШ соответствия профилей для перезаписи
                  # Находим Хэш значений Для 2-х массивов значений полей is_profile двух БК.
                  collected_equal_profiles_hash = collect_equal_profiles_in_hash(found_is_profile_arr,searched_is_profile_arr)
                  logger.info "search_n_find_profiles_hash = #{collected_equal_profiles_hash}"

                  pos_profiles_arr << tree_row.profile_id #
                  logger.info "=== ЗАНОСИМ В Список УСПЕШНО проверенных профилей: pos_profiles_arr = #{pos_profiles_arr}"

                  # Делать здесь:
                  #@final_search_profiles_step_arr = [[17, 19], [16, 20, 18]] # from hard_search
                  #@final_found_profiles_step_arr = [[27, 30], [28, 29, 24]] # from hard_search



                  # Дополнение массива совпавших профилей профилями из ближних кругов совпавшего профиля
                  searched_and_found_profiles_hash.merge!( collected_equal_profiles_hash ) # Главный ХАШ соответствия профилей для перезаписи
                  logger.info "searched_and_found_profiles_hash = #{searched_and_found_profiles_hash}"

                  ###########################
                else
                  #########################################################
                  logger.info "=== ОТРИЦАТЕЛЬНЫЙ результат compare_rezult CHECK поиска профиля"
                  neg_profiles_arr << tree_row.profile_id #
                  logger.info "=== Профиль #{tree_row.profile_id} заносим в список НЕ УСПЕШНО проверенных профилей: neg_profiles_arr = #{neg_profiles_arr} (с отриц.рез-том) для исключения повтора ПОИСКА"

                end
                qty_of_results += 1  # подсчет кол-ва рядов в relation_match_arr, которые входят в результат по очереди
              else
                logger.info "=== Профиль #{tree_row.profile_id} уже проверялся ранее и находится в списках УСПЕШНО и НЕ УСПЕШНО проверенных профилей: pos_profiles_arr = #{pos_profiles_arr} и neg_profiles_arr = #{neg_profiles_arr} для исключения повтора ПОИСКА"
             end

            end  # ОСНОВНОЙ ЦИКЛ ПОИСКА завершение поиска НЕ Автора

          else # relation_match_arr.blank!
            #########################################################
            logger.info "=== НЕТ результата! - ДАЛЬШЕ НЕ НУЖНО ПРОДОЛЖАТЬ С all_profile_rows!"
            logger.info "=== В деревьях сайта ничего не найдено для записи № #{all_profile_rows_No}: #{relation_row.attributes.inspect} === "
            go_on_all_profile_rows = false  # Уст-ка признака ПРОДОЛЖАТЬ в false
            logger.info "!!!!! go_on_all_profile_rows: #{go_on_all_profile_rows} "   #

          end # end if !relation_match_arr.blank?

          all_profile_rows_No += 1 # Подсчет номера по порядку очередной записи об искомом профиле

        end

      end

    end

    logger.info "НАКОПЛЕННЫЕ РЕЗУЛЬТАТЫ ПОСЛЕ ОЧЕРЕДНОЙ ОДНОЙ ИТЕРАЦИИ - ВСЕХ рядов all_profile_rows"
    logger.info "Текущий Главный Хэш искомых и найденных профилей: searched_and_found_profiles_hash = #{searched_and_found_profiles_hash}"
    logger.info "Текущий Список УСПЕШНО проверенных профилей: pos_profiles_arr = #{pos_profiles_arr}"
    logger.info "Текущий Список НЕ УСПЕШНО проверенных профилей: neg_profiles_arr = #{neg_profiles_arr}"

    # Накапливание Пар совпавших профилей @final_searched_and_found_profiles_arr:  [{17=>27, 16=>28, 20=>29, 19=>30, 18=>24}, {19=>30, 17=>27, 18=>24, 16=>28, 20=>29}]
    @final_searched_and_found_profiles_arr << searched_and_found_profiles_hash if !searched_and_found_profiles_hash.empty? # Заполнение выходного массива хэшей
    logger.info "FINAL @final_searched_and_found_profiles_arr = #{@final_searched_and_found_profiles_arr}"
    @final_pos_profiles_arr << pos_profiles_arr if !pos_profiles_arr.empty? # Заполнение выходного массива профилей проверенных ДЛЯ ОДНОЙ ИТЕРАЦИИ по БК УСПЕШНО
    logger.info "FINAL @final_pos_profiles_arr = #{@final_pos_profiles_arr}"
    @final_neg_profiles_arr << neg_profiles_arr if !neg_profiles_arr.empty? # Заполнение выходного массива профилей проверенных ДЛЯ ОДНОЙ ИТЕРАЦИИ по БК НЕ УСПЕШНО
    logger.info "FINAL @final_neg_profiles_arr = #{@final_neg_profiles_arr}"

  end # Конец метода поиска hard_search_match


  def get_step_arrs(pos_profiles_arr, profiles_to_connect_hash)
    search_profiles_step_arr = []
    found_profiles_step_arr = []
    search_step_arr1 = []
    found_step_arr1 = []
    search_step_arr2 = []
    found_step_arr2 = []
    profiles_to_connect_hash.each do |key,val|
      if pos_profiles_arr.include?(val)
        search_step_arr1 << key
        found_step_arr1 << val
      else
        search_step_arr2 << key
        found_step_arr2 << val
      end
    end
    search_profiles_step_arr << search_step_arr1
    found_profiles_step_arr << found_step_arr1
    search_profiles_step_arr << search_step_arr2
    found_profiles_step_arr << found_step_arr2

    return search_profiles_step_arr, found_profiles_step_arr
  end



end