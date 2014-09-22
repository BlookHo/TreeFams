module Search
  extend ActiveSupport::Concern
  include SearchHelper

  def start_search(certainty_koeff)    # Запуск мягкого поиска для объединения

    connected_author_arr = self.get_connected_users # Состав объединенного дерева в виде массива id
    author_tree_arr = get_connected_tree(connected_author_arr) # Массив объединенного дерева из Tree
    qty_of_tree_profiles = author_tree_arr.map {|p| p[4] }.uniq.size # Кол-во профилей в объед-ном дереве - для отображения на Главной

    #author_tree_arr = # DEBUGG_TO_VIEW
    # [
    #   ]

    logger.info "======================= RUN start_search ========================= "
    logger.info "Общее задание на поиск от зарег-го Юзера - весь массив заданий (author_tree_arr)"
    logger.info "#{author_tree_arr}"

    search_profiles_from_tree(connected_author_arr, author_tree_arr) # Основной поиск по дереву Автора среди деревьев в ProfileKeys.

    results = {
        connected_author_arr: connected_author_arr,
        qty_of_tree_profiles: qty_of_tree_profiles,
        ############################# NEW METHOD ############
        new_profiles_relations_arr: @new_profiles_relations_arr,
        new_profiles_found_arr: @new_profiles_found_arr,
        uniq_profiles_pairs_hash: @uniq_profiles_pairs_hash,
        double_profiles_pairs_hash: @double_profiles_pairs_hash
        ######################################################
    }

    return results
  end

  # Основной поиск по дереву Автора - Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_profiles_from_tree(connected_users_arr, tree_arr)

    ##### NEW METHOD ############
    @new_profiles_found_arr = []     #
    @new_profiles_to_profiles_arr = []     #

    @new_profiles_relations_arr = []     #
    @new_pairs_profiles_relations_arr = []     #

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

        ###############  ЗАПУСК НОВОГО ПОИСКА ДЛЯ ОТОБРАЖЕНИЯ РЕЗУЛЬТАТОВ
        search_match(connected_users_arr, profile_id_searched)
        # На выходе: @all_match_arr по данному дереву

      end
    end

    logger.info "=========== После всего цикла по tree_arr - результат поиска: @all_wide_match_profiles_arr = #{@all_wide_match_profiles_arr}"

    #if !@all_wide_match_profiles_arr.blank?
    #
    #
    #else

    #end

  end

  # Поиск совпадений для одного из профилей
  # Берем параметр: profile_id из массива  = profiles_tree_arr[i][6].
  # @note GET /
  # @see News
#  def search_match(connected_users, from_profile_searching, profile_id_searched, relation_id_searched)
  def search_match(connected_users, profile_id_searched)

    ############################# NEW METHODS ############
    new_found_profiles_hash = Hash.new  #
    profiles_hash = Hash.new
    profile_relations_hash = Hash.new
    one_profile_relations_hash = Hash.new
    ######################################################

    logger.info " "
    logger.info "     IN get_relation_match "
    logger.info " "

    all_profile_rows = ProfileKey.where(:user_id => connected_users).where(:profile_id => profile_id_searched).order('relation_id','is_name_id').select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id, :id)
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

      all_profile_rows.each do |relation_row|

        ############################# NEW METHODS ############
        one_profile_relations_hash.merge!(relation_row.is_profile_id => relation_row.relation_id)
        logger.info "=== one_profile_relations_hash #{one_profile_relations_hash} "
        ######################################################

        logger.info " "
        #logger.info "=== ПОИСК по записи № #{all_profile_rows_No}: #{relation_row.attributes.inspect}"

        relation_match_arr = ProfileKey.where.not(user_id: @search_exclude_users).where.not(user_id: connected_users).where(:name_id => relation_row.name_id, :relation_id => relation_row.relation_id, :is_name_id => relation_row.is_name_id).order('user_id','relation_id','is_name_id').select(:id, :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
        if !relation_match_arr.blank?
          #logger.info "=== Есть результаты! найдено #{relation_match_arr.size} результатов в деревьях сайта (см. ниже список записей) "
          show_in_logger(relation_match_arr, "=== результат" )  # DEBUGG_TO_LOGG
          logger.info "=== Цикл по найденным результатам ==="
          relation_match_arr_row_no = 1  # DEBUGG_TO_LOGG

          relation_match_arr.each do |tree_row|
            logger.info "=== === в результате #{relation_match_arr_row_no} НАЙДЕН ТРИПЛЕКС : name_id = #{tree_row.name_id}, relation_id = #{tree_row.relation_id}, is_name_id = #{tree_row.is_name_id}, profile_id = #{tree_row.profile_id}, is_profile_id = #{tree_row.is_profile_id}) "
            qty_of_results += 1   # DEBUGG_TO_LOGG

            ############################# NEW METHODS ############
            profiles_hash = fill_arrays_in_hash(profiles_hash, tree_row.user_id, tree_row.profile_id, relation_row.relation_id)
            new_found_profiles_hash.merge!( profile_id_searched  => profiles_hash ) # наполнение хэша соответствиями найденных профилей и найденных отношений
            ######################################################

          end
          # Показ результатов
          logger.info " "
          logger.info "=== После ПОИСКА по записи № #{all_profile_rows_No} и записи рез-тов: ХЭШ рез-тов: profiles_hash = #{profiles_hash}, qty_of_results = #{qty_of_results} "

        else
          logger.info "=== НЕТ результата! В деревьях сайта ничего не найдено! === "
        end
        # Здесь: анализ накопленного массива найденных row_arr
        all_profile_rows_No += 1 # Подсчет номера по порядку очередной записи об искомом профиле

      end


    end


    ############################# NEW METHODS ############
    profile_relations_hash.merge!(profile_id_searched  => one_profile_relations_hash)
    logger.info "Все пары profile_relations ИСКОМОГО ПРОФИЛЯ = #{profile_relations_hash.inspect} "

    @new_profiles_relations_arr << profile_relations_hash if !profile_relations_hash.empty? # Заполнение выходного массива хэшей
    logger.info " *** @new_pairs_profiles_relations_arr = #{@new_pairs_profiles_relations_arr} "

    @new_profiles_found_arr << new_found_profiles_hash if !new_found_profiles_hash.empty? # Заполнение выходного массива хэшей
    logger.info " *** @new_profiles_found_arr = #{@new_profiles_found_arr} "

    ######################################################




  end





end # End of search module
