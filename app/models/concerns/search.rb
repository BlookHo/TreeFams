module Search
  extend ActiveSupport::Concern
  include SearchHelper

  def start_search(certain_koeff)    # Запуск мягкого поиска для объединения

    connected_author_arr = self.get_connected_users # Состав объединенного дерева в виде массива id
    author_tree_arr = get_connected_tree(connected_author_arr) # Массив объединенного дерева из Tree
    qty_of_tree_profiles = author_tree_arr.map {|p| p[4] }.uniq.size # Кол-во профилей в объед-ном дереве - для отображения на Главной

    #author_tree_arr = # DEBUGG_TO_VIEW
    # [
    #   ]

    logger.info "======================= RUN start_search ========================= "
    logger.info "Общее задание на поиск от зарег-го Юзера - весь массив заданий (author_tree_arr)"
    logger.info "#{author_tree_arr}"
    logger.info "certain_koeff = #{certain_koeff}"

    ############### ПОИСК ######## NEW METHOD ############
    search_profiles_from_tree(certain_koeff, connected_author_arr, author_tree_arr) # Основной поиск по дереву Автора среди деревьев в ProfileKeys.

    results = {
        connected_author_arr: connected_author_arr, # where use?
        qty_of_tree_profiles: qty_of_tree_profiles, # where use?
        ############### РЕЗУЛЬТАТЫ ПОИСКА ######## NEW METHOD ############
        profiles_relations_arr: @profiles_relations_arr,
        new_profiles_found_arr: @new_profiles_found_arr,
        uniq_profiles_pairs_hash: @uniq_profiles_pairs_hash,
        profiles_with_match_hash: @profiles_with_match_hash,
        ############# РЕЗУЛЬТАТЫ ПОИСКА для отображения на Главной ##########################################
        by_profiles: @by_profiles,
        by_trees: @by_trees,
        ############### ДУБЛИКАТЫ ПОИСКА ######## NEW METHOD ############
        duplicates_One_to_Many_hash: @duplicates_One_to_Many_hash,
        duplicates_Many_to_One_hash: @duplicates_Many_to_One_hash
    }

    logger.info "== END OF start_search ========================= "
    logger.info ""
    return results
  end

  # Основной поиск по дереву Автора - Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_profiles_from_tree(certain_koeff, connected_users_arr, tree_arr)

    ##### NEW METHOD ############
    @new_profiles_found_arr = []     #
    @new_profiles_to_profiles_arr = []     #
    @profiles_relations_arr = []     #
    @new_pairs_profiles_relations_arr = []     #

    logger.info "======================= Запуск цикла поиска по всему массиву заданий ========================= "
    if !tree_arr.blank?
      for i in 0 .. tree_arr.length-1
        # Структура эл-та массива   32, 212, 419, 1, 213, 196, 1, false]
        #                               1        3   4
        from_profile_searching = tree_arr[i][1] # От какого профиля осущ-ся Поиск
        name_id_searched       = tree_arr[i][2] # Имя Профиля
        relation_id_searched   = tree_arr[i][3] # Искомое relation_id К_Профиля
        profile_id_searched    = tree_arr[i][4] # Поиск по ID К_Профиля
        is_name_id_searched    = tree_arr[i][5] # Искомое Имя К_Профиля
        logger.info " "
        logger.info "***** ПОИСК: #{i+1}-я ИТЕРАЦИЯ in search_profiles_from_tree*** Ищем по этому элементу из дерева Юзера: tree_arr[i] = #{tree_arr[i]}"
        logger.info "***** из дерева (объед-х деревьев): #{connected_users_arr}; От профиля: #{from_profile_searching};  Ищем профиль: #{profile_id_searched};"
        logger.info "***** от имени (name_id): #{name_id_searched}; ищем отношение (relation_id) = #{relation_id_searched}, Ищем имя (is_name_id) = #{is_name_id_searched}  "

        ###############  ЗАПУСК НОВОГО ПОИСКА ДЛЯ ОТОБРАЖЕНИЯ РЕЗУЛЬТАТОВ
        search_match(connected_users_arr, profile_id_searched)

      end
    end

    if !@new_profiles_found_arr.blank?

      #######################################################
      ######## Запуск метода выбора пар профилей с максимальной мощностью множеств совпадений отношений
      # по результатам поиска из всего полученного множества результатов @new_profiles_found_arr.
      logger.info ""
      max_power_profiles_pairs_hash, duplicates_One_to_Many_hash, profiles_with_match_hash =
          get_certain_profiles_pairs(@new_profiles_found_arr, certain_koeff)

      logger.info ""
      logger.info "== После get_certain_profiles_pairs - результат поиска: max_power_profiles_pairs_hash = #{max_power_profiles_pairs_hash}"
      logger.info ""
      logger.info "== После get_certain_profiles_pairs - duplicates_One_to_Many_hash = #{duplicates_One_to_Many_hash}"
      logger.info ""
      logger.info "== После get_certain_profiles_pairs - profiles_with_match_hash = #{profiles_with_match_hash}"
      logger.info ""

      #######################################################
      # ПРОВЕРКА ХЭША ПАР ПРОФИЛЕЙ С МАКС. МОЩНОСТЬЮ НА НАЛИЧИЕ ДУБЛИКАТОВ
      # ТИПА 2 К 1
      # Не должно остаться в хэше пар - пар для одного дерева с одним профилем

      # duplicates_out - метод в hasher.rb
      uniq_profiles_pairs_hash, duplicates_Many_to_One_hash =
          duplicates_out(max_power_profiles_pairs_hash)  # Ok
      logger.info "==  - результат поиска: uniq_profiles_pairs_hash = #{uniq_profiles_pairs_hash}"
      # Exclude empty hashes
      uniq_profiles_pairs_hash.delete_if { |k,v|  v == {} }
      logger.info "** ПРОМЕЖУТОЧНЫЕ RESULTS: (После duplicates_out)"
      logger.info "uniq_profiles_pairs_hash = #{uniq_profiles_pairs_hash}"
      logger.info "duplicates_Many_to_One_hash = #{duplicates_Many_to_One_hash}"

      ############# ПРОМЕЖУТОЧНЫЕ РЕЗУЛЬТАТЫ ПОИСКА ##########################################
      @uniq_profiles_pairs_hash = uniq_profiles_pairs_hash #
      @profiles_with_match_hash = profiles_with_match_hash #

      @duplicates_One_to_Many_hash = duplicates_One_to_Many_hash #
      @duplicates_Many_to_One_hash = duplicates_Many_to_One_hash #

      ############# РЕЗУЛЬТАТЫ ПОИСКА ДЛЯ ОТОБРАЖЕНИЯ НА ГЛАВНОЙ ##########################################
      by_profiles, by_trees = make_search_results(uniq_profiles_pairs_hash, profiles_with_match_hash)
      logger.info " by_profiles = #{by_profiles} "
      logger.info " by_trees = #{by_trees} "
      @by_profiles = by_profiles #
      @by_trees = by_trees #


      #### ДОДЕЛАТЬ? ###
      ## Сбор дубликатов всех видов в один хэш
      #@double_profiles_pairs_hash = double_profiles_pairs_hash #
      #duplicated_profiles_pairs_hash.merge!(double_profiles_pairs_hash) if !double_profiles_pairs_hash.empty?
      #logger.info "** Final DUPPS: duplicated_profiles_pairs_hash = #{duplicated_profiles_pairs_hash}"
      #@duplicated_profiles_pairs_hash = duplicated_profiles_pairs_hash #


      #### ДОДЕЛАТЬ? #
      ########### TEST ########################################
      # NB !! Вставить проверку и действия ПРИСУТСТВИЯ КАЖДОГО ПРОФИЛЯ В ЕГО РОДНОМ ДЕРЕВЕ
      # СБОР ВСЕХ НАЙДЕННЫХ ПРОФИЛЕЙ ПО ДЕРЕВЬЯМ
      trees_profiles_hash = collect_trees_profiles(uniq_profiles_pairs_hash)
      logger.info "** collect_trees_profiles begin: trees_profiles_hash = #{trees_profiles_hash} "
      ################ TEST #######################################
      # ПРОВЕРКА ПРИСУТСТВИЯ КАЖДОГО ПРОФИЛЯ В ЕГО РОДНОМ ДЕРЕВЕ
      def check_profiles_tree_uniqness(trees_profiles_hash)
        check_results_hash = {}
        new_uniq_profiles_hash = {}
        trees_profiles_hash.each_with_index do |(k, v), index|

        end
        return check_results_hash, new_uniq_profiles_hash
      end
      check_results_hash, new_uniq_profiles_hash = check_profiles_tree_uniqness(uniq_profiles_pairs_hash)
      logger.info "** After check_uniqness: new_uniq_profiles_hash = #{new_uniq_profiles_hash}, check_results_hash = #{check_results_hash}"
      # After method Get all found profiles for trees
      #### ДОДЕЛАТЬ? ########### TEST ########################################



    else
      logger.info "** NO SEARCH RESULTS **"
      @uniq_profiles_pairs_hash = {}

      logger.info "** NO DUBLICATES **"
      @duplicates_One_to_Many_hash = {}
      @duplicates_Many_to_One_hash = {}
    end

  end

  # Поиск совпадений для одного из профилей
  # Берем параметр: profile_id из массива  = profiles_tree_arr[i][6].
  # @note GET /
  # @see News
  def search_match(connected_users, profile_id_searched)

    logger.info " "
    logger.info "     IN search_match "
    logger.info " "
    new_found_profiles_hash = Hash.new  #
    profiles_hash = Hash.new
    profile_relations_hash = Hash.new
    one_profile_relations_hash = Hash.new

    all_profile_rows = ProfileKey.where(:user_id => connected_users).where(:profile_id => profile_id_searched).order('relation_id','is_name_id').select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id, :id)
    # поиск массива записей ближнего круга для каждого профиля в дереве Юзера
    logger.info "Круг ИСКОМОГО ПРОФИЛЯ = #{profile_id_searched.inspect} в (объединенном) дереве #{connected_users} зарег-го Юзера"
    show_in_logger(all_profile_rows, "all_profile_rows - запись" )  # DEBUGG_TO_LOGG
    qty_of_results = 0 # Начало подсчета результатов поиска (сумма успешных поисков в противоположном дереве)

        #@search_exclude_users = [85,86,87,88,89,90,91,92] # временный массив исключения косых юзеров из поиска DEBUGG_TO_VIEW
        @search_exclude_users = [] # временный массив исключения косых юзеров из поиска DEBUGG_TO_LOGG
        # убрать потом !!!

    all_profile_rows_No = 1
    if !all_profile_rows.blank?
      @all_profile_rows_len = all_profile_rows.length if !all_profile_rows.blank? #DEBUGG_TO_LOGG
      # размер ближнего круга профиля в дереве current_user.id
      logger.info "Мощность круга ИСКОМОГО ПРОФИЛЯ (кол-во записей): @all_profile_rows_len = #{@all_profile_rows_len}"

      all_profile_rows.each do |relation_row|

        one_profile_relations_hash.merge!(relation_row.is_profile_id => relation_row.relation_id)
        logger.info " "
        logger.info "=== one_profile_relations_hash #{one_profile_relations_hash} "
        relation_match_arr = ProfileKey.where.not(user_id: @search_exclude_users).where.not(user_id: connected_users).where(:name_id => relation_row.name_id, :relation_id => relation_row.relation_id, :is_name_id => relation_row.is_name_id).order('user_id','relation_id','is_name_id').select(:id, :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
        if !relation_match_arr.blank?
          show_in_logger(relation_match_arr, "=== результат" )  # DEBUGG_TO_LOGG
          logger.info "=== Цикл по найденным результатам ==="
          relation_match_arr_row_no = 1  # DEBUGG_TO_LOGG

          relation_match_arr.each do |tree_row|
            logger.info "=== === в результате #{relation_match_arr_row_no} НАЙДЕН ТРИПЛЕКС : name_id = #{tree_row.name_id}, relation_id = #{tree_row.relation_id}, is_name_id = #{tree_row.is_name_id}, profile_id = #{tree_row.profile_id}, is_profile_id = #{tree_row.is_profile_id}) "
            qty_of_results += 1   # DEBUGG_TO_LOGG
            profiles_hash = fill_arrays_in_hash(profiles_hash, tree_row.user_id, tree_row.profile_id, relation_row.relation_id)
            new_found_profiles_hash.merge!( profile_id_searched  => profiles_hash ) # наполнение хэша соответствиями найденных профилей и найденных отношений
            relation_match_arr_row_no += 1  # DEBUGG_TO_LOGG
          end
          logger.info " "
          logger.info "=== После ПОИСКА по записи № #{all_profile_rows_No} и записи рез-тов: ХЭШ рез-тов: profiles_hash = #{profiles_hash}, qty_of_results = #{qty_of_results} "

        else
          logger.info "=== НЕТ результата! В деревьях сайта ничего не найдено! === "
        end
        # Здесь: анализ накопленного массива найденных row_arr
        all_profile_rows_No += 1 # Подсчет номера по порядку очередной записи об искомом профиле

      end

    end

    profile_relations_hash.merge!(profile_id_searched  => one_profile_relations_hash)
    logger.info " "
    logger.info "Все пары profile_relations ИСКОМОГО ПРОФИЛЯ = #{profile_relations_hash.inspect} "

    # ВСПОМОГАТЕЛЬНЫЙ РЕЗ-ТАТ ПОИСКА - СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА (массив ХЭШей ПАР ПРОФИЛЕЙ-ОТНОШЕНИЙ):
    # {профиль искомый -> профиль -> его отношение к искомому} )
    @profiles_relations_arr << profile_relations_hash if !profile_relations_hash.empty? # Заполнение выходного массива хэшей
    logger.info " *** @profiles_relations_arr = #{@profiles_relations_arr} "

    # ОСНОВНОЙ РЕЗ-ТАТ ПОИСКА -
    # НАЙДЕННЫЕ ПРОФИЛИ С СОВПАВШИМИ ОТНОШЕНИЯМИ (массив):
    # {профиль искомый -> дерево -> профиль найденный -> [ массив совпавших отношений с искомым профилем ]
    @new_profiles_found_arr << new_found_profiles_hash if !new_found_profiles_hash.empty? # Заполнение выходного массива хэшей
    logger.info " *** @new_profiles_found_arr = #{@new_profiles_found_arr} "

  end


  ############# МЕТОДЫ ДЛЯ ИЗГОТОВЛЕНИЯ РЕЗУЛЬТАТОВ ПОИСКА для отображения на Главной ##########################################

  # make final sorted by_trees search results
  def fill_hash_w_val_arr(filling_hash, input_key, input_val)
    test = filling_hash.key?(input_key) # Is elem w/input_key in filling_hash?
    if test == false #  "NOT Found in hash"
      filling_hash.merge!({input_key => [input_val]}) # include new elem in hash
    else  #  "Found in hash"
      ids_arr = filling_hash.values_at(input_key)[0]
      ids_arr << input_val
      filling_hash[input_key] = ids_arr # store new arr val
    end
  end

  # make final sorted by_trees search results
  def make_by_trees_results(filling_hash)
    by_trees = []
    filling_hash.each do |tree_id, profiles_ids|
      one_tree_hash = {}
      one_tree_hash.merge!(:found_tree_id => tree_id)
      one_tree_hash.merge!(:found_profile_ids => profiles_ids)
      by_trees << one_tree_hash
    end
    return by_trees
  end

  # make final search results for view
  def make_search_results(uniq_hash, profiles_match_hash)
    by_profiles = []
    filling_hash = {}
    uniq_hash.each do |search_profile_id, found_hash|
      found_hash.each do |found_tree_id, found_profile_id|
        # make fill_hash for by_trees search results
        fill_hash_w_val_arr(filling_hash, found_tree_id, found_profile_id)

        # make fill_hash for by_profiles search results
        one_result_hash = {}
        count = 0
        one_result_hash.merge!(:search_profile_id => search_profile_id)
        one_result_hash.merge!(:found_tree_id => found_tree_id)
        one_result_hash.merge!(:found_profile_id => found_profile_id)
        count = profiles_match_hash.values_at(found_profile_id)[0] if !profiles_match_hash.empty?
        one_result_hash.merge!(:count => count)
        by_profiles << one_result_hash

      end
    end

    # make final sorted by_profiles search results
    by_profiles = by_profiles.sort_by {|h| [ h[:count] ]}.reverse
    # make final by_trees search results
    by_trees = make_by_trees_results(filling_hash)

    return by_profiles, by_trees
  end





end # End of search module
