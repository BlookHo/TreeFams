module SearchSoft
  extend ActiveSupport::Concern
  include SearchHelper

  def start_search_soft    # Запуск мягкого поиска для объединения

    connected_author_arr = self.get_connected_users # Состав объединенного дерева в виде массива id
    author_tree_arr = get_connected_tree(connected_author_arr) # Массив объединенного дерева из Tree
    qty_of_tree_profiles = author_tree_arr.map {|p| p[4] }.uniq.size # Кол-во профилей в объед-ном дереве - для отображения на Главной

   #author_tree_arr = # DEBUGG_TO_VIEW
   # [
 #   ]

   #     [
        #]

    logger.info "======================= RUN start_search ========================= "
    logger.info "Общее задание на поиск от зарег-го Юзера - весь массив заданий (author_tree_arr)"
    logger.info "#{author_tree_arr}"

    search_profiles_from_tree(connected_author_arr, author_tree_arr) # Основной поиск по дереву Автора среди деревьев в ProfileKeys.

    results = {
      final_reduced_profiles_hash: @final_reduced_profiles_hash,
      final_reduced_relations_hash: @final_reduced_relations_hash,
      wide_user_ids_arr: @wide_user_ids_arr,
      connected_author_arr: connected_author_arr,
      qty_of_tree_profiles: qty_of_tree_profiles
    }

    return results
  end

  # Основной поиск по дереву Автора - Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_profiles_from_tree(connected_users_arr, tree_arr)

    @tree_arr_len = tree_arr.length  # DEBUGG TO VIEW
    @tree_to_display = []
    @tree_row = []

    #@type_search_message = "Работает SEARCH_SOFT"

    ##### Будущие результаты поиска
    @all_match_trees_arr = []     # Массив совпадений деревьев
    @all_match_profiles_arr = []  # Массив совпадений профилей
    @all_match_relations_arr = []  # Массив совпадений отношений
    #####

    # Исп-ся в hard_search - может еще где
    @all_wide_match_profiles_arr = []     # Широкий Массив совпадений профилей
    @all_wide_match_relations_arr = []     # Широкий Массив совпадений отношений
    @all_searched_n_found_profiles_hash = []  # Широкий Массив совпадений профилей
    @all_pos_profiles_arr = []          # Широкий Массив совпадений профилей
    @all_neg_profiles_arr = []          # Широкий Массив НЕ совпадений профилей

    @hard_search_result_profiles = []     #
    @hard_search_result_relations = []     #
    @all_found_profiles_arr = []  # Итоговый массив найденных профилей

    @relation_id_searched_arr = []     #_DEBUGG_TO_VIEW Ok

    logger.info "======================= Запуск цикла поиска по всему массиву заданий ========================= "
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
        logger.info " "
        logger.info "***** ПОИСК: #{i+1}-я ИТЕРАЦИЯ in search_profiles_from_tree*** Ищем по этому элементу из дерева Юзера: tree_arr[i] = #{tree_arr[i]}"
        logger.info "***** из дерева (объед-х деревьев): #{connected_users_arr}; От профиля: #{from_profile_searching};  Ищем профиль: #{profile_id_searched};"
        logger.info "***** от имени (name_id): #{name_id_searched}; ищем отношение (relation_id) = #{relation_id_searched}, Ищем имя (is_name_id) = #{is_name_id_searched}  "

        ###############  ЗАПУСК ОБЫЧНОГО МЯГКОГО ПОИСКА ДЛЯ ОТОБРАЖЕНИЯ РЕЗУЛЬТАТОВ
        soft_search_match(connected_users_arr, from_profile_searching, profile_id_searched, relation_id_searched)       # На выходе: @all_match_arr по данному дереву

      end
    end


    logger.info "=========== После всего цикла по tree_arr - результат поиска: @all_wide_match_profiles_arr = #{@all_wide_match_profiles_arr}"

    #### расширенные РЕЗУЛЬТАТЫ ПОИСКА:
    if !@all_wide_match_profiles_arr.blank?
      #### PROFILES
      all_wide_match_hash = join_arr_of_hashes(@all_wide_match_profiles_arr) if !@all_wide_match_profiles_arr.blank?  # Если найдены совпадения - в @all_match_arr
      #@all_wide_match_hash = all_wide_match_hash  #_DEBUGG_TO_VIEW
      @all_wide_match_arr_sorted = Hash[all_wide_match_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      # DIFFERENCE W/FIRST SEARCH
      #@complete_hash = make_complete_hash(@all_wide_match_arr_sorted)  #_DEBUGG_TO_VIEW

      logger.info "********** Формирование итогового результата **************"
      logger.info "********** @all_wide_match_arr_sorted = #{@all_wide_match_arr_sorted} "
      # @final_reduced_profiles_hash = итоговый Хаш массивов найденных профилей
      # Здесь - исключаем из результатов - те, в кот-х найдено всего одно совпадение
      # см. метод reduce_hash
      # То же - симметрично повторяется для relations
      @final_reduced_profiles_hash = reduce_hash(make_complete_hash(@all_wide_match_arr_sorted))  # TO VIEW
      logger.info "********** @final_reduced_profiles_hash = #{@final_reduced_profiles_hash} "

      # @wide_user_ids_arr = итоговый массив найденных деревьев
      @wide_user_ids_arr = @final_reduced_profiles_hash.keys.flatten  #

      # @wide_profile_ids_arr = итоговый массив хашей найденных профилей
      @wide_profile_ids_arr = @final_reduced_profiles_hash.values.flatten #

      # @wide_amount_of_profiles = Подсчет количества найденных Профилей в массиве Хэшей
      @wide_amount_of_profiles = count_profiles_in_hash(@wide_profile_ids_arr)

      #### RELATIONS
      all_wide_match_relations_hash = join_arr_of_hashes(@all_wide_match_relations_arr) if !@all_wide_match_relations_arr.blank?  # Если найдены совпадения - в @all_match_arr
      @all_wide_match_relations_sorted = Hash[all_wide_match_relations_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      #@complete_relations_hash = make_complete_hash(@all_wide_match_relations_sorted)

      @final_reduced_relations_hash = reduce_hash(make_complete_hash(@all_wide_match_relations_sorted))  # TO VIEW
      logger.info "********** @final_reduced_relations_hash = #{@final_reduced_relations_hash} "

      #@relation_ids_arr = @all_match_relations_sorted.values.flatten # TO VIEW
      #@all_match_relations_hash = all_match_relations_hash # TO VIEW
      #count_users_found(profile_ids_arr) # TO VIEW

    else
      @final_reduced_profiles_hash = []
      @final_reduced_relations_hash = []
      @wide_user_ids_arr = []
    end

  end


  # На выходе ближний круг для профиля в дереве user_id
  # по записям в ProfileKey
  def profile_near_circle(user_ids, profile_id)
    Tree.where(user_id: user_ids).where("profile_id = #{profile_id} or is_profile_id = #{profile_id}").order('relation_id').includes(:name)
  end



  # ВАЖНО! Исключение из Хэша результатов тех элементов,
  # которые отсутствуют в массиве отобранных профилей по-жесткому
  def main_exclude_search_hashes(input_profiles_hash, input_relations_hash, profiles_array)
   new_search_profiles_arr = []
   new_search_relations_arr = []
   test_array = profiles_array
   input_profiles_hash.each_with_index do |k, index| #,val_hash|
     one_elem_value_hash = k.values[0].values.flatten[0]
     if test_array.include?(one_elem_value_hash)
       new_search_profiles_arr << k
       new_search_relations_arr << input_relations_hash[index]
       test_array = test_array - [one_elem_value_hash]
     end
     logger.info " *** k = #{k}, test_array = #{test_array}, one_elem_value_hash = #{one_elem_value_hash}"
     logger.info " *** new_search_profiles_arr = #{new_search_profiles_arr}"
     logger.info " *** new_search_relations_arr = #{new_search_relations_arr}"
   end

   logger.info " *** new_search_profiles_arr = #{new_search_profiles_arr}"
   logger.info " *** new_search_relations_arr = #{new_search_relations_arr}"

   return new_search_profiles_arr, new_search_relations_arr
 end


def find_right_profile(tree_row)

  res_hash = Hash.new  # Hash найденных профилей = {profile_id => qty}
  trees_res_hash = Hash.new  # Hash найденных профилей = {tree => {profile_id => qty}} для одной записи из all_profile_rows

  fill_hash(res_hash, tree_row.profile_id) # наполнение хэша найденными profile_id и частотой их обнаружения = 1
  # Формирование ХЭШа с результатами: Сколько раз какой профиль был найден.
  #logger.info "=== Hash найденных профилей: #{res_hash} "
  trees_res_hash.merge!({tree_row.user_id  => res_hash } ) # наполнение хэша накопленные Hash найденных профилей: #{res_hash}
  #logger.info "=== Trees Hash найденных профилей: #{trees_res_hash} "   #
  # Его структура: {tree_id => {profile_id => частота появления profile_id в рез-тах поиска}}/

  # ВАЖНЫЙ УЧАСТОК: ОПРЕДЕЛЕНИЕ ПРАВИЛЬНОГО ПРОФИЛЯ В КАЧЕСТВЕ СООТВЕТСТВИЯ ИСКОМОМУ
  trees_res_hash.each_pair {|key,val_hash|  key == tree_row.user_id; qty_arr = val_hash.values
  max_qty = qty_arr.sort.last
  right_profile = val_hash.key(max_qty)
  #logger.info "=== Из Trees Hash : @right_profile = #{right_profile}"
  @right_profile_id = right_profile
  }

  return @right_profile_id

end


  # Поиск совпадений для одного из профилей БК current_user
  # Берем параметр: profile_id из массива  = profiles_tree_arr[i][6].
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # На выходе: @all_match_arr по данному виду родства
  def soft_search_match(connected_users, from_profile_searching, profile_id_searched, relation_id_searched)

    found_trees_hash = Hash.new     #{ 0 => []}
    all_relation_match_arr = []     #

       wide_found_profiles_arr = Array.new  #
       wide_found_relations_arr = Array.new  #

    wide_found_profiles_hash = Hash.new  #
    wide_found_relations_hash = Hash.new  #
       logger.info " "
       logger.info "     IN get_relation_match "
       logger.info " "

    all_profile_rows = ProfileKey.where(:user_id => connected_users).where(:profile_id => profile_id_searched).select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id, :id)
    # поиск массива записей ближнего круга для каждого профиля в дереве Юзера
       logger.info "Все записи об ИСКОМОМ ПРОФИЛЕ = #{profile_id_searched.inspect} в (объединенном) дереве зарег-го Юзера"
       show_in_logger(all_profile_rows, "all_profile_rows - запись" )  # DEBUGG_TO_LOGG
    qty_of_results = 0 # Начало подсчета результатов поиска (сумма успешных поисков в противоположном дереве)

    #@search_exclude_users = [85,86,87,88,89,90,91,92] # временный массив исключения косых юзеров из поиска DEBUGG_TO_VIEW
    @search_exclude_users = [] # временный массив исключения косых юзеров из поиска DEBUGG_TO_LOGG
    # убрать потом !!!

    all_profile_rows_No = 1
    if !all_profile_rows.blank?
      @all_profile_rows_len = all_profile_rows.length if !all_profile_rows.blank? #DEBUGG_TO_LOGG
      # размер ближнего круга профиля в дереве current_user.id
           logger.info "кол-во всех записей об ИСКОМОМ ПРОФИЛЕ @all_profile_rows_len = #{@all_profile_rows_len}"
      # DIFFERENCE W/FIRST SEARCH
      row_arr = []   # DEBUGG_TO_LOGG
      res_hash = Hash.new

      all_profile_rows.each do |relation_row|
               logger.info " "
               logger.info "=== ПОИСК по записи № #{all_profile_rows_No}: #{relation_row.attributes.inspect}"

        relation_match_arr = ProfileKey.where.not(user_id: @search_exclude_users).where.not(user_id: connected_users).where(:name_id => relation_row.name_id, :relation_id => relation_row.relation_id, :is_name_id => relation_row.is_name_id).select(:id, :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
        if !relation_match_arr.blank?
          # DIFFERENCE W/FIRST SEARCH
           logger.info "=== Есть результаты! найдено #{relation_match_arr.size} результатов в деревьях сайта (см. ниже список записей) "
           show_in_logger(relation_match_arr, "=== результат" )  # DEBUGG_TO_LOGG
           logger.info "=== Цикл по найденным результатам ==="
          relation_match_arr_row_no = 1  # DEBUGG_TO_LOGG

          relation_match_arr.each do |tree_row|
             logger.info "=== === в результате #{relation_match_arr_row_no} НАЙДЕН ТРИПЛЕКС : name_id = #{tree_row.name_id}, relation_id = #{tree_row.relation_id}, is_name_id = #{tree_row.is_name_id}   (profile_id = #{tree_row.profile_id}, is_profile_id = #{tree_row.is_profile_id}) "
             logger.debug "=== === === СОХРАНЕНИЕ РЕЗ-ТОВ поиска по результату № #{relation_match_arr_row_no} "
             row_arr << tree_row.profile_id  # DEBUGG_TO_LOGG
             qty_of_results += 1   # DEBUGG_TO_LOGG

             fill_hash(res_hash, tree_row.profile_id) # наполнение хэша найденными profile_id и частотой их обнаружения
               # Формирование ХЭШа с результатами: Сколько раз какой профиль был найден.
             logger.info "=== === === накопленные: Hash найденных профилей: #{res_hash}, общее кол-во сохранений результатов = #{qty_of_results}  "
             logger.info "=== === === !!! ДЛЯ ИСКОМОГО ПРОФИЛЯ #{profile_id_searched.inspect} - НАЙДЕН ПРОФИЛЬ #{tree_row.profile_id} !!! "
             logger.info "=== === === накопленные: массив найденных профилей: #{row_arr} "# ", кол-во результатов = #{relation_match_arr_row_no}  "

              # В СИТУАЦИИ КОГДА ПОЯВЛЯЕТСЯ МНОЖЕСТВО ВАРИАНТОВ ПРОФИЛЕЙ tree_row.profile_id В КАЧ-ВЕ РЕЗ-ТА ПОИСКА
              # ЗДЕСЬ - АНАЛИЗ И ВЫБОР ПРАВИЛЬНОГО ПРОФИЛЯ ДЛЯ ЗАПИСИ В ХЭШ wide_found_profiles_hash РЕЗУЛЬТАТОВ
              #
              # В НАСТОЯЩИЙ МОМЕНТ - ПРАВИЛЬНЫЙ ПРОФИЛЬ ТОТ,
              # ЧТО БЫЛ НАЙДЕН МАКСИМАЛЬНОЕ ЧИСЛО РАЗ ПО СРАВНЕНИЮ С ДРУГИМИ
              # ЕСЛИ ЭТОГО НЕ ДЕЛАТЬ, ТО В РЕЗ-ТИР-Й ХЭШ wide_found_profiles_hash ЗАПИШЕТСЯ ПОСЛЕДНИЙ ИЗ НАЙДЕННЫХ ПРОФИЛЕЙ,
              # НЕСМОТРЯ НА ТО, ЧТО ОН МОЖЕТ БЫЛ НАЙДЕН ВСЕГО 1 РАЗ. КОГДА ДРУГИЕ ПРОФИЛИ - БОЛЬШЕЕ ЧИСЛО РАЗ.
              # (ТАК РАБОТАЕТ merge)
              # .
              # СЕЙЧАС СДЕЛАНО ТАК:
              # ПРОИСХОДИТ СОРТИРОВКА НАКОПЛЕННОГО ХЭША res_hash ПО ЗНАЧЕНИЮ ВСТРЕЧАЕМОСТИ ПРОФИЛЯ
              # и извлечение последнего, т.к. м.б. несколько с макс-м значением (?) - ПРЕДПОЛОЖЕНИЕ
              #
              right_profile_key = res_hash.sort{|a,b| a[1] <=> b[1]}.last[0]  # KEY последний в отсортированном Хэше по value
                         logger.info "=== === === === === определен ТЕКУЩИЙ правильный profile_id : right_profile_key = #{right_profile_key} для записи в окончательный рез-тат - в wide_found_profiles_hash"
              # в принципе здесь ВМЕСТО ЭТОГО ВОЗМОЖНО ПОТРЕБУЕТСЯ более ТОЧНЫЙ анализ по определению правильного ПРОФИЛЯ - рез-та поиска
              # НУЖНО БУДЕТ АНАЛИЗИРОВАТЬ НАЛИЧИЕ ДРУГИХ СВЯЗЕЙ КАЖДОГО ИЗ НАЙДЕННЫХ ПРОФИЛЕЙ
              #
              # В ПРИНЦИПЕ, ЧАСТОТА ИХ (ПРОФИЛЕЙ) ОБНАРУЖЕНИЯ, КОТ. ЗАПИСАНА В ХЭШЕ res_hash - ЭТО И ЕСТЬ ПОДТВЕРЖДЕНИЕ ТОГО, ЧТО
              # В ПОИСКЕ СРАБОТАЛИ СООТВ-Е КОЛ-ВО ИМЕЮЩИХСЯ СВЯЗЕЙ (см.res_hash).
              # ПРОБЛЕМА МОЖЕТ БЫТЬ ЕСЛИ ЧАСТОТА ОБНАРУЖЕНИЯ РАЗНЫХ ПРОФИЛЕЙ БУДЕТ ОДИНАКОВА
              # ТОГДА НАДО ВЫЯСНЯТЬ СИТУАЦИЮ МЕЖДУ ЭТИМИ РАВНОНАЙДЕННЫМИ ПРОФИЛЯМИ
                     # НО ЭТО - СЛЕДУЮЩАЯ ЗАДАЧА
             fill_hash(found_trees_hash, tree_row.user_id) # наполнение хэша найденными user_id = trees и частотой их обнаружения
             #logger.info "=== === === found_trees_hash = #{found_trees_hash} "

             wide_found_profiles_arr << {from_profile_searching => [right_profile_key]} # DEBUGG_TO_LOGG
             wide_found_relations_arr << {from_profile_searching => [relation_id_searched]} # DEBUGG_TO_LOGG

              wide_found_profiles_hash.merge!({tree_row.user_id  => {from_profile_searching => [right_profile_key]} } ) # наполнение хэша найденными profile_id
              wide_found_relations_hash.merge!({tree_row.user_id  => {from_profile_searching => [relation_id_searched]} } ) # наполнение хэша найденными relation_id
             logger.info "=== === обработан результат № #{relation_match_arr_row_no} из relation_match_arr"
             logger.info "=== === промежуточный итог обработки: накопленное кол-во успешных поисков для итерации qty_of_results = #{qty_of_results}, found_trees_hash = #{found_trees_hash},"
             logger.info "=== === wide_found_profiles_hash = #{wide_found_profiles_hash}, wide_found_relations_hash = #{wide_found_relations_hash}"
             logger.info "=== === wide_found_profiles_arr = #{wide_found_profiles_arr}, wide_found_relations_arr = #{wide_found_relations_arr}"
             relation_match_arr_row_no += 1  # подсчет кол-ва рядов в relation_match_arr, которые входят в результат по очереди

             # КРОМЕ ТОГО, ДЛЯ ЧИСТОТЫ: НУЖНО УМЕНЬШАТЬ в found_trees_hash КОЛ-ВО РАЗ, КОГДА В ДАННОМ ДЕРЕВЕ tree_row.user_id
             # НАЙДЕН РЕЗУЛЬТАТ, НА ВЕЛИЧИНУ РЕЗ-ТОВ, КОТОРЫЕ ОТКИНУТЫ КАК НЕВЕРНЫЕ ПРИ ОПРЕДЕЛЕНИИ ТЕКУЩЕГО ПРАВИЛЬНОГО ПРОФИЛЯ
             # Т.Е. НУЖНО ВЫДЕЛИТЬ КОЛ-ВО РАЗ ПОЯВЛЕНИЯ ПРАВИЛЬНОГО ПРОФИЛЯ В ХЭШЕ РЕЗ-ТОВ res_hash =  {4=>4, 7=>1},
             # ЭТО ЗДЕСЬ РАВНО 4 И ЗАНЕСТИ ЭТО ЗНАЧЕНИЕ в found_trees_hash, ЧТОБЫ ВМЕСТО {1=>5} СТАЛО
             # found_trees_hash = {1=>4}. Т.К. ИМЕННО 4 РАЗА БЫЛ НАЙДЕН ПРАВИЛЬНЫЙ ПРОФИЛЬ В ДЕРЕВЕ 1
             # А 1 РАЗ - БЫЛ НАЙДЕН НЕПРАВИЛЬНЫЙ
             # ЭТО СДЕЛАНО НИЖЕ! /

             logger.info "=== === Корректировка found_trees_hash в завис-ти от res_hash :"
             new_val = res_hash.values_at(right_profile_key)[0]
             # найти дерево, в котором сидит правильный профиль - для случая объединенных
             tree_id = Profile.find(right_profile_key).tree_id
             found_trees_hash.merge!(tree_id  => new_val)
             # наполнение хэша найденными profile_id
             logger.info "!!!!!  === === new found_trees_hash = #{found_trees_hash} (tree_id = #{tree_id} === === #{new_val})"

          end
          # Показ результатов
          logger.info " "
          logger.info "=== После ПОИСКА по записи № #{all_profile_rows_No} и записи рез-тов: ХЭШ рез-тов: res_hash = #{res_hash}, qty_of_results = #{qty_of_results} "

        else
          logger.info "=== НЕТ результата! В деревьях сайта ничего не найдено! === "
        end
        # Здесь: анализ накопленного массива найденных row_arr
        all_profile_rows_No += 1 # Подсчет номера по порядку очередной записи об искомом профиле

      end

      ##### НАСТРОЙКИ результатов поиска - ТРЕБУЕТСЯ НОВОЕ ОСОЗНАНИЕ!
      # Исключение тех user_id, по которым не все запросы дали результат внутри Ближнего круга
      # Остаются те user_id, в которых найдены совпавшие профили.
      # На выходе ХЭШ: {user_id  => кол-во успешных поисков } - должно быть равно (не меньше) длине массива
      # всех видов отношений в блжнем круге для разыскиваемого профиля.
      if relation_id_searched != 0 # Для всех профилей, кот-е не явл. current_user
        # Исключение из результатов поиска
        if all_profile_rows.length > 4

          found_trees_hash.delete_if {|key, value|  value <= 2 } # <=2 all_profile_rows.length - 1 } #
        #  found_trees_hash.delete_if {|key, value|  value < all_profile_rows.length } #
          # all_profile_rows.length = размер ближнего круга профиля в дереве current_user.id
        else
          #  # Если маленький БК
          found_trees_hash.delete_if {|key, value|  value <= 1  }  # <= 1 = НАСТРОЙКА!!
        end

      else
        if all_profile_rows.length > 3 #<= 3
          found_trees_hash.delete_if {|key, value|  value <= 2 } #<= 2   all_profile_rows.length  }  # 1 .. 3 = НАСТРОЙКА!!
          #  # Исключение из результатов поиска групп с малым кол-вом совпадений в других деревьях or value < all_profile_rows.length
        else
          #  # Если маленький БК
          found_trees_hash.delete_if {|key, value|  value <= 1  }  # <= 1   .. 2 = НАСТРОЙКА!!
        end

      end

    end
    logger.info " *** настройка рез-тов поиска в get_relation_match: found_trees_hash = #{found_trees_hash} "
    ##### КОРРЕКТИРОВКА результатов поиска на основе настройки результатов поиска - см.выше
    wide_found_profiles_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
    # На выходе ХЭШ: {user_id  => profile_id} - найденные деревья с найденным профилем в них.
    @wide_found_profiles_hash = wide_found_profiles_hash

    wide_found_relations_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
    logger.info " *** после настройки рез-тов поиска: wide_found_profiles_hash = #{wide_found_profiles_hash}, wide_found_relations_hash = #{wide_found_relations_hash}"

    ##### ИТОГОВЫЕ РАСШИРЕННЫЕ результаты поиска
    @all_wide_match_profiles_arr << wide_found_profiles_hash if !wide_found_profiles_hash.blank? # Заполнение выходного массива хэшей
    @all_wide_match_relations_arr << wide_found_relations_hash if !wide_found_relations_hash.empty? # Заполнение выходного массива хэшей
    logger.info " *** РЕЗУЛЬТАТ ПОИСКА из get_relation_match: @all_wide_match_profiles_arr = #{@all_wide_match_profiles_arr}"

    #@found_profiles_hash = found_profiles_hash # DEBUGG TO VIEW
    #@found_relations_hash = found_relations_hash # DEBUGG TO VIEW
    #@found_trees_hash = found_trees_hash # DEBUGG TO VIEW
    #@all_profile_rows = all_profile_rows   # DEBUGG TO VIEW
    #@all_relation_match_arr = all_relation_match_arr   ## DEBUGG TO VIEW
    #@wide_found_profiles_hash = wide_found_profiles_hash # DEBUGG TO VIEW
    #@wide_found_relations_hash = wide_found_relations_hash # DEBUGG TO VIEW

  end






end # End of search_soft module
