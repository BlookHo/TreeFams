module Search
  extend ActiveSupport::Concern
  include SearchHelper

  def start_search(certain_koeff)    # Запуск мягкого поиска для объединения

    connected_author_arr = self.get_connected_users # Состав объединенного дерева в виде массива id
    author_tree_arr = get_connected_tree(connected_author_arr) # Массив объединенного дерева из Tree
    qty_of_tree_profiles = author_tree_arr.map {|p| p.is_profile_id }.uniq.size # Кол-во профилей в объед-ном дереве - для отображения на Главной
    logger.info "Кол-во профилей в Искомом дереве #{connected_author_arr}:  #{qty_of_tree_profiles}"

    #author_tree_arr = # DEBUGG_TO_VIEW


    logger.info "======================= RUN start_search ========================= "
    logger.info "Задание на поиск от Дерева Юзера: connected_author_arr = #{connected_author_arr} "
    logger.info "Коэффициент достоверности: certain_koeff = #{certain_koeff}"

    ############### ПОИСК ######## NEW METHOD ############
    search_profiles_from_tree(certain_koeff, connected_author_arr, author_tree_arr) # Основной поиск по дереву Автора среди деревьев в ProfileKeys.

    results = {
        connected_author_arr: connected_author_arr, # where use?
        qty_of_tree_profiles: qty_of_tree_profiles, # where use?
        ############### РЕЗУЛЬТАТЫ ПОИСКА ######## NEW METHOD ############
        profiles_relations_arr: @profiles_relations_arr,
        profiles_found_arr: @profiles_found_arr,
        uniq_profiles_pairs: @uniq_profiles_pairs,
        profiles_with_match_hash: @profiles_with_match_hash,
        ############# РЕЗУЛЬТАТЫ ПОИСКА для отображения на Главной ##########################################
        by_profiles: @by_profiles,
        by_trees: @by_trees,
        ############### ДУБЛИКАТЫ ПОИСКА ######## NEW METHOD ############
        duplicates_One_to_Many: @duplicates_One_to_Many,
        duplicates_Many_to_One: @duplicates_Many_to_One
    }

    logger.info "== END OF start_search ========================= "
    return results
  end # END OF start_search

  # Основной поиск по дереву Автора - Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_profiles_from_tree(certain_koeff, connected_users_arr, tree_arr)

    @profiles_found_arr = []     #
    @new_profiles_to_profiles_arr = []     #
    @profiles_relations_arr = []     #

    logger.info "=== IN search_profiles_from_tree === Запуск Циклов поиска === "
    i = 0 # DEBUGG_TO_LOGG
    if !tree_arr.blank?
      tree_arr.each do |arr_row|
        from_profile_searching = arr_row.profile_id # От какого профиля осущ-ся Поиск DEBUGG_TO_LOGG
        name_id_searched       = arr_row.name_id # Имя Профиля DEBUGG_TO_LOGG
        relation_id_searched   = arr_row.relation_id # Искомое relation_id К_Профиля DEBUGG_TO_LOGG
        profile_id_searched    = arr_row.is_profile_id # Поиск по ID К_Профиля
        is_name_id_searched    = arr_row.is_name_id # Искомое Имя К_Профиля DEBUGG_TO_LOGG
        logger.info " "
        logger.info "***** Цикл ПОИСКa: #{i+1}-я ИТЕРАЦИЯ "
        logger.info "***** От профиля: #{from_profile_searching};  Ищем профиль: #{profile_id_searched};"
        logger.info "***** Oт имени (name_id): #{name_id_searched}; ищем отношение (relation_id) = #{relation_id_searched}, Ищем имя (is_name_id) = #{is_name_id_searched}  "

        ###### ЗАПУСК ПОИСКА ОДНОГО ПРОФИЛЯ
        search_match(connected_users_arr, profile_id_searched)
        ###################################
        i += 1  # DEBUGG_TO_LOGG
      end

    end

    if !@profiles_found_arr.blank?

      #####################################
      ######## Запуск метода выбора пар профилей с максимальной мощностью множеств совпадений отношений
      logger.info ""
      max_power_profiles_pairs_hash, duplicates_One_to_Many, profiles_with_match_hash =
          get_certain_profiles_pairs(@profiles_found_arr, certain_koeff)

      logger.info ""
      logger.info "== После get_certain_profiles_pairs - результат поиска: max_power_profiles_pairs_hash = #{max_power_profiles_pairs_hash}"
      logger.info ""
      logger.info "== После get_certain_profiles_pairs - duplicates_One_to_Many = #{duplicates_One_to_Many}"
      logger.info ""
      logger.info "== После get_certain_profiles_pairs - profiles_with_match_hash = #{profiles_with_match_hash}"
      logger.info ""

      ####################################
      # ПРОВЕРКА ХЭША ПАР ПРОФИЛЕЙ С МАКС. МОЩНОСТЬЮ НА НАЛИЧИЕ ДУБЛИКАТОВ
      # ТИПА 2 К 1
      # Не должно остаться в хэше пар - пар для одного дерева с одним профилем
      {137 =>{12=>{111=>[3],    90=>[3, 7]},    13=>{111=>[3],    90=>[3, 7]},              14=>{106=>[3, 7],    105=>[3]},    15=>{121=>[3, 7]}}}
      {130=> {12=>{111=>[3, 7], 90=>[3, 3, 3]}, 13=>{111=>[3, 7], 90=>[3, 3, 3], 116=>[7]}, 14=>{106=>[3, 3, 3], 105=>[3, 7]}, 15=>{121=>[3, 3, 3], 124=>[7]}}}

      # max_power_profiles_pairs_hash =
              {135=>{12=>94},
               136=>{12=>89, 13=>89, 14=>103, 15=>120},
                137=>{12=>90, 13=>90, 14=>106, 15=>121},
               128=>{12=>93},
                130=>{12=>90, 13=>90, 14=>106, 15=>121},
               134=>{12=>88, 13=>88, 14=>109, 15=>122},
               129=>{12=>110, 13=>110, 14=>104}}

         # uniq_profiles_pairs =
              {135=>{12=>94},
               136=>{12=>89, 13=>89, 14=>103, 15=>120},
               137=>{},
               128=>{12=>93},
               130=>{},
               134=>{12=>88, 13=>88, 14=>109, 15=>122},
               129=>{12=>110, 13=>110, 14=>104}}
         # duplicates_Many_to_One =
              {130=>{12=>90, 13=>90, 14=>106, 15=>121},
               137=>{12=>90, 13=>90, 14=>106, 15=>121}}

      # duplicates_out - метод в hasher.rb
      uniq_profiles_pairs, duplicates_Many_to_One =
          duplicates_out(max_power_profiles_pairs_hash)  # Ok
      logger.info "==  - результат поиска: uniq_profiles_pairs = #{uniq_profiles_pairs}"
      # Exclude empty hashes
      uniq_profiles_pairs.delete_if { |k,v|  v == {} }
      logger.info "** ПРОМЕЖУТОЧНЫЕ RESULTS: (После duplicates_out)"
      logger.info "uniq_profiles_pairs = #{uniq_profiles_pairs}"
      logger.info "duplicates_Many_to_One = #{duplicates_Many_to_One}"

      ##### ПРОМЕЖУТОЧНЫЕ РЕЗУЛЬТАТЫ ПОИСКА ############
      @uniq_profiles_pairs = uniq_profiles_pairs #
      @profiles_with_match_hash = profiles_with_match_hash #

      @duplicates_One_to_Many = duplicates_One_to_Many #
      @duplicates_Many_to_One = duplicates_Many_to_One #

      ##### РЕЗУЛЬТАТЫ ПОИСКА ДЛЯ ОТОБРАЖЕНИЯ НА ГЛАВНОЙ #########
      by_profiles, by_trees = make_search_results(uniq_profiles_pairs, profiles_with_match_hash)
      logger.info " by_profiles = #{by_profiles} "
      logger.info " by_trees = #{by_trees} "
      @by_profiles = by_profiles #
      @by_trees = by_trees #


      #### ДОДЕЛАТЬ! #
      ########### TEST ########################################
      # NB !! Вставить проверку и действия ПРИСУТСТВИЯ КАЖДОГО FOUND ПРОФИЛЯ В ЕГО РОДНОМ ДЕРЕВЕ
      # СБОР ВСЕХ НАЙДЕННЫХ ПРОФИЛЕЙ ПО ДЕРЕВЬЯМ
      ################ TEST #######################################
      # ПРОВЕРКА ПРИСУТСТВИЯ КАЖДОГО ПРОФИЛЯ В ЕГО РОДНОМ ДЕРЕВЕ
      def check_profiles_tree_uniqness(trees_profiles_hash)
        logger.info "**  in check_profiles_tree_uniqness: trees_profiles_hash = #{trees_profiles_hash} "
        check_results_hash = {}
        new_uniq_profiles_hash = {}
        trees_profiles_hash.each_with_index do |(k, v), index|
          all_tree_profiles = Tree.where(user_id: k).pluck(:is_profile_id)
          logger.info "** all_tree_profiles = #{all_tree_profiles} "

        end
        return check_results_hash, new_uniq_profiles_hash
      end

  #    uniq_profiles_pairs = {89=>{14=>103}, 90=>{14=>106}, 91=>{14=>108}, 92=>{14=>107}, 88=>{14=>109}}
  #    trees_profiles_hash = collect_trees_profiles(uniq_profiles_pairs)
  #    logger.info "** collect_trees_profiles begin: trees_profiles_hash = #{trees_profiles_hash} "

  #    check_results_hash, new_uniq_profiles_hash = check_profiles_tree_uniqness(trees_profiles_hash)
  #    logger.info "** After check_uniqness: new_uniq_profiles_hash = #{new_uniq_profiles_hash}, check_results_hash = #{check_results_hash}"
      # After method Get all found profiles for trees
      #### ДОДЕЛАТЬ? ########### TEST ########################################



    else
      logger.info "** NO SEARCH RESULTS **"
      @uniq_profiles_pairs = {}

      logger.info "** NO DUBLICATES **"
      @duplicates_One_to_Many = {}
      @duplicates_Many_to_One = {}
    end

  end

  # Делаем ХЭШ профилей-отношений для искомого дерева. - пригодится.
  # ВСПОМОГАТЕЛЬНЫЙ РЕЗ-ТАТ ПОИСКА - СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА (массив ХЭШей ПАР ПРОФИЛЕЙ-ОТНОШЕНИЙ):
  # {профиль искомый -> профиль -> его отношение к искомому} )
  def make_profile_relations(profile_id_searched, one_profile_relations, profiles_relations_arr)
    profile_relations_hash = Hash.new
    profile_relations_hash.merge!(profile_id_searched  => one_profile_relations)
    profiles_relations_arr << profile_relations_hash if !profile_relations_hash.empty? # Заполнение выходного массива хэшей
    logger.info "Все пары profile_relations ИСКОМОГО ПРОФИЛЯ: profiles_relations_arr = #{profiles_relations_arr} "
    logger.info " ***  =  "
    return profiles_relations_arr
  end


  # Получение РЕЗ-ТАТа ПОИСКА - found_profiles_hash - для одной записи круга искомого профиля
  # found_profiles_hash - НАЙДЕННЫЕ ПРОФИЛИ С СОВПАВШИМИ ОТНОШЕНИЯМИ (hash)
  def get_found_profiles(profiles_hash, relation_row, search_exclude_users, connected_users, profile_id_searched)
    logger.info "IN get_found_profiles "
    found_profiles_hash = Hash.new  #
    relation_match_arr = ProfileKey.where.not(user_id: search_exclude_users).where.not(user_id: connected_users).where(:name_id => relation_row.name_id, :relation_id => relation_row.relation_id, :is_name_id => relation_row.is_name_id).order('user_id','relation_id','is_name_id').select(:id, :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
    if !relation_match_arr.blank?
      show_in_logger(relation_match_arr, "=== результат" )  # DEBUGG_TO_LOGG
      #relation_row_No = 1  # DEBUGG_TO_LOGG
      relation_match_arr.each do |tree_row|
        #logger.info "=== === в результате № #{relation_row_No} - НАЙДЕНO: name_id = #{tree_row.name_id}, relation_id = #{tree_row.relation_id}, is_name_id = #{tree_row.is_name_id}, profile_id = #{tree_row.profile_id}, is_profile_id = #{tree_row.is_profile_id}) "
        profiles_hash = fill_arrays_in_hash(profiles_hash, tree_row.user_id, tree_row.profile_id, relation_row.relation_id)
        found_profiles_hash.merge!( profile_id_searched  => profiles_hash ) # наполнение хэша соответствиями найденных профилей и найденных отношений
        #relation_row_No += 1  # DEBUGG_TO_LOGG
      end
    else
      logger.info " "
      logger.info "=== НЕТ результата! В деревьях сайта ничего не найдено! === "
    end

    return found_profiles_hash
  end

  # Поиск совпадений для одного из профилей
  # Берем параметр: profile_id из массива  = profiles_tree_arr[i][6].
  # @note GET /
  # @see News
  def search_match(connected_users, profile_id_searched)

    logger.info " "
    logger.info "IN search_match "
    logger.info " "
    found_profiles_hash = Hash.new  #
    profiles_hash = Hash.new
    one_profile_relations_hash = Hash.new

    all_profile_rows = ProfileKey.where(:user_id => connected_users).where(:profile_id => profile_id_searched).order('relation_id','is_name_id').select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id).distinct
    # поиск массива записей искомого круга для каждого профиля в дереве Юзера
    logger.info "Круг ИСКОМОГО ПРОФИЛЯ = #{profile_id_searched.inspect} в (объединенном) дереве #{connected_users} зарег-го Юзера"      # :user_id, , :id
    show_in_logger(all_profile_rows, "all_profile_rows - запись" )  # DEBUGG_TO_LOGG
    #qty_of_results = 0 # Начало подсчета результатов поиска (сумма успешных поисков в противоположном дереве)

        #@search_exclude_users = [85,86,87,88,89,90,91,92] # временный массив исключения косых юзеров из поиска DEBUGG_TO_VIEW
        @search_exclude_users = [] # временный массив исключения косых юзеров из поиска DEBUGG_TO_LOGG
        # убрать потом !!!

    all_profile_rows_No = 1 # DEBUGG_TO_LOGG
    if !all_profile_rows.blank?

      all_profile_rows.each do |relation_row|
        one_profile_relations_hash.merge!(relation_row.is_profile_id => relation_row.relation_id)

        # Получение РЕЗ-ТАТа ПОИСКА для одной записи Kруга искомого профиля - НАЙДЕННЫЕ ПРОФИЛИ С СОВПАВШИМИ ОТНОШЕНИЯМИ (hash)
        found_profiles_hash = get_found_profiles(profiles_hash, relation_row, @search_exclude_users, connected_users, profile_id_searched)

        logger.info " "
        logger.info "=== После ПОИСКА по записи № #{all_profile_rows_No} и записи рез-тов: ХЭШ рез-тов: profiles_hash = #{profiles_hash} "
        all_profile_rows_No += 1 # Подсчет номера по порядку очередной записи об искомом профиле  # DEBUGG_TO_LOGG
      end

    end

    # ДОПОЛНИТЕЛЬНЫЙ РЕЗ-ТАТ ПОИСКА - СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА (массив ХЭШей ПАР ПРОФИЛЕЙ-ОТНОШЕНИЙ):
    @profiles_relations_arr = make_profile_relations(profile_id_searched, one_profile_relations_hash, @profiles_relations_arr)

    # ОСНОВНОЙ РЕЗ-ТАТ ПОИСКА - НАЙДЕННЫЕ ПРОФИЛИ С СОВПАВШИМИ ОТНОШЕНИЯМИ (массив):
    # {профиль искомый -> дерево -> профиль найденный -> [ массив совпавших отношений с искомым профилем ]
    @profiles_found_arr << found_profiles_hash if !found_profiles_hash.empty? # Заполнение выходного массива хэшей
    logger.info " *** @profiles_found_arr = #{@profiles_found_arr} "

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
