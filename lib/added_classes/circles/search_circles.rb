class SearchCircles

  #############################################################
  # Иванищев А.В. 2015
  # @note: Методы работы с "кругами" - для ряда моделей и методов
  #############################################################


  # @note: Получение Кругов для пары профилей - для последующего сравнения и анализа
  #   ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH"
  def self.find_circles_arrs(profile_searched, profile_found)
    search_bk_arr, search_bk_profiles_arr, search_is_profiles_arr = have_profile_circle(profile_searched)
    found_bk_arr, found_bk_profiles_arr, found_is_profiles_arr = have_profile_circle(profile_found)
    { search_bk_arr: search_bk_arr,
      search_bk_profiles_arr: search_bk_profiles_arr,
      search_is_profiles_arr: search_is_profiles_arr,
      found_bk_arr: found_bk_arr,
      found_bk_profiles_arr: found_bk_profiles_arr,
      found_is_profiles_arr: found_is_profiles_arr
    }
  end


  # @note: ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH"
  # Взять Бл.круг одного профиля
  # получить массивы триад для дальнейшего сравнения
  # показать в Логгере
  def self.have_profile_circle(profile_id)
    profile_user_id = Profile.where(id: profile_id, deleted: 0)[0].tree_id
    profile_circle = get_one_profile_circle(profile_id, profile_user_id)
    circle_arr, circle_profiles_arr, circle_is_profiles_arr =
        make_arrays_from_circle(profile_circle)
    circle_is_profiles_arr = circle_is_profiles_arr.uniq
    return circle_arr, circle_profiles_arr, circle_is_profiles_arr
  end


  # @note: ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH" & Similars complete search
  # NB: ЕСЛИ connected_user = ОБЪЕДИНЕННЫМ ДЕРЕВОМ ? - check действие order('user_id',??
  # МЕТОД Получения БК для любого одного профиля из дерева
  def self.get_one_profile_circle(profile_id, user_id)
    connected_users_arr = User.find(user_id).get_connected_users  ##найти БК для найденного профиля .where('relation_id <= 8')
    if !connected_users_arr.blank?
      found_profile_circle = ProfileKey.where(user_id: connected_users_arr, profile_id: profile_id, deleted: 0)
                                 .order('user_id','relation_id','is_name_id' )
      #.select(:user_id, :name_id, :relation_id, :is_name_id).distinct
      if !found_profile_circle.blank?
        return found_profile_circle # Найден БК
      else
        puts "Error in get_one_profile_BK. Не найден БК для Профиля = #{profile_id} у такого Юзера = #{user_id}"
      end
    else
      puts "Error in get_one_profile_BK. Нет такого Юзера = #{user_id} или не найдены его connected_users_arr = #{connected_users_arr.inspect}"
    end
  end


  # @note: ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH"
  # МЕТОД Получения массива Хэшей по аттрибутам для любого БК одного профиля из дерева
  # Аттрибуты здесь заданы жестко - путем исключения из ActiveRecord
  # ИСп-ся в Жестком поиске - в hard_search_match
  def self.make_arrays_from_circle(bk_rows)
    bk_arr = []
    bk_arr_w_profiles = []
    is_profiles_arr = []
    # relations_arr = []  # for next demand
    bk_rows.each do |row|
      bk_arr << row.attributes.except('id','user_id','profile_id','is_profile_id','display_name_id','is_display_name_id','created_at','updated_at')
      bk_arr_w_profiles << row.attributes.except('id','user_id','display_name_id','is_display_name_id','created_at','updated_at') # for further analyze
      is_profiles_arr << row.attributes.except('id','user_id','profile_id','name_id','display_name_id','is_display_name_id','relation_id','is_name_id','created_at','updated_at').values_at('is_profile_id') # for further analyze
      #relations_arr << row.attributes.except('id','user_id','profile_id','name_id','is_profile_id','is_name_id','created_at','updated_at').values_at('relation_id') # for further analyze
    end
    is_profiles_arr = is_profiles_arr.flatten(1)
    #relations_arr = relations_arr.flatten(1)
    return bk_arr, bk_arr_w_profiles, is_profiles_arr #, relations_arr # Сделан БК в виде массива Хэшей
  end


  # @note: compare two circles & proceed compare result
  #  ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH"
  def self.proceed_compare_circles(compare_circles_data)
    profile_searched = compare_circles_data[:profile_searched]
    profile_found = compare_circles_data[:profile_found]
    found_bk_arr = compare_circles_data[:found_bk_arr]
    search_bk_arr = compare_circles_data[:search_bk_arr]
    found_bk_profiles_arr = compare_circles_data[:found_bk_profiles_arr]
    search_bk_profiles_arr = compare_circles_data[:search_bk_profiles_arr]
    found_is_profiles_arr = compare_circles_data[:found_is_profiles_arr]
    search_is_profiles_arr = compare_circles_data[:search_is_profiles_arr]
    new_connection_hash = compare_circles_data[:new_connection_hash]

    # Сравнение двух Кругов пары профилей Если: НЕТ ДУБЛИКАТОВ В КАЖДОМ ИЗ КРУГОВ,
    puts " compare_two_circles: ИСКОМОГО ПРОФИЛЯ = #{profile_searched} и НАЙДЕННОГО ПРОФИЛЯ = #{profile_found}:"
    # puts " compare_two_circles:
    #   found_bk_arr = #{found_bk_arr}
    #   search_bk_arr = #{search_bk_arr}:"
    compare_rezult, common_circle_arr, delta = compare_two_circles(found_bk_arr, search_bk_arr)
    # puts " compare_rezult = #{compare_rezult}"
    # puts " ПЕРЕСЕЧЕНИЕ двух Кругов: common_circle_arr = #{common_circle_arr}"
    # puts " РАЗНОСТЬ двух Кругов: delta = #{delta}"

    # Анализ результата сравнения двух Кругов
    if !common_circle_arr.blank? # Если есть какое-то ПЕРЕСЕЧЕНИЕ при сравнении 2-х Кругов
      new_connection_hash = get_fields_arr_from_circles(search_bk_profiles_arr, found_bk_profiles_arr )
    else
      # @@@@@ NB !! Вставить проверку: Если Круги равны, И: НЕТ ДУБЛИКАТОВ В КАЖДОМ ИЗ КРУГОВ,
      # то формируем новый хэш из их профилей, КОТ-Е ТОЖЕ РАВНЫ
      search_is_profiles_arr.each_with_index do | is_profile, index |
        new_connection_hash.merge!(is_profile => found_is_profiles_arr[index])
      end
    end
    puts " После сравнения Кругов: new_connection_hash = #{new_connection_hash} "

    new_connection_hash

  end




  # @note: ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH"
  # todo: перенести этот метод в CirclesMethods - для нескольких моделей
  # Метод сравнения 2-х БК профилей
  # этот метод требует развития - что делать, когда два БК не равны?
  # Означает ли это, что надо давать сразу отрицат-й ответ?.
  # На входе - два массива Хэшей = 2 БК
  # На выходе: compare_rezult = false or true.
  def self.compare_two_circles(found_bk_arr, search_bk_arr)

    if !found_bk_arr.blank?
      if !search_bk_arr.blank?
        delta = []
        puts "in compare_two_circles: СРАВНЕНИЕ ДВУХ БК: По Size и По содержанию (разность)"
        if found_bk_arr.size.inspect == search_bk_arr.size.inspect
          common_circle_arr = found_bk_arr - search_bk_arr
          if common_circle_arr == []
            compare_equal_rezult = true
            puts " circles Size = EQUAL и Содержание - ОДИНАКОВОЕ. (Разность 2-х БК = []) common_circle_arr = #{common_circle_arr}"
          else
            common_circle_arr, compare_equal_rezult = circles_intersection(found_bk_arr, search_bk_arr)
            # common_circle_arr = found_bk_arr & search_bk_arr # ПЕРЕСЕЧЕНИЕ 2-х БК
            # compare_equal_rezult = false
            puts "circles Sizes = EQUAL, но Содержание - РАЗНОЕ. (ПЕРЕСЕЧЕНИЕ 2-х БК - НЕ != []) common_circle_arr = #{common_circle_arr}"
            delta = get_circles_delta(found_bk_arr, search_bk_arr, common_circle_arr)
          end

        else
          common_circle_arr = found_bk_arr & search_bk_arr # ПЕРЕСЕЧЕНИЕ 2-х БК
          compare_equal_rezult = false
          puts "BKs - SIZE = UNEQUAL и Содержание - РАЗНОЕ. (ПЕРЕСЕЧЕНИЕ 2-х circles - НЕ != [])"
          delta = get_circles_delta(found_bk_arr, search_bk_arr, common_circle_arr)
        end

      else
        puts "Error in compare_two_BK. Нет БК для Профиля: search_bk_arr = #{search_bk_arr}"
      end
    else
      puts "Error in compare_two_BK. Нет БК для Профиля: found_bk_arr = #{found_bk_arr}"
    end
    puts "### delta = #{delta}"
    puts "### common_circle_arr = #{common_circle_arr}"

    return compare_equal_rezult, common_circle_arr, delta
  end


  # @note: Пересечение двух кругов
  #   ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH"
  # Метод получения общей части 2-х БК профилей
  def self.circles_intersection(found_bk_arr, search_bk_arr)
    common_circle_arr = found_bk_arr & search_bk_arr # ПЕРЕСЕЧЕНИЕ 2-х БК
    return common_circle_arr, false # == compare_equal_rezult
  end


  # @note: ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH"
  # Метод получения НЕ общей части 2-х БК профилей
  def self.get_circles_delta(first_bk, second_bk, common_circle_arr)
    # one = (first_bk - common_circle_arr)
    # two = (second_bk - common_circle_arr)
    # puts " get_delta_bk: one = #{one}, two = #{two}"
    (first_bk - common_circle_arr) + (second_bk - common_circle_arr)
  end


  # PREV VERSION @note: ИСПОЛЬЗУЕТСЯ В METHOD "COMPLETE SEARCH"
  # метод получения массива значений одного поля = key в массиве хэшей
  # без необходимости предварительной сортировки, кот-я может исказить рез-т/
  # На входе:         bk_arr_w_profiles  = [
  #    {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>28, "is_name_id"=>123},
  #    {"profile_id"=>27, "name_id"=>123, "relation_id"=>3, "is_profile_id"=>29, "is_name_id"=>125},
  #    .... ]
  # На выходе: field_arr = [28, 29, 30, 24]
  # def self.get_fields_arr_from_circles(bk_arr_searched, bk_arr_found)
  #   puts "search_bk_profiles_arr = #{bk_arr_searched} "
  #   puts "found_bk_profiles_arr = #{bk_arr_found}     "
  #   new_connection_hash = {}
  #
  #   # unless bk_arr_searched.blank?
  #   bk_arr_searched.each do |one_searched_row|
  #     puts "#### one_searched_row = #{one_searched_row} "
  #     name_id_s = one_searched_row.values_at('name_id')
  #     profile_id_s = one_searched_row.values_at('profile_id')
  #     relation_id_s = one_searched_row.values_at('relation_id')
  #     is_name_id_s = one_searched_row.values_at('is_name_id')
  #     is_profile_id_s = one_searched_row.values_at('is_profile_id')
  #
  #     bk_arr_found.each do |one_found_row|
  #       puts "@ one_found_row = #{one_found_row} of new_connection_hash"
  #       name_id_f = one_found_row.values_at('name_id')
  #       profile_id_f = one_found_row.values_at('profile_id')
  #       relation_id_f = one_found_row.values_at('relation_id')
  #       is_name_id_f = one_found_row.values_at('is_name_id')
  #       is_profile_id_f = one_found_row.values_at('is_profile_id')
  #
  #       if name_id_s == name_id_f && relation_id_s == relation_id_f && is_name_id_s == is_name_id_f
  #         if is_profile_id_s != is_profile_id_f
  #           if (profile_id_s != is_profile_id_f) && (profile_id_f != is_profile_id_s)# Одинаковые профили не заносим в хэш объединения (они и так одинаковые)
  #             # make new el-t of new_connection_hash
  #             new_connection_hash.merge!({one_searched_row.values_at('is_profile_id')[0] => one_found_row.values_at('is_profile_id')[0]})
  #             puts "$$$$ new_connection_hash = #{new_connection_hash} "
  #           end
  #         end
  #       end
  #
  #     end
  #
  #     # end
  #   end
  #   new_connection_hash
  # end

  def self.get_fields_arr_from_circles(bk_arr_searched, bk_arr_found)
    puts "search_bk_profiles_arr = #{bk_arr_searched} "
    puts "found_bk_profiles_arr = #{bk_arr_found}     "
    new_connection_hash = {}

    # unless bk_arr_searched.blank?
    bk_arr_searched.each do |one_searched_row|
      puts "#### one_searched_row = #{one_searched_row} "
      profile_data_s = {
        name_id_s: one_searched_row.values_at('name_id'),
        profile_id_s: one_searched_row.values_at('profile_id'),
        relation_id_s: one_searched_row.values_at('relation_id'),
        is_name_id_s: one_searched_row.values_at('is_name_id'),
        is_profile_id_s: one_searched_row.values_at('is_profile_id')
      }

      collect_data = {
        new_connection_hash: new_connection_hash,
        one_profile: profile_data_s[:is_profile_id_s][0]
      }

      new_connection_hash = bk_found_cycle(bk_arr_found, profile_data_s, collect_data)

      # end
    end
    new_connection_hash
  end


  # @note: check & find the SAME profiles found
  def self.bk_found_cycle(bk_arr_found, profile_data_s, collect_data)
    new_connection_hash = collect_data[:new_connection_hash]

    bk_arr_found.each do |one_found_row|
      puts "@ one_found_row = #{one_found_row} of new_connection_hash"
      profile_data_f = {
          name_id_f: one_found_row.values_at('name_id'),
          profile_id_f: one_found_row.values_at('profile_id'),
          relation_id_f: one_found_row.values_at('relation_id'),
          is_profile_id_f: one_found_row.values_at('is_profile_id'),
          is_name_id_f: one_found_row.values_at('is_name_id')
      }
      collect_data[:to_profile] = profile_data_f[:is_profile_id_f][0]
      new_connection_hash = find_profiles_connect(profile_data_s, profile_data_f, collect_data)
    end
    new_connection_hash
  end


    # @note: check & find the SAME profiles found
  def self.find_profiles_connect(profile_data_s, profile_data_f, collect_data)
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
          puts "$$$$ new_connection_hash = #{new_connection_hash} "
        end
      end
    end

    new_connection_hash

  end





end
