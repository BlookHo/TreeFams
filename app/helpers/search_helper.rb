module SearchHelper

  # todo: разобрать методы из этого Helper: оставить - для View для нескольких моделей

  ############################# NEW METHODS ############

  # # todo: перенести этот метод в Operational - для нескольких моделей
  # # "EXCLUDE Many_to_One DUPLICATES"
  # # Extract duplicates hashes from input hash
  # def duplicates_out(start_hash)
  #   # Initaialize empty hash
  #   duplicates_Many_to_One = {}
  #   uniqs = start_hash
  #
  #   # Collect duplicates
  #   start_hash.each_with_index do |(k, v), index|
  #     start_hash.each do |key, value|
  #       next if k == key
  #       # logger.info "=========== SEARCH DEBUG ========"
  #       # logger.info "=========== KEY"
  #       # logger.info key
  #       # logger.info start_hash[key]
  #       # logger.info "=========== K"
  #       # logger.info k
  #       # logger.info start_hash[k]
  #       # logger.info "=========== END SEARCH DEBUG ========"
  #       intersection = start_hash[key] & start_hash[k]
  #       if duplicates_Many_to_One.has_key?(key)
  #         duplicates_Many_to_One[key][intersection.keys.first] = intersection[intersection.keys.first] if !intersection.empty?
  #       else
  #         duplicates_Many_to_One[key] = intersection if !intersection.empty?
  #       end
  #     end
  #   end
  #
  #   # Collect uniqs
  #   duplicates_Many_to_One.each do |key, value|
  #     value.each do |k, v|
  #       uniqs[key].delete_if { |kk,vv|  kk == k && vv = v }
  #     end
  #   end
  #   logger.info "** In  duplicates_out: duplicates_Many_to_One = #{duplicates_Many_to_One}"
  #
  #    return uniqs, duplicates_Many_to_One
  # end



  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "SEARCH.rb"
  # ИЗЪЯТИЕ ПРОФИЛЕЙ С МАЛОЙ МОЩНОСТЬЮ НАЙДЕННЫХ ОТНОШЕНИЙ
  def reduce_profile_relations(profile_relations_hash, certainty_koeff)      ###################
    reduced_profile_relations_hash = profile_relations_hash.select {|k,v| v.size >= certainty_koeff }
    logger.info " reduced_profile_relations_hash = #{reduced_profile_relations_hash} "
    ###############
    return reduced_profile_relations_hash
  end

  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "SEARCH.rb"
  # ПРЕВРАЩЕНИЕ ХЭША ПРОФИЛЕЙ С НАЙДЕННЫМИ ОТНОШЕНИЯМИ В ХЭШ ПРОФИЛЕЙ С МОЩНОСТЯМИ ОТНОШЕНИЙ
  def make_profiles_power_hash(reduced_profile_relations_hash)
    profiles_powers_hash = {}
    reduced_profile_relations_hash.each { |k, v_arr | profiles_powers_hash.merge!( k => v_arr.size) }
    logger.info " profiles_powers_hash = #{profiles_powers_hash} "
    profiles_powers_hash
  end

  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "SEARCH.rb"
  # ПРЕВРАЩЕНИЕ ХЭША ПРОФИЛЕЙ С МОЩНОСТЯМИ ОТНОШЕНИЙ В ХЭШ ПРОФИЛЯ(ЕЙ) С МАКСИМАЛЬНОЙ(МИ) МОЩНОСТЬЮ
  def get_max_power_profiles_hash(profiles_powers_hash)
    max_power = profiles_powers_hash.values.max # определение значения макс-й мощности
    max_profiles_powers_hash = profiles_powers_hash.select { |k, v| v == max_power} # выбор эл-тов хэша с макс-й мощностью
    logger.info " max profiles_powers_hash = #{max_profiles_powers_hash} "
    return max_profiles_powers_hash, max_power
  end

  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "SEARCH.rb"
  # Получение хэша профилей с максимальными значениями совпадений
  def get_profiles_match_hash(profiles_with_match_hash, max_profiles_powers_hash)
    new_profiles_with_match_hash = profiles_with_match_hash
    profiles_arr = new_profiles_with_match_hash.keys
    if max_profiles_powers_hash.size == 1
      one_profile = max_profiles_powers_hash.keys[0]
      one_match = max_profiles_powers_hash.values_at(one_profile)[0]
      logger.info " IN get_profiles_match_hash:: new_profiles_with_match_hash = #{new_profiles_with_match_hash}, profiles_arr = #{profiles_arr}, one_profile = #{one_profile}, one_match = #{one_match},  "
      if profiles_arr.include?(one_profile)
        match_in_hash = new_profiles_with_match_hash.values_at(one_profile)[0]
        if one_match > match_in_hash
          new_profiles_with_match_hash = profiles_with_match_hash.merge!(max_profiles_powers_hash ) if !max_profiles_powers_hash.empty?
        end
      else
        new_profiles_with_match_hash = profiles_with_match_hash.merge!(max_profiles_powers_hash ) if !max_profiles_powers_hash.empty?
      end
    else
      logger.info "ERROR IN get_profiles_match_hash profiles_arr: max_profiles_powers_hash.size != 1 "
    end
    new_profiles_with_match_hash
  end

  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "SEARCH.rb"
  # ПОЛУЧЕНИЕ ПАР СООТВЕТСТВИЙ ПРОФИЛЕЙ С МАКС. МОЩНОСТЬЮ МНОЖЕСТВ СОВПАДЕНИЙ ОТНОШЕНИЙ
  # Вход
  # Выход
  def get_certain_profiles_pairs(profiles_found_arr, certainty_koeff)
    logger.info ""
    logger.info "=== IN get_certain_profiles_pairs "
    logger.info " profiles_found_arr = #{profiles_found_arr} "
    max_power_profiles_pairs_hash = {}  # Профили с макс-м кол-вом совпадений для одного соответствия в дереве
    profiles_with_match_hash = {} # Порофили, отсортир-е по кол-ву совпадений
    new_profiles_with_match_hash = {}
    duplicates_pairs_one_to_many = {}  # Дубликаты ТИПА 1 К 2 - One_to_Many пар профилей
    profiles_found_arr.each do |hash_in_arr|
      #logger.info " hash_in_arr = #{hash_in_arr} "
      hash_in_arr.each do |searched_profile, profile_trees_relations|
        #logger.info " searched_profile = #{searched_profile} "
        max_power_pairs_hash = {}
        duplicates_one_to_many_hash = {}
        profile_trees_relations.each do |key_tree, profile_relations_hash|
          logger.info " profile_relations_hash = #{profile_relations_hash} "
          reduced_profile_relations_hash = reduce_profile_relations(profile_relations_hash, certainty_koeff)
          unless reduced_profile_relations_hash.empty?
            profiles_powers_hash = make_profiles_power_hash(reduced_profile_relations_hash)
            max_profiles_powers_hash, max_power = get_max_power_profiles_hash(profiles_powers_hash)
            # Выявление дубликатов ТИПА 1 К 2 - One_to_Many
            if max_profiles_powers_hash.size == 1 # один профиль с максимальной мощностью
              # НАРАЩИВАНИЕ ХЭША ДОСТОВЕРНЫХ ПАР ПРОФИЛЕЙ certain_max_power_pairs_hash
              profile_selected = max_profiles_powers_hash.key(max_power)
              max_power_pairs_hash.merge!(key_tree => profile_selected )
              new_profiles_with_match_hash = get_profiles_match_hash(profiles_with_match_hash, max_profiles_powers_hash)
            else # больше одного профиля с максимальной мощностью
              # НАРАЩИВАНИЕ ХЭША ПРОФИЛЕЙ-ДУПЛИКАТОВ duplicates_one_to_many_hash
              # ЕСЛИ НАЙДЕНО БОЛЬШЕ 1 ПАРЫ ПРОФИЛЕЙ С ОДИНАК. МАКС. МОЩНОСТЬЮ
              # Т.Е. ДУПЛИКАТ ТИПА 1 К 2 - One_to_Many, => ЗАНОСИМ В ХЭШ ДУПЛИКАТОВ.
              duplicates_one_to_many_hash.merge!(key_tree => max_profiles_powers_hash )
            end

          end

        end

        new_profiles_with_match_hash = Hash[new_profiles_with_match_hash.sort_by { |k, v| v }.reverse] #  Ok Sorting of input hash by values Descend

        max_power_profiles_pairs_hash.merge!(searched_profile => max_power_pairs_hash ) if !max_power_pairs_hash.empty?

        duplicates_pairs_one_to_many.merge!(searched_profile => duplicates_one_to_many_hash ) if !duplicates_one_to_many_hash.empty?

      end

    end
    return max_power_profiles_pairs_hash, duplicates_pairs_one_to_many, new_profiles_with_match_hash

  end # End of method


  # # todo: перенести этот метод в Operational - для нескольких моделей
  # # ИСПОЛЬЗУЕТСЯ В NEW METHOD complete_search
  # # Наращивание (пополнение) Хэша1 новыми значениями из другого Хэша2
  # #conn_hash = {72=>58, 75=>59, 76=>61, 77=>60, 78=>57}
  # #new_conn_hash = {72=>58, 75=>59, 76=>61, 77=>60, 79=>62}
  # # hash_1 -does not change
  # # 79=>62 - найти те эл-ты in hash_2, кот-е отс-ют в hash_1
  # # add 79=>62 to hash_1
  # # Result: {72=>58, 75=>59, 76=>61, 77=>60, 78=>57, 79=>62} /
  # def add_to_hash(hash_1,hash_2)
  #   arr_key1 = hash_1.keys
  #   hash_2.each do |k,v|
  #     hash_1 = hash_1.merge!( k => v) if !arr_key1.include?(k)
  #   end
  # end


  # todo: перенести этот метод в CirclesMethods - для нескольких моделей
  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # Метод получения НЕ общей части 2-х БК профилей
  def get_circles_delta(first_bk, second_bk, common_circle_arr)
    one = (first_bk - common_circle_arr)
    two = (second_bk - common_circle_arr)
    logger.info " get_delta_bk: one = #{one}, two = #{two}"
    # circles_delta = (first_bk - common_circle_arr) + (second_bk - common_circle_arr)
    (first_bk - common_circle_arr) + (second_bk - common_circle_arr)
  end

  # todo: перенести этот метод в CirclesMethods - для нескольких моделей
  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # Взять Бл.круг одного профиля
  # получить массивы триад для дальнейшего сравнения
  # показать в Логгере
  def have_profile_circle(profile_id) # , deleted: 0
    # profile_user_id = Profile.find(profile_id).tree_id
    profile_user_id = Profile.where(id: profile_id, deleted: 0)[0].tree_id
    profile_circle = get_one_profile_circle(profile_id, profile_user_id)
    logger.info "=== КРУГ ПРОФИЛЯ = #{profile_id} "
    show_in_logger(profile_circle, "= ряд " )  # DEBUGG_TO_LOGG
    #circle_arr, circle_profiles_arr, circle_is_profiles_arr, circle_relations_arr =
    circle_arr, circle_profiles_arr, circle_is_profiles_arr =
        make_arrays_from_circle(profile_circle)
    circle_is_profiles_arr = circle_is_profiles_arr.uniq
    return circle_arr, circle_profiles_arr, circle_is_profiles_arr #, circle_relations_arr
  end

  # todo: перенести этот метод в CirclesMethods - для нескольких моделей
  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # NB !! ЕСЛИ connected_user = ОБЪЕДИНЕННЫМ ДЕРЕВОМ ? - проверить действие order('user_id',??
  # МЕТОД Получения БК для любого одного профиля из дерева
  # ИСп-ся в Жестком поиске - в hard_search_match
  def get_one_profile_circle(profile_id, user_id)
    connected_users_arr = User.find(user_id).get_connected_users  ##найти БК для найденного профиля .where('relation_id <= 8')
    if !connected_users_arr.blank?
      found_profile_circle = ProfileKey.where(user_id: connected_users_arr, profile_id: profile_id, deleted: 0)
                                 .order('user_id','relation_id','is_name_id' )
                                  #.select(:user_id, :name_id, :relation_id, :is_name_id).distinct
      if !found_profile_circle.blank?
        return found_profile_circle # Найден БК
      else
        logger.info "Error in get_one_profile_BK. Не найден БК для Профиля = #{profile_id} у такого Юзера = #{user_id}"
      end
    else
      logger.info "Error in get_one_profile_BK. Нет такого Юзера = #{user_id} или не найдены его connected_users_arr = #{connected_users_arr.inspect}"
    end
  end

  # todo: перенести этот метод в CirclesMethods - для нескольких моделей
  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # МЕТОД Получения массива Хэшей по аттрибутам для любого БК одного профиля из дерева
  # Аттрибуты здесь заданы жестко - путем исключения из ActiveRecord
  # ИСп-ся в Жестком поиске - в hard_search_match
  def make_arrays_from_circle(bk_rows)
    bk_arr = []
    bk_arr_w_profiles = []
    is_profiles_arr = []
    relations_arr = []
    bk_rows.each do |row|
      bk_arr << row.attributes.except('id','user_id','profile_id','is_profile_id','created_at','updated_at')
      bk_arr_w_profiles << row.attributes.except('id','user_id','created_at','updated_at') # for further analyze
      is_profiles_arr << row.attributes.except('id','user_id','profile_id','name_id','relation_id','is_name_id','created_at','updated_at').values_at('is_profile_id') # for further analyze
      #relations_arr << row.attributes.except('id','user_id','profile_id','name_id','is_profile_id','is_name_id','created_at','updated_at').values_at('relation_id') # for further analyze
    end
    is_profiles_arr = is_profiles_arr.flatten(1)
    #relations_arr = relations_arr.flatten(1)
    logger.debug "bk_arr_w_profiles  = #{bk_arr_w_profiles}"
    #logger.debug "relations_arr  = #{relations_arr}"
    return bk_arr, bk_arr_w_profiles, is_profiles_arr #, relations_arr # Сделан БК в виде массива Хэшей
  end


  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # todo: перенести этот метод в CirclesMethods - для нескольких моделей
  # Метод сравнения 2-х БК профилей
  # этот метод требует развития - что делать, когда два БК не равны?
  # Означает ли это, что надо давать сразу отрицат-й ответ?.
  # На входе - два массива Хэшей = 2 БК
  # На выходе: compare_rezult = false or true.
  def  compare_two_circles(found_bk_arr, search_bk_arr)

    if !found_bk_arr.blank?
      if !search_bk_arr.blank?
        delta = []
        logger.info "in compare_two_circles: СРАВНЕНИЕ ДВУХ БК: По Size и По содержанию (разность)"
        if found_bk_arr.size.inspect == search_bk_arr.size.inspect
          common_circle_arr = found_bk_arr - search_bk_arr
          if common_circle_arr == []
            compare_rezult = true
            logger.info " circles Size = EQUAL и Содержание - ОДИНАКОВОЕ. (Разность 2-х БК = []) common_circle_arr = #{common_circle_arr}"
          else
            common_circle_arr = found_bk_arr & search_bk_arr # ПЕРЕСЕЧЕНИЕ 2-х БК
            compare_rezult = false
            logger.info "circles Sizes = EQUAL, но Содержание - РАЗНОЕ. (ПЕРЕСЕЧЕНИЕ 2-х БК - НЕ != []) common_circle_arr = #{common_circle_arr}"
            delta = get_circles_delta(found_bk_arr, search_bk_arr, common_circle_arr)
          end

        else
          common_circle_arr = found_bk_arr & search_bk_arr # ПЕРЕСЕЧЕНИЕ 2-х БК
          compare_rezult = false
          logger.info "BKs - SIZE = UNEQUAL и Содержание - РАЗНОЕ. (ПЕРЕСЕЧЕНИЕ 2-х circles - НЕ != [])"
          delta = get_circles_delta(found_bk_arr, search_bk_arr, common_circle_arr)
        end

      else
        logger.info "Error in compare_two_BK. Нет БК для Профиля: search_bk_arr = #{search_bk_arr}"
      end
    else
      logger.info "Error in compare_two_BK. Нет БК для Профиля: found_bk_arr = #{found_bk_arr}"
    end

    return compare_rezult, common_circle_arr, delta
  end

  # TEST COMPARE 2 BK
  # bk_arr1  = [{"name_id"=>125, "relation_id"=>1, "is_name_id"=>123},
  #            {"name_id"=>125, "relation_id"=>2, "is_name_id"=>98},
  #            {"name_id"=>125, "relation_id"=>5, "is_name_id"=>123},  # -
  #            {"name_id"=>125, "relation_id"=>5, "is_name_id"=>130}]
  #
  #bk_arr2  = [{"name_id"=>125, "relation_id"=>1, "is_name_id"=>123},
  #            {"name_id"=>125, "relation_id"=>2, "is_name_id"=>98},
  #          #  {"name_id"=>125, "relation_id"=>5, "is_name_id"=>123},
  #            {"name_id"=>125, "relation_id"=>5, "is_name_id"=>130},
  #            {"name_id"=>125, "relation_id"=>8, "is_name_id"=>48}]
  #
  #compare_rezult12, rez_bk_arr12 = compare_two_BK(bk_arr1, bk_arr2)
  #logger.info " compare_rezult = #{compare_rezult12}"
  #logger.info " ПЕРЕСЕЧЕНИЕ двух БК: rez_bk_arr12 = #{rez_bk_arr12}"
  #rez_bk_arr = [{"name_id"=>125, "relation_id"=>1, "is_name_id"=>123},
  #              {"name_id"=>125, "relation_id"=>2, "is_name_id"=>98},
  #              {"name_id"=>125, "relation_id"=>5, "is_name_id"=>123},
  #              {"name_id"=>125, "relation_id"=>5, "is_name_id"=>130}]
  #
  #rez_bk_arr12 = [{"name_id"=>125, "relation_id"=>1, "is_name_id"=>123},
  #                {"name_id"=>125, "relation_id"=>2, "is_name_id"=>98},
  #                {"name_id"=>125, "relation_id"=>5, "is_name_id"=>130}]
  #

  # todo: перенести этот метод в CirclesMethods - для нескольких моделей
  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # метод получения массива значений одного поля = key в массиве хэшей
  # без необходимости предварительной сортировки, кот-я может исказить рез-т/
  # На входе:         bk_arr_w_profiles  = [
  #    {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>28, "is_name_id"=>123},
  #    {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>29, "is_name_id"=>125},
  #    .... ]
  # На выходе: field_arr = [28, 29, 30, 24]
  def get_fields_arr_from_circles(bk_arr_searched, bk_arr_found)
    logger.info "search_bk_profiles_arr = #{bk_arr_searched} "
    logger.info "found_bk_profiles_arr = #{bk_arr_found}     "
    new_connection_hash = {}

    # unless bk_arr_searched.blank?
    bk_arr_searched.each do |one_searched_row|
      #logger.info "one_searched_row = #{one_searched_row} "
      name_id_s = one_searched_row.values_at('name_id')
      profile_id_s = one_searched_row.values_at('profile_id')
      relation_id_s = one_searched_row.values_at('relation_id')
      is_name_id_s = one_searched_row.values_at('is_name_id')
      is_profile_id_s = one_searched_row.values_at('is_profile_id')
      bk_arr_found.each do |one_found_row|
        logger.info "one_found_row = #{one_found_row} of new_connection_hash"
        name_id_f = one_found_row.values_at('name_id')
        profile_id_f = one_found_row.values_at('profile_id')
        relation_id_f = one_found_row.values_at('relation_id')
        is_name_id_f = one_found_row.values_at('is_name_id')
        is_profile_id_f = one_found_row.values_at('is_profile_id')

        if name_id_s == name_id_f && relation_id_s == relation_id_f && is_name_id_s == is_name_id_f
          if is_profile_id_s != is_profile_id_f
            if (profile_id_s != is_profile_id_f) && (profile_id_f != is_profile_id_s)# Одинаковые профили не заносим в хэш объединения (они и так одинаковые)
          # make new el-t of new_connection_hash
           new_connection_hash.merge!({one_searched_row.values_at('is_profile_id')[0] => one_found_row.values_at('is_profile_id')[0]})
            end
          end
        end

      end

    # end
    end
    return new_connection_hash
  end


  # Служебный метод для отладки - для LOGGER
  # todo: перенести этот метод в Operational - для нескольких моделей
  # Показывает массив в logger
  def show_in_logger(arr_to_log, string_to_add)
    row_no = 0  # DEBUGG_TO_LOGG
    arr_to_log.each do |row| # DEBUGG_TO_LOGG
      row_no += 1
      logger.debug "#{string_to_add} № #{row_no.inspect}: #{row.attributes.inspect} " # DEBUGG_TO_LOGG
    end  # DEBUGG_TO_LOGG
  end




end
