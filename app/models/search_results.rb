class SearchResults < ActiveRecord::Base

  # validates_presence_of :user_id, :found_user_id, :profile_id, :found_profile_id, :count, :found_profile_ids,
  #                       :searched_profile_ids, :counts,
  #                       :message => "Должно присутствовать в SearchResults"
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
    unless found_profile_ids.is_a?(Array) # || wdays.detect{|d| !(0..6).include?(d)}
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


  # @note запись рез-тов поиска в отдельную таблицу
  #   Store new results ONLY IF there are NO BOTH TYPEs duplicates
  #   Вначале - удаление предыд-х рез-тов: clear_prev_results
  #   Далее: сбор ИД деревьев, в кот-х есть дубликаты: collect_doubles_tree_ids
  #   Далее: Если такие деревья есть, то сокращение массивов рез-тов поиска (для сохранения): exclude_doubles_results
  #   Сохранение рез-тов, не имеющих дубликатов: store_results
  def self.store_search_results(results, current_user_id)
    # puts "In store_search_results: by_trees results = #{results[:by_trees].inspect} "
    clear_prev_results(results[:by_trees], current_user_id)
    by_trees_to_store = update_by_trees(results)
    store_data = { tree_ids: collect_tree_ids(by_trees_to_store), by_profiles: results[:by_profiles],
                   current_user_tree_ids: results[:connected_author_arr], current_user_id: current_user_id }
    store_results(store_data)
  end

  # @note: update trees ids: exclude trees ids with duplicates of both types
  def self.update_by_trees(results)
    by_trees = results[:by_trees]
    tree_ids_to_exclude = collect_doubles_tree_ids(results)
    puts "In store_search_results: tree_ids_to_exclude = #{tree_ids_to_exclude.inspect} "
    unless tree_ids_to_exclude.blank?
      by_trees = exclude_doubles_results(results[:by_trees], tree_ids_to_exclude)
    end
    by_trees
  end

  # @note: collect ids of trees, which contains doubles, for each type of doubles,
  #   and make an ids array
  def self.collect_doubles_tree_ids(results)
    tree_ids_duplication = []
    final_ids = []
    [results[:duplicates_one_to_many], results[:duplicates_many_to_one]].each do |duplication|
      tree_ids_duplication = collect_one_doubles_ids(duplication) unless duplication.empty?
      final_ids << tree_ids_duplication
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

  def self.collect_doubles_ids(tree_id_with_doubles, val)
    val.each_key do |key|
      tree_id_with_doubles << key
    end
  end

  # @note: Check and delete_if: if one_hash contains {found_tree_id: tree_id_with_double} - tree w/doubles results
  #   If No -> leave this one_hash in by_trees_arr of hashes
  # @params: by_trees_arr - from search results
  #   tree_ids_to_exclude - arr of tree ids where doubles were found
  def self.exclude_doubles_results(by_trees_arr, tree_ids_to_exclude)
    tree_ids_to_exclude.each do |tree_id_with_double|
      by_trees_arr.delete_if { |one_hash| one_hash.merge({found_tree_id: tree_id_with_double }) == one_hash }
    end
    by_trees_arr
  end


  # @note: Clear previous search results before save new ones
  def self.clear_prev_results(by_trees, current_user_id)
    previous_results = where(user_id: current_user_id, found_user_id: collect_tree_ids(by_trees))
    previous_results.each(&:destroy) unless previous_results.blank?
  end

  # @note - сбор tree_ids всех найденных деревьев
  def self.collect_tree_ids(by_trees)
    found_tree_ids = []
    by_trees.each do |one_found_tree|
      found_tree_ids << one_found_tree[:found_tree_id]
    end
    # puts "In collect_tree_ids: found_tree_ids = #{found_tree_ids.inspect} "
    found_tree_ids
  end

  # @note: Удаление SearchResults, относящихся к проведенному объединению между двумя деревьями
  # @params: who_connect, with_whom_connect - arrs of ids
  def self.destroy_previous_results(who_connect, with_whom_connect)
    previous_results1 = where("user_id in (?)", who_connect).where("found_user_id in (?)", with_whom_connect)
    previous_results1.each(&:destroy) unless previous_results1.blank?
    previous_results2 = where("user_id in (?)", with_whom_connect).where("found_user_id in (?)", who_connect)
    previous_results2.each(&:destroy) unless previous_results2.blank?
  end

  # @note - запись результатов поиска
  def self.store_results(store_data)

    # found_tree_ids    =  store_data[:tree_ids]
    # by_profiles       =  store_data[:by_profiles]
    # current_tree_ids  =  store_data[:current_user_tree_ids]
    # current_user_id   =  store_data[:current_user_id]

    store_data[:tree_ids].each do |tree_id|
      results_arrs = collect_search_profile_ids(store_data[:by_profiles], tree_id)
      searched_profile_ids = results_arrs[:search_profile_id]
      found_profile_ids    = results_arrs[:found_profile_id]
      counts               = results_arrs[:count]

      connected_tree_id = User.find(tree_id).get_connected_users # Состав объединенного дерева в виде массива id

      connection_id = counter_request_exist(connected_tree_id, store_data[:current_user_tree_ids])
      value = my_request_exist(connected_tree_id, store_data[:current_user_tree_ids])
      # puts "In store_results: connection_id = #{connection_id.inspect}, value = #{value.inspect}"
      # puts "In store_results: searched_profile_ids[0] = #{searched_profile_ids[0].inspect}, found_profile_ids[0] = #{found_profile_ids[0].inspect}, counts[0] = #{counts[0].inspect}, value = #{value.inspect}"
      # puts "counts = #{counts.inspect}, value = #{value.inspect}"

      create(user_id: store_data[:current_user_id], found_user_id: tree_id,
                           profile_id: searched_profile_ids[0], found_profile_id: found_profile_ids[0],
                           count: counts[0], found_profile_ids: found_profile_ids,
                           searched_profile_ids: searched_profile_ids, counts: counts,
                           connection_id: connection_id, pending_connect: value)
    end

  end

  # @note Если встречный запрос существует, то получаем его connection_id
  def self.counter_request_exist(connected_tree_id, current_tree_ids)
    connection_id = nil
    # puts "In counter_request_exist: connected_tree_id = #{connected_tree_id.inspect}, current_tree_ids = #{current_tree_ids.inspect}"

    request = ConnectionRequest.where("user_id in (?)", connected_tree_id)
                  .where("with_user_id in (?)", current_tree_ids)
                  .where(:done => false )
    # puts "In counter_request_exist: request = #{request.inspect}"

    unless request.blank?
      connection_id = request[0].connection_id
    end
    connection_id
  end

  # @note Если запрос текущего юзера существует, то устанавливаем pending_connect в 1 его рез-тов поиска
  def self.my_request_exist(connected_tree_id, current_tree_ids)
    my_request = ConnectionRequest.where("with_user_id in (?)", connected_tree_id)
                     .where("user_id in (?)", current_tree_ids)
                     .where(:done => false )
    value = 0
    unless my_request.blank?
      value = 1
    end
    # logger.info "In my_request_exist: pending_connect value = #{value.inspect} "
    value
  end


  # @note - сбор данных о профилях из рез-тов поиска в виде массивов
  # :by_profiles=>
  #     [{:search_profile_id=>18, :found_tree_id=>2, :found_profile_id=>9, :count=>5},
  #      {:search_profile_id=>18, :found_tree_id=>1, :found_profile_id=>9, :count=>5},
  #      {:search_profile_id=>17, :found_tree_id=>2, :found_profile_id=>8, :count=>5},
  def self.collect_search_profile_ids(by_profiles, tree_id)
    results_arrs = { search_profile_id: [],
                     found_profile_id: [],
                     count: [] }
    by_profiles.each do |one_profiles_hash|
      one_result = {}
      one_result = get_one_result(one_profiles_hash) if one_profiles_hash[:found_tree_id] == tree_id
      results_arrs = collect_result_arrs(results_arrs, one_result) unless one_result.empty?
    end
    results_arrs
  end

  def self.get_one_result(one_profiles_hash)
    if one_profiles_hash.kind_of? Hash
      { search_profile_id: one_profiles_hash[:search_profile_id],
        found_profile_id:  one_profiles_hash[:found_profile_id],
        count:             one_profiles_hash[:count] }
    else
      {}
    end
  end

  def self.collect_result_arrs(results_arrs, one_result)
    results_arrs[:search_profile_id] << one_result[:search_profile_id]
    results_arrs[:found_profile_id] << one_result[:found_profile_id]
    results_arrs[:count] << one_result[:count]
    results_arrs
  end





end
