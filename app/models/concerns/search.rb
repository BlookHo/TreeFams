module Search
  extend ActiveSupport::Concern



  def start_search(with_path: true)
    # @circle = current_user.profile.circle(current_user.id)

    @circle = self.profile.circle(self.get_connected_users)
    @author = self.profile

    @current_user_id = self.id # DEBUGG_TO_VIEW


     @connected_users_arr = self.get_connected_users # DEBUGG_TO_VIEW

 #   @connected_users_arr = [32,33]   # DEBUGG_TO_VIEW
    #@connected_users_arr = [current_user.id]    # DEBUGG_TO_VIEW

     @new_tree_arr = get_connected_users_tree(@connected_users_arr)
     @new_tree_arr_length = @new_tree_arr.length if !@new_tree_arr.blank?


      beg_search_time = Time.now   # Начало отсечки времени поиска

 #    @connected_users_arr = [current_user.id]    # DEBUGG_TO_VIEW

     #@circle_result = circle(@connected_users_arr)  # DEBUGG_TO_VIEW
     #@circle_result_len = @circle_result.length if !@circle_result.blank?  # DEBUGG_TO_VIEW

      search_profiles_tree_match(@connected_users_arr, @new_tree_arr)    # Основной поиск по дереву Автора среди деревьев в ProfileKeys.

      end_search_time = Time.now   # Конец отсечки времени поиска
      @elapsed_search_time = (end_search_time - beg_search_time).round(5)


      results = {
        final_reduced_profiles_hash: @final_reduced_profiles_hash,
        final_reduced_relations_hash: @final_reduced_relations_hash,
        wide_user_ids_arr: @wide_user_ids_arr
      }
  end


  # Получение массива дерева соединенных Юзеров из Tree
  #  На входе - массив соединенных Юзеров
  def get_connected_users_tree(connected_users_arr)

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
    #session[:tree_arr] = {:value => tree_arr, :updated_at => Time.current}

    @len_check_tree = check_tree_arr.length  if !check_tree_arr.blank?
    return tree_arr

  end



  # Поиск совпадений для одного из профилей БК current_user
  # Берем параметр: profile_id из массива  = profiles_tree_arr[tree_index][6].
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # На выходе: @all_match_arr по данному виду родства
 def get_relation_match(connected_users, from_profile_searching, profile_id_searched, relation_id_searched)

   found_trees_hash = Hash.new     #{ 0 => []}
   all_relation_match_arr = []     #

   wide_found_profiles_hash = Hash.new  #
   wide_found_relations_hash = Hash.new  #

   #all_profile_rows = ProfileKey.where(:user_id => current_user.id).where(:profile_id => profile_id_searched).select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id)
   all_profile_rows = ProfileKey.where(:user_id => connected_users).where(:profile_id => profile_id_searched).select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id)
   # поиск массива записей ближнего круга для каждого профиля в дереве Юзера
   @from_profile_searching = from_profile_searching  # DEBUGG_TO_VIEW
   @profile_searched = profile_id_searched   # DEBUGG_TO_VIEW
   @relation_searched = relation_id_searched   # DEBUGG TO VIEW
   @all_profile_rows = all_profile_rows   # DEBUGG_TO_VIEW

   if !all_profile_rows.blank?
     @all_profile_rows_len = all_profile_rows.length if !all_profile_rows.blank? #_DEBUGG_TO_VIEW
     # размер ближнего круга профиля в дереве current_user.id
     all_profile_rows.each do |relation_row|
#       relation_match_arr = ProfileKey.where.not(user_id: current_user.id).where(:name_id => relation_row.name_id).where(:relation_id => relation_row.relation_id).where(:is_name_id => relation_row.is_name_id).select(:id, :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
        relation_match_arr = ProfileKey.where.not(user_id: connected_users).where(:name_id => relation_row.name_id, :relation_id => relation_row.relation_id, :is_name_id => relation_row.is_name_id).select(:id, :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
        if !relation_match_arr.blank?
          row_arr = []
          relation_match_arr.each do |tree_row|
            row_arr[0] = tree_row.user_id              # ID Автора
            row_arr[1] = tree_row.profile_id           # ID От_Профиля
            row_arr[2] = tree_row.name_id              # ID Имени От_Профиля
            row_arr[3] = tree_row.relation_id          # ID Родства От_Профиля с другим К_Профиля
            row_arr[4] = tree_row.is_profile_id        # ID другого К_Профиля
            row_arr[5] = tree_row.is_name_id           # ID Имени К_Профиля

            all_relation_match_arr << row_arr
            row_arr = []

            fill_hash(found_trees_hash, tree_row.user_id) # наполнение хэша найденными user_id = trees и частотой их обнаружения

            wide_found_profiles_hash.merge!({tree_row.user_id  => {from_profile_searching => [tree_row.profile_id]} } ) # наполнение хэша найденными profile_id
            wide_found_relations_hash.merge!({tree_row.user_id  => {from_profile_searching => [relation_id_searched]} } ) # наполнение хэша найденными relation_id

          end
          @relation_match_arr = relation_match_arr   # DEBUGG TO VIEW
        else
         # @relation_match_arr = ["relation_match_arr"]   # DEBUGG TO VIEW
     #     @relation_match_arr = relation_match_arr   # DEBUGG TO VIEW
        end
     end
     @relation_id_searched_arr << relation_id_searched  #_DEBUGG_TO_VIEW

     ##### НАСТРОЙКИ результатов поиска

     # Исключение тех user_id, по которым не все запросы дали результат внутри Ближнего круга
     # Остаются те user_id, в которых найдены совпавшие профили.
     # На выходе ХЭШ: {user_id  => кол-во успешных поисков } - должно быть равно (не меньше) длине массива
     # всех видов отношений в блжнем круге для разыскиваемого профиля.
     if relation_id_searched != 0 # Для всех профилей, кот-е не явл. current_user
       # Исключение из результатов поиска
       #if all_profile_rows.length > 3

 #      found_trees_hash.delete_if {|key, value|  value < all_profile_rows.length - 1 } #
       #found_trees_hash.delete_if {|key, value|  value < all_profile_rows.length } #
       # all_profile_rows.length = размер ближнего круга профиля в дереве current_user.id
       #else
       #  # Если маленький БК
       #  found_trees_hash.delete_if {|key, value|  value <= 2  }  # 1 .. 3 = НАСТРОЙКА!!
       #end

     else
       #if all_profile_rows.length <= 3
       #  found_trees_hash.delete_if {|key, value|  value <= 0 } #all_profile_rows.length  }  # 1 .. 3 = НАСТРОЙКА!!
       #  # Исключение из результатов поиска групп с малым кол-вом совпадений в других деревьях or value < all_profile_rows.length
       #else
       #  # Если маленький БК
       #  found_trees_hash.delete_if {|key, value|  value <= 0  }  # 1 .. 2 = НАСТРОЙКА!!
       #end
     end

   end


   ##### КОРРЕКТИРОВКА результатов поиска

   wide_found_profiles_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
   # На выходе ХЭШ: {user_id  => profile_id} - найденные деревья с найденным профилем в них.
   @wide_found_profiles_hash = wide_found_profiles_hash

   wide_found_relations_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей

   ##### ИТОГОВЫЕ РАСШИРЕННЫЕ результаты поиска
   @all_wide_match_profiles_arr << wide_found_profiles_hash if !wide_found_profiles_hash.blank? # Заполнение выходного массива хэшей
   @all_wide_match_relations_arr << wide_found_relations_hash if !wide_found_relations_hash.empty? # Заполнение выходного массива хэшей

   #@found_profiles_hash = found_profiles_hash # DEBUGG TO VIEW
   #@found_relations_hash = found_relations_hash # DEBUGG TO VIEW
   @found_trees_hash = found_trees_hash # DEBUGG TO VIEW
   @all_profile_rows = all_profile_rows   # DEBUGG TO VIEW
   @all_relation_match_arr = all_relation_match_arr   ## DEBUGG TO VIEW

   @wide_found_profiles_hash = wide_found_profiles_hash # DEBUGG TO VIEW
   @wide_found_relations_hash = wide_found_relations_hash # DEBUGG TO VIEW

 end

# Основной поиск по дереву Автора - Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_profiles_tree_match(connected_users_arr, tree_arr)

    @tree_arr_len = tree_arr.length  # DEBUGG TO VIEW
    @tree_to_display = []
    @tree_row = []

    ##### Будущие результаты поиска
    @all_match_trees_arr = []     # Массив совпадений деревьев
    @all_match_profiles_arr = []  # Массив совпадений профилей
    @all_match_relations_arr = []  # Массив совпадений отношений
    #####
    @all_wide_match_profiles_arr = []     # Широкий Массив совпадений профилей
    @all_wide_match_relations_arr = []     # Широкий Массив совпадений отношений

    @relation_id_searched_arr = []     #_DEBUGG_TO_VIEW Ok

    if !tree_arr.blank?
      for tree_index in 0 .. tree_arr.length-1
    #    32, 212, 419, 1, 213, 196, 1, false]
    #         1        3   4
        from_profile_searching = tree_arr[tree_index][1] # От какого профиля осущ-ся Поиск
        relation_id_searched = tree_arr[tree_index][3] # relation_id К_Профиля
        profile_id_searched = tree_arr[tree_index][4] # Поиск по ID К_Профиля
        get_relation_match(connected_users_arr, from_profile_searching, profile_id_searched, relation_id_searched)       # На выходе: @all_match_arr по данному дереву
      end
    end

    #### расширенные РЕЗУЛЬТАТЫ ПОИСКА:
    if !@all_wide_match_profiles_arr.blank?
      #### PROFILES
      all_wide_match_hash = join_arr_of_hashes(@all_wide_match_profiles_arr) if !@all_wide_match_profiles_arr.blank?  # Если найдены совпадения - в @all_match_arr
      @all_wide_match_hash = all_wide_match_hash  #_DEBUGG_TO_VIEW
      @all_wide_match_arr_sorted = Hash[all_wide_match_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      @complete_hash = make_complete_hash(@all_wide_match_arr_sorted)  #_DEBUGG_TO_VIEW

      # @final_reduced_profiles_hash = итоговый Хаш массивов найденных профилей
      # Здесь - исключаем из результатов - те, в кот-х найдено всего одно совпадение
      # см. метод reduce_hash
      # То же - симметрично повторяется для relations
      @final_reduced_profiles_hash = reduce_hash(make_complete_hash(@all_wide_match_arr_sorted))  # TO VIEW

      # @wide_user_ids_arr = итоговый массив найденных деревьев
      @wide_user_ids_arr = @final_reduced_profiles_hash.keys.flatten  # TO VIEW

      # @wide_profile_ids_arr = итоговый массив хашей найденных профилей
      @wide_profile_ids_arr = @final_reduced_profiles_hash.values.flatten # TO VIEW

      # @wide_amount_of_profiles = Подсчет количества найденных Профилей в массиве Хэшей
      @wide_amount_of_profiles = count_profiles_in_hash(@wide_profile_ids_arr)

      #### RELATIONS
      all_wide_match_relations_hash = join_arr_of_hashes(@all_wide_match_relations_arr) if !@all_wide_match_relations_arr.blank?  # Если найдены совпадения - в @all_match_arr
      @all_wide_match_relations_sorted = Hash[all_wide_match_relations_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      #@complete_relations_hash = make_complete_hash(@all_wide_match_relations_sorted)

      @final_reduced_relations_hash = reduce_hash(make_complete_hash(@all_wide_match_relations_sorted))  # TO VIEW

      #@relation_ids_arr = @all_match_relations_sorted.values.flatten # TO VIEW
      #@all_match_relations_hash = all_match_relations_hash # TO VIEW
      #count_users_found(profile_ids_arr) # TO VIEW

    else
      @final_reduced_profiles_hash = []
      @final_reduced_relations_hash = []
      @wide_user_ids_arr = []
    end

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