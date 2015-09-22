module Search
  extend ActiveSupport::Concern


  # @note: Запуск мягкого поиска для объединения
  #   Значение certain_koeff - из вьюхи/
  def start_search(certain_koeff)

    tree_data =  Tree.tree_main_data(self) # collect tree info

    author_tree_arr      = tree_data[:author_tree_arr]
    tree_profiles        = tree_data[:tree_profiles]
    qty_of_tree_profiles = tree_data[:qty_of_tree_profiles]
    connected_author_arr = tree_data[:connected_author_arr]

    #from_profile_searching = author_tree_arr.profile_id     # От какого профиля осущ-ся Поиск DEBUGG_TO_LOGG
    #name_id_searched       = author_tree_arr.name_id        # Имя Профиля DEBUGG_TO_LOGG
    #relation_id_searched   = author_tree_arr.relation_id    # Искомое relation_id К_Профиля DEBUGG_TO_LOGG
    #is_name_id_searched    = author_tree_arr.is_name_id     # Искомое Имя К_Профиля DEBUGG_TO_LOGG
    #profile_id_searched    = author_tree_arr.is_profile_id  # Поиск по ID К_Профиля

    # Задание на поиск от Дерева Юзера:
    # tree_is_profiles = [9, 15, 14, 21, 8, 19, 11, 7, 2, 20, 16, 10, 17, 12, 3, 13, 124, 18] - in RSpec user_spec.rb

    # puts "======================= RUN start_search ========================= "
    logger.info "======================= RUN start_search ========================= "
    logger.info "B Искомом дереве #{connected_author_arr} - kол-во профилей:  #{qty_of_tree_profiles}"
    show_in_logger(author_tree_arr, "=== результат" )  # DEBUGG_TO_LOGG
    logger.info "Задание на поиск от Дерева Юзера:  author_tree_arr.size = #{author_tree_arr.size}, tree_profiles = #{tree_profiles} "
    logger.info "Коэффициент достоверности: certain_koeff = #{certain_koeff}"

    ############### ПОИСК ######## NEW LAST METHOD ############
    search_profiles_from_tree(certain_koeff, connected_author_arr, tree_profiles) # Основной поиск по дереву Автора среди деревьев в ProfileKeys.

    # TEST CONNECTION FAILS
    # @duplicates_one_to_many = { 3=> [2, 4]}     # for DEBUGG ONLY!!!
    # @duplicates_many_to_one = { 4=> 2, 3 => 2}  # for DEBUGG ONLY!!!

    results = {
        tree_profiles:            tree_data[:tree_profiles],        # where use? - in RSpec, View
        connected_author_arr:     tree_data[:connected_author_arr], # where use? - in RSpec, View
        qty_of_tree_profiles:     tree_data[:qty_of_tree_profiles], # where use? - in RSpec, View
        ############### РЕЗУЛЬТАТЫ ПОИСКА ######## NEW METHOD ############
        profiles_relations_arr:   @profiles_relations_arr, #  DEBUGG_TO_LOGG
        profiles_found_arr:       @profiles_found_arr, #  DEBUGG_TO_LOGG
        uniq_profiles_pairs:      @uniq_profiles_pairs,
        profiles_with_match_hash: @profiles_with_match_hash, #  DEBUGG_TO_LOGG
        ############# РЕЗУЛЬТАТЫ ПОИСКА для отображения на Главной ##########################################
        by_profiles:              @by_profiles,
        by_trees:                 @by_trees,
        ############### ДУБЛИКАТЫ ПОИСКА ######## NEW METHOD ############
        duplicates_one_to_many:   @duplicates_one_to_many,
        duplicates_many_to_one:   @duplicates_many_to_one
    }

    # From 46 - > in 45 .. 47

    # by_profiles
     [{:search_profile_id=>665, :found_tree_id=>45, :found_profile_id=>647, :count=>7},
      {:search_profile_id=>657, :found_tree_id=>47, :found_profile_id=>667, :count=>7},
      {:search_profile_id=>664, :found_tree_id=>45, :found_profile_id=>646, :count=>7},
      {:search_profile_id=>658, :found_tree_id=>47, :found_profile_id=>668, :count=>7},
      {:search_profile_id=>658, :found_tree_id=>45, :found_profile_id=>645, :count=>7},
      {:search_profile_id=>659, :found_tree_id=>47, :found_profile_id=>666, :count=>7},
      {:search_profile_id=>659, :found_tree_id=>45, :found_profile_id=>650, :count=>7},
      {:search_profile_id=>656, :found_tree_id=>47, :found_profile_id=>669, :count=>7},
      {:search_profile_id=>656, :found_tree_id=>45, :found_profile_id=>649, :count=>7},
      {:search_profile_id=>665, :found_tree_id=>47, :found_profile_id=>673, :count=>5},
      {:search_profile_id=>662, :found_tree_id=>47, :found_profile_id=>670, :count=>5},
      {:search_profile_id=>662, :found_tree_id=>34, :found_profile_id=>540, :count=>5},
      {:search_profile_id=>657, :found_tree_id=>45, :found_profile_id=>651, :count=>5},
      {:search_profile_id=>657, :found_tree_id=>34, :found_profile_id=>539, :count=>5},
      {:search_profile_id=>664, :found_tree_id=>47, :found_profile_id=>672, :count=>5},
      {:search_profile_id=>658, :found_tree_id=>34, :found_profile_id=>544, :count=>5},
      {:search_profile_id=>659, :found_tree_id=>34, :found_profile_id=>543, :count=>5},
      {:search_profile_id=>663, :found_tree_id=>47, :found_profile_id=>671, :count=>5},
      {:search_profile_id=>663, :found_tree_id=>34, :found_profile_id=>541, :count=>5},
      {:search_profile_id=>656, :found_tree_id=>34, :found_profile_id=>542, :count=>5}]

    # by_trees
     [{:found_tree_id=>34, :found_profile_ids=>[542, 541, 543, 544, 539, 540]},
      {:found_tree_id=>45, :found_profile_ids=>[649, 650, 645, 646, 651, 647]},
      {:found_tree_id=>47, :found_profile_ids=>[669, 671, 666, 668, 672, 667, 670, 673]}]

    # duplicates_one_to_many
     {711=>{45=>{648=>5, 710=>5}}}


    # From 45 - > in 46 .. 47
    # [inf] by_profiles =
        [{:search_profile_id=>649, :found_tree_id=>46, :found_profile_id=>656, :count=>7},
         {:search_profile_id=>646, :found_tree_id=>46, :found_profile_id=>664, :count=>7},
         {:search_profile_id=>647, :found_tree_id=>46, :found_profile_id=>665, :count=>7},
         {:search_profile_id=>650, :found_tree_id=>46, :found_profile_id=>659, :count=>7},
         {:search_profile_id=>645, :found_tree_id=>46, :found_profile_id=>658, :count=>7},
         {:search_profile_id=>649, :found_tree_id=>47, :found_profile_id=>669, :count=>5},
         {:search_profile_id=>646, :found_tree_id=>47, :found_profile_id=>672, :count=>5},
         {:search_profile_id=>651, :found_tree_id=>47, :found_profile_id=>667, :count=>5},
         {:search_profile_id=>651, :found_tree_id=>46, :found_profile_id=>657, :count=>5},
         {:search_profile_id=>647, :found_tree_id=>47, :found_profile_id=>673, :count=>5},
         {:search_profile_id=>650, :found_tree_id=>47, :found_profile_id=>666, :count=>5},
         {:search_profile_id=>645, :found_tree_id=>47, :found_profile_id=>668, :count=>5}]

    # [inf] by_trees =
        [{:found_tree_id=>46, :found_profile_ids=>[658, 659, 665, 657, 664, 656]},
         {:found_tree_id=>47, :found_profile_ids=>[668, 666, 673, 667, 672, 669]}]

    # duplicates_Many_to_One =
        {648=>{46=>711}, 710=>{46=>711}}



    logger.info "= Before store_search_results ========== results = #{results} "
    # if (results[:duplicates_one_to_many].empty? && results[:duplicates_many_to_one].empty?)
      # Store new results ONLY IF there are NO BOTH duplicates
      store_search_results(results) # запись рез-тов поиска в отдельную таблицу - для Метеора
    # end


   # Start double_users_search(results) - only first time after registration
   ############# SWITCHED OFF - double_users_search
   if self.double == 0
     if results[:by_trees].blank?
       self.update_attributes(:double => 1, :updated_at => Time.now)
       logger.info "Start + No search: double => 1: self.double = #{self.double} " # DEBUGG_TO_LOGG
     else
       logger.info "Start + Search: double_users_search: self.double = #{self.double} " # DEBUGG_TO_LOGG
       doubles_search_data = { relations_arr: results[:profiles_relations_arr],
                               by_trees: results[:by_trees] }
       self.double_users_search(doubles_search_data, certain_koeff)
       logger.info "After double_users_search: self.double = #{self.double} " # DEBUGG_TO_LOGG
     end
   end


    logger.info "== END OF start_search ===  results = #{results.inspect}"
    # puts "== END OF start_search === "
    results

    # {:connected_author_arr=>[1, 2], :qty_of_tree_profiles=>16,
    #  :profiles_relations_arr=>[{:profile_searched=>9, :profile_relations=>{3=>4, 10=>8, 2=>18, 17=>112}},
    #                            {:profile_searched=>15, :profile_relations=>{17=>1, 11=>2, 243=>4, 16=>5, 2=>91, 12=>92, 3=>101, 13=>102, 14=>202}},
    #                            {:profile_searched=>14, :profile_relations=>{12=>1, 13=>2, 11=>6, 18=>91, 19=>101, 15=>212, 16=>212}},
    #                            {:profile_searched=>243, :profile_relations=>{}},
    #                            {:profile_searched=>8, :profile_relations=>{2=>3, 7=>7, 3=>17, 17=>111}},
    #                            {:profile_searched=>19, :profile_relations=>{12=>3, 18=>7, 11=>121, 14=>121}},
    #                            {:profile_searched=>11, :profile_relations=>{12=>1, 13=>2, 15=>3, 16=>3, 14=>6, 17=>7, 2=>13, 3=>14, 18=>91, 19=>101}},
    #                            {:profile_searched=>2, :profile_relations=>{7=>1, 8=>2, 17=>3, 3=>8, 9=>15, 10=>16, 11=>17, 15=>111, 16=>111}},
    #                            {:profile_searched=>7, :profile_relations=>{2=>3, 8=>8, 3=>17, 17=>111}},
    #                            {:profile_searched=>16, :profile_relations=>{17=>1, 11=>2, 15=>5, 2=>91, 12=>92, 3=>101, 13=>102, 14=>202}},
    #                            {:profile_searched=>10, :profile_relations=>{3=>4, 9=>7, 2=>18, 17=>112}},
    #                            {:profile_searched=>17, :profile_relations=>{2=>1, 3=>2, 15=>3, 16=>3, 11=>8, 12=>15, 13=>16, 7=>91, 9=>92, 8=>101, 10=>102}},
    #                            {:profile_searched=>12, :profile_relations=>{18=>1, 19=>2, 11=>4, 14=>4, 13=>8, 17=>18, 15=>112, 16=>112}},
    #                            {:profile_searched=>3, :profile_relations=>{9=>1, 10=>2, 17=>3, 2=>7, 7=>13, 8=>14, 11=>17, 15=>111, 16=>111}},
    #                            {:profile_searched=>13, :profile_relations=>{11=>4, 14=>4, 12=>7, 17=>18, 15=>112, 16=>112}},
    #                            {:profile_searched=>18, :profile_relations=>{12=>3, 19=>8, 11=>121, 14=>121}}],
    #  :profiles_found_arr=>[{9=>{19=>{367=>[4]}}}, {15=>{3=>{215=>[1, 2, 5, 92, 102, 202]}, 9=>{85=>[1, 2, 4, 5, 91, 101]}, 10=>{100=>[1, 2, 4]}, 11=>{128=>[1, 2, 5, 91, 92, 101, 102]}}}, {14=>{3=>{22=>[1, 2, 6, 91, 101, 212, 212]}}}, {8=>{21=>{391=>[7]}}}, {19=>{3=>{27=>[3, 7, 121, 121]}}}, {11=>{3=>{25=>[1, 2, 3, 3, 6, 7, 91, 101]}, 11=>{127=>[1, 2, 3, 3, 7, 13, 14]}, 9=>{87=>[3, 3, 7, 13, 14]}, 10=>{171=>[3, 7]}}}, {2=>{9=>{172=>[3, 8, 17, 111, 111]}, 11=>{139=>[3, 8, 17, 111, 111]}}}, {7=>{21=>{390=>[8]}}}, {16=>{3=>{216=>[1, 2, 5, 92, 102, 202]}, 9=>{88=>[1, 2, 5, 91, 101]}, 11=>{125=>[1, 2, 5, 91, 92, 101, 102]}}}, {10=>{}}, {17=>{9=>{86=>[1, 2, 3, 3, 8]}, 11=>{126=>[1, 2, 3, 3, 8, 15, 16]}, 3=>{209=>[3, 3, 8, 15, 16]}, 10=>{170=>[3, 8]}}}, {12=>{3=>{23=>[1, 2, 4, 4, 8, 18, 112, 112]}, 11=>{155=>[4, 8, 18, 112, 112]}}}, {3=>{19=>{383=>[1]}, 9=>{173=>[3, 7, 17, 111, 111]}, 11=>{154=>[3, 7, 17, 111, 111]}}}, {13=>{3=>{24=>[4, 4, 7, 18, 112, 112]}, 11=>{156=>[4, 7, 18, 112, 112]}}}, {18=>{3=>{26=>[3, 8, 121, 121]}}}],
    #  :uniq_profiles_pairs=>{15=>{3=>215, 9=>85, 11=>128}, 14=>{3=>22}, 19=>{3=>27}, 11=>{3=>25, 11=>127, 9=>87}, 2=>{9=>172, 11=>139}, 16=>{3=>216, 9=>88, 11=>125}, 17=>{9=>86, 11=>126, 3=>209}, 12=>{3=>23, 11=>155}, 3=>{9=>173, 11=>154}, 13=>{3=>24, 11=>156}, 18=>{3=>26}},
    #  :profiles_with_match_hash=>{23=>8, 25=>8, 126=>7, 125=>7, 127=>7, 22=>7, 128=>7, 24=>6, 216=>6, 85=>6, 215=>6, 156=>5, 154=>5, 173=>5, 155=>5, 209=>5, 86=>5, 88=>5, 139=>5, 172=>5, 87=>5, 26=>4, 27=>4},
    #  :by_profiles=>[{:search_profile_id=>12, :found_tree_id=>3, :found_profile_id=>23, :count=>8},
    #                 {:search_profile_id=>11, :found_tree_id=>3, :found_profile_id=>25, :count=>8},
    #                 {:search_profile_id=>17, :found_tree_id=>11, :found_profile_id=>126, :count=>7},
    #                 {:search_profile_id=>16, :found_tree_id=>11, :found_profile_id=>125, :count=>7},
    #                 {:search_profile_id=>11, :found_tree_id=>11, :found_profile_id=>127, :count=>7},
    #                 {:search_profile_id=>14, :found_tree_id=>3, :found_profile_id=>22, :count=>7},
    #                 {:search_profile_id=>15, :found_tree_id=>11, :found_profile_id=>128, :count=>7},
    #                 {:search_profile_id=>13, :found_tree_id=>3, :found_profile_id=>24, :count=>6},
    #                 {:search_profile_id=>16, :found_tree_id=>3, :found_profile_id=>216, :count=>6},
    #                 {:search_profile_id=>15, :found_tree_id=>9, :found_profile_id=>85, :count=>6},
    #                 {:search_profile_id=>15, :found_tree_id=>3, :found_profile_id=>215, :count=>6},
    #                 {:search_profile_id=>13, :found_tree_id=>11, :found_profile_id=>156, :count=>5},
    #                 {:search_profile_id=>3, :found_tree_id=>11, :found_profile_id=>154, :count=>5},
    #                 {:search_profile_id=>3, :found_tree_id=>9, :found_profile_id=>173, :count=>5},
    #                 {:search_profile_id=>12, :found_tree_id=>11, :found_profile_id=>155, :count=>5},
    #                 {:search_profile_id=>17, :found_tree_id=>3, :found_profile_id=>209, :count=>5},
    #                 {:search_profile_id=>17, :found_tree_id=>9, :found_profile_id=>86, :count=>5},
    #                 {:search_profile_id=>16, :found_tree_id=>9, :found_profile_id=>88, :count=>5},
    #                 {:search_profile_id=>2, :found_tree_id=>11, :found_profile_id=>139, :count=>5},
    #                 {:search_profile_id=>2, :found_tree_id=>9, :found_profile_id=>172, :count=>5},
    #                 {:search_profile_id=>11, :found_tree_id=>9, :found_profile_id=>87, :count=>5},
    #                 {:search_profile_id=>18, :found_tree_id=>3, :found_profile_id=>26, :count=>4},
    #                 {:search_profile_id=>19, :found_tree_id=>3, :found_profile_id=>27, :count=>4}],
    #  :by_trees=>[{:found_tree_id=>3, :found_profile_ids=>[215, 22, 27, 25, 216, 209, 23, 24, 26]},
    #              {:found_tree_id=>9, :found_profile_ids=>[85, 87, 172, 88, 86, 173]},
    #              {:found_tree_id=>11, :found_profile_ids=>[128, 127, 139, 125, 126, 155, 154, 156]}],
    #  :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}
    #

  end # END OF start_search


  def clear_prev_results(by_trees)
    previous_results = SearchResults.where(user_id: self, found_user_id: collect_tree_ids(by_trees))
    # previous_results_count = previous_results.count
    # puts "In store_search_results = found_tree_ids = #{collect_tree_ids(by_trees).inspect}, previous_results_count = #{previous_results_count.inspect} "
    previous_results.each(&:destroy) unless previous_results.blank?
  end


  # @note: Check and delete_if: if one_hash contains {found_tree_id: tree_id_with_double} - tree w/doubles results
  #   If No -> leave this one_hash in by_trees_arr of hashes
  # @params: by_trees_arr - from search results
  #   tree_ids_to_exclude - arr of tree ids where doubles were found
  def exclude_doubles_results(by_trees_arr, tree_ids_to_exclude)
    tree_ids_to_exclude.each do |tree_id_with_double|
      by_trees_arr.delete_if { |one_hash| one_hash.merge({found_tree_id: tree_id_with_double }) == one_hash }
    end
    by_trees_arr
  end

  # @note: Find tree ids, which contains doubles, for one type double
  #   and make an array of this ids
  # @params: one_type_doubles - from search results - hash with one type double
  # @input: results[:duplicates_one_to_many] = {711=>{45=>{648=>5, 710=>5}}}
  # @input: results[:duplicates_Many_to_One =  {648=>{46=>711}, 710=>{46=>711}}
  def collect_one_doubles_ids(one_type_doubles)
    tree_ids_with_doubles = []
    one_type_doubles.each_value do |val|
      val.each_key do |key|
        tree_ids_with_doubles << key
      end
    end
    tree_ids_with_doubles.uniq
  end


  # @note: collect ids of trees, which contains doubles, for each type of doubles,
  #   and make an ids array
  def collect_doubles_tree_ids(results)
    tree_ids_one_to_many = []
    tree_ids_many_to_one = []
    tree_ids_one_to_many = collect_one_doubles_ids(results[:duplicates_one_to_many]) unless results[:duplicates_one_to_many].empty?
    tree_ids_many_to_one = collect_one_doubles_ids(results[:duplicates_many_to_one]) unless results[:duplicates_many_to_one].empty?
    (tree_ids_one_to_many + tree_ids_many_to_one).uniq
  end

  # @note запись рез-тов поиска в отдельную таблицу
  #   Вначале - удаление предыд-х рез-тов: clear_prev_results
  #   Далее: сбор ИД деревьев, в кот-х есть дубликаты: collect_doubles_tree_ids
  #   Далее: Если такие деревья есть, то сокращение массивов рез-тов поиска (для сохранения): exclude_doubles_results
  #   Сохранение рез-тов, не имеющих дубликатов: store_results
  def store_search_results(results)
    by_profiles = results[:by_profiles]
    by_trees = results[:by_trees]
    current_user_tree_ids = results[:connected_author_arr]

    clear_prev_results(by_trees)
    tree_ids_to_exclude = collect_doubles_tree_ids(results)
    logger.info "# In home/index: after exclude_doubles_results: tree_ids_to_exclude = #{tree_ids_to_exclude}, by_trees = #{by_trees}"
    unless tree_ids_to_exclude.blank?
      by_trees = exclude_doubles_results(results[:by_trees], tree_ids_to_exclude)
    end
    logger.info "# In home/index: after exclude_doubles_results: by_trees = #{by_trees}"
    store_results(collect_tree_ids(by_trees), by_profiles, current_user_tree_ids)
  end


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
  def store_results(found_tree_ids, by_profiles, current_user_tree_ids)

    found_tree_ids.each do |tree_id|
      searched_profile_ids, found_profile_ids, counts = collect_search_profile_ids(by_profiles, tree_id)

      connected_tree_id = User.find(tree_id).get_connected_users # Состав объединенного дерева в виде массива id

      connection_id = counter_request_exist(connected_tree_id, current_user_tree_ids)
      value = my_request_exist(connected_tree_id, current_user_tree_ids)

      SearchResults.create(user_id: self.id, found_user_id: tree_id, profile_id: searched_profile_ids[0],
                           found_profile_id: found_profile_ids[0], count: counts[0],
                           found_profile_ids: found_profile_ids, searched_profile_ids: searched_profile_ids,
                           counts: counts, connection_id: connection_id, pending_connect: value  )
    end

    # qty_rows = SearchResults.all.count  # for RSpec
    # puts "In store_results - SearchResults created: All qty_rows = #{qty_rows.inspect} "

  end


  # @note Если запрос текущего юзера существует, то устанавливаем в 1 его рез-тов поиска
  def my_request_exist(connected_tree_id, current_user_tree_ids)
    my_request = ConnectionRequest.where("with_user_id in (?)", connected_tree_id).where(:done => false )
                                  .where("user_id in (?)", current_user_tree_ids)
    value = 0
    unless my_request.blank?
      value = 1
    end
    # puts "In request_exist: value = #{value.inspect} "
    value
  end


  # @note Если встречный запрос существует, то получаем его connection_id
  def counter_request_exist(connected_tree_id, current_user_tree_ids)
    request = ConnectionRequest.where("user_id in (?)", connected_tree_id)
                               .where("with_user_id in (?)", current_user_tree_ids).where(:done => false )
    unless request.blank?
      connection_id = request[0].connection_id
    end
    # puts "In request_exist: connection_id = #{connection_id.inspect} "
    connection_id
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
                             .where(:name_id => relation_row.name_id, :relation_id => relation_row.relation_id, :is_name_id => relation_row.is_name_id, deleted: 0)
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

    all_profile_rows = ProfileKey.where(:user_id => connected_users).where(:profile_id => profile_id_searched, deleted: 0).order('relation_id','is_name_id').select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id).distinct
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


  # make final sorted by_trees search results
  def make_by_trees_results(filling_hash)
    by_trees = []
    filling_hash.each do |tree_id, profiles_ids|
      one_tree_hash = {}
      one_tree_hash.merge!(:found_tree_id => tree_id)
      one_tree_hash.merge!(:found_profile_ids => profiles_ids)
      by_trees << one_tree_hash
    end
    by_trees
  end




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
