module Search
  extend ActiveSupport::Concern

  def start_search(certain_koeff)    # Запуск мягкого поиска для объединения
                                     # Значение certain_koeff - из вьюхи/

    connected_author_arr = self.get_connected_users # Состав объединенного дерева в виде массива id
    author_tree_arr = Tree.get_connected_tree(connected_author_arr) # DISTINCT Массив объединенного дерева из Tree
    ###################################
    #from_profile_searching = author_tree_arr.profile_id     # От какого профиля осущ-ся Поиск DEBUGG_TO_LOGG
    #name_id_searched       = author_tree_arr.name_id        # Имя Профиля DEBUGG_TO_LOGG
    #relation_id_searched   = author_tree_arr.relation_id    # Искомое relation_id К_Профиля DEBUGG_TO_LOGG
    #is_name_id_searched    = author_tree_arr.is_name_id     # Искомое Имя К_Профиля DEBUGG_TO_LOGG
    #
    #profile_id_searched    = author_tree_arr.is_profile_id  # Поиск по ID К_Профиля
    ###################################

    tree_is_profiles = author_tree_arr.map {|p| p.is_profile_id }.uniq
    qty_of_tree_profiles = tree_is_profiles.size unless tree_is_profiles.blank? # Кол-во профилей в объед-ном дереве - для отображения на Главной
    # Задание на поиск от Дерева Юзера: tree_is_profiles =
    # [9, 15, 14, 21, 8, 19, 11, 7, 2, 20, 16, 10, 17, 12, 3, 13, 124, 18]

    logger.info "======================= RUN start_search ========================= "
    logger.info "B Искомом дереве #{connected_author_arr} - kол-во профилей:  #{qty_of_tree_profiles}"
    logger.info "Задание на поиск от Дерева Юзера: tree_is_profiles = #{tree_is_profiles} "
    logger.info "Коэффициент достоверности: certain_koeff = #{certain_koeff}"

    ############### ПОИСК ######## NEW LAST METHOD ############
    search_profiles_from_tree(certain_koeff, connected_author_arr, tree_is_profiles) # Основной поиск по дереву Автора среди деревьев в ProfileKeys.

    # TEST CONNECTION FAILS
    # @duplicates_one_to_many = { 3=> [2, 4]}     # for DEBUGG ONLY!!!
    # @duplicates_many_to_one = { 4=> 2, 3 => 2}  # for DEBUGG ONLY!!!

    results = {
        connected_author_arr: connected_author_arr, # where use? - in View
        qty_of_tree_profiles: qty_of_tree_profiles, # where use? - in View
        ############### РЕЗУЛЬТАТЫ ПОИСКА ######## NEW METHOD ############
        profiles_relations_arr: @profiles_relations_arr, #  DEBUGG_TO_LOGG
        profiles_found_arr: @profiles_found_arr, #  DEBUGG_TO_LOGG
        uniq_profiles_pairs: @uniq_profiles_pairs,
        profiles_with_match_hash: @profiles_with_match_hash, #  DEBUGG_TO_LOGG
        ############# РЕЗУЛЬТАТЫ ПОИСКА для отображения на Главной ##########################################
        by_profiles: @by_profiles,
        by_trees: @by_trees,
        ############### ДУБЛИКАТЫ ПОИСКА ######## NEW METHOD ############
        duplicates_one_to_many: @duplicates_one_to_many,
        duplicates_many_to_one: @duplicates_many_to_one
    }

    logger.info "= Before store_search_results ========================= "
    if (results[:duplicates_one_to_many].empty? && results[:duplicates_many_to_one].empty?)
      # Store new results ONLY IF there are NO BOTH duplicates
      store_search_results(results) # запись рез-тов поиска в отдельную таблицу - для Метеора
    end

    logger.info "== END OF start_search ========================= "
    logger.info " $$$$-----$$$  After start_search: results = #{results.inspect}"
    results
  end # END OF start_search


  # @note запись рез-тов поиска в отдельную таблицу - для Метеора
  def store_search_results(results)
    by_profiles = results[:by_profiles]
    by_trees = results[:by_trees]

    # by_profiles =
    # [{:search_profile_id=>18, :found_tree_id=>2, :found_profile_id=>9, :count=>5},
    #  {:search_profile_id=>18, :found_tree_id=>1, :found_profile_id=>19, :count=>5},
    #  {:search_profile_id=>17, :found_tree_id=>2, :found_profile_id=>8, :count=>5},
    #  {:search_profile_id=>17, :found_tree_id=>1, :found_profile_id=>18, :count=>5},
    #  {:search_profile_id=>19, :found_tree_id=>1, :found_profile_id=>17, :count=>5},
    #  {:search_profile_id=>62, :found_tree_id=>1, :found_profile_id=>111, :count=>5},
    #  {:search_profile_id=>19, :found_tree_id=>2, :found_profile_id=>7, :count=>5},
    #  {:search_profile_id=>62, :found_tree_id=>2, :found_profile_id=>11, :count=>5},
    #  {:search_profile_id=>20, :found_tree_id=>2, :found_profile_id=>13, :count=>4},
    #  {:search_profile_id=>20, :found_tree_id=>1, :found_profile_id=>113, :count=>4}]
    #
    # by_trees =
    # [{:found_tree_id=>1, :found_profile_ids=>[13, 7, 11, 8, 9]},
    #  {:found_tree_id=>2, :found_profile_ids=>[13, 7, 11, 8, 9]}]


    # logger.info "= in store_search_results: by_profiles = #{by_profiles.inspect},\n by_trees = #{by_trees.inspect}"
    found_tree_ids = collect_tree_ids(by_trees)
    # previous_results_count = SearchResults.where(user_id: self, found_user_id: found_tree_ids).count
    previous_results = SearchResults.where(user_id: self, found_user_id: found_tree_ids)
    logger.info "= found_tree_ids = #{found_tree_ids.inspect} "
    if !previous_results.blank?
      previous_results.each(&:destroy)
      store_results(found_tree_ids, by_profiles)
    else
      store_results(found_tree_ids, by_profiles)
    end
  end
  # by_profiles = [{:search_profile_id=>340, :found_tree_id=>17, :found_profile_id=>350, :count=>7},
  # {:search_profile_id=>342, :found_tree_id=>17, :found_profile_id=>349, :count=>7},
  # {:search_profile_id=>341, :found_tree_id=>17, :found_profile_id=>351, :count=>7},
  # {:search_profile_id=>346, :found_tree_id=>17, :found_profile_id=>356, :count=>5},
  # {:search_profile_id=>345, :found_tree_id=>17, :found_profile_id=>355, :count=>5},
  # {:search_profile_id=>348, :found_tree_id=>17, :found_profile_id=>358, :count=>5},
  # {:search_profile_id=>347, :found_tree_id=>17, :found_profile_id=>357, :count=>5}]
  # by_trees = [{:found_tree_id=>17, :found_profile_ids=>[357, 351, 349, 358, 350, 355, 356]}]


  # @note - сбор tree_ids всех найденных деревьев
  def collect_tree_ids(by_trees)
    found_tree_ids = []
    by_trees.each do |one_found_tree|
      found_tree_ids << one_found_tree[:found_tree_id]
    end
    found_tree_ids
  end


  # @note - сбор данных о профилях из рез-тов поиска в виде массивов
  def collect_search_profile_ids(by_profiles, tree_id)
    search_profile_id = []
    found_profile_id = []
    count = []
    by_profiles.each do |one_profiles_hash|
      if one_profiles_hash[:found_tree_id] == tree_id
        search_profile_id << one_profiles_hash[:search_profile_id]
        found_profile_id << one_profiles_hash[:found_profile_id]
        count << one_profiles_hash[:count]
      end
    end
    return search_profile_id, found_profile_id, count
  end


  # @note - запись результатов поиска
  def store_results(found_tree_ids, by_profiles)
    found_tree_ids.each do |tree_id|
      searched_profile_ids, found_profile_ids, counts = collect_search_profile_ids(by_profiles, tree_id)
      SearchResults.create(user_id: self.id, found_user_id: tree_id, profile_id: searched_profile_ids[0],
                           found_profile_id: found_profile_ids[0], count: counts[0],
                           found_profile_ids: found_profile_ids, searched_profile_ids: searched_profile_ids,
                           counts: counts )
    end
  end


  # Основной поиск по дереву Автора - Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_profiles_from_tree(certain_koeff, connected_users_arr, tree_is_profiles)

    @profiles_found_arr = []     #
    @new_profiles_to_profiles_arr = []     #
    @profiles_relations_arr = []     #

    logger.info " "
    logger.info "=== IN search_profiles_from_tree === Запуск Циклов поиска по tree_arr === "
    i = 0 # DEBUGG_TO_LOGG
    unless tree_is_profiles.blank?
      tree_is_profiles.each do |profile_id_searched|
        logger.info " "
        logger.info "***** Цикл ПОИСКa: #{i+1}-я ИТЕРАЦИЯ - Ищем профиль: #{profile_id_searched.inspect};"
        ###### ЗАПУСК ПОИСКА ОДНОГО ПРОФИЛЯ
        search_match(connected_users_arr, profile_id_searched, certain_koeff)
        ###################################
        i += 1  # DEBUGG_TO_LOGG
      end
    end

    if !@profiles_found_arr.blank?
      ######## Запуск метода выбора пар профилей с максимальной мощностью множеств совпадений отношений
      logger.info ""
      max_power_profiles_pairs_hash, duplicates_one_to_many, profiles_with_match_hash =
          get_certain_profiles_pairs(@profiles_found_arr, certain_koeff)
      ###################################

      logger.info ""
      logger.info "== После get_certain_profiles_pairs - результат поиска: max_power_profiles_pairs_hash = #{max_power_profiles_pairs_hash}"
      logger.info ""
      logger.info "== После get_certain_profiles_pairs - duplicates_one_to_many = #{duplicates_one_to_many}"
      logger.info ""
      logger.info "== После get_certain_profiles_pairs - profiles_with_match_hash = #{profiles_with_match_hash}"
      logger.info ""

      ##### Удаление дубликатов типа duplicates_many_to_one # duplicates_out - метод в hasher.rb
      uniq_profiles_pairs, duplicates_many_to_one =
          duplicates_out(max_power_profiles_pairs_hash)  # Ok
      ##### Удаление пустых хэшей из результатов # Exclude empty hashes
      uniq_profiles_pairs.delete_if { |k,v|  v == {} }
      logger.info "== Pезультат поиска (После duplicates_out): uniq_profiles_pairs = #{uniq_profiles_pairs}"
      logger.info "duplicates_many_to_one = #{duplicates_many_to_one}"

      ##### ПРОМЕЖУТОЧНЫЕ РЕЗУЛЬТАТЫ ПОИСКА - DEBUGG_TO_VIEW #####
      @uniq_profiles_pairs = uniq_profiles_pairs # DEBUGG_TO_VIEW
      @profiles_with_match_hash = profiles_with_match_hash # DEBUGG_TO_VIEW
      @duplicates_one_to_many = duplicates_one_to_many # DEBUGG_TO_VIEW
      @duplicates_many_to_one = duplicates_many_to_one # DEBUGG_TO_VIEW

      ##### РЕЗУЛЬТАТЫ ПОИСКА ДЛЯ ОТОБРАЖЕНИЯ НА ГЛАВНОЙ #####
      by_profiles, by_trees = make_search_results(uniq_profiles_pairs, profiles_with_match_hash)

      logger.info " by_profiles = #{by_profiles} "
      logger.info " by_trees = #{by_trees} "
      @by_profiles = by_profiles # DEBUGG_TO_VIEW
      @by_trees = by_trees # DEBUGG_TO_VIEW


    else
      logger.info "** NO SEARCH RESULTS **"
      @uniq_profiles_pairs = {}

      @by_profiles = {}
      @by_trees = {}

      logger.info "** NO DUBLICATES **"
      @duplicates_one_to_many = {}
      @duplicates_many_to_one = {}
    end

  end

  # @note: Делаем ХЭШ профилей-отношений для искомого дерева. - пригодится.
  #   Tested
  # @param:
  # @return: ВСПОМОГАТЕЛЬНЫЙ РЕЗ-ТАТ ПОИСКА - СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА
  #   (массив ХЭШей ПАР ПРОФИЛЕЙ-ОТНОШЕНИЙ):
  #   [ {profile_searched: -> профиль искомый, profile_relations: -> все отношения к искомому профилю } ]
  # @see:
  def make_profile_relations(profile_id_searched, one_profile_relations, profiles_relations_arr)
    profile_relations_hash = Hash.new
    one_profile_relations_hash = { profile_searched: profile_id_searched, profile_relations: one_profile_relations}
    # profile_relations_hash.merge!(profile_id_searched  => one_profile_relations)
    profile_relations_hash.merge!(one_profile_relations_hash)
    profiles_relations_arr << profile_relations_hash unless profile_relations_hash.empty? # Заполнение выходного массива хэшей
    logger.info "Все пары profile_relations ИСКОМОГО ПРОФИЛЯ: profile_relations_hash = #{profile_relations_hash} "
    logger.info ""
    profiles_relations_arr
  end


  # Получение РЕЗ-ТАТа ПОИСКА - found_profiles_hash - для одной записи круга искомого профиля
  # found_profiles_hash - НАЙДЕННЫЕ ПРОФИЛИ С СОВПАВШИМИ ОТНОШЕНИЯМИ (hash)
  # Если вставлять деревья, кот-е надо исключить для поиска, то - это здесь: where.not(user_id: search_exclude_users)
  # search_exclude_users = [22,134,...]/
  def get_found_profiles(profiles_hash, relation_row, connected_users, profile_id_searched)
    logger.info "=== IN get_found_profiles "
    found_profiles_hash = Hash.new  #
    relation_match_arr = ProfileKey.where.not(user_id: connected_users)
                             .where(:name_id => relation_row.name_id, :relation_id => relation_row.relation_id, :is_name_id => relation_row.is_name_id)
                             .order('user_id','relation_id','is_name_id')
                             .select(:id, :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
                             .distinct
    if !relation_match_arr.blank?
      show_in_logger(relation_match_arr, "=== результат" )  # DEBUGG_TO_LOGG
      relation_match_arr.each do |tree_row|
        profiles_hash = fill_arrays_in_hash(profiles_hash, tree_row.user_id, tree_row.profile_id, relation_row.relation_id)
        found_profiles_hash.merge!( profile_id_searched  => profiles_hash ) # наполнение хэша соответствиями найденных профилей и найденных отношений
      end
    else
      found_profiles_hash.merge!( profile_id_searched  => profiles_hash ) # наполнение хэша соответствиями найденных профилей и найденных отношений
      logger.info " "
      logger.info "=== НЕТ результата! В деревьях сайта ничего не найдено! === "
    end

    found_profiles_hash
  end

  # Поиск совпадений для одного из профилей
  # Берем параметр: profile_id из массива  = profiles_tree_arr[i][6].
  # @note GET /
  # @see News
  def search_match(connected_users, profile_id_searched, certain_koeff)

    logger.info " "
    logger.info "=== IN search_match "
    logger.info " "
    found_profiles_hash = Hash.new  #
    profiles_hash = Hash.new
    one_profile_relations_hash = Hash.new

    all_profile_rows = ProfileKey.where(:user_id => connected_users).where(:profile_id => profile_id_searched).order('relation_id','is_name_id').select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id).distinct
    # поиск массива записей искомого круга для каждого профиля в дереве Юзера
    logger.info "Круг ИСКОМОГО ПРОФИЛЯ = #{profile_id_searched.inspect} в (объединенном) дереве #{connected_users} зарег-го Юзера"      # :user_id, , :id
    show_in_logger(all_profile_rows, "all_profile_rows - запись" )  # DEBUGG_TO_LOGG

    all_profile_rows_No = 1 # DEBUGG_TO_LOGG
    if !all_profile_rows.blank?
      logger.info "all_profile_rows.size = #{all_profile_rows.size} " # DEBUGG_TO_LOGG
      # допускаем до поиска те круги искомых профилей, размер кот-х (кругов) больше или равно коэфф-та достоверности
      if all_profile_rows.size >= certain_koeff
        all_profile_rows.each do |relation_row|
          one_profile_relations_hash.merge!(relation_row.is_profile_id => relation_row.relation_id)
          # Получение РЕЗ-ТАТа ПОИСКА для одной записи Kруга искомого профиля - НАЙДЕННЫЕ ПРОФИЛИ С СОВПАВШИМИ ОТНОШЕНИЯМИ (hash)
          found_profiles_hash = get_found_profiles(profiles_hash, relation_row, connected_users, profile_id_searched)

          logger.info " "
          logger.info "=== После ПОИСКА по записи № #{all_profile_rows_No}" # DEBUGG_TO_LOGG
          logger.info "one_profile_relations_hash = #{one_profile_relations_hash} " # DEBUGG_TO_LOGG
          logger.info "profiles_hash = #{profiles_hash} " # DEBUGG_TO_LOGG
          logger.info "found_profiles_hash = #{found_profiles_hash} " # DEBUGG_TO_LOGG

          all_profile_rows_No += 1 # Подсчет номера по порядку очередной записи об искомом профиле  # DEBUGG_TO_LOGG
        end

      end

    else
      logger.info " "
      logger.info "ERROR in search_match: В искомом дереве - НЕТ искомого профиля!?? "
    end

    # ДОПОЛНИТЕЛЬНЫЙ РЕЗ-ТАТ ПОИСКА - СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА (массив ХЭШей ПАР ПРОФИЛЕЙ-ОТНОШЕНИЙ):
    @profiles_relations_arr = make_profile_relations(profile_id_searched, one_profile_relations_hash, @profiles_relations_arr)

    # ОСНОВНОЙ РЕЗ-ТАТ ПОИСКА - НАЙДЕННЫЕ ПРОФИЛИ С СОВПАВШИМИ ОТНОШЕНИЯМИ (массив):
    # {профиль искомый -> дерево -> профиль найденный -> [ массив совпавших отношений с искомым профилем ]
    @profiles_found_arr << found_profiles_hash if !found_profiles_hash.empty? # Заполнение выходного массива хэшей
    logger.info "Где что найдено: Для искомого профиля #{profile_id_searched} - в конце этого Хэша @profiles_found_arr:"
    logger.info "#{@profiles_found_arr} " # DEBUGG_TO_LOGG

  end # End of search_match


  ###### МЕТОДЫ ДЛЯ ИЗГОТОВЛЕНИЯ РЕЗУЛЬТАТОВ ПОИСКА (by_profiles, by_trees)
  ###### - для отображения на Главной

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

        # check_request_exists?

        # update_conn_req_id
        #



        by_profiles << one_result_hash

      end
    end

    # make final sorted by_profiles search results
    by_profiles = by_profiles.sort_by {|h| [ h[:count] ]}.reverse

    # get_found_profile_ids(by_profiles)
    # make final by_trees search results
    by_trees = make_by_trees_results(filling_hash)

    return by_profiles, by_trees
  end

  # # @note Получить массивы профилей упорядоченных по count для каждого дерева
  # def get_found_profile_ids(by_profiles)
  #
  #
  # end


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

  # # Служебный метод для отладки - для LOGGER
  # # todo: перенести этот метод в Operational - для нескольких моделей
  # # Показывает массив в logger
  # def show_in_logger(arr_to_log, string_to_add)
  #   row_no = 0  # DEBUGG_TO_LOGG
  #   arr_to_log.each do |row| # DEBUGG_TO_LOGG
  #     row_no += 1
  #     logger.debug "#{string_to_add} № #{row_no.inspect}: #{row.attributes.inspect} " # DEBUGG_TO_LOGG
  #   end  # DEBUGG_TO_LOGG
  # end




end # End of search module



#== Local 1 + 2  search from 3
# END OF start_search =========================
#        ======== search_data:
{:connected_author_arr=>[3],
 :qty_of_tree_profiles=>5,
 :profiles_relations_arr=>
     [{20=>{62=>3, 19=>8, 17=>15, 18=>16}},
      {19=>{17=>1, 18=>2, 62=>3, 16=>6, 20=>7}},
      {62=>{20=>1, 19=>2, 17=>92, 18=>102, 16=>202}},
      {17=>{19=>4, 16=>4, 18=>8, 20=>18, 62=>112}},
      {18=>{19=>4, 16=>4, 17=>7, 20=>18, 62=>112}}],
 :profiles_found_arr=>
     [{20=>{1=>{13=>[3, 8, 15, 16]},
            2=>{13=>[3, 8, 15, 16]}}},
      {19=>{1=>{7=>[1, 2, 3, 7]},
            2=>{7=>[1, 2, 3, 6, 7]}}},
      {62=>{1=>{11=>[1, 2, 92, 102]},
            2=>{11=>[1, 2, 92, 102, 202]}}},
      {17=>{1=>{8=>[4, 8, 18, 112]},
            2=>{8=>[4, 4, 8, 18, 112]}}},
      {18=>{1=>{9=>[4, 7, 18, 112]},
            2=>{9=>[4, 4, 7, 18, 112]}}}],
 :uniq_profiles_pairs=>
     {20=>{1=>13, 2=>13},
      19=>{1=>7, 2=>7},
      62=>{1=>11, 2=>11},
      17=>{1=>8, 2=>8},
      18=>{1=>9, 2=>9}},
 :profiles_with_match_hash=>
     {9=>5, 8=>5, 7=>5, 11=>5, 13=>4},
 :by_profiles=>
     [{:search_profile_id=>18, :found_tree_id=>2, :found_profile_id=>9, :count=>5},
      {:search_profile_id=>18, :found_tree_id=>1, :found_profile_id=>9, :count=>5},
      {:search_profile_id=>17, :found_tree_id=>2, :found_profile_id=>8, :count=>5},
      {:search_profile_id=>17, :found_tree_id=>1, :found_profile_id=>8, :count=>5},
      {:search_profile_id=>19, :found_tree_id=>1, :found_profile_id=>7, :count=>5},
      {:search_profile_id=>62, :found_tree_id=>1, :found_profile_id=>11, :count=>5},
      {:search_profile_id=>19, :found_tree_id=>2, :found_profile_id=>7, :count=>5},
      {:search_profile_id=>62, :found_tree_id=>2, :found_profile_id=>11, :count=>5},
      {:search_profile_id=>20, :found_tree_id=>2, :found_profile_id=>13, :count=>4},
      {:search_profile_id=>20, :found_tree_id=>1, :found_profile_id=>13, :count=>4}],
 :by_trees=>
     [{:found_tree_id=>1, :found_profile_ids=>[13, 7, 11, 8, 9]},
      {:found_tree_id=>2, :found_profile_ids=>[13, 7, 11, 8, 9]}],
 :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}
#
