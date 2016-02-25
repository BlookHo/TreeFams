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
    certain_koeff = CERTAIN_KOEFF #WeafamSetting.first.certain_koeff
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

  # @note Check if results already exists - so don't start search!
  def self.results_exists?(current_user_id)
    # puts "In results_exists?: current_user_id = #{current_user_id}"
    where("#{current_user_id} = ANY (searched_connected)").exists?
  end

  # @note Collect profiles from search results for current_user
  #
  def self.search_results_profiles(current_user_id)
    puts "In collect search_results_profiles: current_user_id = #{current_user_id}"
    searched_profiles = []
    searched_profiles_query = where("#{current_user_id} = ANY (searched_connected)")
    unless searched_profiles_query.blank?
      puts "searched_profiles_query.size = #{searched_profiles_query.size}"
      searched_profiles_query.each do |one_result|
        searched_profiles = (searched_profiles + one_result.searched_profile_ids).uniq
      end
      # searched_profiles_query.map{ |one_result| searched_profiles =
      #     (searched_profiles + one_result.searched_profile_ids).uniq }
    end
    puts "Collected searched_profile_ids = #{searched_profiles}"
    searched_profiles
  end

  # @note Run search methods in tread
  def self.start_search_methods_in_thread(current_user, search_event)
    Thread.new do
      #ActiveRecord::Base.connection_pool.with_connection do |conn|
        # self.start_search_methods(current_user)
        # ActiveRecord::Base.connection_pool.release_connection(conn)
        # ActiveRecord::Base.connection_handler.connection_pool_list.each(&:clear_stale_cached_connections!)
      # end
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        self.start_search_methods(current_user, search_event)
        ActiveRecord::Base.connection_pool.release_connection(conn)
      end

    end
    current_size = ActiveRecord::Base.connection_pool.connections.size
    logger.info "== AR POOL SIZE LOG: {search.start_search_methods_in_thread} size: #{current_size}"
  end


  # @note start search methods: # sims & search
  # first - similars, then - search if no sims results
  def self.start_search_methods(current_user, search_event)
    logger.info  "In start_search_methods: start_search_methods: current_user.id = #{current_user.id.inspect} "

    similars_results = current_user.start_similars
    # {tree_info: tree_info, new_sims: new_sims, similars: similars,connected_users: connected_users,
    #                        log_connection_id: log_connection_id }
    # [inf] In start_similars: similars =
    #  [{:first_profile_id=>70, :first_name_id=>"Ольга", :first_relation_id=>"Жена", :name_first_relation_id=>"Петра", :first_sex_id=>"Ж",
    #    :second_profile_id=>81, :second_name_id=>"Ольга", :second_relation_id=>"Сестра", :name_second_relation_id=>"Елены", :second_sex_id=>"Ж",
    #    :common_relations=>{"Отец"=>[351], "Мама"=>[187], "Сестра"=>[173], "Муж"=>[370]},
    #    :common_power=>4, :inter_relations=>[]},
    #   {:first_profile_id=>79, :first_name_id=>"Олег", :first_relation_id=>"Отец", :name_first_relation_id=>"Ольги", :first_sex_id=>"М",
    #    :second_profile_id=>82, :second_name_id=>"Олег", :second_relation_id=>"Отец", :name_second_relation_id=>"Елены", :second_sex_id=>"М",
    #    :common_relations=>{"Дочь"=>[173, 354], "Жена"=>[187], "Зять"=>[370]},
    #    :common_power=>4, :inter_relations=>[]}]

    logger.info  "In start_search_methods: similars_results[:similars] = #{similars_results[:similars].inspect}"

    if similars_results[:similars].blank?
      logger.info  "In start_search_methods: No Similars -> start search "
      search_results = current_user.start_search(search_event)
      search_results
    else
      logger.info  "In start_search_methods: Similars in tree -> No start search "
      similars_results
    end

  end


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
    search_results_arr = make_results(store_data)
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
    store_data[:tree_ids].each do |tree_id|
      results_arrs = collect_search_profile_ids(store_data[:by_profiles], tree_id)
      found_tree_ids = User.find(tree_id).connected_users # Состав объединенного дерева в виде массива id
      conn_id = get_connection_id(store_data[:current_user_tree_ids], found_tree_ids)
      opp_conn_id = get_connection_id(found_tree_ids, store_data[:current_user_tree_ids])
      pending_value = get_pending_request(found_tree_ids, store_data[:current_user_tree_ids])
      opp_pending_value = get_pending_request(store_data[:current_user_tree_ids], found_tree_ids)
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
                     connection_id: conn_id,
                     pending_connect: pending_value,
                     searched_connected: store_data[:current_user_tree_ids],
                     founded_connected: found_tree_ids }
      search_results_arr << one_result

      one_opp_result = { user_id: tree_id, # store_data[:current_user_id],
                     found_user_id: store_data[:current_user_id], # tree_id,
                     profile_id: found_profile_ids[0], # searched_profile_ids[0],
                     found_profile_id: searched_profile_ids[0], # found_profile_ids[0],
                     count: counts[0],
                     found_profile_ids: searched_profile_ids, # found_profile_ids,
                     searched_profile_ids: found_profile_ids, # searched_profile_ids,
                     counts: counts,
                     connection_id: opp_conn_id,
                     pending_connect: opp_pending_value,
                     searched_connected: found_tree_ids,
                     founded_connected: store_data[:current_user_tree_ids] }
      search_results_arr << one_opp_result

    end
    search_results_arr
  end

  #
  # # @note: determine search_results prams to be stored
  # def self.get_results_params(connected_one_tree, connected_other_tree)
  #   # puts "In get_results_params: tree_id = #{tree_id.inspect}, connected_tree_ids = #{connected_tree_ids.inspect} "
  #   connection_id = set_connection_id(connected_one_tree, connected_other_tree)
  #   value = set_pending_request(connected_one_tree, connected_other_tree)
  #   { connection_id: connection_id, pending_value: value, current_tree_ids: connected_other_tree, connected_tree_ids: connected_one_tree }
  # end

  # @note Если встречный запрос существует (if counter_request_exist), то получаем его connection_id
  # if request.blank? AND
  # if connected_other_tree = current tree ids, then connection_id should have value
  def self.get_connection_id(connected_one_tree, connected_other_tree)
    # p " In set_connection_id: connected_one_tree = #{connected_one_tree}, connected_other_tree = #{connected_other_tree} "
    conn_request = ConnectionRequest
                  .where("user_id in (?)", connected_other_tree )
                  .where("with_user_id in (?)", connected_one_tree)
                  .where(:done => false )
    connection_id = nil
    connection_id = conn_request.first.connection_id unless conn_request.blank?
    # p " In set_connection_id:  connection_id = #{connection_id.inspect}, conn_request.count = #{conn_request.count}"
    connection_id
  end

  # @note Если запрос текущего юзера существует, то устанавливаем
  # pending_connect в 1 его рез-тов поиска if my_request_exist
  def self.get_pending_request(connected_one_tree, connected_other_tree)
    # p " In set_pending_request: connected_one_tree = #{connected_one_tree}, connected_other_tree = #{connected_other_tree} "
    pending_request = ConnectionRequest
                     .where("user_id in (?)", connected_other_tree)
                     .where("with_user_id in (?)", connected_one_tree)
                     .where(:done => false )
    value = 0
    value = 1 unless pending_request.blank?
    # p " In set_pending_request:  pending_value = #{value}, pending_request.count = #{pending_request.count}"
    value
  end

  # @note: При создании запроса на объединение,
  #   соответствующие рез-ты поиска получают признак pending_connect = 1
  def self.make_results_pending(who_conn_ids, with_whom_conn_ids)
    current_user_results = SearchResults
                               .where("user_id in (?)", who_conn_ids)
                               .where("found_user_id in (?)", with_whom_conn_ids)
    current_user_results.update_all({pending_connect: 1}) unless current_user_results.blank?
  end

  # @note: При создании запроса на объединение,
  #   соответствующие рез-ты поиска получают value connection_id
  def self.set_connection_id_results(who_conn_ids, with_whom_conn_ids, connection_id)
    opp_user_results = SearchResults
                           .where("user_id in (?)", with_whom_conn_ids)
                           .where("found_user_id in (?)", who_conn_ids)
    opp_user_results.update_all({connection_id: connection_id}) unless opp_user_results.blank?
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
    puts "In clear_all_prev_results: connected_users = #{connected_users.inspect} "
    all_previous_to_results = where("user_id in (?)", connected_users)
    aii_previous_opp_results = where("found_user_id in (?)", connected_users)
    all_previous_results = all_previous_to_results + aii_previous_opp_results
    all_previous_results.each(&:destroy) unless all_previous_results.blank?

    # scope :one_way_result,     -> (connected_users) {where("user_id in (?)", connected_users)}

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
    puts "In update_by_trees: tree_ids_to_exclude = #{tree_ids_to_exclude.inspect} "
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
    one_way_result(current_user_id).each(&:destroy) unless results.blank?
    one_opp_way_result(current_user_id)
  end

  # # @note: Удаление SearchResults, относящихся к проведенному объединению между двумя деревьями
  # # @params: who_connect, with_whom_connect - arrs of ids
  # def self.destroy_previous_results(who_connect, with_whom_connect)
  #   one_result_destroy(who_connect, with_whom_connect)
  #   one_result_destroy(with_whom_connect, who_connect)
  # end

  # # @note: destroy one result - in one search way
  def self.one_result_destroy(user_id, found_user_id)
    results = one_way_result(user_id, found_user_id)
    results.each(&:destroy) unless results.blank?
  end


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

  # @note: collect all results arrays
  def self.search_results_exists?(current_user_id)
    puts "In search_results_exists? current_user_id = #{current_user_id}"



  end





  end


#58
{:tree_profiles=>[805, 806, 808, 812, 810, 813, 814, 809, 807, 811, 815],
 :connected_author_arr=>[58], :qty_of_tree_profiles=>11,
 :profiles_relations_arr=>[
     {:profile_searched=>805,
      :profile_relations=>{806=>1, 807=>2, 809=>3, 810=>3, 808=>6, 811=>7, 812=>91, 814=>92, 813=>101, 815=>102}},
     {:profile_searched=>806,
      :profile_relations=>{812=>1, 813=>2, 805=>4, 808=>4, 807=>8, 814=>15, 815=>16, 811=>18, 809=>112, 810=>112}},
     {:profile_searched=>808,
      :profile_relations=>{806=>1, 807=>2, 805=>6, 812=>91, 814=>92, 813=>101, 815=>102, 809=>212, 810=>212}},
     {:profile_searched=>812, :profile_relations=>{806=>3, 813=>8, 807=>17, 805=>121, 808=>121}},
     {:profile_searched=>810, :profile_relations=>{811=>1, 805=>2, 809=>5, 806=>92, 807=>102, 808=>202}},
     {:profile_searched=>813, :profile_relations=>{806=>3, 812=>7, 807=>17, 805=>121, 808=>121}},
     {:profile_searched=>814, :profile_relations=>{807=>4, 815=>8, 806=>18, 805=>122, 808=>122}},
     {:profile_searched=>809, :profile_relations=>{811=>1, 805=>2, 810=>5, 806=>92, 807=>102, 808=>202}},
     {:profile_searched=>807,
      :profile_relations=>{814=>1, 815=>2, 805=>4, 808=>4, 806=>7, 812=>13, 813=>14, 811=>18, 809=>112, 810=>112}},
     {:profile_searched=>811, :profile_relations=>{809=>3, 810=>3, 805=>8, 806=>15, 807=>16}},
     {:profile_searched=>815, :profile_relations=>{807=>4, 814=>7, 806=>18, 805=>122, 808=>122}}],
 :profiles_found_arr=>[
     {805=>{57=>{795=>[3, 3, 7]}}}, {806=>{}}, {808=>{}}, {812=>{}}, {810=>{57=>{794=>[1, 2, 5]}}},
     {813=>{}}, {814=>{}}, {809=>{57=>{793=>[1, 2, 5]}}}, {807=>{}}, {811=>{57=>{790=>[3, 3, 8]}}}, {815=>{}}],
 :uniq_profiles_pairs=>{}, :profiles_with_match_hash=>{}, :by_profiles=>[], :by_trees=>[], :duplicates_one_to_many=>{},
 :duplicates_many_to_one=>{}}
# touched trees: 57



#57
{:tree_profiles=>[790, 797, 791, 792, 793, 794, 795, 799, 798, 796],
 :connected_author_arr=>[57], :qty_of_tree_profiles=>10,
 :profiles_relations_arr=>[
     {:profile_searched=>790,
      :profile_relations=>{791=>1, 792=>2, 793=>3, 794=>3, 795=>8, 796=>91, 798=>92, 797=>101, 799=>102}},
     {:profile_searched=>797, :profile_relations=>{791=>3, 796=>7, 792=>17, 790=>111}},
     {:profile_searched=>791,
      :profile_relations=>{796=>1, 797=>2, 790=>3, 792=>8, 798=>15, 799=>16, 795=>17, 793=>111, 794=>111}},
     {:profile_searched=>792,
      :profile_relations=>{798=>1, 799=>2, 790=>3, 791=>7, 796=>13, 797=>14, 795=>17, 793=>111, 794=>111}},
     {:profile_searched=>793, :profile_relations=>{790=>1, 795=>2, 794=>5, 791=>91, 792=>101}},
     {:profile_searched=>794, :profile_relations=>{790=>1, 795=>2, 793=>5, 791=>91, 792=>101}},
     {:profile_searched=>795, :profile_relations=>{793=>3, 794=>3, 790=>7, 791=>13, 792=>14}},
     {:profile_searched=>799, :profile_relations=>{792=>4, 798=>7, 791=>18, 790=>112}},
     {:profile_searched=>798, :profile_relations=>{792=>4, 799=>8, 791=>18, 790=>112}},
     {:profile_searched=>796, :profile_relations=>{791=>3, 797=>8, 792=>17, 790=>111}}],
 :profiles_found_arr=>[{790=>{58=>{811=>[3, 3, 8]}}}, {797=>{55=>{742=>[7]}, 56=>{754=>[7]}}},
                       {791=>{}}, {792=>{19=>{383=>[1]}}}, {793=>{58=>{809=>[1, 2, 5]}}},
                       {794=>{58=>{810=>[1, 2, 5]}}}, {795=>{58=>{805=>[3, 3, 7]}}}, {799=>{}},
                       {798=>{19=>{367=>[4]}}}, {796=>{55=>{741=>[8]}, 56=>{753=>[8]}}}],
 :uniq_profiles_pairs=>{}, :profiles_with_match_hash=>{}, :by_profiles=>[], :by_trees=>[],
 :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}
# touched trees: 58, 55, 56, 19

# 57 - 58 - no results


# 59
  {:tree_profiles=>[817, 818, 819, 820, 821, 823, 824, 822], :connected_author_arr=>[59],
   :qty_of_tree_profiles=>8,
   :profiles_relations_arr=>[
       {:profile_searched=>817, :profile_relations=>{818=>1, 819=>2, 820=>5, 821=>91, 823=>92, 822=>101, 824=>102}},
       {:profile_searched=>818, :profile_relations=>{821=>1, 822=>2, 817=>3, 820=>3, 819=>8, 823=>15, 824=>16}},
       {:profile_searched=>819, :profile_relations=>{823=>1, 824=>2, 817=>3, 820=>3, 818=>7, 821=>13, 822=>14}},
       {:profile_searched=>820, :profile_relations=>{818=>1, 819=>2, 817=>5, 821=>91, 823=>92, 822=>101, 824=>102}},
       {:profile_searched=>821, :profile_relations=>{818=>3, 822=>8, 819=>17, 817=>111, 820=>111}},
       {:profile_searched=>823, :profile_relations=>{819=>4, 824=>8, 818=>18, 817=>112, 820=>112}},
       {:profile_searched=>824, :profile_relations=>{819=>4, 823=>7, 818=>18, 817=>112, 820=>112}},
       {:profile_searched=>822, :profile_relations=>{818=>3, 821=>7, 819=>17, 817=>111, 820=>111}}],
   :profiles_found_arr=>[{817=>{57=>{793=>[1, 2, 5, 91, 101]},
                                58=>{809=>[1, 2, 5, 92, 102]},
                                60=>{828=>[1, 2, 5, 91, 92, 101, 102]}}},
                         {818=>{57=>{790=>[1, 2, 3, 3, 8]},
                                60=>{826=>[1, 2, 3, 3, 8, 15, 16]},
                                58=>{811=>[3, 3, 8, 15, 16]}}},
                         {819=>{58=>{805=>[1, 2, 3, 3, 7]},
                                60=>{827=>[1, 2, 3, 3, 7, 13, 14]},
                                57=>{795=>[3, 3, 7, 13, 14]}}},
                         {820=>{57=>{794=>[1, 2, 5, 91, 101]},
                                58=>{810=>[1, 2, 5, 92, 102]},
                                60=>{825=>[1, 2, 5, 91, 92, 101, 102]}}},
                         {821=>{57=>{791=>[3, 8, 17, 111, 111]},
                                60=>{829=>[3, 8, 17, 111, 111]}}},
                         {823=>{58=>{806=>[4, 8, 18, 112, 112]},
                                60=>{831=>[4, 8, 18, 112, 112]}}},
                         {824=>{58=>{807=>[4, 7, 18, 112, 112]},
                                60=>{832=>[4, 7, 18, 112, 112]}}},
                         {822=>{57=>{792=>[3, 7, 17, 111, 111]},
                                60=>{830=>[3, 7, 17, 111, 111]}}}],
   :uniq_profiles_pairs=>{817=>{57=>793, 58=>809, 60=>828}, 818=>{57=>790, 60=>826, 58=>811},
                          819=>{58=>805, 60=>827, 57=>795}, 820=>{57=>794, 58=>810, 60=>825},
                          821=>{57=>791, 60=>829}, 823=>{58=>806, 60=>831}, 824=>{58=>807, 60=>832},
                          822=>{57=>792, 60=>830}},
   :profiles_with_match_hash=>{825=>7, 827=>7, 826=>7, 828=>7, 830=>5, 792=>5, 832=>5, 807=>5, 831=>5, 806=>5, 829=>5, 791=>5, 810=>5, 794=>5, 795=>5, 805=>5, 811=>5, 790=>5, 809=>5, 793=>5},
   :by_profiles=>[{:search_profile_id=>820, :found_tree_id=>60, :found_profile_id=>825, :count=>7},
                  {:search_profile_id=>819, :found_tree_id=>60, :found_profile_id=>827, :count=>7},
                  {:search_profile_id=>818, :found_tree_id=>60, :found_profile_id=>826, :count=>7},
                  {:search_profile_id=>817, :found_tree_id=>60, :found_profile_id=>828, :count=>7},
                  {:search_profile_id=>822, :found_tree_id=>60, :found_profile_id=>830, :count=>5},
                  {:search_profile_id=>822, :found_tree_id=>57, :found_profile_id=>792, :count=>5},
                  {:search_profile_id=>824, :found_tree_id=>60, :found_profile_id=>832, :count=>5},
                  {:search_profile_id=>824, :found_tree_id=>58, :found_profile_id=>807, :count=>5},
                  {:search_profile_id=>823, :found_tree_id=>60, :found_profile_id=>831, :count=>5},
                  {:search_profile_id=>823, :found_tree_id=>58, :found_profile_id=>806, :count=>5},
                  {:search_profile_id=>821, :found_tree_id=>60, :found_profile_id=>829, :count=>5},
                  {:search_profile_id=>821, :found_tree_id=>57, :found_profile_id=>791, :count=>5},
                  {:search_profile_id=>820, :found_tree_id=>58, :found_profile_id=>810, :count=>5},
                  {:search_profile_id=>820, :found_tree_id=>57, :found_profile_id=>794, :count=>5},
                  {:search_profile_id=>819, :found_tree_id=>57, :found_profile_id=>795, :count=>5},
                  {:search_profile_id=>819, :found_tree_id=>58, :found_profile_id=>805, :count=>5},
                  {:search_profile_id=>818, :found_tree_id=>58, :found_profile_id=>811, :count=>5},
                  {:search_profile_id=>818, :found_tree_id=>57, :found_profile_id=>790, :count=>5},
                  {:search_profile_id=>817, :found_tree_id=>58, :found_profile_id=>809, :count=>5},
                  {:search_profile_id=>817, :found_tree_id=>57, :found_profile_id=>793, :count=>5}],
   :by_trees=>[{:found_tree_id=>57, :found_profile_ids=>[793, 790, 795, 794, 791, 792]},
               {:found_tree_id=>58, :found_profile_ids=>[809, 811, 805, 810, 806, 807]},
               {:found_tree_id=>60, :found_profile_ids=>[828, 826, 827, 825, 829, 831, 832, 830]}],
   :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}

# touched trees: 58, 57, 60

# 60
 {:tree_profiles=>[825, 830, 826, 827, 831, 829, 832, 828], :connected_author_arr=>[60],
  :qty_of_tree_profiles=>8, :profiles_relations_arr=>[
     {:profile_searched=>825, :profile_relations=>{826=>1, 827=>2, 828=>5, 829=>91, 831=>92, 830=>101, 832=>102}},
     {:profile_searched=>830, :profile_relations=>{826=>3, 829=>7, 827=>17, 828=>111, 825=>111}},
     {:profile_searched=>826, :profile_relations=>{829=>1, 830=>2, 828=>3, 825=>3, 827=>8, 831=>15, 832=>16}},
     {:profile_searched=>827, :profile_relations=>{831=>1, 832=>2, 828=>3, 825=>3, 826=>7, 829=>13, 830=>14}},
     {:profile_searched=>831, :profile_relations=>{827=>4, 832=>8, 826=>18, 828=>112, 825=>112}},
     {:profile_searched=>829, :profile_relations=>{826=>3, 830=>8, 827=>17, 828=>111, 825=>111}},
     {:profile_searched=>832, :profile_relations=>{827=>4, 831=>7, 826=>18, 828=>112, 825=>112}},
     {:profile_searched=>828, :profile_relations=>{826=>1, 827=>2, 825=>5, 829=>91, 831=>92, 830=>101, 832=>102}}],
  :profiles_found_arr=>[{825=>{57=>{794=>[1, 2, 5, 91, 101]},
                               58=>{810=>[1, 2, 5, 92, 102]},
                               59=>{820=>[1, 2, 5, 91, 92, 101, 102]}}},
                        {830=>{57=>{792=>[3, 7, 17, 111, 111]},
                               59=>{822=>[3, 7, 17, 111, 111]}}},
                        {826=>{57=>{790=>[1, 2, 3, 3, 8]},
                               59=>{818=>[1, 2, 3, 3, 8, 15, 16]},
                               58=>{811=>[3, 3, 8, 15, 16]}}},
                        {827=>{58=>{805=>[1, 2, 3, 3, 7]},
                               59=>{819=>[1, 2, 3, 3, 7, 13, 14]},
                               57=>{795=>[3, 3, 7, 13, 14]}}},
                        {831=>{58=>{806=>[4, 8, 18, 112, 112]},
                               59=>{823=>[4, 8, 18, 112, 112]}}},
                        {829=>{57=>{791=>[3, 8, 17, 111, 111]},
                               59=>{821=>[3, 8, 17, 111, 111]}}},
                        {832=>{58=>{807=>[4, 7, 18, 112, 112]},
                               59=>{824=>[4, 7, 18, 112, 112]}}},
                        {828=>{57=>{793=>[1, 2, 5, 91, 101]},
                               58=>{809=>[1, 2, 5, 92, 102]},
                               59=>{817=>[1, 2, 5, 91, 92, 101, 102]}}}],
  :uniq_profiles_pairs=>{825=>{57=>794, 58=>810, 59=>820}, 830=>{57=>792, 59=>822}, 826=>{57=>790, 59=>818, 58=>811},
                         827=>{58=>805, 59=>819, 57=>795}, 831=>{58=>806, 59=>823}, 829=>{57=>791, 59=>821},
                         832=>{58=>807, 59=>824}, 828=>{57=>793, 58=>809, 59=>817}},
  :profiles_with_match_hash=>{817=>7, 819=>7, 818=>7, 820=>7, 809=>5, 793=>5, 824=>5, 807=>5, 821=>5, 791=>5, 823=>5, 806=>5, 795=>5, 805=>5, 811=>5, 790=>5, 822=>5, 792=>5, 810=>5, 794=>5},
  :by_profiles=>[{:search_profile_id=>828, :found_tree_id=>59, :found_profile_id=>817, :count=>7},
                 {:search_profile_id=>827, :found_tree_id=>59, :found_profile_id=>819, :count=>7},
                 {:search_profile_id=>826, :found_tree_id=>59, :found_profile_id=>818, :count=>7},
                 {:search_profile_id=>825, :found_tree_id=>59, :found_profile_id=>820, :count=>7},
                 {:search_profile_id=>828, :found_tree_id=>58, :found_profile_id=>809, :count=>5},
                 {:search_profile_id=>828, :found_tree_id=>57, :found_profile_id=>793, :count=>5},
                 {:search_profile_id=>832, :found_tree_id=>59, :found_profile_id=>824, :count=>5},
                 {:search_profile_id=>832, :found_tree_id=>58, :found_profile_id=>807, :count=>5},
                 {:search_profile_id=>829, :found_tree_id=>59, :found_profile_id=>821, :count=>5},
                 {:search_profile_id=>829, :found_tree_id=>57, :found_profile_id=>791, :count=>5},
                 {:search_profile_id=>831, :found_tree_id=>59, :found_profile_id=>823, :count=>5},
                 {:search_profile_id=>831, :found_tree_id=>58, :found_profile_id=>806, :count=>5},
                 {:search_profile_id=>827, :found_tree_id=>57, :found_profile_id=>795, :count=>5},
                 {:search_profile_id=>827, :found_tree_id=>58, :found_profile_id=>805, :count=>5},
                 {:search_profile_id=>826, :found_tree_id=>58, :found_profile_id=>811, :count=>5},
                 {:search_profile_id=>826, :found_tree_id=>57, :found_profile_id=>790, :count=>5},
                 {:search_profile_id=>830, :found_tree_id=>59, :found_profile_id=>822, :count=>5},
                 {:search_profile_id=>830, :found_tree_id=>57, :found_profile_id=>792, :count=>5},
                 {:search_profile_id=>825, :found_tree_id=>58, :found_profile_id=>810, :count=>5},
                 {:search_profile_id=>825, :found_tree_id=>57, :found_profile_id=>794, :count=>5}],
  :by_trees=>[{:found_tree_id=>57, :found_profile_ids=>[794, 792, 790, 795, 791, 793]},
              {:found_tree_id=>58, :found_profile_ids=>[810, 811, 805, 806, 807, 809]},
              {:found_tree_id=>59, :found_profile_ids=>[820, 822, 818, 819, 823, 821, 824, 817]}],
  :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}

# touched trees: 58, 57, 59
