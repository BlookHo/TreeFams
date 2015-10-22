module SearchHelper

  #############################################################
  # Иванищев А.В. 2014 - 2015
  # Методы для отображения рез-тов поиска
  #############################################################

  # @note: Logger tree data  # Debug
  def debug_tree_data_logger(tree_data, certain_koeff)
    author_tree_arr      = tree_data[:author_tree_arr]
    tree_profiles        = tree_data[:tree_profiles]
    qty_of_tree_profiles = tree_data[:qty_of_tree_profiles]
    connected_author_arr = tree_data[:connected_author_arr]
    logger.info "======================= RUN start_search ========================= "
    logger.info "B Искомом дереве #{connected_author_arr} - kол-во профилей:  #{qty_of_tree_profiles}"
    show_in_logger(author_tree_arr, "=== результат" )  # DEBUGG_TO_LOGG
    logger.info "Задание на поиск от Дерева Юзера:  author_tree_arr.size = #{author_tree_arr.size}, tree_profiles = #{tree_profiles} "
    logger.info "Коэффициент достоверности: certain_koeff = #{certain_koeff}"
  end

  # @note: DEBUG LOGGER LIST  # Debug
  def debug_logger(logger_data)
    logger.info " "
    logger.info "=== После ПОИСКА по записи № #{logger_data[:all_profile_rows_no]}" # DEBUGG_TO_LOGG
    logger.info "one_profile_relations_hash = #{logger_data[:one_profile_relations_hash]} " # DEBUGG_TO_LOGG
    logger.info "profiles_hash = #{logger_data[:profiles_hash]} " # DEBUGG_TO_LOGG
    logger.info "found_profiles_hash = #{logger_data[:found_profiles_hash]} " # DEBUGG_TO_LOGG
  end

  # @note: collect results vars
  #  Logger of ПРОМЕЖУТОЧНЫЕ РЕЗУЛЬТАТЫ ПОИСКА
  def logger_search_results(search_results_data)
    logger.info "- duplicates_one_to_many = #{search_results_data[:duplicates_one_to_many]}"
    logger.info "- profiles_with_match_hash = #{search_results_data[:profiles_with_match_hash]}"
    logger.info "- (После duplicates_out): uniq_profiles_pairs = #{search_results_data[:uniq_profiles_pairs]}"
    logger.info "- duplicates_many_to_one = #{search_results_data[:duplicates_many_to_one]}"
  end

  ###################### END OF SEARCH.RB methods ##########################################################

  # todo: перенести этот метод в CirclesMethods - для нескольких моделей
  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # Метод получения НЕ общей части 2-х БК профилей
  def get_circles_delta(first_bk, second_bk, common_circle_arr)
    one = (first_bk - common_circle_arr)
    two = (second_bk - common_circle_arr)
    logger.info " get_delta_bk: one = #{one}, two = #{two}"
    # circles_delta = (first_bk - common_circle_arr) + (second_bk - common_circle_arr)
    (first_bk - common_circle_arr) + (second_bk - common_circle_arr)
  end


  # todo: doubled in Search_Circles.rb lib
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

  # todo: doubled in Search_Circles.rb lib
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

  # todo: doubled in Search_Circles.rb lib
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
    new_connection_hash
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
