class SearchCircles

  #############################################################
  # Иванищев А.В. 2015
  # @note: Методы работы с "кругами" - для ряда моделей и методов
  #############################################################


  # # @note: In SearchWork.check_add_hash
  # # To check add_connection_hash before its including into final_connection_hash
  # #   compare_profiles to check equ two profiles
  # #   get common_relations_hash - result of two_circles_compare
  # def self.compare_profiles(profile_searched, profile_found)
  #   common_relations_hash ={}
  #   # puts "In SearchCircles.compare_profiles: profile_searched = #{profile_searched}, profile_found = #{profile_found}"
  #   circles_arrs_data = find_circles_arrs(profile_searched, profile_found)
  #   compare_circles_data = {
  #     profile_searched:       profile_searched,
  #     profile_found:          profile_found,
  #     search_bk_arr:          circles_arrs_data[:search_bk_arr],
  #     search_bk_profiles_arr: circles_arrs_data[:search_bk_profiles_arr],
  #     search_is_profiles_arr: circles_arrs_data[:search_is_profiles_arr],
  #     found_bk_arr:           circles_arrs_data[:found_bk_arr],
  #     found_bk_profiles_arr:  circles_arrs_data[:found_bk_profiles_arr],
  #     found_is_profiles_arr:  circles_arrs_data[:found_is_profiles_arr],
  #     new_connection_hash:    common_relations_hash
  #   }
  #   common_relations_hash = two_circles_compare(compare_circles_data)
  #   # puts " for profile_searched = #{profile_searched} and profile_found = #{profile_found}:"
  #   # puts " common_relations_hash = #{common_relations_hash}"
  #   common_relations_hash
  # end


  # @note: Получение Кругов для пары профилей - для последующего сравнения и анализа
  #   ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH":  SearchCircles.compare_profiles
  def self.find_circles_arrs(profile_searched, profile_found)
    # search_bk_arr, search_bk_profiles_arr, search_is_profiles_arr = have_profile_circle(profile_searched)
    # found_bk_arr, found_bk_profiles_arr, found_is_profiles_arr = have_profile_circle(profile_found)
    # { search_bk_arr: search_bk_arr,
    #   search_bk_profiles_arr: search_bk_profiles_arr,
    #   search_is_profiles_arr: search_is_profiles_arr,
    #   found_bk_arr: found_bk_arr,
    #   found_bk_profiles_arr: found_bk_profiles_arr,
    #   found_is_profiles_arr: found_is_profiles_arr
    # }
    search_bk_profiles_arr, search_is_profiles_arr = have_profile_circle(profile_searched)
    found_bk_profiles_arr, found_is_profiles_arr = have_profile_circle(profile_found)
    { search_bk_profiles_arr: search_bk_profiles_arr,
      search_is_profiles_arr: search_is_profiles_arr,
      found_bk_profiles_arr: found_bk_profiles_arr,
      found_is_profiles_arr: found_is_profiles_arr }
  end

  # {:search_bk_profiles_arr=>[
  #     {"profile_id"=>815, "name_id"=>249, "relation_id"=>4, "is_name_id"=>82, "is_profile_id"=>807},
  #     {"profile_id"=>815, "name_id"=>249, "relation_id"=>7, "is_name_id"=>110, "is_profile_id"=>814},
  #     {"profile_id"=>815, "name_id"=>249, "relation_id"=>18, "is_name_id"=>343, "is_profile_id"=>806},
  #     {"profile_id"=>815, "name_id"=>249, "relation_id"=>122, "is_name_id"=>48, "is_profile_id"=>795},
  #     {"profile_id"=>815, "name_id"=>249, "relation_id"=>122, "is_name_id"=>331, "is_profile_id"=>808}],
  #  :search_is_profiles_arr=>[807, 814, 806, 795, 808],
  #     :found_bk_profiles_arr=>[
  #         {"profile_id"=>817, "name_id"=>370, "relation_id"=>1, "is_name_id"=>28, "is_profile_id"=>818},
  #         {"profile_id"=>817, "name_id"=>370, "relation_id"=>2, "is_name_id"=>48, "is_profile_id"=>819},
  #         {"profile_id"=>817, "name_id"=>370, "relation_id"=>4, "is_name_id"=>446, "is_profile_id"=>1006},
  #         {"profile_id"=>817, "name_id"=>370, "relation_id"=>5, "is_name_id"=>465, "is_profile_id"=>820},
  #         {"profile_id"=>817, "name_id"=>370, "relation_id"=>8, "is_name_id"=>147, "is_profile_id"=>1005},
  #         {"profile_id"=>817, "name_id"=>370, "relation_id"=>91, "is_name_id"=>122, "is_profile_id"=>821},
  #         {"profile_id"=>817, "name_id"=>370, "relation_id"=>92, "is_name_id"=>343, "is_profile_id"=>823},
  #         {"profile_id"=>817, "name_id"=>370, "relation_id"=>101, "is_name_id"=>82, "is_profile_id"=>822},
  #         {"profile_id"=>817, "name_id"=>370, "relation_id"=>102, "is_name_id"=>82, "is_profile_id"=>824},
  #         {"profile_id"=>817, "name_id"=>370, "relation_id"=>202, "is_name_id"=>331, "is_profile_id"=>1004}],
  #     :found_is_profiles_arr=>[818, 819, 1006, 820, 1005, 821, 823, 822, 824, 1004]}

  # @note: compare two circles & proceed compare result
  #  ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH":  SearchCircles.compare_profiles
  def self.two_circles_compare(compare_circles_data)
    found_bk_profiles_arr = compare_circles_data[:found_bk_profiles_arr]
    search_bk_profiles_arr = compare_circles_data[:search_bk_profiles_arr]
    new_connection_hash = get_fields_arr_from_circles(search_bk_profiles_arr, found_bk_profiles_arr )
    new_connection_hash
  end


  # @note: ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH"
  # Взять Бл.круг одного профиля
  # получить массивы триад для дальнейшего сравнения
  def self.have_profile_circle(profile_id)
    # circle_arr = []
    circle_profiles_arr = []
    circle_is_profiles_arr = []
    puts "In have_profile_circle: profile_id = #{profile_id}"
    profile = Profile.where(id: profile_id, deleted: 0)[0]
    unless profile.blank?
      # puts "Before get profile_circle: profile = #{profile} - NOT blank"
      profile_user_id = profile.tree_id
      # puts "before User.find: profile_user_id = #{profile_user_id}"
      user_of_tree = User.find(profile_user_id) #.connected_users
      unless user_of_tree.blank?
        connected_users_arr = user_of_tree.connected_users
        # puts "Before get profile_circle: user_of_tree.id = #{user_of_tree.id} - NOT blank, connected_users_arr = #{connected_users_arr}"
        profile_circle = profile.profile_circle(connected_users_arr)
        unless profile_circle.blank?
          circle_profiles_arr, circle_is_profiles_arr =
              make_arrays_from_circle(profile_circle)
          circle_is_profiles_arr = circle_is_profiles_arr.uniq
        end
      end
    end
    return circle_profiles_arr, circle_is_profiles_arr
  end


  # # @note: NO USE ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH" & Similars complete search
  # # NB: ЕСЛИ connected_user = ОБЪЕДИНЕННЫМ ДЕРЕВОМ ? - check действие order('user_id',??
  # # МЕТОД Получения БК для любого одного профиля из дерева
  # def self.get_one_profile_circle(profile_id, connected_users_arr)
  #   # connected_users_arr = User.find(user_id).connected_users  ##найти БК для найденного профиля .where('relation_id <= 8')
  #   # if connected_users_arr.blank?
  #   #   puts "Error in get_one_profile_BK: У Юзера не найден его connected_users_arr = #{connected_users_arr.inspect}"
  #   # else
  #     found_profile_circle = ProfileKey.where(user_id: connected_users_arr, profile_id: profile_id, deleted: 0)
  #                                      .order('user_id','relation_id','is_name_id' )
  #     #.select(:user_id, :name_id, :relation_id, :is_name_id).distinct
  #     if found_profile_circle.blank?
  #       puts "Error in get_one_profile_circle: No БК для Профиля = #{profile_id}, connected_users_arr = #{connected_users_arr}"
  #     else
  #       return found_profile_circle # Найден БК
  #     end
  #   # end
  # end


  # @note: ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH"
  # МЕТОД Получения массива Хэшей по аттрибутам для любого БК одного профиля из дерева
  # Аттрибуты здесь заданы жестко - путем исключения из ActiveRecord
  # ИСп-ся в Жестком поиске - в hard_search_match
  def self.make_arrays_from_circle(bk_rows)
    # bk_arr = []
    bk_arr_w_profiles = []
    is_profiles_arr = []
    bk_rows.each do |row|
      # bk_arr << row.attributes.except('id','user_id','profile_id','is_profile_id','created_at','updated_at')
      bk_arr_w_profiles << row.attributes.except('id','user_id','created_at','updated_at','deleted')
      is_profiles_arr << row.attributes.except('id','user_id','profile_id','name_id','relation_id','is_name_id','created_at','updated_at').values_at('is_profile_id')
    end
    is_profiles_arr = is_profiles_arr.flatten(1)
    # return bk_arr, bk_arr_w_profiles, is_profiles_arr
    return bk_arr_w_profiles, is_profiles_arr
  end


  # # @note: compare two circles & proceed compare result
  # def self.no_use_proceed_compare_circles(compare_circles_data)
  #   profile_searched = compare_circles_data[:profile_searched]
  #   profile_found = compare_circles_data[:profile_found]
  #   found_bk_arr = compare_circles_data[:found_bk_arr]
  #   search_bk_arr = compare_circles_data[:search_bk_arr]
  #   found_bk_profiles_arr = compare_circles_data[:found_bk_profiles_arr]
  #   search_bk_profiles_arr = compare_circles_data[:search_bk_profiles_arr]
  #   found_is_profiles_arr = compare_circles_data[:found_is_profiles_arr]
  #   search_is_profiles_arr = compare_circles_data[:search_is_profiles_arr]
  #   # new_connection_hash = compare_circles_data[:new_connection_hash]
  #
  #   # Сравнение двух Кругов пары профилей Если: НЕТ ДУБЛИКАТОВ В КАЖДОМ ИЗ КРУГОВ,
  #   puts " compare_two_circles: ИСКОМОГО ПРОФИЛЯ = #{profile_searched} и НАЙДЕННОГО ПРОФИЛЯ = #{profile_found}:"
  #   common_circle_arr = compare_two_circles(found_bk_arr, search_bk_arr)
  #   # common_circle_arr = circles_intersection(found_bk, search_bk)
  #
  #   # Анализ результата сравнения двух Кругов
  #   if common_circle_arr.blank?
  #     # @@@@@ NB !! Вставить проверку: Если Круги равны, И: НЕТ ДУБЛИКАТОВ В КАЖДОМ ИЗ КРУГОВ,
  #     # то формируем новый хэш из их профилей, КОТ-Е ТОЖЕ РАВНЫ
  #     search_is_profiles_arr.each_with_index do | is_profile, index |
  #       new_connection_hash.merge!(is_profile => found_is_profiles_arr[index])
  #     end
  #   else # Если есть какое-то ПЕРЕСЕЧЕНИЕ при сравнении 2-х Кругов
  #     # puts "To -> get_fields_arr_from_circles: search_bk_profiles_arr = #{search_bk_profiles_arr}:"
  #     # puts "To -> get_fields_arr_from_circles: found_bk_profiles_arr = #{found_bk_profiles_arr}:"
  #     new_connection_hash = get_fields_arr_from_circles(search_bk_profiles_arr, found_bk_profiles_arr )
  #   end
  #   # new_connection_hash = get_fields_arr_from_circles(search_bk_profiles_arr, found_bk_profiles_arr )
  #
  #   new_connection_hash
  # end


  # @note:
  def self.get_fields_arr_from_circles(bk_arr_searched, bk_arr_found)
    new_connection_hash = {}

    # unless bk_arr_searched.blank?
    bk_arr_searched.each do |one_searched_row|
      profile_data_s = {
          name_id_s: one_searched_row.values_at('name_id'),
          profile_id_s: one_searched_row.values_at('profile_id'),
          relation_id_s: one_searched_row.values_at('relation_id'),
          is_name_id_s: one_searched_row.values_at('is_name_id'),
          is_profile_id_s: one_searched_row.values_at('is_profile_id')
      }

      collect_data = { new_connection_hash: new_connection_hash, one_profile: profile_data_s[:is_profile_id_s][0] }
      # puts "In get_fields_arr_from_circles: collect_data = #{collect_data}"
      new_connection_hash = bk_found_cycle(bk_arr_found, profile_data_s, collect_data)

      # end
    end
    new_connection_hash
  end


  # @note: check & find the SAME profiles found
  def self.bk_found_cycle(bk_arr_found, profile_data_s, collect_data)
    new_connection_hash = collect_data[:new_connection_hash]

    bk_arr_found.each do |one_found_row|
      profile_data_f = {
          name_id_f: one_found_row.values_at('name_id'),
          profile_id_f: one_found_row.values_at('profile_id'),
          relation_id_f: one_found_row.values_at('relation_id'),
          is_name_id_f: one_found_row.values_at('is_name_id'),
          is_profile_id_f: one_found_row.values_at('is_profile_id')
      }
      collect_data[:to_profile] = profile_data_f[:is_profile_id_f][0]
      new_connection_hash = find_profiles_connect(profile_data_s, profile_data_f, collect_data)
    end
    new_connection_hash
  end


  # @note: check & find the SAME profiles found
  def self.find_profiles_connect(profile_data_s, profile_data_f, collect_data)
    # puts "In f_pr_conn: profile_data_s = #{profile_data_s}"
    # puts "In f_pr_conn: profile_data_f = #{profile_data_f}"
    # puts ""
    name_id_s = profile_data_s[:name_id_s]
    profile_id_s = profile_data_s[:profile_id_s]
    relation_id_s = profile_data_s[:relation_id_s]
    is_name_id_s = profile_data_s[:is_name_id_s]
    is_profile_id_s = profile_data_s[:is_profile_id_s]

    name_id_f = profile_data_f[:name_id_f]
    profile_id_f = profile_data_f[:profile_id_f]
    relation_id_f = profile_data_f[:relation_id_f]
    is_profile_id_f = profile_data_f[:is_profile_id_f]
    is_name_id_f = profile_data_f[:is_name_id_f]

    new_connection_hash = collect_data[:new_connection_hash]
    one_profile = collect_data[:one_profile]
    to_profile = collect_data[:to_profile]

    if name_id_s == name_id_f && relation_id_s == relation_id_f && is_name_id_s == is_name_id_f
      if is_profile_id_s != is_profile_id_f
        if (profile_id_s != is_profile_id_f) && (profile_id_f != is_profile_id_s)# Одинаковые профили не заносим в хэш объединения (они и так одинаковые)
          # make new el-t of new_connection_hash
          new_connection_hash.merge!({one_profile => to_profile})
          # puts "In find_profiles_connect: $ new_connection_hash = #{new_connection_hash} "
        end
      end
    end

    new_connection_hash
  end


  # @note: ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH"
  # Метод сравнения 2-х БК профилей
  # этот метод требует развития - что делать, когда два БК не равны?
  # Означает ли это, что надо давать сразу отрицат-й ответ?.
  # На входе - два массива Хэшей = 2 БК
  # На выходе: compare_rezult = false or true.
  def self.compare_two_circles(found_bk, search_bk)
    # puts " compare_two_circles: found_bk = #{found_bk}:"
    # puts " compare_two_circles: search_bk = #{search_bk}:"

    common_circle_arr = []
    if found_bk.blank?
      puts "Error in compare_two_BK. Нет БК для Профиля: found_bk = #{found_bk}"
    else
      if search_bk.blank?
        puts "Error in compare_two_BK. Нет БК для Профиля: search_bk = #{search_bk}"
      else
        # delta = []
        # common_circle_arr, compare_equal_rezult, delta = get_compare_results(found_bk, search_bk)
        common_circle_arr = get_compare_results(found_bk, search_bk)
      end
    end

    puts " ПЕРЕСЕЧЕНИЕ двух Кругов: common_circle_arr = #{common_circle_arr}"
    return common_circle_arr #, compare_equal_rezult, delta
  end


  # @note: comparing of two circles
  #   check - equal sizes
  def self.equal_circles_size?(found_bk, search_bk)
    found_bk.size == search_bk.size
  end

  # @note: comparing of two circles
  #   check - delta == empty
  def self.empty_circles_delta?(found_bk, search_bk)
    distinct1 = found_bk - search_bk
    distinct2 = search_bk - found_bk
    (distinct1 == []) && (distinct2 == [])
    # (found_bk - search_bk) == []
  end

  # @note: form result of comparing of two circles
  def self.get_compare_results(found_bk, search_bk)
    # puts "## in get_compare_results: СРАВНЕНИЕ ДВУХ БК: По Size и По содержанию (разность)"

    if equal_circles_size?(found_bk, search_bk) && empty_circles_delta?(found_bk, search_bk)
      common_circle_arr = []
      # puts "# 1. circles Size = EQUAL и Содержание - ОДИНАКОВОЕ. (Разность 2-х БК = []) common_circle_arr = #{common_circle_arr}"
    else
      common_circle_arr = circles_intersection(found_bk, search_bk)
      # puts "# 2.a. circles Sizes = EQUAL, но Содержание - РАЗНОЕ. (ПЕРЕСЕЧЕНИЕ 2-х БК - НЕ != []) common_circle_arr = #{common_circle_arr}"
      # puts "OR "
      # puts "# 2.b. circles Sizes = UNEQUAL и Содержание - РАЗНОЕ. (ПЕРЕСЕЧЕНИЕ 2-х circles - НЕ != [])"
    end

    return common_circle_arr
  end

  # @note: Пересечение двух кругов
  #   ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH"
  # Метод получения общей части 2-х БК профилей
  def self.circles_intersection(found_bk, search_bk)
    found_bk & search_bk # ПЕРЕСЕЧЕНИЕ 2-х БК
  end


  # @note: New & last ver of profiles compare - based on exclusions of relations - ONLY
  def self.compare_profiles_exclusions(profile_searched, profile_found)
    puts "\n In compare_profiles_exclusions"
    search_filled_hash = filled_hash(profile_searched)
    puts "profile_searched = #{profile_searched}, profile_found = #{profile_found}"
    # puts "search_filled_hash = #{search_filled_hash}"
    found_filled_hash = filled_hash(profile_found)
    # puts "found_filled_hash = #{found_filled_hash}"
    equality, match_count = check_exclusions(search_filled_hash, found_filled_hash) unless found_filled_hash.empty?

    equality#, match_count
  end


  # @note: collect filling hashes for search and found profiles
  # @input: profile_id
  # @output: filled_hash = {1=>[122], 2=>[82], 3=>[370, 465], 8=>[48], 15=>[343], 16=>[82]}
  #  { relation => [name] }
  def self.filled_hash(profile_id)
    rel_name_arr = rel_name_profile_records(profile_id)
    # filled_hash =
    relations_with_names(rel_name_arr)
    # logger.info "filled_hash = #{filled_hash}"
    # filled_hash
  end


  # @note: collect hash of two fields records: relations (key) and names array (value)
  # for searching profile
  # todo: place this method in ProfileKey model
  def self.rel_name_profile_records(profile_id)
    # logger.info "In rel_name_profile_records: profile_id = #{profile_id}"
    ProfileKey.where(:profile_id => profile_id, deleted: 0)
        .order('relation_id','is_name_id')
        .select( :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id)
        .distinct
        .pluck(:relation_id, :is_name_id)
  end


  # @note: collect hash of keys and items array as hash value
  # from input array of arrays=pairs: [[key, item] .. [ , ]]
  # trees with found profile in it: {57=>[795], 59=>[819], 60=>[827]}   OR
  # relation with name (names array): {3=>[370, 465], ... 17=>[147], 121=>[446]}
  def self.relations_with_names(key_item_pairs_arr)
    trees_profiles = {}
    key_item_pairs_arr.each do |one_array|
      SearchWork.fill_hash_w_val_arr(trees_profiles, one_array[0], one_array[1])
    end
    trees_profiles
  end

  # @note: main check of exclusions - special algorythm
  # @input: For profile_searched = 13 and profile_found = 23:
  #   search_filled_hash = {1=>[110], 2=>[249], 4=>[48, 331], 7=>[343], 13=>[194], 14=>[48], 18=>[28], 112=>[370, 465]}
  #   found_filled_hash = {1=>[194], 2=>[48], 4=>[48, 331], 8=>[82], 15=>[110], 16=>[249]}
  #   EXCLUSION_RELATIONS = WeafamSetting.first.exclusion_relations = [1,2,3,4,5,6,7,8,91,101,111,121,92,102,112,122]
  # @output:
  #   equality = [true, false] - main result: two profiles are equal or not
  #   priznak = [true, false]
  #   match_count = integer - has value > 0 until exclusions passed
  def self.check_exclusions(search_filled_hash, found_filled_hash)

    check_data = {}
    check_data[:equality] = false
    check_data[:match_count] = 0
    search_filled_hash.each do |relation, names|
      # puts "In each: - relation = #{relation}"
      sval = search_filled_hash[relation]
      fval = found_filled_hash[relation]
      check_data[:sval] = sval
      check_data[:fval] = fval
      if found_filled_hash.has_key?(relation)
        check_data[:relation] = relation
        current_equality, current_match_count = set_equality(check_data)
        # puts "current check_exclusions: current_equality = #{current_equality}, current_match_count = #{current_match_count}"
        return current_equality, current_match_count unless current_equality
        check_data[:equality]    = current_equality
        check_data[:match_count] = current_match_count
      end

    end
    puts "After all check_exclusions: :equality = #{check_data[:equality]}, :match_count = #{check_data[:match_count]}"
    return check_data[:equality], check_data[:match_count]
  end


  # @note: check data and set equality priznak. At the same time - count match_count
  def self.set_equality(check_data)
    sval        = check_data[:sval]
    fval        = check_data[:fval]
    relation    = check_data[:relation]
    equality    = check_data[:equality]
    match_count = check_data[:match_count]

    if EXCLUSION_RELATIONS.include?(relation) # is IN exclusions list
      if sval == fval         # completely equal names arrays for one relation
        match_count += sval.size
        equality = true
      elsif sval & fval != [] # names arrays for one relation has intersection
        match_count += (sval & fval).size
        equality = true
      else                    # unequal names arrays for one relation
        equality = false
        # puts "In All checks failed: - equality = #{equality}, match_count = #{match_count}"
        return equality, match_count
      end
    else # out of Exclusions relations list
      if sval == fval # completely equal names arrays
        match_count += sval.size
      else sval & fval != []
        match_count += (sval & fval).size
      end
    end

    return equality, match_count
  end





  # # @note: ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH"
  # # Метод получения НЕ общей части 2-х БК профилей
  # def self.get_circles_delta(first_bk, second_bk, common_circle_arr)
  #   (first_bk - common_circle_arr) + (second_bk - common_circle_arr)
  # end
  #




  # def sequest_doubles(hash)
  #
  #   hash.each do |profiles_s, profile_f|
  #     new_connection_hash.delete_if { |k_conn,v_conn| k_conn == profiles_s && v_conn == profile_f }
  #   end
  #
  #
  #   new_hash
  # end


end
