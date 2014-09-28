module SearchHelper

  ############################# NEW METHODS ############

  # "EXCLUDE Many_to_One DUPLICATES"
  # Extract duplicates hashes from input hash
  def duplicates_out(start_hash)
    # Initaialize empty hash
    duplicates_Many_to_One = {}
    uniqs = start_hash

    # Collect duplicates
    start_hash.each_with_index do |(k, v), index|
      start_hash.each do |key, value|
        next if k == key
        intersection = start_hash[key] & start_hash[k]
        if duplicates_Many_to_One.has_key?(key)
          duplicates_Many_to_One[key][intersection.keys.first] = intersection[intersection.keys.first] if !intersection.empty?
        else
          duplicates_Many_to_One[key] = intersection if !intersection.empty?
        end
      end
    end

    # Collect uniqs
    duplicates_Many_to_One.each do |key, value|
      value.each do |k, v|
        uniqs[key].delete_if { |kk,vv|  kk == k && vv = v }
      end
    end
    logger.info "** In  duplicates_out: duplicates_Many_to_One = #{duplicates_Many_to_One}"

     return uniqs, duplicates_Many_to_One
  end



  # СБОР ВСЕХ НАЙДЕННЫХ ПРОФИЛЕЙ ПО ДЕРЕВЬЯМ
  def collect_trees_profiles(start_hash)

    results = {}
    start_hash.each do |key, value|
      value.each do |k, v|
        if results.has_key? k
          results[k].push v
        else
          results[k] = [v]
        end
      end
    end
    return results

  end


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
    return profiles_powers_hash
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
    return new_profiles_with_match_hash
  end

  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "SEARCH.rb"
  # ПОЛУЧЕНИЕ ПАР СООТВЕТСТВИЙ ПРОФИЛЕЙ С МАКС. МОЩНОСТЬЮ МНОЖЕСТВ СОВПАДЕНИЙ ОТНОШЕНИЙ
  # Вход
  # Выход
  # .
  def get_certain_profiles_pairs(profiles_found_arr, certainty_koeff)
    logger.info " profiles_found_arr = #{profiles_found_arr} "
    max_power_profiles_pairs_hash = {}  # Профили с макс-м кол-вом совпадений для одного соответствия в дереве
    profiles_with_match_hash = {} # Порофили, отсортир-е по кол-ву совпадений
    new_profiles_with_match_hash = {}
    duplicates_pairs_One_to_Many_hash = {}  # Дубликаты ТИПА 1 К 2 - One_to_Many пар профилей
    profiles_found_arr.each do |hash_in_arr|
      #logger.info " hash_in_arr = #{hash_in_arr} "
      hash_in_arr.each do |searched_profile, profile_trees_relations|
        #logger.info " searched_profile = #{searched_profile} "
        max_power_pairs_hash = {}
        # new_profiles_with_match_hash = {}
        duplicates_One_to_Many_hash = {}
        profile_trees_relations.each do |key_tree, profile_relations_hash|
          logger.info " profile_relations_hash = #{profile_relations_hash} "
          reduced_profile_relations_hash = reduce_profile_relations(profile_relations_hash, certainty_koeff)
          if !reduced_profile_relations_hash.empty?
            profiles_powers_hash = make_profiles_power_hash(reduced_profile_relations_hash)
            max_profiles_powers_hash, max_power = get_max_power_profiles_hash(profiles_powers_hash)
            # Выявление дубликатов ТИПА 1 К 2 - One_to_Many
            if max_profiles_powers_hash.size == 1 # один профиль с максимальной мощностью
              # НАРАЩИВАНИЕ ХЭША ДОСТОВЕРНЫХ ПАР ПРОФИЛЕЙ certain_max_power_pairs_hash
              profile_selected = max_profiles_powers_hash.key(max_power)
              max_power_pairs_hash.merge!(key_tree => profile_selected )
              new_profiles_with_match_hash = get_profiles_match_hash(profiles_with_match_hash, max_profiles_powers_hash)
            else # больше одного профиля с максимальной мощностью
              # НАРАЩИВАНИЕ ХЭША ПРОФИЛЕЙ-ДУПЛИКАТОВ duplicates_One_to_Many_hash
              # ЕСЛИ НАЙДЕНО БОЛЬШЕ 1 ПАРЫ ПРОФИЛЕЙ С ОДИНАК. МАКС. МОЩНОСТЬЮ
              # Т.Е. ДУПЛИКАТ ТИПА 1 К 2 - One_to_Many, => ЗАНОСИМ В ХЭШ ДУПЛИКАТОВ.
              duplicates_One_to_Many_hash.merge!(key_tree => max_profiles_powers_hash )
            end

          end

        end

        new_profiles_with_match_hash = Hash[new_profiles_with_match_hash.sort_by { |k, v| v }.reverse] #  Ok Sorting of input hash by values Descend

        max_power_profiles_pairs_hash.merge!(searched_profile => max_power_pairs_hash ) if !max_power_pairs_hash.empty?

        duplicates_pairs_One_to_Many_hash.merge!(searched_profile => duplicates_One_to_Many_hash ) if !duplicates_One_to_Many_hash.empty?

      end

    end
    return max_power_profiles_pairs_hash, duplicates_pairs_One_to_Many_hash, new_profiles_with_match_hash

  end # End of method



  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # Наращивание (пополнение) Хэша1 новыми значениями из другого Хэша2
  #conn_hash = {72=>58, 75=>59, 76=>61, 77=>60, 78=>57}
  #new_conn_hash = {72=>58, 75=>59, 76=>61, 77=>60, 79=>62}
  # hash_1 -does not change
  # 79=>62 - найти те эл-ты in hash_2, кот-е отс-ют в hash_1
  # add 79=>62 to hash_1
  # Result: {72=>58, 75=>59, 76=>61, 77=>60, 78=>57, 79=>62} /
  def add_to_hash(hash_1,hash_2)
    arr_key1 = hash_1.keys
    hash_2.each do |k,v|
      hash_1 = hash_1.merge!( k => v) if !arr_key1.include?(k)
    end
  end

  # Метод суммы двух хэшей без уничтожения значений при совпадениях ключей
  # hash_one = {17=>27, 16=>28, 20=>29, 19=>30, 18=>24}
  # hash_two = {16=>28, 23=>35, 21=>34}
  # sum_hash = {17=>27, 16=>[28, 28], 20=>29, 19=>30, 18=>24, 23=>35, 21=>34}
  def sun_two_hashes(hash_one, hash_two)
    sum_hash = hash_one.merge(hash_two){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
    return sum_hash
  end

  # Метод сортировки массива хэшей по нескольким ключам
  def sort_hash_array(hash_arr_to_sort)
    sorted_hash_arr = hash_arr_to_sort.sort_by {|h| [ h['name_id'],h['relation_id'],h['is_name_id'] ]}
    return sorted_hash_arr
  end

  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # Метод получения НЕ общей части 2-х БК профилей
  def get_circles_delta(first_bk, second_bk, common_circle_arr)
    #one = (first_bk - common_circle_arr)
    #two = (second_bk - common_circle_arr)
    #logger.info " get_delta_bk: one = #{one}, two = #{two}"
    circles_delta = (first_bk - common_circle_arr) + (second_bk - common_circle_arr)

    return circles_delta
  end

  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # Взять Бл.круг одного профиля
  # получить массивы триад для дальнейшего сравнения
  # показать в Логгере
  #
  # /
  def have_profile_circle(profile_id)
    profile_user_id = Profile.find(profile_id).tree_id
    profile_circle = get_one_profile_circle(profile_id, profile_user_id)
    logger.info "=== КРУГ ПРОФИЛЯ = #{profile_id} "
    show_in_logger(profile_circle, "= ряд " )  # DEBUGG_TO_LOGG
    circle_arr, circle_profiles_arr, circle_is_profiles_arr, circle_relations_arr = make_arr_hash_BK(profile_circle)

    return circle_arr, circle_profiles_arr, circle_is_profiles_arr, circle_relations_arr
  end

  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # NB !! ЕСЛИ connected_user = ОБЪЕДИНЕННЫМ ДЕРЕВОМ ? - проверить действие order('user_id',??
  # МЕТОД Получения БК для любого одного профиля из дерева
  # ИСп-ся в Жестком поиске - в hard_search_match
  def get_one_profile_circle(profile_id, user_id)
    connected_users_arr = User.find(user_id).get_connected_users  ##найти БК для найденного профиля
    if !connected_users_arr.blank?
      found_profile_circle = ProfileKey.where(user_id: connected_users_arr, profile_id: profile_id).order('user_id','relation_id','is_name_id' )
      if !found_profile_circle.blank?
        return found_profile_circle # Найден БК
      else
        logger.info "Error in get_one_profile_BK. Не найден БК для Профиля = #{profile_id} у такого Юзера = #{user_id}"
      end
    else
      logger.info "Error in get_one_profile_BK. Нет такого Юзера = #{user_id} или не найдены его connected_users_arr = #{connected_users_arr.inspect}"
    end
  end

  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # МЕТОД Получения массива Хэшей по аттрибутам для любого БК одного профиля из дерева
  # Аттрибуты здесь заданы жестко - путем исключения из ActiveRecord
  # ИСп-ся в Жестком поиске - в hard_search_match
  def make_arr_hash_BK(bk_rows)
    bk_arr = []
    bk_arr_w_profiles = []
    is_profiles_arr = []
    relations_arr = []
    bk_rows.each do |row|
      bk_arr << row.attributes.except('id','user_id','profile_id','is_profile_id','created_at','updated_at')
      bk_arr_w_profiles << row.attributes.except('id','user_id','profile_id','created_at','updated_at') # for further analyze
      is_profiles_arr << row.attributes.except('id','user_id','profile_id','name_id','relation_id','is_name_id','created_at','updated_at').values_at('is_profile_id') # for further analyze
      relations_arr << row.attributes.except('id','user_id','profile_id','name_id','is_profile_id','is_name_id','created_at','updated_at').values_at('relation_id') # for further analyze
    end
    is_profiles_arr = is_profiles_arr.flatten(1)
    relations_arr = relations_arr.flatten(1)
    logger.debug "bk_arr_w_profiles  = #{bk_arr_w_profiles}"
    #logger.debug "relations_arr  = #{relations_arr}"
    return bk_arr, bk_arr_w_profiles, is_profiles_arr, relations_arr # Сделан БК в виде массива Хэшей
  end

  # NO USE!!!!
  # МЕТОД Вявления дубликатов в Круге
  # NB !! Вставить проверку и действия ЕСЛИ В БК ЕСТЬ СОВЕРШЕННО
  # ОДИНАКОВЫЕ ЭЛ-ТЫ: ИМЯ - ОТНОШЕНИЕ - ИМЯ
  # Например, два одинаковых по имени брата и т.п.
  # Действия: Отловить, Сформировать хэш дубликатов, Вытащить его наружу
  # И прекратить объединение деревьев !
  # !
  # ИСп-ся в Жестком поиске - в hard_complete_search
  def find_circle_duplicates(circle)
    logger.info " in find_circle_duplicates"
    diplicates_hash = {}
    circle.each do |k,v|
      #logger.info " k = in find_circle_duplicates"

    end
    logger.info " diplicates_hash: #{diplicates_hash}"

    return diplicates_hash
  end
  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
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
            logger.info "circles Size = EQUAL, но Содержание - РАЗНОЕ. (ПЕРЕСЕЧЕНИЕ 2-х БК - НЕ != []) common_circle_arr = #{common_circle_arr}"
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

  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # метод получения массива значений одного поля = key в массиве хэшей
  # без необходимости предварительной сортировки, кот-я может исказить рез-т/
  # На входе:         bk_arr_w_profiles  = [
  #    {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>28, "is_name_id"=>123},
  #    {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>29, "is_name_id"=>125},
  #    .... ]
  # На выходе: field_arr = [28, 29, 30, 24]
  def get_fields_arrays_from_bk(bk_arr_searched, bk_arr_found)
    field_arr_searched = []
    field_arr_found = []
    new_connection_hash = {}

    #   logger.info "Массив значений хэшей с  key= is_profile_id : field_values_arr = #{field_values_arr}     "
    bk_arr_searched.each_with_index do |one_searched_row, index|
  #    logger.info "one_searched_row = #{one_searched_row} "
      name_id_s = one_searched_row.values_at('name_id')
      relation_id_s = one_searched_row.values_at('relation_id')
      is_name_id_s = one_searched_row.values_at('is_name_id')
 #     logger.info "name_id_s = #{name_id_s}, relation_id_s = #{relation_id_s}, is_name_id_s = #{is_name_id_s} "
      bk_arr_found.each_with_index do |one_found_row, index|
 #       logger.info "one_found_row = #{one_found_row} "
        name_id_f = one_found_row.values_at('name_id')
        relation_id_f = one_found_row.values_at('relation_id')
        is_name_id_f = one_found_row.values_at('is_name_id')
 #       logger.info "name_id_f = #{name_id_f}, relation_id_f = #{relation_id_f}, is_name_id_f = #{is_name_id_f} "

        if name_id_s == name_id_f && relation_id_s == relation_id_f && is_name_id_s == is_name_id_f
         # rez = true
          field_arr_searched << one_searched_row.values_at('is_profile_id')
          field_arr_found << one_found_row.values_at('is_profile_id')
          new_connection_hash.merge!({one_searched_row.values_at('is_profile_id')[0] => one_found_row.values_at('is_profile_id')[0]}) # make new el-t of hash

          #logger.info "field_arr_searched = #{field_arr_searched}, field_arr_found = #{field_arr_found}, "

        end

      end

    end

    return field_arr_searched, field_arr_found, new_connection_hash
  end

  def get_step_arrs(pos_profiles_arr, profiles_to_connect_hash)
    search_profiles_step_arr = []
    found_profiles_step_arr = []
    search_step_arr1 = []
    found_step_arr1 = []
    search_step_arr2 = []
    found_step_arr2 = []
    profiles_to_connect_hash.each do |key,val|
      if pos_profiles_arr.include?(val)
        search_step_arr1 << key
        found_step_arr1 << val
      else
        search_step_arr2 << key
        found_step_arr2 << val
      end
    end
    search_profiles_step_arr << search_step_arr1
    found_profiles_step_arr << found_step_arr1
    search_profiles_step_arr << search_step_arr2
    found_profiles_step_arr << found_step_arr2

    return search_profiles_step_arr, found_profiles_step_arr
  end


  ## ВАРИАНТ № 2
  #search_bk_profiles_arr_sorted = sort_hash_array(search_bk_profiles_arr)
  #found_bk_profiles_arr_sorted = sort_hash_array(found_bk_profiles_arr)
  #search_bk_is_profiles_arr = get_field_array(search_bk_profiles_arr_sorted, "is_profile_id")
  #found_bk_is_profiles_arr = get_field_array(found_bk_profiles_arr_sorted, "is_profile_id")
  #logger.info "=ВАРИАНТ № 2== В БЛИЖНем КРУГе НАЙДЕННОГО ПРОФИЛЯ = #{tree_row.profile_id} - Массивы профилей is_profiles : search_bk_is_profiles_arr = #{search_bk_is_profiles_arr}, found_bk_is_profiles_arr = #{found_bk_is_profiles_arr}"

# ВАРИАНТ № 2
  # метод получения массива значений одного поля = key в массиве хэшей
  # На входе:         bk_arr_w_profiles  = [
  #    {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>28, "is_name_id"=>123},
  #    {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>29, "is_name_id"=>125},
  #    .... ]
  # На выходе: field_arr = [28, 29, 30, 24]
  def get_field_array(bk_arr_w_profiles, field_name_str)
    field_values_arr = bk_arr_w_profiles.map{|x| x[field_name_str]}
 #   logger.info "Массив значений хэшей с  key= is_profile_id : field_values_arr = #{field_values_arr}     "
    return field_values_arr
  end


  # Служебный метод для отладки - для LOGGER
  # Показывает массив в logger
  def show_in_logger(arr_to_log, string_to_add)
    row_no = 0  # DEBUGG_TO_LOGG
    arr_to_log.each do |row| # DEBUGG_TO_LOGG
      row_no += 1
      logger.debug "#{string_to_add} № #{row_no.inspect}: #{row.attributes.inspect} " # DEBUGG_TO_LOGG
    end  # DEBUGG_TO_LOGG
  end

  # Автоматическое наполнение хэша сущностями и
  # количеством появлений каждой сущности.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place = main_contrl.,
  ################# FILLING OF HASH WITH KEYS AND/OR VALUES
  def fill_hash(one_hash, elem) # Filling of hash with keys and values, according to key occurance
    if elem.blank? or elem == "" or elem == nil
      one_hash['Не найдено'] += 1
    else
      test = one_hash.key?(elem) # Is  elem in one_hash?
      if test == false #  "NOT Found in hash"
        one_hash.merge!({elem => 1}) # include elem with val=1 in hash
      else  #  "Found in hash"
        one_hash[elem] += 1 # increase (+1) val of occurance of elem
      end
    end
  end

  ## NEW SEARCH method
  ## получает на вход id деревьев из которых надо собрать ближний круг profile_id
  ## в виде двух хэшей: хэш профилей и хэш их отношений к self.id
  #def profile_circle_hash(user_ids, profile_id)
  #
  #  profiles_circle_hash = Hash.new
  #  profiles_arr = []
  #  relations_circle_hash = Hash.new
  #  relations_arr = []
  #  profiles_arr << profile_id
  #  relations_arr << 0
  #  rows = ProfileKey.where(user_id: user_ids, profile_id: profile_id).order('relation_id')#.includes(:profile_id, :relation_id).uniq_by(&:is_profile_id)
  #  rows.each do |row|
  #    profiles_arr << row.is_profile_id
  #    relations_arr << row.relation_id
  #  end
  #  profiles_circle_hash.merge!(profile_id => profiles_arr ) #
  #  relations_circle_hash.merge!(profile_id => relations_arr ) #
  #  return profiles_circle_hash, relations_circle_hash
  #
  #end

  # NEW SEARCH method
  # Автоматическое наполнение хэша сущностями и
  # количестpвом появлений каждой сущности.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place = main_contrl.,
  ################# FILLING OF HASH WITH KEYS AND/OR VALUES
  def fill_arrays_in_hash(one_hash, tree, profile, relation) # Filling of hash with keys and values, according to key occurance
    test_tree = one_hash.key?(tree) # Is profile_searched in one_hash?
    if test_tree == false #  "key = profile_searched YET NOT in hash - make new hash in hash"
      one_hash.merge!(tree => { profile => [relation] } ) # include new profile_searched with new profile with new array in hash
    else
      current_hash = one_hash.fetch(tree) # get hash for tree
      #logger.info " current_hash = #{current_hash} "
      test_profile_found = current_hash.key?(profile) # Is  elem in one_hash?
      if test_profile_found == false #  "key=profile NOT Found in hash"
        current_hash.merge!({profile => [relation]}) # include profile with new array in hash
        #logger.info " new current_hash = #{current_hash} "
        one_hash.merge!(tree => current_hash ) # наполнение хэша соответствиями найденных профилей и найденных отношений
        #logger.info " one_hash = #{one_hash} "
      else  #  "Found in hash"
        value_array = current_hash.values_at(profile)
        value_array << relation
        value_array = value_array.flatten(1)
        current_hash.merge!(profile => value_array ) # наполнение хэша соответствиями найденных профилей и найденных отношений
        #logger.info " current_hash = #{current_hash} "
        one_hash.merge!(tree => current_hash ) # наполнение хэша соответствиями найденных профилей и найденных отношений
        #logger.info " one_hash = #{one_hash} "
      end
    end

    logger.info " one_hash = #{one_hash} "
    return one_hash

  end



  # ИСПОЛЬЗУЕТСЯ В МЕТОДЕ ОБЪЕДИНЕНИЯ ДЕРЕВЬЕВ - connection_of_trees
  # Получение массива дерева соединенных Юзеров из Tree
  #  На входе - массив соединенных Юзеров
  # Используется 2 массива для исключения повторов
  def get_connected_tree(connected_users_arr)
    tree_arr = []
    check_tree_arr = [] # "опорный массив" - для удаления повторных элементов при формировании tree_arr
    connected_users_arr.each do |one_user|
      user_tree = Tree.where(:user_id => one_user)
      row_arr = []
      check_row_arr = []

      user_tree.each do |tree_row|
        row_arr[0] = tree_row.user_id              # user_id ID От_Профиля
        row_arr[1] = tree_row.profile_id           # ID От_Профиля (From_Profile)
        row_arr[2] = tree_row.name_id              # name_id ID От_Профиля
        row_arr[3] = tree_row.relation_id          # ID Родства От_Профиля с К_Профилю (To_Profile)
        row_arr[4] = tree_row.is_profile_id        # ID К_Профиля
        row_arr[5] = tree_row.is_name_id           # name_id К_Профиля
        row_arr[6] = tree_row.is_sex_id            # sex К_Профиля
        row_arr[7] = tree_row.connected            # Объединено дерево К_Профиля с другим деревом

        check_row_arr[0] = tree_row.profile_id           # ID От_Профиля (From_Profile)
        check_row_arr[1] = tree_row.name_id              # name_id ID От_Профиля
        check_row_arr[2] = tree_row.relation_id          # ID Родства От_Профиля с К_Профилю (To_Profile)
        check_row_arr[3] = tree_row.is_profile_id        # ID К_Профиля
        check_row_arr[4] = tree_row.is_name_id           # name_id К_Профиля
        check_row_arr[5] = tree_row.is_sex_id            # sex К_Профиля

        #logger.info "DEBUG IN get_connection_of_trees: #{tree_arr.include?(row_arr).inspect}" # == false
        #logger.info "DEBUG IN get_connection_of_trees: #{tree_arr.inspect} --- #{row_arr}"
        if !check_tree_arr.include?(check_row_arr) # контроль на наличие повторов
          tree_arr << row_arr
          check_tree_arr << check_row_arr
        end
        row_arr = []
        check_row_arr = []
      end
    end
    return tree_arr
  end



  ## Формирование полного щирокого Хаша
  # @note GET
  # На входе:
  # На выходе: @ Итоговый  ХЭШ
  def make_complete_hash(input_hash)
    complete_hash = Hash.new     #
    if !input_hash.blank?
      input_hash.each do |k, v|
        if v.size == 1
          complete_hash.merge!({k => v}) # наполнение хэша найденными profile_id
        else
          rez_hash = Hash.new     #
          v.each do |one_arr|
            if !one_arr.blank?
              merged_hash = rez_hash.merge({one_arr[0] => one_arr[1]}){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
              rez_hash = merged_hash
            end
          end
          complete_hash.merge!(k => rez_hash) # искомый хэш
          # с найденнымии profile_id, распределенными по связанным с ними profile_id
        end
      end
    end
    return complete_hash
  end


  # НАСТРОЙКА СОКРАЩЕНИЯ РЕ-В ПОИСКА: УДАЛЕНИЕ КОРОТКИХ СОВПАДЕНИЙ
  # ЦИФРА В УСЛОВИИ if - ЭТО РАЗМЕР СОВПАДЕНИЙ В ДЕРЕВЕ ПРИ ПОИСКЕ.
  # # Исключение тех рез-тов поиска, где найден всего один профиль
  # @note GET
  # На входе:
  # На выходе: @ Итоговый  ХЭШ
  def reduce_hash(input_hash)
    reduced_hash = Hash.new
    input_hash.each do |k, v|
      if v.values.flatten.size > 1  # НАСТРОЙКА УДАЛЕНИЯ МАЛЫХ СОВПАДЕНИЙ
        # сохраняем в рез-тах те, в кот. найдено больше 1 профиля
        reduced_hash.merge!({k => v}) #
      end
    end
    return reduced_hash
  end

  # Слияние массива Хэшей без потери значений { (key = user_id) => (value = profile_id) }
  # Получение упорядоченного Хэша: {user_id  -> [ profile_id, profile_id, profile_id ...]}
  # @note GET
  # На входе: массив хэшей: [{user_id -> profile_id, ... , user_id -> profile_id}, ..., {user_id -> profile_id, ... , user_id -> profile_id} ]
  # На выходе: @all_match_hash Итоговый упорядоченный ХЭШ
  # @param admin_page [Integer]
  def join_arr_of_hashes(all_match_hash_arr)
    final_merged_hash = Hash.new
    for h_ind in 0 .. all_match_hash_arr.length - 1
      next_hash = all_match_hash_arr[h_ind]
      merged_hash = final_merged_hash.merge(next_hash){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
      final_merged_hash = merged_hash
    end
    #@all_match_hash = final_merged_hash  # DEBUGG TO VIEW
    return final_merged_hash
  end

  # Преобразование Хэша хэшей в Хэш массивов вместо хэшей
  # На входе: Из: { user_id => { profile_id => [profile_id, profile_id ,..]}, user_id => { profile_id => [profile_id, profile_id ,..]}
  # На выходе в Хэш, где значения - массивы:
  # { user_id => [ profile_id, [profile_id, profile_id ,..]], user_id => [profile_id, [profile_id, profile_id ,..]]
  # @note GET
  # final_hash_arr = Итоговый ХЭШ
  def hash_hash_to_hash_arr(input_hash_hash)
    final_hash_arr = Hash.new
    ind = 0
    input_hash_hash.values.each do |one_hash|
      new_hash_merging = final_hash_arr.merge({input_hash_hash.keys[ind] => one_hash.to_a.flatten(1)} )
      final_hash_arr = new_hash_merging
      ind += 1
    end
    return final_hash_arr
  end


  # Подсчет количества найденных Профилей в массиве Хэшей
  # На входе: массив Хэшей профилей input_arr_hash
  # На выходе: amount_found Кол-во
  def count_profiles_in_hash(input_arr_hash)
    amount_found = 0
    input_arr_hash.each do |k|
      amount_found = amount_found + k.values.flatten.size
    end
    return amount_found
  end

  # Подсчет количества найденных Юзеров среди найденных Профилей
  # @note GET
  # На входе: массив профилей all_profiles_arr: profile_id
  # На выходе: @count Кол-во Юзеров
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def count_users_found(all_profiles_arr)
    @count = 0
    @users_ids_arr = []
    for ind in 0 .. all_profiles_arr.length - 1
      user_found_id = User.find_by_profile_id(all_profiles_arr[ind])
      if !user_found_id.blank?
        @count += 1
        @users_ids_arr << user_found_id.id  # user_id среди найденных профилей
      end
    end
  end

  ##Управляемый Метод для изготовления 2-х синхронных UNIQ массивов
  ##Вход:
  #def make_uniq_arrays(found_profiles, found_relations)
  #  found_profiles_uniq = []
  #  found_relations_uniq = []
  #
  #  found_profiles_uniq << found_profiles[0]
  #  found_relations_uniq << found_relations[0]
  #  for arr_ind in 1 .. found_profiles.length-1
  #    if !found_profiles_uniq.include?(found_profiles[arr_ind].to_i) # для исключения случая,
  #      found_profiles_uniq << found_profiles[arr_ind]
  #      found_relations_uniq << found_relations[arr_ind]
  #    end
  #  end
  #
  #  return found_profiles_uniq, found_relations_uniq
  #end




end
