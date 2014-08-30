module SearchHelper

  # Метод сравнения 2-х БК профилей
  # этот метод требует развития - что делать, когда два БК не равны?
  # Означает ли это, что надо давать сразу отрицат-й ответ?.
  # На входе - два массива Хэшей = 2 БК
  # На выходе: compare_rezult = false or true.
  def  compare_two_BK(found_bk_arr, search_bk_arr)
    if found_bk_arr.size.inspect == search_bk_arr.size.inspect
      logger.info "ПОДРОБНОЕ СРАВНЕНИЕ ДВУХ БЛИЖНИХ КРУГОВ"

      if found_bk_arr - search_bk_arr == []
        #bk_arr  = [
        #    {"name_id"=>130, "relation_id"=>1, "is_name_id"=>123},
        #    {"name_id"=>130, "relation_id"=>2, "is_name_id"=>98},
        #    {"name_id"=>130, "relation_id"=>5, "is_name_id"=>123},
        #    {"name_id"=>130, "relation_id"=>5, "is_name_id"=>125}
        #]

        bk_arr_w_profiles  = [
            {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>28, "is_name_id"=>123},
            {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>29, "is_name_id"=>125},
            {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>30, "is_name_id"=>130},
            {"profile_id"=>27, "name_id"=>123, "relation_id"=>8, "is_profile_id"=>24, "is_name_id"=>98}
        ]


        #bk_arr  = [
        #    {"name_id"=>130, "relation_id"=>1, "is_name_id"=>123},
        #    {"name_id"=>130, "relation_id"=>2, "is_name_id"=>98},
        #    {"name_id"=>130, "relation_id"=>5, "is_name_id"=>123},
        #    {"name_id"=>130, "relation_id"=>5, "is_name_id"=>125}
        #]
        # get

        bk_arr_w_profiles  = [
            {"name_id"=>123, "relation_id"=>3, "is_name_id"=>123, "profile_id"=>17, "is_profile_id"=>16},
            {"name_id"=>123, "relation_id"=>8, "is_name_id"=>98, "profile_id"=>17, "is_profile_id"=>18},
            {"name_id"=>123, "relation_id"=>3, "is_name_id"=>130, "profile_id"=>17, "is_profile_id"=>19},
            {"name_id"=>123, "relation_id"=>3, "is_name_id"=>125, "profile_id"=>17, "is_profile_id"=>20}
        ]

        # Метод выделения массива значений Поля из массива Хэшей





        compare_rezult = true
        logger.info "BKs - EQUAL   compare_rezult = #{compare_rezult} "
      else
        compare_rezult = false
        logger.info "BKs - UNEQUAL   compare_rezult = #{compare_rezult} "
      end
    else
      logger.info "СРАВНЕНИЕ ДВУХ БЛИЖНИХ КРУГОВ - БК найденного профиля и БК искомого - разной длины -> ОНИ РАЗНЫЕ"
      if  search_bk_arr.size.inspect > found_bk_arr.size.inspect
        rez_arr = found_bk_arr & search_bk_arr #
        logger.info "BKs - UNEQUAL all_profile_rows.size > found_profile_circle.size "
        compare_rezult = false
        #logger.info "go_on_all_profile_rows = #{go_on_all_profile_rows} "
        logger.info "compare_rezult = #{compare_rezult} "

      end
    end
    return compare_rezult
  end

  # МЕТОД Получения БК для любого одного профиля из дерева
  # ИСп-ся в Жестком поиске - в hard_search_match
  def get_one_profile_BK(profile_id, user_id)
    with_whom_connect_users_arr = User.find(user_id).get_connected_users  ##найти БК для найденного профиля tree_row в дереве tree_row
    if !with_whom_connect_users_arr.blank?
      logger.info "=get_one_profile_BK= connected trees with #{user_id} = with_whom_connect_users_arr #{with_whom_connect_users_arr.inspect}"
      found_profile_circle = ProfileKey.where(user_id: with_whom_connect_users_arr, profile_id: profile_id).order('relation_id')
      if !found_profile_circle.blank?
        return found_profile_circle # Найден БК
      else
        logger.info "=get_one_profile_BK= Не найден БК для Профиля #{profile_id} у такого Юзера #{user_id}"
      end
    else
      logger.info "=get_one_profile_BK= Нет такого Юзера #{user_id} или не найдены его with_whom_connect_users_arr #{with_whom_connect_users_arr.inspect}"
    end
  end

  # МЕТОД Получения массива Хэшей по аттрибутам для любого БК одного профиля из дерева
  # Аттрибуты здесь заданы жестко - путем исключения из ActiveRecord
  # ИСп-ся в Жестком поиске - в hard_search_match
  def make_arr_hash_BK(bk_rows)
    bk_arr = []
    bk_arr_w_profiles = []
    bk_rows.each do |found_bk_row|
      bk_arr << found_bk_row.attributes.except('id','user_id','profile_id','is_profile_id','created_at','updated_at')
      bk_arr_w_profiles << found_bk_row.attributes.except('id','user_id','created_at','updated_at') # for further analyze
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
