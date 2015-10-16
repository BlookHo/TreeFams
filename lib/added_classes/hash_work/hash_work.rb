class HashWork

  #############################################################
  # Иванищев А.В. 2014
  # @note: Методы обработки данных поиска в виде Hash
  #############################################################

  # ИСПОЛЬЗУЕТСЯ В NEW METHODS complete_search & similars_complete_search
  # Наращивание (пополнение) Хэша1 новыми значениями из другого Хэша2
  #conn_hash = {72=>58, 75=>59, 76=>61, 77=>60, 78=>57}
  #new_conn_hash = {72=>58, 75=>59, 76=>61, 77=>60, 79=>62}
  # hash_1 -does not change
  # 79=>62 - найти те эл-ты in hash_2, кот-е отс-ют в hash_1
  # add 79=>62 to hash_1
  # Result: {72=>58, 75=>59, 76=>61, 77=>60, 78=>57, 79=>62} /
  def self.add_to_hash(hash_1,hash_2)
    arr_key1 = hash_1.keys
    hash_2.each do |k,v|
      hash_1 = hash_1.merge!( k => v) if !arr_key1.include?(k)
    end
  end


  # @note: "EXCLUDE Many_to_One DUPLICATES"
  # Extract duplicates hashes from input hash
  def self.duplicates_out(start_hash)
    # Initaialize empty hash
    duplicates_many_to_one = {}
    uniqs = start_hash

    # Collect duplicates
    start_hash.each_with_index do |(k, v), index|
      start_hash.each do |key, value|
        next if k == key
        intersection = start_hash[key] & start_hash[k]
        if duplicates_many_to_one.has_key?(key)
          duplicates_many_to_one[key][intersection.keys.first] = intersection[intersection.keys.first] if !intersection.empty?
        else
          duplicates_many_to_one[key] = intersection if !intersection.empty?
        end
      end
    end

    # Collect uniqs
    duplicates_many_to_one.each do |key, value|
      value.each do |k, v|
        uniqs[key].delete_if { |kk,vv|  kk == k && vv = v }
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
  # def self.fill_arrays_in_hash(one_hash, tree, profile, relation) # Filling of hash with keys and values, according to key occurance
  def self.fill_arrays_in_hash(fill_arrays_data) # Filling of hash with keys and values, according to key occurance

    one_hash = fill_arrays_data[:profiles_hash]
    tree     = fill_arrays_data[:tree_user_id]
    profile  = fill_arrays_data[:tree_profile_id]
    relation = fill_arrays_data[:row_relation_id]

    test_tree = one_hash.key?(tree) # Is profile_searched in one_hash?
    if test_tree == false #  "key = profile_searched YET NOT in hash - make new hash in hash"
      one_hash.merge!(tree => { profile => [relation] } ) # include new profile_searched with new profile with new array in hash
    else
      current_hash = one_hash.fetch(tree) # get hash for tree
      test_profile_found = current_hash.key?(profile) # Is  elem in one_hash?
      if test_profile_found == false #  "key=profile NOT Found in hash"
        current_hash.merge!({profile => [relation]}) # include profile with new array in hash
        one_hash.merge!(tree => current_hash ) # наполнение хэша соответствиями найденных профилей и найденных отношений
      else  #  "Found in hash"
        value_array = current_hash.values_at(profile)
        value_array << relation
        value_array = value_array.flatten(1)
        current_hash.merge!(profile => value_array ) # наполнение хэша соответствиями найденных профилей и найденных отношений
        one_hash.merge!(tree => current_hash ) # наполнение хэша соответствиями найденных профилей и найденных отношений
      end
    end
    one_hash
  end


  # @note: Делаем ХЭШ профилей-отношений для искомого дерева. - пригодится.
  #   Tested
  # @param:
  # @return: ВСПОМОГАТЕЛЬНЫЙ РЕЗ-ТАТ ПОИСКА - СОСТАВ КРУГОВ ПРОФИЛЕЙ ИСКОМОГО ДЕРЕВА
  #   (массив ХЭШей ПАР ПРОФИЛЕЙ-ОТНОШЕНИЙ):
  #   [ {profile_searched: -> профиль искомый, profile_relations: -> все отношения к искомому профилю } ]
  # @see:
  def self.make_profile_relations(profile_id_searched, one_profile_relations, profiles_relations_arr)
    profile_relations_hash = Hash.new
    one_profile_relations_hash = { profile_searched: profile_id_searched, profile_relations: one_profile_relations}
    profile_relations_hash.merge!(one_profile_relations_hash)
    profiles_relations_arr << profile_relations_hash unless profile_relations_hash.empty? # Заполнение выходного массива хэшей
    profiles_relations_arr
  end



end
