module SearchHelper

  # Метод сортировки массива хэшей по нескольким ключам
  def sort_hash_array(hash_arr_to_sort)
    sorted_hash_arr = hash_arr_to_sort.sort_by {|h| [ h['name_id'],h['relation_id'],h['is_name_id'] ]}
    return sorted_hash_arr
  end


  # Метод сравнения 2-х БК профилей
  # этот метод требует развития - что делать, когда два БК не равны?
  # Означает ли это, что надо давать сразу отрицат-й ответ?.
  # На входе - два массива Хэшей = 2 БК
  # На выходе: compare_rezult = false or true.
  #def  compare_two_BK_old(found_bk_arr, search_bk_arr)
  #  if found_bk_arr.size.inspect == search_bk_arr.size.inspect
  #    logger.info "ПОДРОБНОЕ СРАВНЕНИЕ ДВУХ БЛИЖНИХ КРУГОВ"
  #
  #    if found_bk_arr - search_bk_arr == []
  #      compare_rezult = true
  #      logger.info "BKs - EQUAL   compare_rezult = #{compare_rezult} "
  #    else
  #      logger.info "СРАВНЕНИЕ ДВУХ БЛИЖНИХ КРУГОВ - БК найденного профиля и БК искомого - разной длины -> ОНИ РАЗНЫЕ"
  #      if  search_bk_arr.size.inspect > found_bk_arr.size.inspect
  #        rez_arr = found_bk_arr & search_bk_arr #
  #        logger.info "BKs - UNEQUAL all_profile_rows.size > found_profile_circle.size "
  #        compare_rezult = false
  #        #logger.info "go_on_all_profile_rows = #{go_on_all_profile_rows} "
  #        logger.info "compare_rezult = #{compare_rezult} "
  #
  #      end
  #    end
  #    return compare_rezult
  #  end
  #
  #  end

    def  compare_two_BK(found_bk_arr, search_bk_arr)

    if !found_bk_arr.blank?
      if !search_bk_arr.blank?

        logger.info "СРАВНЕНИЕ ДВУХ БК: По Size и По содержанию (разность)"
        if found_bk_arr.size.inspect == search_bk_arr.size.inspect
          if found_bk_arr - search_bk_arr == []
            compare_rezult = true
            logger.info "BKs Size = EQUAL, Содержание - ОДИНАКОВОЕ. (Разность = [])"
          else
            compare_rezult = false
            logger.info "BKs Size = EQUAL, Содержание - РАЗНОЕ. (Разность - НЕ != [])"
          end

        else
            rez_bk_arr = found_bk_arr & search_bk_arr # ПЕРЕСЕЧЕНИЕ 2-х БК
            compare_rezult = false
            logger.info "BKs - SIZE = UNEQUAL, Содержание - РАЗНОЕ. (ПЕРЕСЕЧЕНИЕ 2-х БК - НЕ != [])"
        end

      else
        logger.info "Error in compare_two_BK. Нет БК для Профиля: search_bk_arr = #{search_bk_arr}"
      end
    else
      logger.info "Error in compare_two_BK. Нет БК для Профиля: found_bk_arr = #{found_bk_arr}"
    end

    #logger.info "compare_rezult = #{compare_rezult} "
    return compare_rezult, rez_bk_arr
  end

# ВАРИАНТ № 1
  # метод получения массива значений одного поля = key в массиве хэшей
  # На входе:         bk_arr_w_profiles  = [
  #    {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>28, "is_name_id"=>123},
  #    {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>29, "is_name_id"=>125},
  #    .... ]
  # На выходе: field_arr = [28, 29, 30, 24]
  def get_fields_arrays_from_bk(bk_arr_searched, bk_arr_found)
    field_arr_searched = []
    field_arr_found = []
    rez = false

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
          rez = true
          field_arr_searched << one_searched_row.values_at('is_profile_id')
          field_arr_found << one_found_row.values_at('is_profile_id')
  #        logger.info "rez = #{rez}, field_arr_searched = #{field_arr_searched}, field_arr_found = #{field_arr_found}, "

        end

      end

    end

    return field_arr_searched, field_arr_found
  end


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

  # МЕТОД Получения БК для любого одного профиля из дерева
  # ИСп-ся в Жестком поиске - в hard_search_match
  def get_one_profile_BK(profile_id, user_id)
    logger.info "=in get_one_profile_BK="
    connected_users_arr = User.find(user_id).get_connected_users  ##найти БК для найденного профиля
    if !connected_users_arr.blank?
      logger.info "Для Юзера = #{user_id} : connected_users_arr = #{connected_users_arr.inspect}"
      found_profile_circle = ProfileKey.where(user_id: connected_users_arr, profile_id: profile_id).order('relation_id')
      if !found_profile_circle.blank?
        return found_profile_circle # Найден БК
      else
        logger.info "Error in get_one_profile_BK. Не найден БК для Профиля = #{profile_id} у такого Юзера = #{user_id}"
      end
    else
      logger.info "Error in get_one_profile_BK. Нет такого Юзера = #{user_id} или не найдены его connected_users_arr = #{connected_users_arr.inspect}"
    end
  end

  # МЕТОД Получения массива Хэшей по аттрибутам для любого БК одного профиля из дерева
  # Аттрибуты здесь заданы жестко - путем исключения из ActiveRecord
  # ИСп-ся в Жестком поиске - в hard_search_match
  def make_arr_hash_BK(bk_rows)
    bk_arr = []
    bk_arr_w_profiles = []
    bk_rows.each do |row|

      bk_arr << row.attributes.except('id','user_id','profile_id','is_profile_id','created_at','updated_at')
      bk_arr_w_profiles << row.attributes.except('id','user_id','profile_id','created_at','updated_at') # for further analyze
      #logger.debug "row  = #{row}"
      #logger.debug "bk_arr  = #{bk_arr}"
      #logger.debug "bk_arr_w_profiles  = #{bk_arr_w_profiles}"
    end
    logger.debug "bk_arr  = #{bk_arr}"
    logger.debug "bk_arr_w_profiles  = #{bk_arr_w_profiles}"
    return bk_arr, bk_arr_w_profiles # Сделан БК в виде массива Хэшей
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





end
