module SearchModified
  extend ActiveSupport::Concern

  #############################################################
  # Иванищев А.В. 2015, December
  # Метод поиска - модифицированный, с отработкой исключений противоречий
  # между найденными профилями
  #############################################################
  # Осуществляет поиск совпадений в деревьях, расчет результатов и сохранение в БД
  # @note: Here is the storage of Search class methods
  #   to evaluate data to be stored
  #   as proper search results and update search data
  #############################################################


  # profile_id_searched = 811
  # profile_id_found = 790
  # name_id_searched = 28
  # connected_users = [58]

  # @note: extra_search
  # New super speed extra search
  # Before:
  # 1.new table Person: user_id, profile_id, name_id, deleted, in_sims,
  #                     fathers (arr - int) = [23,124,345]
  #                     mothers (arr - int) = [23,124,345]
  #                     sisters (arr - int) = [23,124,345]
  #                     daughters (arr - int) = [23,124,345]
  #                     sons (arr - int) = [23,124,345]
  #                     wives (arr - int) = [23,124,345]
  #                     husbands (arr - int) = [23,124,345]
  #                     deds_father (arr - int) = [23,124,345]
  #                     deds_mother (arr - int) = [23,124,345]
  #                     babs_father (arr - int) = [23,124,345]
  #                     babs_mother (arr - int) = [23,124,345]
  #                     vnuks_father (arr - int) = [23,124,345]
  #                     vnuks_mother (arr - int) = [23,124,345]
  #                     vnuchkas_father (arr - int) = [23,124,345]
  #                     vnuchkas_mother (arr - int) = [23,124,345]
  #                     .... an so on
  # 2.create and update all joined records in Person - at the same time as usual
  #   so Person content is up_to_date as other main tables
  # 3.
  #
  # Searching.
  # for each profile from searching tree
  # 1.circle of searching profile
  # 2.using arrays match and exclusion logic in query -
  #   find found matched records of profiles - get profile_ids with user_ids
  # 3.determine, which profile_id have more records than coeff-t
  # 4.sequest profile_ids if necessary
  # 5.determine found profiles in each user_id
  # 6.eliminate doubled found profiles if there are
  # 7.make usual search_results for store/
  # /

  # TEST one profile search & check
  # profile_search_data = {:connected_users=>[58], :profile_id_searched=>805, :name_id_searched=>48}
  # modi_search_one_profile(profile_search_data)


  # == END OF search_tree_profiles === Search_time = 679.99 msec
  # == END OF search_tree_profiles === Search_time = 667.55 msec
  # == END OF ALL search_tree_profiles === Search_time = 418.8 msec
  # == END OF modified_search === Search_time = 503.99 msec
  # Search_time OF modified_search with double trees check = 552.69 msec.
  # Search_time OF modified_search with double trees check = 515.11 msec.
  # Search_time OF modified_search with double trees check = 483.21 msec.
  # Search_time OF modified_search with double trees check = 883.91 msec.
  # Search_time OF modified_search with double trees check = 561.63 msec.
  # Search_time OF modified_search with double trees check = 569.47 msec.



  # [inf] == END OF start_search === Search_time = 1.43 sec (pid:3770)
  # [inf] == END OF start_search === Search_time =  854.63 msec (pid:3770)
  # [inf] == END OF start_search === Search_time =  1357.82 msec (pid:3571)
  # [inf] == END OF start_search === Search_time =  568.9 msec (pid:3571)
  # [inf] == END OF start_search === Search_time =  734.93 msec (pid:6281)


  # @note: NEW & LAST TO DATE modified search with exclusions
  def modified_search

    start_search_time = Time.now
    logger.info "modified connected_users = #{self.connected_users}.inspect}, certain_koeff = #{WeafamConstants::CERTAIN_KOEFF}"

    # WeafamConstants.new.show_all_constants

    # todo: DEVELOPING: place conditions, when search should be started - depends upon last action(s) in current tree
    results = search_tree_profiles

    logger.info "SearchResults made & READY:"
    logger.info "modified results[:connected_author_arr] = #{results[:connected_author_arr].inspect}"
    logger.info "modified results[:by_profiles] = #{results[:by_profiles].inspect}"
    logger.info "modified results[:by_trees] = #{results[:by_trees].inspect}"
    logger.info "modified results[:duplicates_one_to_many] = #{results[:duplicates_one_to_many].inspect}"
    logger.info "modified results[:duplicates_many_to_one] = #{results[:duplicates_many_to_one].inspect}"

    check_results_to_store(results)

    search_time = (Time.now - start_search_time) * 1000
    puts "\nSearch_time OF modified_search with double trees check = #{search_time.round(2)} msec.\n\n"
  end


  ############################################################
  # @note: New super extra search body
  def search_tree_profiles

    start_search_time = Time.now
    # logger.info  "\n##### search_tree_profiles #####\n\n"

    # todo: collect profiles to start search profiles list,
    # todo: combine with previous search_results in table if exists
    # todo: get profiles touched by last action: create, delete, rename ...
    # @note:
    #  -  new method to reduce search field - space
    # tree_profiles = collect_profiles_to_search(connected_users, action_id)

    connected_users = self.get_connected_users # Состав объединенного дерева в виде массива id
    author_tree_arr = Tree.get_connected_tree(connected_users) # DISTINCT Массив объединенного дерева из Tree
    tree_profiles = [self.profile_id] + author_tree_arr.map {|p| p.is_profile_id }.uniq
    tree_profiles = tree_profiles.uniq
    logger.info "In search_tree_profiles: connected_users = #{connected_users}, tree_profiles = #{tree_profiles} "

    uniq_profiles_pairs = {}
    profiles_with_match_hash = {}
    doubles_one_to_many_hash = {}

    # Start MAIN SEARCH PROFILES CYCLE by profiles to search & found
    tree_profiles.each do |profile_id_searched|
      profile_search_data = { connected_users: connected_users,
                              profile_id_searched: profile_id_searched,
                              name_id_searched: Profile.find(profile_id_searched).name_id }
      # modified search with exclusions
      one_profile_results = modi_search_one_profile(profile_search_data)

      uniq_profiles_pairs.merge!(one_profile_results[:profiles_trees_pairs])
      profiles_with_match_hash.merge!(one_profile_results[:profiles_counts])
      doubles_one_to_many_hash.merge!(one_profile_results[:doubles_one_to_many])
    end

    uniq_profiles_pairs.delete_if { |key,val|  val == {} }
    uniq_profiles_no_doubles, duplicates_many_to_one = SearchWork.duplicates_out(uniq_profiles_pairs)
    by_profiles, by_trees = SearchResults.make_search_results(uniq_profiles_no_doubles, profiles_with_match_hash)

    results = {
        connected_author_arr:     connected_users,
        by_profiles:              by_profiles,
        by_trees:                 by_trees,
        duplicates_one_to_many:   doubles_one_to_many_hash,
        duplicates_many_to_one:   duplicates_many_to_one }

    search_time = (Time.now - start_search_time) * 1000
    logger.info  "\nSearch_time OF ALL search_tree_profiles = #{search_time.round(2)} msec.\n\n"

    results
  end


  # @note: check search results for double users check
  # before store results /
  def check_results_to_store(results)
    if results[:by_trees].blank?
      logger.info  "In check_results_to_store: Search results READY, but BLANK: results[:by_trees] = #{results[:by_trees]} -> No double trees check, No SearchResults store."
      no_double_trees
    else
      results_without_doubles(results) if !results[:duplicates_one_to_many].empty? or !results[:duplicates_many_to_one].empty?
      logger.info  "In check_results_to_store: Search results READY, checked results_without_doubles: results[:by_trees] = #{results[:by_trees].inspect}"

      self.find_double_tree(results) unless results[:by_trees].blank?
      SearchResults.store_search_results(results, self.id) if self.double == 1
    end
  end


  # Служебный метод для отладки - для LOGGER
  # todo: перенести этот метод в Operational - для нескольких моделей
  # Показывает массив в logger
  def show_in_logger(arr_to_log, string_to_add)
    row_no = 0  # DEBUGG_TO_LOGG
    arr_to_log.each do |row| # DEBUGG_TO_LOGG
      row_no += 1
      logger.info "#{string_to_add} № #{row_no.inspect}: #{row.attributes.inspect} " # DEBUGG_TO_LOGG
    end  # DEBUGG_TO_LOGG
  end

  # @note: collect hash of keys and items array as hash value
  # from input array of arrays=pairs: [[key, item] .. [ , ]]
  # trees with found profile in it: {57=>[795], 59=>[819], 60=>[827]}   OR
  # relation with name (names array): {3=>[370, 465], ... 17=>[147], 121=>[446]}
  def get_keys_with_items_array(key_item_pairs_arr)
    new_items_hash = {}
    key_item_pairs_arr.each do |one_array|
      SearchWork.fill_hash_w_val_arr(new_items_hash, one_array[0], one_array[1])
    end
    logger.info "After get_keys_with_items_array: new_items_hash = #{new_items_hash}"
    new_items_hash
  end


  # @note: collect hash of two fields records: relations (key) and names array (value)
  # for searching profile
  # todo: place this method in ProfileKey model
  def rel_name_profile_records(profile_id)
    # logger.info "In rel_name_profile_records: profile_id = #{profile_id}"
    ProfileKey.where(:profile_id => profile_id, deleted: 0)
        .order('relation_id','is_name_id')
        .select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id)
        .distinct
        .pluck(:relation_id, :is_name_id)
  end

  # @note: collect hash of relations (key) and names array (value)
  # todo: place this method in ProfileKey model
  def one_field_content(profile_id, field_name)
    # logger.info "In one_field_content: field_name = #{field_name}"
    ProfileKey.where(:profile_id => profile_id, deleted: 0)
        .select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id)
        .order('relation_id')
        .pluck(field_name)
    # .distinct
  end

  # @note: get checked profiles for exclusions
  def profiles_checking(profile_id_searched, trees_profiles)

    all_trees_found = trees_profiles.keys.flatten
    logger.info "all_trees_found = #{all_trees_found}"
    all_profiles_found = trees_profiles.values.flatten
    logger.info "all_profiles_found = #{all_profiles_found}"

    certain_profiles_trees = []
    certain_profiles_found = []
    certain_profiles_count = []

    all_profiles_found.each_with_index do |found_profile_to_check, index|
      priznak, match_count = check_exclusions(profile_id_searched, found_profile_to_check)
      # logger.info "After check_exclusions: found_profile_to_check = #{found_profile_to_check}, priznak = #{priznak}, match_count = #{match_count}"
      profile_checked = check_exclusions_priznak(priznak, match_count, found_profile_to_check)
      if profile_checked
        certain_profiles_count << match_count
        certain_profiles_found << profile_checked
        certain_profiles_trees << all_trees_found[index]
        puts "After check_exclusions & check_match_count?: profile_checked = #{profile_checked.inspect}, priznak = #{priznak}, match_count = #{match_count}"
      end
    end
    return certain_profiles_found, certain_profiles_count, certain_profiles_trees
  end

  # @note: main check of exclusions - special algorythm
  def check_exclusions(profile_id_searched, profile_id_found)
    puts "\n # check_exclusions # profile_id_searched = #{profile_id_searched}, profile_id_found To check = #{profile_id_found}\n"

    s_rel_name_arr = rel_name_profile_records(profile_id_searched)
    # s_rel_name_arr =
    [[8, 48], [3, 465], [3, 370], [15, 343], [16, 82], [17, 147], [121, 446]]
    # logger.info "search results: s_rel_name_arr = #{s_rel_name_arr} "

    f_rel_name_arr = rel_name_profile_records(profile_id_found)
    # f_rel_name_arr =
    [[1, 122], [2, 82], [91, 90], [3, 465], [121, 446], [3, 370], [8, 48], [101, 449], [92, 361], [102, 293], [17, 147]]
    # logger.info "found results: f_rel_name_arr = #{f_rel_name_arr}"

    # EXCLUSION_RELATIONS = WeafamSetting.first.exclusion_relations = [1,2,3,4,5,6,7,8,91,101,111,121,92,102,112,122]

    search_filling_hash = get_keys_with_items_array(s_rel_name_arr)
    logger.info "search_filling_hash = #{search_filling_hash}"
    found_filling_hash = get_keys_with_items_array(f_rel_name_arr)
    logger.info "found_filling_hash = #{found_filling_hash}"

    match_count = 0
    priznak = true
    search_filling_hash.each do |relation, names|
      # logger.info "In search_filling_hash: - relation = #{relation}, names = #{names}"
      sval = search_filling_hash[relation]
      fval = found_filling_hash[relation]
      if found_filling_hash.has_key?(relation)
        # logger.info "In found_filling_hash  has_key: - relation = #{relation}, fval = #{fval}, sval = #{sval}"
        if WeafamConstants::EXCLUSION_RELATIONS.include?(relation)
          if sval == fval
            match_count += sval.size
            priznak = true
            # logger.info "In IF check: (==) COMPLETE EQUAL - match_count = #{match_count}, check = #{(sval == fval) }"
          elsif sval & fval != []
            match_count += (sval & fval).size
            priznak = true
            # logger.info "In IF check: (&)ARE COMMON - match_count = #{match_count}, check = #{sval & fval != []}"
          else
            priznak = false
            logger.info "In All checks failed: - priznak = #{priznak}, match_count = #{match_count}"
            return priznak, match_count
          end
        else
          # logger.info "Not include main relations = #{relation}"
          if sval == fval
            match_count += sval.size
            # logger.info "In IF check: (==) COMPLETE EQUAL - match_count = #{match_count}, check = #{(sval == fval) }"
          else sval & fval != []
          match_count += (sval & fval).size
            # logger.info "In IF check: (&)ARE COMMON - match_count = #{match_count}, check = #{sval & fval != []}"
          end
        end

      else
        priznak = true
        # logger.info "In IF check: ([]) EMPTY Arrs - match_count = #{match_count}, check = #{sval == [] || fval == []}"
      end

    end
    logger.info "check_exclusions end: - priznak = #{priznak}, match_count = #{match_count}"

    return priznak, match_count
  end


  def check_match_count?(match_count)

    if match_count >= WeafamConstants::CERTAIN_KOEFF
      # logger.info "PROFILES ARE EQUAL - with exclusions determine"
      true
    else
      # logger.info "PROFILES NOT EQUAL"
      false
    end
  end


  def check_exclusions_priznak(priznak, match_count, profile_id_found)
    # logger.info "check_exclusions_priznak: - priznak = #{priznak}, match_count = #{match_count}"
    if priznak
      # logger.info "EXCLUSIONS PASSED"
      if check_match_count?(match_count)
        profile_id_found
      else
        nil
      end
    else
      # logger.info "EXCLUSIONS DID NOT PASSED"
      nil
    end
  end


  # @note: create data for search_results generation
  # @input: profiles_found = [790, 818, 826], profiles_trees = [57, 59, 60], profiles_count = [5, 5, 5]
  def create_results_data(certain_search_data)

    profile_id_searched = certain_search_data[:search]
    profiles_found      = certain_search_data[:founds]
    profiles_count      = certain_search_data[:counts]
    profiles_trees      = certain_search_data[:trees]
    # - certain_profiles_found =
    [790, 818, 826]
    # - certain_profiles_count =
    [5, 5, 5]
    # - certain_profiles_trees =
    [57, 59, 60]

    uniq_profiles_pairs = {}
    trees_profiles_found = {}
    profiles_counts = {}
    profiles_found.each_with_index do |one_profile, index|
      trees_profiles_found.merge!(profiles_trees[index] => one_profile )
      profiles_counts.merge!(one_profile => profiles_count[index] )
    end
    uniq_profiles_pairs.merge!(profile_id_searched => trees_profiles_found )
    {811=>{57=>790, 59=>818, 60=>826}}

    # uniq_profiles_pairs, profiles_with_match_hash = create_uniq_hash(profile_id_searched, profiles_found, profiles_trees)
    {811=>{57=>790, 59=>818, 60=>826}}

    # profiles_with_match_hash = create_profiles_counts(profiles_found, profiles_count)
    {790=>5, 818=>5, 826=>5}

    return uniq_profiles_pairs, profiles_counts
  end


  # @note: New modified quick search
  # for each profile from searching tree
  # 1.circle of searching profile
  # 2.find found matched records - get user_ids
  # 3.determine, for which trees have more records than coeff-t
  # 4.sequest user_ids if necessary
  # 5.determine found profiles in each user_id
  # 6.eliminate doubled found profiles if there are
  # 7.collect final found profile_ids
  # 8.check exclusions for each found profile_ids
  # 9.get final found profile_ids with user_id position
  # 10.make usual search_results for store/
  def modi_search_one_profile(profile_search_data)
    start_search_time = Time.now

    puts "\n ##### modi_search_one_profile #####\n\n"
    logger.info "profile_search_data = #{profile_search_data}"

    profile_id_searched = profile_search_data[:profile_id_searched]

    [[8, 48], [3, 465], [3, 370], [15, 343], [16, 82], [17, 147], [121, 446]]
    # logger.info "search records: profile_id_searched = #{profile_id_searched}"

    arr_relations = one_field_content(profile_id_searched, 'relation_id')
    arr_names     = one_field_content(profile_id_searched, 'is_name_id')

    query_data = { connected_users: profile_search_data[:connected_users],
                   name_id_searched: profile_search_data[:name_id_searched],
                   arr_relations: arr_relations,
                   arr_names: arr_names }
    # logger.info "query_data[:connected_users] = #{query_data[:connected_users]}, query_data[:name_id_searched] = #{query_data[:name_id_searched]}"
    # logger.info "query_data[:arr_relations] = #{query_data[:arr_relations]}"
    # logger.info "query_data[:arr_names] = #{query_data[:arr_names]}"

    # query_data =
    #     {:connected_users=>[58], :name_id_searched=>28,
    #      :arr_relations=>[3, 3, 8, 15, 16, 17, 121],
    #      :arr_names=>   [465, 370, 48, 343, 82, 147, 446]}

    trees_profiles = get_found_two_fields(query_data, 'user_id', 'profile_id')
    # logger.info "trees_profiles = #{trees_profiles}"
    # trees_profiles = {57=>[795, 6000], 59=>[819], 60=>[827], 64=>[877], 65=>[892]}
    # logger.info "trees_profiles w doub= #{trees_profiles}"
    trees_profiles_no_double, doubles_one_to_many = SearchWork.duplicates_one_many_out(profile_id_searched, trees_profiles)
    logger.info "trees_profiles_no_double = uniqs = #{trees_profiles_no_double}, trees doubles_one_to_many = #{doubles_one_to_many}"

    certain_profiles_found, certain_profiles_count, certain_profiles_trees = profiles_checking(profile_id_searched, trees_profiles_no_double)
    # puts "\n After profile_checking: profile_id_searched = #{profile_id_searched}"
    # logger.info  "\n After profile_checking: profile_id_searched = #{profile_id_searched}"
    # logger.info " - certain_profiles_found = #{certain_profiles_found}"
    # logger.info " - certain_profiles_count = #{certain_profiles_count}"
    # logger.info " - certain_profiles_trees = #{certain_profiles_trees}"

    certain_search_data = {
        search: profile_id_searched,
        founds: certain_profiles_found,
        counts: certain_profiles_count,
        trees: certain_profiles_trees
    }

    profiles_trees_pairs, profiles_counts = create_results_data(certain_search_data)

    one_profile_results = {
        profiles_trees_pairs: profiles_trees_pairs,
        profiles_counts: profiles_counts,
        doubles_one_to_many: doubles_one_to_many
    }
    logger.info "finish modi_search_one_profile:"
    logger.info "one_profile_results = #{one_profile_results}"

    search_time = (Time.now - start_search_time) * 1000
    puts "\n == END OF modi_search === Search_time = #{search_time.round(2)} msec  \n\n"
    one_profile_results
  end

  ##################################################################################

  # @note: Determine: in which trees ids profiles were found
  def get_found_two_fields(query_data, field_one, field_two)
    fields_arr_values = both_fields_records(query_data, field_one, field_two)
    # logger.info "fields_arr_values = #{fields_arr_values}"
    # Hand test:
    # fields_arr_values = [[57, 795], [57, 795], [57, 795], [57, 795], [57, 795], [59, 819], [59, 819], [59, 819], [59, 819], [59, 819], [60, 827], [60, 827], [60, 827], [60, 827], [60, 827], [64, 877], [65, 892]]
    # fields_arr_values = [[57, 790], [57, 790], [57, 790], [57, 790], [57, 7960], [59, 818], [59, 818], [59, 818], [59, 818], [59, 818], [60, 826], [60, 826], [60, 826], [60, 826], [60, 826]]
    # logger.info "Hand fields_arr_values = #{fields_arr_values}"

    values_occurence = occurence_counts(fields_arr_values)
    logger.info "values_occurence = #{values_occurence}"

    fields_arr_to_check = exclude_uncertain_trees(values_occurence)
    logger.info "fields_arr_to_check = #{fields_arr_to_check}"
    get_keys_with_items_array(fields_arr_to_check)

  end

  # @note: Determine: in which trees ids profiles were found
  def get_found_fields(query_data, field)
    field_values = found_records(query_data, field)
    logger.info "field_values = #{field_values}"

    values_occurence = occurence_counts(field_values)
    logger.info "values_occurence = #{values_occurence}"

    exclude_uncertain_trees(values_occurence)
  end

  # @note: Find by fields - [relation, is_name_id]
  # for each row in ProfileKey
  # get array of arrays: [[key, item] .. [ , ]]
  def both_fields_records(query_data, field_one, field_two)
    connected_users = query_data[:connected_users]
    name_id_searched = query_data[:name_id_searched]
    arr_relations = query_data[:arr_relations]
    arr_names = query_data[:arr_names]

    # arr_relations = [8,3,3,15,16,17,121]
    # arr_names = [48,465,370,343,82,147,446]

    ProfileKey.where.not(user_id: connected_users)
        .where(:name_id => name_id_searched)
        .where(deleted: 0)
        .where("relation_id in (?)", arr_relations)
        .where("is_name_id in (?)", arr_names)
        .order('user_id','relation_id','is_name_id')
        .select('id','user_id','profile_id','name_id','relation_id','is_name_id','is_profile_id')
        .pluck(field_one, field_two)
  end

  # @note: Find by new field - [relation, is_name_id]
  # for each row in ProfileKey
  def found_records(query_data, field_array)
    connected_users = query_data[:connected_users]
    name_id_searched = query_data[:name_id_searched]
    arr_relations = query_data[:arr_relations]
    arr_names = query_data[:arr_names]

    # arr_relations = [8,3,3,15,16,17,121]
    # arr_names = [48,465,370,343,82,147,446]

    ProfileKey.where.not(user_id: connected_users)
        .where(:name_id => name_id_searched)
        .where(deleted: 0)
        .where("relation_id in (?)", arr_relations)
        .where("is_name_id in (?)", arr_names)
        .order('user_id','relation_id','is_name_id')
        .select('id','user_id','profile_id','name_id','relation_id','is_name_id','is_profile_id')
        .pluck(field_array)
  end


  # @note: How many array element ocure
  def occurence_counts(user_ids)
    user_ids.each_with_object(Hash.new(0)) { |word,counts| counts[word] += 1 }
  end


  # @note: Exclude tree_id (user_id) if found records < certain_koeff
  def exclude_uncertain_trees(user_id_occurence)
    # user_id_occurence = {57=>5, 59=>5, 60=>4} #test
    user_id_occurence.delete_if { |user_id, occure| occure < WeafamConstants::CERTAIN_KOEFF }
    user_id_occurence.keys
  end


  # @note: Put away doubles New super extra search body
  def results_without_doubles(results)
    # results_by_trees_to_store =
    SearchResults.update_by_trees(results)
  end





  # TEST
  # start_hash = {805=>{57=>795, 59=>819, 60=>827}, 806=>{59=>819, 60=>831}, 811=>{57=>790, 59=>818, 60=>826}, 810=>{59=>820, 60=>825}, 809=>{57=>793, 59=>817, 60=>828}, 807=>{59=>824, 60=>832}, 896=>{57=>898}}
  # After duplicates_many_to_one:
  # uniqs =
  #  {805=>{57=>795, 60=>827}, 806=>{60=>831}, 811=>{57=>790, 59=>818, 60=>826}, 810=>{59=>820, 60=>825}, 809=>{57=>793, 59=>817, 60=>828}, 807=>{59=>824, 60=>832}, 896=>{57=>898}}
  # duplicates_many_to_one =
  #  {806=>{59=>819}, 805=>{59=>819}}

  # [inf] search records: start_hash =
  # {805=>{57=>795, 59=>819, 60=>827}, 806=>{59=>823, 60=>831}, 811=>{57=>790, 59=>818, 60=>826}, 810=>{59=>820, 60=>825}, 809=>{57=>793, 59=>817, 60=>828}, 807=>{59=>824, 60=>832}, 896=>{57=>898}}
  # # [inf] search records: profiles_with_match_hash =
  # {795=>5, 819=>5, 827=>5, 823=>5, 831=>5, 790=>5, 818=>5, 826=>5, 820=>5, 825=>5, 793=>5, 817=>5, 828=>5, 824=>5, 832=>5, 898=>5}
  # [inf] search records: doubles_one_to_many_hash = {} (pid:3925)

  # Before SearchResults:
  # search records: uniq_profiles_pairs =
  {805=>{57=>795, 59=>819, 60=>827},
   806=>{59=>823, 60=>831},
   811=>{57=>790, 59=>818, 60=>826},
   810=>{59=>820, 60=>825},
   809=>{57=>793, 59=>817, 60=>828},
   807=>{59=>824, 60=>832},
   896=>{57=>898}}
  # search records: profiles_with_match_hash =
  {795=>5, 819=>5, 827=>5, 823=>5, 831=>5, 790=>5, 818=>5, 826=>5,
   820=>5, 825=>5, 793=>5, 817=>5, 828=>5, 824=>5, 832=>5, 898=>5}
  # search records:
  # doubles_one_to_many_hash =
  {}



  # [inf] SearchResults: From 58 by_profiles =
  [{:search_profile_id=>896, :found_tree_id=>57, :found_profile_id=>898, :count=>5},
   {:search_profile_id=>807, :found_tree_id=>60, :found_profile_id=>832, :count=>5},
   {:search_profile_id=>807, :found_tree_id=>59, :found_profile_id=>824, :count=>5},
   {:search_profile_id=>809, :found_tree_id=>60, :found_profile_id=>828, :count=>5},
   {:search_profile_id=>809, :found_tree_id=>59, :found_profile_id=>817, :count=>5},
   {:search_profile_id=>809, :found_tree_id=>57, :found_profile_id=>793, :count=>5},
   {:search_profile_id=>810, :found_tree_id=>60, :found_profile_id=>825, :count=>5},
   {:search_profile_id=>810, :found_tree_id=>59, :found_profile_id=>820, :count=>5},
   {:search_profile_id=>811, :found_tree_id=>60, :found_profile_id=>826, :count=>5},
   {:search_profile_id=>811, :found_tree_id=>59, :found_profile_id=>818, :count=>5},
   {:search_profile_id=>811, :found_tree_id=>57, :found_profile_id=>790, :count=>5},
   {:search_profile_id=>806, :found_tree_id=>60, :found_profile_id=>831, :count=>5},
   {:search_profile_id=>806, :found_tree_id=>59, :found_profile_id=>823, :count=>5},
   {:search_profile_id=>805, :found_tree_id=>60, :found_profile_id=>827, :count=>5},
   {:search_profile_id=>805, :found_tree_id=>59, :found_profile_id=>819, :count=>5},
   {:search_profile_id=>805, :found_tree_id=>57, :found_profile_id=>795, :count=>5}]
  # by_trees =
  [{:found_tree_id=>57, :found_profile_ids=>[795, 790, 793, 898]},
   {:found_tree_id=>59, :found_profile_ids=>[819, 823, 818, 820, 817, 824]},
   {:found_tree_id=>60, :found_profile_ids=>[827, 831, 826, 825, 828, 832]}]

  #########################################################################

  # :by_profiles=>
  [{:search_profile_id=>658, :found_tree_id=>47, :found_profile_id=>668, :count=>8},
   {:search_profile_id=>659, :found_tree_id=>47, :found_profile_id=>666, :count=>8},
   {:search_profile_id=>656, :found_tree_id=>47, :found_profile_id=>669, :count=>8},
   {:search_profile_id=>665, :found_tree_id=>45, :found_profile_id=>647, :count=>7},
   {:search_profile_id=>657, :found_tree_id=>47, :found_profile_id=>667, :count=>7},
   {:search_profile_id=>658, :found_tree_id=>45, :found_profile_id=>645, :count=>7},
   {:search_profile_id=>664, :found_tree_id=>45, :found_profile_id=>646, :count=>7},
   {:search_profile_id=>659, :found_tree_id=>45, :found_profile_id=>650, :count=>7},
   {:search_profile_id=>656, :found_tree_id=>45, :found_profile_id=>649, :count=>7},
   {:search_profile_id=>665, :found_tree_id=>47, :found_profile_id=>673, :count=>6},
   {:search_profile_id=>664, :found_tree_id=>47, :found_profile_id=>672, :count=>6},
   {:search_profile_id=>662, :found_tree_id=>47, :found_profile_id=>670, :count=>5},
   {:search_profile_id=>657, :found_tree_id=>45, :found_profile_id=>651, :count=>5},
   {:search_profile_id=>663, :found_tree_id=>47, :found_profile_id=>671, :count=>5},
   {:search_profile_id=>734, :found_tree_id=>47, :found_profile_id=>721, :count=>5}]
  # :by_trees=>
  [{:found_tree_id=>47, :found_profile_ids=>[669, 666, 672, 721, 668, 671, 667, 670, 673]}]
  # , :duplicates_one_to_many=>
  {734=>{45=>{648=>5, 733=>5}}}



  ####################################################################
  # :by_profiles=>
  [{:search_profile_id=>658, :found_tree_id=>47, :found_profile_id=>668, :count=>8}, {:search_profile_id=>659, :found_tree_id=>47, :found_profile_id=>666, :count=>8}, {:search_profile_id=>656, :found_tree_id=>47, :found_profile_id=>669, :count=>8}, {:search_profile_id=>665, :found_tree_id=>45, :found_profile_id=>647, :count=>7}, {:search_profile_id=>657, :found_tree_id=>47, :found_profile_id=>667, :count=>7},
   {:search_profile_id=>658, :found_tree_id=>45, :found_profile_id=>645, :count=>7}, {:search_profile_id=>664, :found_tree_id=>45, :found_profile_id=>646, :count=>7}, {:search_profile_id=>659, :found_tree_id=>45, :found_profile_id=>650, :count=>7}, {:search_profile_id=>656, :found_tree_id=>45, :found_profile_id=>649, :count=>7}, {:search_profile_id=>665, :found_tree_id=>47, :found_profile_id=>673, :count=>6}, {:search_profile_id=>664, :found_tree_id=>47, :found_profile_id=>672, :count=>6}, {:search_profile_id=>662, :found_tree_id=>47, :found_profile_id=>670, :count=>5}, {:search_profile_id=>657, :found_tree_id=>45, :found_profile_id=>651, :count=>5}, {:search_profile_id=>663, :found_tree_id=>47, :found_profile_id=>671, :count=>5}, {:search_profile_id=>734, :found_tree_id=>47, :found_profile_id=>721, :count=>5}]
  # :by_trees=>
  [{:found_tree_id=>47, :found_profile_ids=>[669, 666, 672, 721, 668, 671, 667, 670, 673]}]
  # , :duplicates_one_to_many=>
  {734=>{45=>{648=>5, 733=>5}}}

  # For test for doubles: trees_profiles = {57=>[795, 6000], 59=>[819], 60=>[827], 64=>[877], 65=>[892]}
  # finish modi_search_one_profile: one_profile_results =
  {:profiles_trees_pairs=>{805=>{59=>819, 60=>827}},
   :profiles_counts=>{819=>5, 827=>5},
   :doubles_one_to_many=>{805=>{57=>[795, 6000]}}}


  # [inf] modified results[:by_profiles] =
  [{:search_profile_id=>694, :found_tree_id=>49, :found_profile_id=>687, :count=>6},
   {:search_profile_id=>691, :found_tree_id=>49, :found_profile_id=>684, :count=>5},
   {:search_profile_id=>691, :found_tree_id=>24, :found_profile_id=>443, :count=>5},
   {:search_profile_id=>690, :found_tree_id=>49, :found_profile_id=>683, :count=>5},
   {:search_profile_id=>690, :found_tree_id=>24, :found_profile_id=>442, :count=>5},
   {:search_profile_id=>695, :found_tree_id=>49, :found_profile_id=>688, :count=>4},
   {:search_profile_id=>693, :found_tree_id=>49, :found_profile_id=>686, :count=>4},
   {:search_profile_id=>693, :found_tree_id=>24, :found_profile_id=>450, :count=>4}]
  # [inf] modified results[:by_trees] =
  [{:found_tree_id=>24, :found_profile_ids=>[450, 442, 443]},
   {:found_tree_id=>49, :found_profile_ids=>[686, 687, 688, 683, 684]}]
  # [inf] modified results[:duplicates_one_to_many] =
  {689=>{49=>[682, 685]}, 692=>{49=>[682, 685]}}


  # results[:by_profiles] =
  [{:search_profile_id=>690, :found_tree_id=>49, :found_profile_id=>683, :count=>7},
   {:search_profile_id=>693, :found_tree_id=>49, :found_profile_id=>686, :count=>6},
   {:search_profile_id=>690, :found_tree_id=>24, :found_profile_id=>442, :count=>5},
   {:search_profile_id=>694, :found_tree_id=>49, :found_profile_id=>687, :count=>5},
   {:search_profile_id=>689, :found_tree_id=>49, :found_profile_id=>682, :count=>5},
   {:search_profile_id=>692, :found_tree_id=>49, :found_profile_id=>685, :count=>4},
   {:search_profile_id=>694, :found_tree_id=>24, :found_profile_id=>444, :count=>4},
   {:search_profile_id=>693, :found_tree_id=>24, :found_profile_id=>450, :count=>4}]
  # [inf] results[:by_trees] =
  [{:found_tree_id=>49, :found_profile_ids=>[682, 686, 687, 683, 685]},
   {:found_tree_id=>24, :found_profile_ids=>[450, 444, 442]}]
  # [inf] results[:profiles_relations_arr] =
  [{:profile_searched=>689,
    :profile_relations=>{690=>1, 691=>2, 694=>3, 692=>5, 693=>6, 695=>8}},

   {:profile_searched=>693,
    :profile_relations=>{690=>1, 691=>2, 689=>5, 692=>5, 694=>211}},
   {:profile_searched=>694,
    :profile_relations=>{689=>1, 695=>2, 690=>91, 691=>101, 692=>191, 693=>201}},
   {:profile_searched=>695,
    :profile_relations=>{694=>3, 689=>7, 690=>13, 691=>14}},
   {:profile_searched=>690,
    :profile_relations=>{689=>3, 692=>3, 693=>4, 691=>8, 695=>17, 694=>111}},
   {:profile_searched=>691,
    :profile_relations=>{689=>3, 692=>3, 693=>4, 690=>7, 695=>17, 694=>111}},
   {:profile_searched=>692,
    :profile_relations=>{690=>1, 691=>2, 689=>5, 693=>6, 694=>211}}]



  [{:profile_searched=>689,
    :profile_relations=>{690=>1, 691=>2, 694=>3, 692=>5, 693=>6, 695=>8},
    :profile_relations=>{690=>1, 691=>2, 694=>3, 692=>5, 693=>6, 695=>8},

    :init_user_name=>123, :init_user_id=>50,
    :init_relations_names=>{690=>162, 691=>48, 694=>461, 692=>123, 693=>2, 695=>9}},
   {:profile_searched=>682,
    :profile_relations=>{683=>1, 684=>2, 687=>3, 685=>5, 686=>6, 688=>8},
    :user_name=>123, :found_user_id=>49,
    :user_relations_names=>{683=>162, 684=>219, 687=>461, 685=>123, 686=>2, 688=>9}}]


  # # [inf] results[:profiles_relations_arr] =
  # [{:profile_searched=>805,
  #   :profile_relations=>{806=>1, 807=>2, 809=>3, 810=>3, 808=>6, 811=>7, 895=>17, 812=>91, 814=>92, 813=>101, 815=>102, 896=>121}},
  #  {:profile_searched=>806,
  #   :profile_relations=>{812=>1, 813=>2, 805=>4, 808=>4, 807=>8, 814=>15, 815=>16, 811=>18, 809=>112, 810=>112}},
  #  {:profile_searched=>808,
  #   :profile_relations=>{806=>1, 807=>2, 805=>6, 812=>91, 814=>92, 813=>101, 815=>102, 809=>212, 810=>212}},
  #  {:profile_searched=>813,
  #   :profile_relations=>{806=>3, 812=>7, 807=>17, 805=>121, 808=>121}},
  #  {:profile_searched=>814,
  #   :profile_relations=>{807=>4, 815=>8, 806=>18, 805=>122, 808=>122}},
  #  {:profile_searched=>895,
  #   :profile_relations=>{902=>1, 896=>4, 809=>7, 811=>13, 805=>14}},
  #  {:profile_searched=>811,
  #   :profile_relations=>{809=>3, 810=>3, 805=>8, 806=>15, 807=>16, 895=>17, 896=>121}},
  #  {:profile_searched=>815,
  #   :profile_relations=>{807=>4, 814=>7, 806=>18, 805=>122, 808=>122}},
  #  {:profile_searched=>812,
  #   :profile_relations=>{806=>3, 813=>8, 807=>17, 805=>121, 808=>121}},
  #  {:profile_searched=>810,
  #   :profile_relations=>{811=>1, 805=>2, 809=>5, 806=>92, 807=>102, 808=>202, 896=>221}},
  #  {:profile_searched=>809,
  #   :profile_relations=>{811=>1, 805=>2, 896=>4, 810=>5, 895=>8, 902=>15, 806=>92, 807=>102, 808=>202}},
  #  {:profile_searched=>807,
  #   :profile_relations=>{814=>1, 815=>2, 805=>4, 808=>4, 806=>7, 812=>13, 813=>14, 811=>18, 809=>112, 810=>112}},
  #  {:profile_searched=>902,
  #   :profile_relations=>{}},
  #  {:profile_searched=>896,
  #   :profile_relations=>{809=>1, 895=>2, 811=>91, 902=>92, 805=>101, 810=>191}}]

  # ('---- 8- 48','---- 3- 465','---- 3- 370','---- 15- 343','---- 16- 82','---- 17- 147','---- 121- 446')


  [[8, 48, 805], [3, 465, 810], [3, 370, 809], [15, 343, 806], [16, 82, 807], [17, 147, 895], [121, 446, 896]]




  # SELECT "profile_keys".* FROM "profile_keys"  WHERE ("profile_keys"."user_id" NOT IN (58)) AND "profile_keys"."name_id" = 28 AND (relation_id in (8,3,3,15,16,17,121)) AND (is_name_id in (48,465,370,343,82,147,446)) AND "profile_keys"."deleted" = 0  ORDER BY user_id, relation_id, is_name_id (pid:26935)
  {"id"=>5611, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>3, "is_name_id"=>370, "is_profile_id"=>793}
  {"id"=>5617, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>3, "is_name_id"=>465, "is_profile_id"=>794}
  {"id"=>5625, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>8, "is_name_id"=>48, "is_profile_id"=>795}
  {"id"=>6387, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>17, "is_name_id"=>147, "is_profile_id"=>897}
  {"id"=>6395, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>121, "is_name_id"=>446, "is_profile_id"=>898}
  {"id"=>5776, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>3, "is_name_id"=>370, "is_profile_id"=>817}
  {"id"=>5783, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>3, "is_name_id"=>465, "is_profile_id"=>820}
  {"id"=>5779, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>8, "is_name_id"=>48, "is_profile_id"=>819}
  {"id"=>5811, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>15, "is_name_id"=>343, "is_profile_id"=>823}
  {"id"=>5821, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>16, "is_name_id"=>82, "is_profile_id"=>824}
  {"id"=>5831, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>3, "is_name_id"=>370, "is_profile_id"=>828}
  {"id"=>5824, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>3, "is_name_id"=>465, "is_profile_id"=>825}
  {"id"=>5827, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>8, "is_name_id"=>48, "is_profile_id"=>827}
  {"id"=>5859, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>15, "is_name_id"=>343, "is_profile_id"=>831}
  {"id"=>5869, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>16, "is_name_id"=>82, "is_profile_id"=>832}


  {"id"=>5611, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>3, "is_profile_id"=>793, "is_name_id"=>370}
  {"id"=>5617, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>3, "is_profile_id"=>794, "is_name_id"=>465}
  {"id"=>5625, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>8, "is_profile_id"=>795, "is_name_id"=>48}
  {"id"=>6395, "user_id"=>57, "profile_id"=>790, "name_id"=>28, "relation_id"=>121, "is_profile_id"=>898, "is_name_id"=>446}
  {"id"=>5776, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>3, "is_profile_id"=>817, "is_name_id"=>370}
  {"id"=>5783, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>3, "is_profile_id"=>820, "is_name_id"=>465}
  {"id"=>5779, "user_id"=>59, "profile_id"=>818, "name_id"=>28, "relation_id"=>8, "is_profile_id"=>819, "is_name_id"=>48}
  {"id"=>5831, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>3, "is_profile_id"=>828, "is_name_id"=>370}
  {"id"=>5824, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>3, "is_profile_id"=>825, "is_name_id"=>465}
  {"id"=>5827, "user_id"=>60, "profile_id"=>826, "name_id"=>28, "relation_id"=>8, "is_profile_id"=>827, "is_name_id"=>48}


end # End of search module
