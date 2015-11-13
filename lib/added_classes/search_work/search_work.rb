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
    # test = filling_hash.key?(input_key) # Is elem w/input_key in filling_hash?
    # if test == false #  "NOT Found in hash"
    # puts "In fill_hash_w_val_arr"
    if !filling_hash.key?(input_key) #  "NOT Found in hash"
      filling_hash.merge!({input_key => [input_val]}) # include new elem in hash
    else  #  "Found in hash"
      ids_arr = filling_hash.values_at(input_key)[0]
      ids_arr << input_val
      filling_hash[input_key] = ids_arr # store new arr val
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
      # "key = profile_searched IS in hash - collect hash"
      current_hash = one_hash.fetch(tree) # get hash for tree
      test_profile_found = current_hash.key?(profile) # Is elem in one_hash?
      collect_hash_data = {
        current_hash: current_hash,
        one_hash:     one_hash,
        profile:      profile,
        tree:         tree,
        relation:     relation
      }
      # PREV REFACT VER
      # if test_profile_found == false #  "key=profile NOT Found in hash"
      #   collect_hash_data[:one_data] = [relation] # include profile with new array in hash
      #   # current_hash.merge!({profile => [relation]}) # include profile with new array in hash
      #   # one_hash.merge!(tree => current_hash ) # наполнение хэша соответствиями найденных профилей и найденных отношений
      # else  #  "Found in hash"
      #   collect_hash_data[:relation] = relation
      #   value_array = make_relation_value(collect_hash_data)
      #   # value_array = current_hash.values_at(profile)
      #   # value_array << relation
      #   # value_array = value_array.flatten(1)
      #   collect_hash_data[:one_data] = value_array
      #   # current_hash.merge!(profile => value_array )
      #   # one_hash.merge!(tree => current_hash )
      # end

      new_collect_hash_data = proceed_hash_data(test_profile_found, collect_hash_data)
      # наполнение хэша соответствиями найденных профилей и найденных отношений
      one_hash = collect_one_hash(new_collect_hash_data)
    else  # if !test_tree # == false
      # "key = profile_searched YET NOT in hash - make new hash in hash"
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
  # puts "one_hash = #{one_hash} "
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
    # logger.info " profiles_powers_hash = #{profiles_powers_hash} "
    profiles_powers_hash
  end


  # 34 Aleksei local
  {:tree_profiles=>[539, 548, 542, 541, 545, 546, 543, 547, 544, 540],
   :connected_author_arr=>[34], :qty_of_tree_profiles=>10,
   :profiles_relations_arr=>[
       {:profile_searched=>539,
        :profile_relations=>{540=>1, 541=>2, 542=>3, 543=>3, 544=>8, 545=>91, 547=>92, 546=>101, 548=>102}},
       {:profile_searched=>548,
        :profile_relations=>{541=>4, 547=>7, 540=>18, 539=>112}},
       {:profile_searched=>542,
        :profile_relations=>{539=>1, 544=>2, 543=>5, 540=>91, 541=>101}},
       {:profile_searched=>541,
        :profile_relations=>{547=>1, 548=>2, 539=>3, 540=>7, 545=>13, 546=>14, 544=>17, 542=>111, 543=>111}},
       {:profile_searched=>545,
        :profile_relations=>{540=>3, 546=>8, 541=>17, 539=>111}},
       {:profile_searched=>546,
        :profile_relations=>{540=>3, 545=>7, 541=>17, 539=>111}},
       {:profile_searched=>543,
        :profile_relations=>{539=>1, 544=>2, 542=>5, 540=>91, 541=>101}},
       {:profile_searched=>547,
        :profile_relations=>{541=>4, 548=>8, 540=>18, 539=>112}},
       {:profile_searched=>544,
        :profile_relations=>{542=>3, 543=>3, 539=>7, 540=>13, 541=>14}},
       {:profile_searched=>540,
        :profile_relations=>{545=>1, 546=>2, 539=>3, 541=>8, 547=>15, 548=>16, 544=>17, 542=>111, 543=>111}}],
   :profiles_found_arr=>[
       # Aleksei
       {539=>{46=>{657=>[1, 2, 3, 3, 8]},
              47=>{667=>[1, 2, 3, 3, 8]},
              45=>{651=>[3, 3, 8]}}},  # Aleksei
       {548=>{}},
       # Petr
       {542=>{45=>{649=>[1, 2, 5]}, # Petr
              46=>{656=>[1, 2, 5, 91, 101]},
              47=>{669=>[1, 2, 5, 91, 101]}}},
       {541=>{19=>{383=>[1]},
              46=>{663=>[3, 7, 17, 111, 111]},
              47=>{671=>[3, 7, 17, 111, 111]}}},
       {545=>{55=>{753=>[8]},
              56=>{753=>[8]}}},
       {546=>{55=>{754=>[7]},
              56=>{754=>[7]}}},
       # Fedor
       {543=>{45=>{650=>[1, 2, 5]}, # Fedor
              46=>{659=>[1, 2, 5, 91, 101]},
              47=>{666=>[1, 2, 5, 91, 101]}}},
       {547=>{19=>{367=>[4]}}},
       # Anna
       {544=>{45=>{645=>[3, 3, 7]}, # Anna
              46=>{658=>[3, 3, 7, 13, 14]},
              47=>{668=>[3, 3, 7, 13, 14]}}},
       {540=>{46=>{662=>[3, 8, 17, 111, 111]},
              47=>{670=>[3, 8, 17, 111, 111]}}}],
   :uniq_profiles_pairs=>
       {539=>{46=>657, 47=>667},
        542=>{46=>656, 47=>669},
        541=>{46=>663, 47=>671},
        543=>{46=>659, 47=>666},
        544=>{46=>658, 47=>668},
        540=>{46=>662, 47=>670}},
   :profiles_with_match_hash=>{670=>5, 662=>5, 668=>5, 658=>5, 666=>5, 659=>5, 671=>5, 663=>5, 669=>5, 656=>5, 667=>5, 657=>5},
   :by_profiles=>[
       {:search_profile_id=>540, :found_tree_id=>47, :found_profile_id=>670, :count=>5},
       {:search_profile_id=>540, :found_tree_id=>46, :found_profile_id=>662, :count=>5},
       {:search_profile_id=>544, :found_tree_id=>47, :found_profile_id=>668, :count=>5},
       {:search_profile_id=>544, :found_tree_id=>46, :found_profile_id=>658, :count=>5},
       {:search_profile_id=>543, :found_tree_id=>47, :found_profile_id=>666, :count=>5},
       {:search_profile_id=>543, :found_tree_id=>46, :found_profile_id=>659, :count=>5},
       {:search_profile_id=>541, :found_tree_id=>47, :found_profile_id=>671, :count=>5},
       {:search_profile_id=>541, :found_tree_id=>46, :found_profile_id=>663, :count=>5},
       {:search_profile_id=>542, :found_tree_id=>47, :found_profile_id=>669, :count=>5},
       {:search_profile_id=>542, :found_tree_id=>46, :found_profile_id=>656, :count=>5},
       {:search_profile_id=>539, :found_tree_id=>47, :found_profile_id=>667, :count=>5},
       {:search_profile_id=>539, :found_tree_id=>46, :found_profile_id=>657, :count=>5}],
   :by_trees=>[{:found_tree_id=>46, :found_profile_ids=>[657, 656, 663, 659, 658, 662]},
               {:found_tree_id=>47, :found_profile_ids=>[667, 669, 671, 666, 668, 670]}],
   :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}


  # 45 Anna local
  {:tree_profiles=>[645, 650, 654, 653, 647, 652, 655, 651, 646, 649, 648],
   :connected_author_arr=>[45], :qty_of_tree_profiles=>11,
   :profiles_relations_arr=>[
       {:profile_searched=>645, # Anna
        :profile_relations=>{646=>1, 647=>2, 649=>3, 650=>3, 648=>6, 651=>7, 652=>91, 654=>92, 653=>101, 655=>102}},
       {:profile_searched=>650,  # Fedor
        :profile_relations=>{651=>1, 645=>2, 649=>5, 646=>92, 647=>102, 648=>202}},
       {:profile_searched=>654,
        :profile_relations=>{647=>4, 655=>8, 646=>18, 645=>122, 648=>122}},
       {:profile_searched=>653,
        :profile_relations=>{646=>3, 652=>7, 647=>17, 645=>121, 648=>121}},
       {:profile_searched=>647,
        :profile_relations=>{654=>1, 655=>2, 645=>4, 648=>4, 646=>7, 652=>13, 653=>14, 651=>18, 649=>112, 650=>112}},
       {:profile_searched=>652,
        :profile_relations=>{646=>3, 653=>8, 647=>17, 645=>121, 648=>121}},
       {:profile_searched=>655,
        :profile_relations=>{647=>4, 654=>7, 646=>18, 645=>122, 648=>122}},
       {:profile_searched=>651, # Aleksei
        :profile_relations=>{649=>3, 650=>3, 645=>8, 646=>15, 647=>16}},
       {:profile_searched=>646,
        :profile_relations=>{652=>1, 653=>2, 645=>4, 648=>4, 647=>8, 654=>15, 655=>16, 651=>18, 649=>112, 650=>112}},
       {:profile_searched=>649, # Petr
        :profile_relations=>{651=>1, 645=>2, 650=>5, 646=>92, 647=>102, 648=>202}},
       {:profile_searched=>648,
        :profile_relations=>{646=>1, 647=>2, 645=>6, 652=>91, 654=>92, 653=>101, 655=>102, 649=>212, 650=>212}}],
   :profiles_found_arr=>[
       # Anna
       {645=>{46=>{658=>[1, 2, 3, 3, 7]},
              47=>{668=>[1, 2, 3, 3, 6, 7]},
              34=>{544=>[3, 3, 7]}}}, # Anna
       # Fedor
       {650=>{34=>{543=>[1, 2, 5]},  # Fedor
              46=>{659=>[1, 2, 5, 92, 102]},
              47=>{666=>[1, 2, 5, 92, 102, 202]}}},
       {654=>{}},
       {653=>{}},
       {647=>{46=>{665=>[4, 7, 18, 112, 112]},
              47=>{673=>[4, 4, 7, 18, 112, 112]}}},
       {652=>{}},
       {655=>{}},
       # Aleksei
       {651=>{34=>{539=>[3, 3, 8]}, # Aleksei
              46=>{657=>[3, 3, 8, 15, 16]},
              47=>{667=>[3, 3, 8, 15, 16]}}},
       {646=>{46=>{664=>[4, 8, 18, 112, 112]},
              47=>{672=>[4, 4, 8, 18, 112, 112]}}},
       # Petr
       {649=>{34=>{542=>[1, 2, 5]}, # Petr
              46=>{656=>[1, 2, 5, 92, 102]},
              47=>{669=>[1, 2, 5, 92, 102, 202]}}},
       {648=>{47=>{721=>[1, 2, 6, 212, 212]}}}],
   :uniq_profiles_pairs=>
       {645=>{46=>658, 47=>668},
        650=>{46=>659, 47=>666},
        647=>{46=>665, 47=>673},
        651=>{46=>657, 47=>667},
        646=>{46=>664, 47=>672},
        649=>{46=>656, 47=>669},
        648=>{47=>721}},
   :profiles_with_match_hash=>{669=>6, 672=>6, 673=>6, 666=>6, 668=>6, 721=>5, 656=>5, 664=>5, 667=>5, 657=>5, 665=>5, 659=>5, 658=>5},
   :by_profiles=>[
       {:search_profile_id=>649, :found_tree_id=>47, :found_profile_id=>669, :count=>6},
       {:search_profile_id=>646, :found_tree_id=>47, :found_profile_id=>672, :count=>6},
       {:search_profile_id=>647, :found_tree_id=>47, :found_profile_id=>673, :count=>6},
       {:search_profile_id=>650, :found_tree_id=>47, :found_profile_id=>666, :count=>6},
       {:search_profile_id=>645, :found_tree_id=>47, :found_profile_id=>668, :count=>6},
       {:search_profile_id=>648, :found_tree_id=>47, :found_profile_id=>721, :count=>5},
       {:search_profile_id=>649, :found_tree_id=>46, :found_profile_id=>656, :count=>5},
       {:search_profile_id=>646, :found_tree_id=>46, :found_profile_id=>664, :count=>5},
       {:search_profile_id=>651, :found_tree_id=>47, :found_profile_id=>667, :count=>5},
       {:search_profile_id=>651, :found_tree_id=>46, :found_profile_id=>657, :count=>5},
       {:search_profile_id=>647, :found_tree_id=>46, :found_profile_id=>665, :count=>5},
       {:search_profile_id=>650, :found_tree_id=>46, :found_profile_id=>659, :count=>5},
       {:search_profile_id=>645, :found_tree_id=>46, :found_profile_id=>658, :count=>5}],
   :by_trees=>[{:found_tree_id=>46, :found_profile_ids=>[658, 659, 665, 657, 664, 656]},
               {:found_tree_id=>47, :found_profile_ids=>[668, 666, 673, 667, 672, 669, 721]}],
   :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}






  # @note: ПОЛУЧЕНИЕ ПАР СООТВЕТСТВИЙ ПРОФИЛЕЙ С МАКС. МОЩНОСТЬЮ МНОЖЕСТВ СОВПАДЕНИЙ ОТНОШЕНИЙ
  def self.get_certain_profiles_pairs(profiles_found_arr, certainty_koeff)
    puts "=== IN get_certain_profiles_pairs "
    puts " profiles_found_arr = #{profiles_found_arr} "
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
    # puts " max profiles_powers_hash = #{max_profiles_powers_hash} "
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
