class SearchResults < ActiveRecord::Base

  #############################################################
  # Иванищев А.В. 2015
  # Результаты поиска
  #############################################################
  # Расчет параметров результатов и сохранение в БД
  # @note: Here is the storage of SearchResults class methods
  #   to evaluate data to be stored
  #   as proper results
  #############################################################

  validates_presence_of :user_id, :found_user_id, :profile_id, :found_profile_id, :count, :found_profile_ids,
                        :searched_profile_ids, :counts,
                        :message => "Должно присутствовать в SearchResults"
  validates_numericality_of :user_id, :found_user_id, :profile_id, :found_profile_id, :count, :pending_connect,
                            :only_integer => true,
                            :message => "Должны быть целым числом в SearchResults"
  validates_numericality_of :user_id, :found_user_id, :profile_id, :found_profile_id, :count,
                            :greater_than => 0,
                            :message => "Должны быть больше 0 в SearchResults"
  validates_numericality_of :connection_id, :only_integer => true, :greater_than => 0, allow_nil: true,
                            :message => "Должно быть больше 0 и целым числом, если существует, в SearchResults"
  validates_inclusion_of :pending_connect, :in => [0, 1],
                         :message => ":pending_connect должно быть [0, 1] в SearchResults"

  # custom validations
  validate :count_value_more_certain  # :count

  def count_value_more_certain
    certain_koeff = 4 #WeafamSetting.first.certain_koeff
    self.errors.add(:search_results, 'Макс. кол-во отношений не должно быть меньше, чем настройка в WeafamSetting.') if self.count < certain_koeff
  end

  validate :searched_n_found_users_unequal  # :user_id  AND :found_user_id
  def searched_n_found_users_unequal
    self.errors.add(:search_results, 'Юзеры в одном ряду не должны быть равны в SearchResults.') if self.user_id == self.found_user_id
  end

  validate :search_found_profiles_unequal  # :profile_id  AND :found_profile_id
  def search_found_profiles_unequal
    self.errors.add(:search_results, 'Профили в одном ряду не должны быть равны в SearchResults.') if self.profile_id == self.found_profile_id
  end


  validate :validate_found_profile_ids
  validate :validate_searched_profile_ids
  validate :validate_counts
  def validate_found_profile_ids
    unless found_profile_ids.is_a?(Array)
      errors.add(:found_profile_ids, :invalid)
    end
  end

  def validate_searched_profile_ids
    unless searched_profile_ids.is_a?(Array)
      errors.add(:searched_profile_ids, :invalid)
    end
  end

  def validate_counts
    unless counts.is_a?(Array)
      errors.add(:counts, :invalid)
    end
  end


  #Scopes
  # use in self.one_result_destroy
  # scope :one_way_result, -> (user_id, found_user_id) {where("user_id in (?)", user_id).
  #                                                     where("found_user_id in (?)", found_user_id)}
  scope :one_way_result,     -> (connected_users) {where("user_id in (?)", connected_users)}
  scope :one_opp_way_result, -> (connected_users) {where("found_user_id in (?)", connected_users)}



  # @note: МЕТОДЫ ДЛЯ ИЗГОТОВЛЕНИЯ РЕЗУЛЬТАТОВ ПОИСКА (by_profiles, by_trees)
  #   make final search results to store
  def self.make_search_results(uniq_hash, profiles_match_hash)
    by_profiles = []
    filling_hash = {}
    uniq_hash.each do |search_profile_id, found_hash|
      hash_results_data = {
          search_profile_id: search_profile_id,
          found_hash: found_hash,
          filling_hash: filling_hash,
          profiles_match_hash: profiles_match_hash,
          by_profiles: by_profiles
      }
      by_profiles = filling_by_profiles(hash_results_data)
    end
    return make_final_bys(filling_hash, by_profiles)
  end

  # @note подготовка рез-тов поиска - по профилям (by_profiles)
  def self.filling_by_profiles(hash_results_data)
    search_profile_id   = hash_results_data[:search_profile_id]
    found_hash          = hash_results_data[:found_hash]
    filling_hash        = hash_results_data[:filling_hash]
    profiles_match_hash = hash_results_data[:profiles_match_hash]
    by_profiles         = hash_results_data[:by_profiles]

    found_hash.each do |found_tree_id, found_profile_id|
      # make fill_hash for by_trees search results
      SearchWork.fill_hash_w_val_arr(filling_hash, found_tree_id, found_profile_id)
      one_result_data = {
          search_profile_id:    search_profile_id,
          found_tree_id:        found_tree_id,
          found_profile_id:     found_profile_id,
          profiles_match_hash:  profiles_match_hash
      }
      by_profiles << collect_result_hush(one_result_data)
    end
    by_profiles
  end


  # @note подготовка of One Hash of рез-тов поиска
  def self.collect_result_hush(one_result_data)

    found_profile_id    = one_result_data[:found_profile_id]
    profiles_match_hash = one_result_data[:profiles_match_hash]

    one_result_hash = {}
    count = 0
    one_result_hash.merge!(:search_profile_id => one_result_data[:search_profile_id])
    one_result_hash.merge!(:found_tree_id => one_result_data[:found_tree_id])
    one_result_hash.merge!(:found_profile_id => found_profile_id)
    count = profiles_match_hash.values_at(found_profile_id)[0] unless profiles_match_hash.empty?
    one_result_hash.merge!(:count => count)

    one_result_hash
  end


  # @note подготовка частей рез-тов поиска - по профилям (by_profiles) и по деревьям (by_trees)
  def self.make_final_bys(filling_hash, by_profiles)
    # make final sorted by_profiles search results
    by_profiles = by_profiles.sort_by {|one_hash| [ one_hash[:count] ]}.reverse
    # make final by_trees search results
    by_trees = SearchWork.make_by_trees_results(filling_hash)
    return by_profiles, by_trees
  end

  # @note запись рез-тов поиска в отдельную таблицу
  #   Store new results ONLY IF there are NO BOTH TYPEs duplicates
  #   Вначале - удаление предыд-х рез-тов: clear_prev_results
  #   Далее: сбор ИД деревьев, в кот-х есть дубликаты: collect_doubles_tree_ids
  #   Далее: Если такие деревья есть, то сокращение массивов рез-тов поиска (для сохранения): exclude_doubles_results
  #   Сохранение рез-тов, не имеющих дубликатов: store_results
  def self.store_search_results(results, current_user_id)
    clear_all_prev_results(current_user_id)
    # clear_prev_results(results[:by_trees], current_user_id)
    by_trees_to_store = update_by_trees(results)
    unless by_trees_to_store.blank?
      store_data = { tree_ids: collect_tree_ids_by_trees(by_trees_to_store), by_profiles: results[:by_profiles],
                     current_user_tree_ids: results[:connected_author_arr], current_user_id: current_user_id }
      store_results_no_doubles(store_data)
    end
  end

  # @note: prepare and store new search results if there were no doublicates
  def self.store_results_no_doubles(store_data)
    # logger.info "#### In  store_results_no_doubles: store_data = #{store_data}"
    search_results_arr = make_results(store_data)
    # logger.info "#### In  store_results_no_doubles: search_results_arr = #{search_results_arr}"
 #   search_opp_results_arr = make_opposite_results(store_data)
    # logger.info "#### In  store_results_no_doubles: search_opp_results_arr = #{search_opp_results_arr}"
 #   search_results_both_dir = search_results_arr + search_opp_results_arr
    # logger.info "#### In  store_results_no_doubles: search_results_both_dir = #{search_results_both_dir}"
    create_search_results(search_results_arr)

  end

  # search_results_arr =
      [{:user_id=>34, :found_user_id=>46, :profile_id=>540, :found_profile_id=>662, :count=>5,
        :found_profile_ids=>[662, 658, 659, 663, 656, 657], :searched_profile_ids=>[540, 544, 543, 541, 542, 539],
        :counts=>[5, 5, 5, 5, 5, 5], :connection_id=>nil, :pending_connect=>0},
       {:user_id=>34, :found_user_id=>47, :profile_id=>540, :found_profile_id=>670, :count=>5,
        :found_profile_ids=>[670, 668, 666, 671, 669, 667], :searched_profile_ids=>[540, 544, 543, 541, 542, 539],
        :counts=>[5, 5, 5, 5, 5, 5], :connection_id=>nil, :pending_connect=>0}]

  # In  search_opp_results_arr =
    [{:user_id=>46, :found_user_id=>34, :profile_id=>662, :found_profile_id=>540, :count=>5,
      :found_profile_ids=>[540, 544, 543, 541, 542, 539], :searched_profile_ids=>[662, 658, 659, 663, 656, 657],
      :counts=>[5, 5, 5, 5, 5, 5], :connection_id=>nil, :pending_connect=>0},
     {:user_id=>47, :found_user_id=>34, :profile_id=>670, :found_profile_id=>540, :count=>5,
      :found_profile_ids=>[540, 544, 543, 541, 542, 539], :searched_profile_ids=>[670, 668, 666, 671, 669, 667],
      :counts=>[5, 5, 5, 5, 5, 5], :connection_id=>nil, :pending_connect=>0}]


  # @note - prepare data for результатов поиска and search arrays
  def self.make_results(store_data)
    search_results_arr = []
    # logger.info "#### In  make_results: store_data[:tree_ids] = #{store_data[:tree_ids]}"
    store_data[:tree_ids].each do |tree_id|
      # logger.info "#### In  make_results.each: tree_id = #{tree_id}, store_data[:tree_ids] = #{store_data[:tree_ids]}"
      results_arrs = collect_search_profile_ids(store_data[:by_profiles], tree_id)
      found_tree_ids = User.find(tree_id).get_connected_users # Состав объединенного дерева в виде массива id
      conn_id = set_connection_id(store_data[:current_user_tree_ids], found_tree_ids)
      opp_conn_id = set_connection_id(found_tree_ids, store_data[:current_user_tree_ids])
      params_to_store = get_results_params(found_tree_ids, store_data[:current_user_tree_ids])
      opp_params_to_store = get_results_params(store_data[:current_user_tree_ids], found_tree_ids)
      # params_to_store = make_results_arrs(store_data, tree_id)
      results_arrs[:tree_id] = tree_id
      searched_profile_ids = results_arrs[:search_profile_id]
      found_profile_ids    = results_arrs[:found_profile_id]
      counts               = results_arrs[:count]

      one_result = { user_id: store_data[:current_user_id],
                     found_user_id: results_arrs[:tree_id],
                     profile_id: searched_profile_ids[0],
                     found_profile_id: found_profile_ids[0],
                     count: counts[0],
                     found_profile_ids: found_profile_ids,
                     searched_profile_ids: searched_profile_ids,
                     counts: counts,
                     # connection_id: params_to_store[:connection_id],
                     connection_id: conn_id,
                     pending_connect: params_to_store[:pending_value],
                     searched_connected: params_to_store[:current_tree_ids],
                     founded_connected: params_to_store[:connected_tree_ids] }
      search_results_arr << one_result

      one_opp_result = { user_id: tree_id, # store_data[:current_user_id],
                     found_user_id: store_data[:current_user_id], # tree_id,
                     profile_id: found_profile_ids[0], # searched_profile_ids[0],
                     found_profile_id: searched_profile_ids[0], # found_profile_ids[0],
                     count: counts[0],
                     found_profile_ids: searched_profile_ids, # found_profile_ids,
                     searched_profile_ids: found_profile_ids, # searched_profile_ids,
                     counts: counts,
                     # connection_id: opp_params_to_store[:connection_id],
                     connection_id: opp_conn_id,
                     pending_connect: opp_params_to_store[:pending_value],
                     searched_connected: opp_params_to_store[:current_tree_ids],
                     founded_connected: opp_params_to_store[:connected_tree_ids] }
      search_results_arr << one_opp_result



      # logger.info "#### In  make_results.IN each: search_results_arr = #{search_results_arr}"
    end
    search_results_arr
  end


  # @note: determine search_results prams to be stored
  def self.get_results_params(connected_one_tree, connected_other_tree)
    # puts "In get_results_params: tree_id = #{tree_id.inspect}, connected_tree_ids = #{connected_tree_ids.inspect} "
    connection_id = set_connection_id(connected_one_tree, connected_other_tree)
    value = set_pending_request(connected_one_tree, connected_other_tree)
    { connection_id: connection_id, pending_value: value, current_tree_ids: connected_other_tree, connected_tree_ids: connected_one_tree }
  end

  # @note Если встречный запрос существует (if counter_request_exist), то получаем его connection_id
  # if request.blank? AND
  # if connected_other_tree = current tree ids, then connection_id should have value
  def self.set_connection_id(connected_one_tree, connected_other_tree)
    p " In set_connection_id: connected_one_tree = #{connected_one_tree}, connected_other_tree = #{connected_other_tree} "
    conn_request = ConnectionRequest
                  .where("user_id in (?)", connected_one_tree)
                  .where("with_user_id in (?)", connected_other_tree)
                  .where(:done => false )
    connection_id = nil
    connection_id = conn_request[0].connection_id unless conn_request.blank?
    p " In set_connection_id:  connection_id = #{connection_id.inspect}, conn_request.count = #{conn_request.count}"
    connection_id
  end

  # @note Если запрос текущего юзера существует, то устанавливаем
  # pending_connect в 1 его рез-тов поиска if my_request_exist
  def self.set_pending_request(connected_one_tree, connected_other_tree)
    p " In set_pending_request: connected_one_tree = #{connected_one_tree}, connected_other_tree = #{connected_other_tree} "
    pending_request = ConnectionRequest
                     .where("user_id in (?)", connected_other_tree)
                     .where("with_user_id in (?)", connected_one_tree)
                     .where(:done => false )
    value = 0
    value = 1 unless pending_request.blank?
    p " In set_pending_request:  pending_value = #{value}, pending_request.count = #{pending_request.count}"
    value
  end

  # # @note - prepare data for opposite результатов поиска and search arrays
  # def self.make_opposite_results(store_data)
  #   # logger.info "#### In  make_opposite_results: store_data[:tree_ids] = #{store_data[:tree_ids]}"
  #   search_opp_results_arr = []
  #   store_data[:tree_ids].each do |tree_id|
  #     results_arrs = collect_search_profile_ids(store_data[:by_profiles], tree_id)
  #     connected_tree_ids = User.find(tree_id).get_connected_users # Состав объединенного дерева в виде массива id
  #     # params_to_store = get_opp_results_params(connected_tree_ids, store_data[:current_user_tree_ids])
  #     params_to_store = get_opp_results_params(store_data[:current_user_tree_ids], connected_tree_ids)
  #     # params_to_store = make_opp_results_arrs(store_data, tree_id)
  #
  #     searched_profile_ids = results_arrs[:search_profile_id]
  #     found_profile_ids    = results_arrs[:found_profile_id]
  #     counts               = results_arrs[:count]
  #     one_result = { user_id: tree_id, # store_data[:current_user_id],
  #                    found_user_id: store_data[:current_user_id], # tree_id,
  #                    profile_id: found_profile_ids[0], # searched_profile_ids[0],
  #                    found_profile_id: searched_profile_ids[0], # found_profile_ids[0],
  #                    count: counts[0],
  #                    found_profile_ids: searched_profile_ids, # found_profile_ids,
  #                    searched_profile_ids: found_profile_ids, # searched_profile_ids,
  #                    counts: counts,
  #                    connection_id: params_to_store[:connection_id],
  #                    pending_connect: params_to_store[:pending_value],
  #                    searched_connected: params_to_store[:connected_tree_ids],
  #                    founded_connected: params_to_store[:current_tree_ids] }
  #     search_opp_results_arr << one_result
  #   end
  #   search_opp_results_arr
  # end


  # # @note: make more search_results params
  # def self.make_results_arrs(store_data, tree_id)
  #   # results_arrs = collect_search_profile_ids(store_data[:by_profiles], tree_id)
  #   # logger.info "#### In  make_results_arrs: results_arrs = #{results_arrs}"
  #   # logger.info "#### In  make_results_arrs: tree_id = #{tree_id}, store_data[:current_user_tree_ids] = #{store_data[:current_user_tree_ids]}"
  #   params_to_store = get_results_params(tree_id, store_data[:current_user_tree_ids])
  #   # logger.info "#### In  make_results_arrs: params_to_store = #{params_to_store}"
  #   return params_to_store
  # end

  # # @note: make more search_results params
  # def self.make_opp_results_arrs(store_data, tree_id)
  #   # results_arrs = collect_search_profile_ids(store_data[:by_profiles], tree_id)
  #   # logger.info "#### In  make_results_arrs: results_arrs = #{results_arrs}"
  #   # logger.info "#### In  make_results_arrs: tree_id = #{tree_id}, store_data[:current_user_tree_ids] = #{store_data[:current_user_tree_ids]}"
  #   params_to_store = get_results_params(tree_id, store_data[:current_user_tree_ids])
  #   # logger.info "#### In  make_results_arrs: params_to_store = #{params_to_store}"
  #   return params_to_store
  # end


  # # @note: determine search_results prams to be stored
  # def self.get_opp_results_params(connected_tree_ids, current_tree_ids)
  #   # connected_tree_ids = User.find(tree_id).get_connected_users # Состав объединенного дерева в виде массива id
  #   # puts "In get_results_params: tree_id = #{tree_id.inspect}, connected_tree_ids = #{connected_tree_ids.inspect} "
  #   connection_id = counter_request_exist(connected_tree_ids, current_tree_ids)
  #   value = my_request_exist(connected_tree_ids, current_tree_ids)
  #   { connection_id: connection_id, pending_value: value, current_tree_ids: current_tree_ids, connected_tree_ids: connected_tree_ids }
  # end

  # Сохранение массива search_results_arr в таблицу SearchResults
  def self.create_search_results(search_results_arr)
    search_results_arr.each do |one_result|
      # logger.info "#### In  create_search_results: one_result = #{one_result}"
      create(user_id:              one_result[:user_id],
             found_user_id:        one_result[:found_user_id],
             profile_id:           one_result[:profile_id],
             found_profile_id:     one_result[:found_profile_id],
             count:                one_result[:count],
             found_profile_ids:    one_result[:found_profile_ids],
             searched_profile_ids: one_result[:searched_profile_ids],
             counts:               one_result[:counts],
             connection_id:        one_result[:connection_id],
             pending_connect:      one_result[:pending_connect],
             searched_connected:   one_result[:searched_connected],
             founded_connected:    one_result[:founded_connected] )
    end
  end



  # @note: Clear all previous results for curent tree
  def self.clear_all_prev_results(current_user_id)
    connected_users = User.find(current_user_id).connected_users
    # puts "In clear_all_prev_results: connected_users = #{connected_users.inspect} "
    all_previous_to_results = where("user_id in (?)", connected_users)
    aii_previous_opp_results = where("found_user_id in (?)", connected_users)
    all_previous_results = all_previous_to_results + aii_previous_opp_results
    all_previous_results.each(&:destroy) unless all_previous_results.blank?

    #test
    # val = 692
    # check_arr = where(user_id: 49).where("#{val} = ANY (found_profile_ids)")
    # puts "In clear_all_prev_results: check_arr.found_profile_ids = #{check_arr[0].found_profile_ids.inspect},
    #       check_arr = #{check_arr.inspect}, val = #{val.inspect} "

  end


  # # @note: Clear previous search results before save new ones
  # def self.clear_prev_results(by_trees, current_user_id)
  #   previous_to_results = where(user_id: current_user_id, found_user_id: collect_tree_ids_by_trees(by_trees))
  #   previous_opp_results = where(user_id: collect_tree_ids_by_trees(by_trees), found_user_id: current_user_id )
  #   previous_results = previous_to_results + previous_opp_results
  #   previous_results.each(&:destroy) unless previous_results.blank?
  # end

  # @note - сбор tree_ids всех найденных деревьев по by_trees
  def self.collect_tree_ids_by_trees(by_trees)
    found_tree_ids = []
    by_trees.each do |one_found_tree|
      found_tree_ids << one_found_tree[:found_tree_id]
    end
    found_tree_ids
  end

  # @note: update trees ids: exclude trees ids with duplicates of both types
  def self.update_by_trees(results)
    by_trees_to_store = results[:by_trees]
    tree_ids_to_exclude = collect_doubles_tree_ids(results)
    # puts "In update_by_trees: tree_ids_to_exclude = #{tree_ids_to_exclude.inspect} "
    by_trees_to_store = exclude_doubles_results(by_trees_to_store, tree_ids_to_exclude) unless tree_ids_to_exclude.blank?
    by_trees_to_store
  end

  # @note: Check and delete_if: if one_hash contains {found_tree_id: tree_id_with_double} - tree w/doubles results
  #   If No -> leave this one_hash in by_trees_arr of hashes
  # @params: by_trees_arr - from search results
  #   tree_ids_to_exclude - arr of tree ids where doubles were found
  def self.exclude_doubles_results(by_trees_arr, tree_ids_to_exclude)
    tree_ids_to_exclude.each do |tree_id_with_double|
      one_double_tree_exclude(by_trees_arr, tree_id_with_double)
    end
    by_trees_arr
  end

  # @note: reduce by_trees_arr to one tree with doubles results
  def self.one_double_tree_exclude(by_trees_arr, tree_id_with_double)
    by_trees_arr.delete_if {|one_hash| one_hash.merge({found_tree_id: tree_id_with_double}) == one_hash }
  end

  # @note: collect ids of trees, which contains doubles, for each type of doubles,
  #   and make an ids array
  def self.collect_doubles_tree_ids(results)
    tree_ids_duplication, final_ids = [], []
    [results[:duplicates_one_to_many], results[:duplicates_many_to_one]].each do |duplication|
      tree_ids_duplication = collect_one_doubles_ids(duplication) unless duplication.empty?
      final_ids << tree_ids_duplication unless tree_ids_duplication.blank?
    end
    final_ids.flatten.uniq
  end

  # @note: Find tree ids, which contains doubles, for one type double
  #   and make an array of this ids
  # @params: one_type_doubles - from search results - hash with one type double
  # @input: results[:duplicates_one_to_many] = {711=>{45=>{648=>5, 710=>5}}}
  # @input: results[:duplicates_Many_to_One =  {648=>{46=>711}, 710=>{46=>711}}
  def self.collect_one_doubles_ids(one_type_doubles)
    tree_ids_with_doubles = []
    one_type_doubles.each_value do |val|
      collect_doubles_ids(tree_ids_with_doubles, val)
    end
    tree_ids_with_doubles.uniq
  end

  # @note: collect ids of trees with duplicates
  def self.collect_doubles_ids(tree_id_with_doubles, val)
    val.each_key do |key|
      tree_id_with_doubles << key
    end
  end

  # @note: Удаление SearchResults, относящихся к проведенному объединению между двумя деревьями
  # @params: who_connect, with_whom_connect - arrs of ids
  def self.destroy_previous_results(current_user_id)
    one_way_result(current_user_id)
    one_opp_way_result(current_user_id)
  end

  # # @note: Удаление SearchResults, относящихся к проведенному объединению между двумя деревьями
  # # @params: who_connect, with_whom_connect - arrs of ids
  # def self.destroy_previous_results(who_connect, with_whom_connect)
  #   one_result_destroy(who_connect, with_whom_connect)
  #   one_result_destroy(with_whom_connect, who_connect)
  # end

  # # @note: destroy one result - in one search way
  # def self.one_result_destroy(user_id, found_user_id)
  #   results = one_way_result(user_id, found_user_id)
  #   results.each(&:destroy) unless results.blank?
  # end


  # @note - сбор данных о профилях из рез-тов поиска в виде массивов
  # :by_profiles=>
  #     [{:search_profile_id=>18, :found_tree_id=>2, :found_profile_id=>9, :count=>5},
  #      {:search_profile_id=>18, :found_tree_id=>1, :found_profile_id=>9, :count=>5},
  def self.collect_search_profile_ids(by_profiles, tree_id)
    results_arrs = { search_profile_id: [], found_profile_id: [], count: [] }
    by_profiles.each do |one_profiles_hash|
      results_arrs = collect_tree_results(one_profiles_hash, results_arrs) if one_profiles_hash[:found_tree_id] == tree_id
    end
    results_arrs
  end

  # @note: collect_tree_results
  def self.collect_tree_results(one_profiles_hash, results_arrs)
    one_result = get_one_result(one_profiles_hash)
    collect_result_arrs(results_arrs, one_result) unless one_result.empty?
  end

  # @note: collect one result
  def self.get_one_result(one_profiles_hash)
    if one_profiles_hash.kind_of? Hash
      { search_profile_id: one_profiles_hash[:search_profile_id],
        found_profile_id:  one_profiles_hash[:found_profile_id],
        count:             one_profiles_hash[:count] }
    else
      {}
    end
  end

  # @note: collect all results arrays
  def self.collect_result_arrs(results_arrs, one_result)
    results_arrs[:search_profile_id] << one_result[:search_profile_id]
    results_arrs[:found_profile_id]  << one_result[:found_profile_id]
    results_arrs[:count]             << one_result[:count]
    results_arrs
  end

end
