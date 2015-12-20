class SearchWork

  #############################################################
  # Иванищев А.В. 2014
  # @note: Методы обработки данных поиска в виде Hash
  #############################################################

  # @note: ИСПОЛЬЗУЮТСЯ В NEW METHODS "SEARCH.rb" & search_complete # & similars_complete_search)
  #   Наращивание (пополнение) Хэша1 новыми значениями из другого Хэша2
  # conn_hash = {72=>58, 75=>59, 76=>61, 77=>60, 78=>57}
  # new_conn_hash = {72=>58, 75=>59, 76=>61, 77=>60, 79=>62}
  # hash_1 -does not change
  # 79=>62 - найти те эл-ты in hash_2, кот-е отс-ют в hash_1
  # add 79=>62 to hash_1
  # Result: {72=>58, 75=>59, 76=>61, 77=>60, 78=>57, 79=>62} /
  def self.add_to_hash(hash_one,hash_two)
    arr_key = hash_one.keys
    hash_two.each do |key,val|
      hash_one = hash_one.merge!( key => val ) unless arr_key.include?(key)
    end
  end

  # @note: Наращивание финального хэша пар профилей для объединения, если есть чем наращивать
  def self.collect_final_connection(add_to_hash_data)
    add_connection_hash   = add_to_hash_data[:add_connection_hash]
    final_connection_hash = add_to_hash_data[:final_connection_hash]
    # unless add_connection_hash.blank?
    unless add_connection_hash.empty?
      add_to_hash(final_connection_hash, add_connection_hash)
    end
    final_connection_hash
  end


  # @note: check add_hash elements: whether each profiles pair - are equal profiles
  def self.check_add_hash(add_connection_hash, certain_koeff)
    checked_add_hash = {}
    add_connection_hash.each do |profile_searched, profile_found|
      common_relations_hash = SearchCircles.compare_profiles(profile_searched, profile_found)
      puts " common_relations_hash = #{common_relations_hash}, common_relations_hash.size = #{common_relations_hash.size} "
      if common_relations_hash.size >= certain_koeff
        checked_add_hash.merge!(profile_searched => profile_found)
        puts "profiles: #{profile_searched} and #{profile_found} -  ARE equal"
        # puts " Add EQU profiles: #{profile_searched} and #{profile_found} to checked_add_hash After Check"
      else
        puts "profiles: #{profile_searched} and #{profile_found} - are NOT equal"
        # puts " DO NOT Add profiles #{profile_searched} and #{profile_found} in checked_add_hash"
      end
    end
    checked_add_hash
  end


  # @note: "EXCLUDE Many_to_One DUPLICATES"
  #   Extract duplicates hashes from
  # @input hash = {57=>[795, 6000], 59=>[819], 60=>[827]}
  # @output:
  def self.duplicates_one_many_out(profile_id_searched,input_hash)
    no_doubles = {}
    duplicates_one_to_many = {}
    input_hash.each do |key, val_arr|
      if val_arr.size > 1
        duplicates_one_to_many.merge!(profile_id_searched => {key => val_arr})
      else
        no_doubles.merge!(key => val_arr)
      end
    end

    return no_doubles, duplicates_one_to_many
  end


    # @note: "EXCLUDE Many_to_One DUPLICATES"
  # Extract duplicates hashes from input hash
  def self.duplicates_out(start_hash)
    # Initaialize empty hash
    duplicates_many_to_one = {}
    uniqs = start_hash

    # Collect duplicates
    start_hash.each_with_index do |(start_k, start_v), index|
      start_hash.each do |key, value|
        next if start_k == key
        intersection = start_hash[key] & start_hash[start_k]
        if duplicates_many_to_one.has_key?(key)
          first_key = intersection.keys.first
          duplicates_many_to_one[key][first_key] = intersection[first_key] unless intersection.empty?
        else
          duplicates_many_to_one[key] = intersection unless intersection.empty?
        end
      end
    end

    # Collect uniqs
    duplicates_many_to_one.each do |dup_key, value|
      value.each do |value_k, value_v|
        uniqs[dup_key].delete_if { |kk,vv|  kk == value_k && vv = value_v }
      end
    end
    return uniqs, duplicates_many_to_one
  end


  # @note: make final sorted by_trees search results
  def self.fill_hash_w_val_arr(filling_hash, input_key, input_val)
    if !filling_hash.key?(input_key) #  "NOT Found in hash"
      filling_hash.merge!({input_key => [input_val]}) # include new elem in hash
    else  #  "Found in hash"
      ids_arr = filling_hash.values_at(input_key)[0]
      ids_arr << input_val
      filling_hash[input_key] = ids_arr.uniq # store new arr val
    end
  end


  # @note: make final sorted by_trees search results
  def self.make_by_trees_results(filling_hash)
    by_trees = []
    filling_hash.each do |tree_id, profiles_ids|
      one_tree_hash = {}
      one_tree_hash.merge!(:found_tree_id => tree_id)
      one_tree_hash.merge!(:found_profile_ids => profiles_ids)
      by_trees << one_tree_hash
    end
    by_trees
  end


  # @note: In NEW SEARCH method
  # Автоматическое наполнение хэша сущностями и
  # количестpвом появлений каждой сущности.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place = main_contrl.,
  ################# FILLING OF HASH WITH KEYS AND/OR VALUES
  def self.fill_arrays_in_hash(fill_arrays_data) # Filling of hash with keys and values, according to key occurance
    one_hash = fill_arrays_data[:profiles_hash]
    tree     = fill_arrays_data[:tree_user_id]
    profile  = fill_arrays_data[:tree_profile_id]
    relation = fill_arrays_data[:row_relation_id]

    # test: one_hash.key?(tree) - Did profile_searched in one_hash?
    if one_hash.key?(tree) #== true
      current_hash = one_hash.fetch(tree) # get hash for tree
      test_profile_found = current_hash.key?(profile) # Is elem in one_hash?
      collect_hash_data = {
        current_hash: current_hash,
        one_hash:     one_hash,
        profile:      profile,
        tree:         tree,
        relation:     relation
      }

      new_collect_hash_data = proceed_hash_data(test_profile_found, collect_hash_data)
      # наполнение хэша соответствиями найденных профилей и найденных отношений
      one_hash = collect_one_hash(new_collect_hash_data)
    else  # if !test_tree # == false
      # include new profile_searched with new profile with new array in hash
      one_hash.merge!(tree => { profile => [relation] } )
    end
    one_hash
  end

  # @note: calc data for hash collecting in dependence of found results
  def self.proceed_hash_data(test_profile_found, collect_hash_data)
    if test_profile_found #  "Found in hash"
      value_array = make_relation_value(collect_hash_data)
      collect_hash_data[:one_data] = value_array
    else  # "key=profile NOT Found in hash"
      collect_hash_data[:one_data] = [collect_hash_data[:relation]] # include profile with new array in hash
    end
    collect_hash_data
  end

  # @note: make_relation_value
  # used to: fill_arrays_in_hash
  def self.make_relation_value(collect_hash_data)
    value_array = collect_hash_data[:current_hash].values_at(collect_hash_data[:profile])
    value_array << collect_hash_data[:relation]
    value_array.flatten(1)
  end

  # @note: Collect hash for found profiles in found trees
  # used to: fill_arrays_in_hash
  # наполнение хэша соответствиями найденных профилей и найденных отношений
  def self.collect_one_hash(collect_hash_data)
    current_hash = collect_hash_data[:current_hash]
    one_hash     = collect_hash_data[:one_hash]
    profile      = collect_hash_data[:profile]
    tree         = collect_hash_data[:tree]
    one_data     = collect_hash_data[:one_data]
    current_hash.merge!(profile => one_data ) # наполнение хэша соответствиями найденных профилей и найденных отношений
    one_hash.merge!(tree => current_hash ) # наполнение хэша соответствиями найденных профилей и найденных отношений
    one_hash
  end

  # @note: Делаем ХЭШ профилей-отношений для искомого дерева. - пригодится.
  #   Tested
  # @param:
  # @return: ВСПОМОГАТЕЛЬНЫЙ РЕЗ-ТАТ ПОИСКА - СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА
  #   (массив ХЭШей ПАР ПРОФИЛЕЙ-ОТНОШЕНИЙ):
  #   [ {profile_searched: -> профиль искомый, profile_relations: -> все отношения к искомому профилю } ]
  # @see:
  def self.make_profile_relations(profile_id_searched, profile_relations, relations_arr)
    profile_relations_hash = Hash.new
    one_profile_relations_hash = { profile_searched: profile_id_searched, profile_relations: profile_relations}
    profile_relations_hash.merge!(one_profile_relations_hash)
    relations_arr << profile_relations_hash unless profile_relations_hash.empty? # Заполнение выходного массива хэшей
    relations_arr
  end


  # @note: ИСПОЛЬЗУЕТСЯ В NEW METHOD "SEARCH.rb"
  # ПРЕВРАЩЕНИЕ ХЭША ПРОФИЛЕЙ С НАЙДЕННЫМИ ОТНОШЕНИЯМИ В ХЭШ ПРОФИЛЕЙ С МОЩНОСТЯМИ ОТНОШЕНИЙ
  # @param: Input - reduced_relations_hash
  def self.make_profiles_power_hash(reduced_rels_hash)
    profiles_powers_hash = {}
    reduced_rels_hash.each { |key, v_arr | profiles_powers_hash.merge!( key => v_arr.size) }
    profiles_powers_hash
  end

  # @note: ПОЛУЧЕНИЕ ПАР СООТВЕТСТВИЙ ПРОФИЛЕЙ С МАКС. МОЩНОСТЬЮ МНОЖЕСТВ СОВПАДЕНИЙ ОТНОШЕНИЙ
  def self.get_certain_profiles_pairs(profiles_found_arr, certainty_koeff)
    # puts "=== IN get_certain_profiles_pairs "
    # puts " profiles_found_arr = #{profiles_found_arr} "
    max_power_profiles_pairs_hash = {}  # Профили с макс-м кол-вом совпадений для одного соответствия в дереве
    profiles_with_match_hash = {} # Профили, отсортир-е по кол-ву совпадений
    new_profiles_with_match_hash = {}
    duplicates_pairs_one_to_many = {}  # Дубликаты ТИПА 1 К 2 - One_to_Many пар профилей
    profiles_found_arr.each do |hash_in_arr|
      hash_in_arr.each do |searched_profile, profile_trees_relations|
        max_power_pairs_hash = {}
        duplicates_one_to_many_hash = {}

        profile_trees_relations.each do |key_tree, profile_relations_hash|
          reduced_profile_relations_hash = reduce_profile_relations(profile_relations_hash, certainty_koeff)
          unless reduced_profile_relations_hash.empty?
            max_profiles_powers_hash, max_power = get_max_power(reduced_profile_relations_hash)
            match_data = {
                max_power: max_power,
                key_tree:key_tree,
                profiles_with_match_hash: profiles_with_match_hash,
                max_profiles_powers_hash: max_profiles_powers_hash,
                max_power_pairs_hash: max_power_pairs_hash
            }
            # Выявление дубликатов ТИПА 1 К 2 - One_to_Many
            max_profiles_powers_hash.size == 1 ? # if один профиль с максимальной мощностью
              ( new_profiles_with_match_hash, max_power_pairs_hash = get_new_profiles_match(match_data) )
              : duplicates_one_to_many_hash.merge!(key_tree => max_profiles_powers_hash )
          end

        end

        result_hashes_data = {
          new_profiles_with_match_hash:  new_profiles_with_match_hash,
          duplicates_one_to_many_hash:   duplicates_one_to_many_hash,
          duplicates_pairs_one_to_many:  duplicates_pairs_one_to_many,
          max_power_pairs_hash:          max_power_pairs_hash,
          max_power_profiles_pairs_hash: max_power_profiles_pairs_hash,
          searched_profile:              searched_profile
        }

        max_power_profiles_pairs_hash, duplicates_pairs_one_to_many, new_profiles_with_match_hash =
            get_result_hashes(result_hashes_data)

      end

    end
    return max_power_profiles_pairs_hash, duplicates_pairs_one_to_many, new_profiles_with_match_hash

  end # End of method get_certain_profiles_pairs


  # @note: get_max_power from reduced_relations_hash
  def self.get_max_power(reduced_relations)
    profiles_powers_hash = make_profiles_power_hash(reduced_relations)
    max_profiles_powers_hash, max_power = get_max_power_profiles_hash(profiles_powers_hash)
    return max_profiles_powers_hash, max_power
  end


  # @note: get_new_profiles_match from reduced_relations_hash
  # НАРАЩИВАНИЕ ХЭША ДОСТОВЕРНЫХ ПАР ПРОФИЛЕЙ certain_max_power_pairs_hash
  def self.get_new_profiles_match(match_data)
    max_profiles_powers_hash = match_data[:max_profiles_powers_hash]
    profiles_with_match_hash = match_data[:profiles_with_match_hash]
    max_power_pairs_hash     = match_data[:max_power_pairs_hash]

    profile_selected = max_profiles_powers_hash.key(match_data[:max_power])
    max_power_pairs_hash.merge!(match_data[:key_tree] => profile_selected )
    new_profiles_with_match_hash = get_profiles_match_hash(profiles_with_match_hash, max_profiles_powers_hash)

    return new_profiles_with_match_hash, max_power_pairs_hash
  end


  # @note: get_max_power from reduced_relations_hash
  def self.get_result_hashes(result_hashes_data)

    new_profiles_with_match_hash   = result_hashes_data[:new_profiles_with_match_hash]
    duplicates_one_to_many_hash    = result_hashes_data[:duplicates_one_to_many_hash]
    duplicates_pairs_one_to_many   = result_hashes_data[:duplicates_pairs_one_to_many]
    max_power_pairs_hash           = result_hashes_data[:max_power_pairs_hash]
    max_power_profiles_pairs_hash  = result_hashes_data[:max_power_profiles_pairs_hash]
    searched_profile               = result_hashes_data[:searched_profile]

    new_profiles_with_match_hash = Hash[new_profiles_with_match_hash.sort_by { |key_match, val_match| val_match }.reverse] #  Ok Sorting of input hash by values Descend
    max_power_profiles_pairs_hash.merge!(searched_profile => max_power_pairs_hash ) unless max_power_pairs_hash.empty?
    duplicates_pairs_one_to_many.merge!(searched_profile => duplicates_one_to_many_hash ) unless duplicates_one_to_many_hash.empty?

    return max_power_profiles_pairs_hash, duplicates_pairs_one_to_many, new_profiles_with_match_hash
  end


  # @note:
  #   ИЗЪЯТИЕ ПРОФИЛЕЙ С МАЛОЙ МОЩНОСТЬЮ НАЙДЕННЫХ ОТНОШЕНИЙ
  def self.reduce_profile_relations(relations_hash, certainty_koeff)
    reduced_relations_hash = relations_hash.select {|key,val| val.size >= certainty_koeff }
    # puts " reduced_profile_relations_hash = #{reduced_relations_hash} "
    reduced_relations_hash
  end

  # @note:ПРЕВРАЩЕНИЕ ХЭША ПРОФИЛЕЙ С МОЩНОСТЯМИ ОТНОШЕНИЙ В ХЭШ ПРОФИЛЯ(ЕЙ) С МАКСИМАЛЬНОЙ(МИ) МОЩНОСТЬЮ
  def self.get_max_power_profiles_hash(profiles_powers_hash)
    max_power = profiles_powers_hash.values.max # определение значения макс-й мощности
    max_profiles_powers_hash = profiles_powers_hash.select { |k_power, v_power| v_power == max_power} # выбор эл-тов хэша с макс-й мощностью
    return max_profiles_powers_hash, max_power
  end


  # @note:Получение хэша профилей с максимальными значениями совпадений
  def self.get_profiles_match_hash(profiles_match_hash, max_profiles_powers)
    new_profiles_with_match_hash = profiles_match_hash
    profiles_arr = new_profiles_with_match_hash.keys
    if max_profiles_powers.size == 1
      one_profile = max_profiles_powers.keys[0]
      one_match = max_profiles_powers.values_at(one_profile)[0]
      # puts " IN get_profiles_match_hash:: new_profiles_with_match_hash = #{new_profiles_with_match_hash}, profiles_arr = #{profiles_arr}, one_profile = #{one_profile}, one_match = #{one_match},  "
      if profiles_arr.include?(one_profile)
        match_in_hash = new_profiles_with_match_hash.values_at(one_profile)[0]
        new_profiles_with_match_hash = collect_profiles_match_hash(profiles_match_hash, max_profiles_powers) if one_match > match_in_hash
      else
        new_profiles_with_match_hash = collect_profiles_match_hash(profiles_match_hash, max_profiles_powers)
      end
    else
      puts "ERROR IN get_profiles_match_hash profiles_arr: max_profiles_powers_hash.size != 1 "
    end
    new_profiles_with_match_hash
  end


  # @note:Collect of хэша профилей с максимальными значениями совпадений
  def self.collect_profiles_match_hash(profiles_match_hash, max_profiles_powers)
    profiles_match_hash.merge!(max_profiles_powers ) unless max_profiles_powers.empty?
  end





end
