class ExtraCode


  #ОТОБРАЖЕНИЕ ДАТЫ ИЗ ТАБЛИЦЫ
  @prof = Profile.find(23)#.select(:created_at)#.created_at
  #@prof_date = @prof.created_at.to_s
  @prof_name = @prof.name_id
  @prof_date = @prof.attributes_before_type_cast["created_at"]
  @prof_date2 = @prof.read_attribute_before_type_cast("created_at")

  #FROM module ProfileQuestions

 # Формирование массива хэшей ближнего круга
 #  для дальнейшего анализа
 # ПОРЯДОК - ВАЖЕН, Т.К. ОПРЕДЕЛЕН ЗАРАНЕЕ!!
 def make_one_array_of_hashes

   # Тестовый исходный circle_as_hash(user_id, profile_id)
   @fathers_hash = {173 => 45 }
   @mothers_hash = {172 => 235 , 174 => 354 }
   @brothers_hash = {190 => 73, 191 => 66 }
   @sisters_hash = {1000 => 233, 1001 => 16}
   @wives_hash = {155 => 292 }
   @husbands_hash = {194 => 111 }
   @sons_hash = {156 => 151 }
   @daughters_hash = {153 => 212, 157 => 214 }

   one_array_of_circle_hashes = []
   one_array_of_circle_hashes << @fathers_hash
   one_array_of_circle_hashes << @mothers_hash
   one_array_of_circle_hashes << @brothers_hash
   one_array_of_circle_hashes << @sisters_hash
   one_array_of_circle_hashes << @wives_hash
   one_array_of_circle_hashes << @husbands_hash
   one_array_of_circle_hashes << @sons_hash
   one_array_of_circle_hashes << @daughters_hash

   return one_array_of_circle_hashes
 end


 # Редакция хэшей ближнего кругав зависимости от ответов на вопросы
 # в нестандартных ситуациях.
 def circle_hash_reduction(non_standard_answers_hash, one_array_of_hashes)
   non_standard_answers_hash.each do |key, val|
     one_array_of_hashes.each do |one_elem_hash|
       #@one_elem_hash = one_elem_hash # DEBUGG_TO_VIEW
       one_elem_hash.each do |k,v|
         one_elem_hash.delete_if {|k, v| k == key && val == false}
       end
     end
   end
   return one_array_of_hashes
 end

 # Получение обратно хэшей ближнего круга из массива сокращенных хэшей
 # в нестандартных ситуациях.
 # ПОРЯДОК - ВАЖЕН, Т.К. ОПРЕДЕЛЕН ЗАРАНЕЕ!!
 def make_circle_hashes_reduced(one_array_of_reduced_hashes)

   one_array_of_reduced_hashes.each_with_index do |elem, index|
     case index
       when 0
         @fathers_hash = elem
       when 1
         @mothers_hash = elem
       when 2
         @brothers_hash = elem
       when 3
         @sisters_hash = elem
       when 4
         @wives_hash = elem
       when 5
         @husbands_hash = elem
       when 6
         @sons_hash = elem
       when 7
         @daughters_hash = elem
       else
         "Nothing"
     end
   end

   @reduced_fathers_hash = @fathers_hash       # DEBUGG_TO_VIEW
   @reduced_mothers_hash = @mothers_hash       # DEBUGG_TO_VIEW
   @reduced_brothers_hash = @brothers_hash     # DEBUGG_TO_VIEW
   @reduced_sisters_hash = @sisters_hash       # DEBUGG_TO_VIEW
   @reduced_wives_hash = @wives_hash           # DEBUGG_TO_VIEW
   @reduced_husbands_hash = @husbands_hash     # DEBUGG_TO_VIEW
   @reduced_sons_hash = @sons_hash             # DEBUGG_TO_VIEW
   @reduced_daughters_hash = @daughters_hash   # DEBUGG_TO_VIEW

 end




  # Ввод одного профиля древа. Проверка Имя-Пол.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place
  def enter_profile_bk(profile_name)    # NO USE
    # проверка, действ-но ли введено женское имя?
    if !profile_name.blank?
      if !check_sex_by_name(profile_name)
        name_correct = true
      else
        name_correct = false
      end
    end
    return name_correct
  end




  # СТАРЫЙ МЕТОД ОПРЕДЕЛЕНИЯ СОВПАДАЮЩИХ ПРОФИЛЕЙ ДЛЯ ПЕРЕЗАПИСИ ПРИ ОБЪЕДИНЕНИИ
  # Метод дла получения массива обратных профилей для
  # перезаписи профилей в таблицах
  # opposite_profiles_arr # DEBUGG_TO_VIEW
  # who_conn_users_arr - массив id, входящих в объед-ное дерево автора (того, кто соединяется)
  # with_who_con_usrs_ar - массив id, входящих в объед-ное дерево того, с кем соединяется автор
  # found_profiles, found_relations

  ######## Обработка результатов поиска для определения профилей для перезаписи
  ######## для метода get_opposite_profiles_old
  # !! СОБИРАЕМ МАССИВЫ НАЙДЕННЫХ ПРОФИЛЕЙ ПО ВСЕМ ЮЗЕРАМ В ДЕРЕВЬЯХ - Т.Е.
  # ПО ВСЕМУ @with_whom_connect_users_arr.
  #matched_profiles_in_tree = []
  #matched_relations_in_tree = []
  #users_in_results = @final_reduced_profiles_hash.keys # users, найденные в поиске
  #@users_in_results = users_in_results#.uniq # DEBUGG_TO_VIEW
  #with_whom_connect_users_arr.each do |user_id_in_conn_tree|
  #  if users_in_results.include?(user_id_in_conn_tree.to_i) # для исключения случая,
  #    # когда в рез-тах поиска (@final_reduced_profiles_hash)
  #    # не для всех юзеров из объед-го дерева (with_whom_connect_users_arr) - есть рез-ты
  #    matched_profiles_arr = @final_reduced_profiles_hash.values_at(user_id_in_conn_tree.to_i)[0].values.flatten
  #    matched_relations_arr = @final_reduced_relations_hash.values_at(user_id_in_conn_tree.to_i)[0].values.flatten
  #    matched_profiles_in_tree << matched_profiles_arr
  #    matched_relations_in_tree << matched_relations_arr
  #  end
  #end
  #found_profiles = matched_profiles_in_tree.flatten(1)  # get one dimension arr
  #@found_profiles = found_profiles#.uniq # DEBUGG_TO_VIEW
  #found_relations = matched_relations_in_tree.flatten(1) # get one dimension arr
  #@found_relations = found_relations#.uniq # DEBUGG_TO_VIEW
  #@matched_profiles_in_tree = matched_profiles_in_tree # DEBUGG_TO_VIEW

  # Управляемый Метод для изготовления 2-х синхронных UNIQ массивов: found_profiles_uniq, found_relations_uniq
  #found_profiles_uniq, found_relations_uniq = make_uniq_arrays(found_profiles, found_relations)

  def get_opposite_profiles_old(who_conn_users_arr, with_who_con_usrs_ar, found_profiles, found_relations)
    opposite_profiles_arr = []  # DEBUGG_TO_VIEW
    profiles_to_rewrite = [] # - массив профилей, которые остаются
    profiles_to_destroy = [] # - массив профилей, которые удаляются
    profiles_relations = [] # - массив отношений, для тех, которые сохраняются в массивах
    @rewrite_and_destroy_hash = Hash.new
    logger.info "DEBUG in get_opposite_profiles: START "
    logger.info " Input users: who_conn_users_arr = #{who_conn_users_arr},  with_who_con_usrs_ar = #{with_who_con_usrs_ar}"
    logger.info " Input arrays: found_profiles = #{found_profiles},  found_relations = #{found_relations}"

    for arr_ind in 0 .. found_profiles.length-1
      one_profile = found_profiles[arr_ind]
      #@one_profile = one_profile # DEBUGG_TO_VIEW
      one_relation = found_relations[arr_ind]
      logger.info " For:  one_profile = #{one_profile},  one_relation = #{one_relation}"
      logger.info " Before each: with_who_con_usrs_ar = #{with_who_con_usrs_ar}"
      with_who_con_usrs_ar.each do |one_user_in_tree|
        logger.info " In with_who-Each:  with_who_con_usrs_ar[each] = #{one_user_in_tree} "
        where_found_tree_row = Tree.where(:user_id => one_user_in_tree, :is_profile_id => one_profile.to_i)[0]
        #@where_found_tree_row = where_found_tree_row # DEBUGG_TO_VIEW
        if !where_found_tree_row.blank?
          logger.info " In with-Each:  where_found_tree_row.is_name_id = #{where_found_tree_row.is_name_id} "
          logger.info " Before each: who_conn_users_arr = #{who_conn_users_arr} "
          who_conn_users_arr.each do |one_user_in_conn_tree|
            logger.info " In who_conn-Each:  who_conn_users_arr[each] = #{one_user_in_conn_tree} "
            who_found_tree_row = Tree.where(:user_id => one_user_in_conn_tree, :is_name_id => where_found_tree_row.is_name_id.to_i, :relation_id => one_relation,:is_sex_id => where_found_tree_row.is_sex_id.to_i)[0]

            if !who_found_tree_row.blank?
              logger.info " In who_conn-Each:  who_found_tree_row.is_profile_id = #{who_found_tree_row.is_profile_id} "
              opposite_profiles_arr << who_found_tree_row.is_profile_id # DEBUGG_TO_VIEW
              if who_found_tree_row.is_profile_id < found_profiles[arr_ind].to_i
                profiles_to_rewrite << who_found_tree_row.is_profile_id
                profiles_to_destroy << found_profiles[arr_ind].to_i
                @rewrite_and_destroy_hash.merge!({who_found_tree_row.is_profile_id => found_profiles[arr_ind].to_i})
                # NB перезапись под одним key, если несколько записей!
                profiles_relations << one_relation.to_i
              else
                profiles_to_rewrite << found_profiles[arr_ind].to_i
                profiles_to_destroy  << who_found_tree_row.is_profile_id
                @rewrite_and_destroy_hash.merge!({found_profiles[arr_ind].to_i => who_found_tree_row.is_profile_id})
                # NB перезапись под одним key, если несколько записей!
                profiles_relations << one_relation.to_i
              end
            end
            logger.info "Growing: To_rewrite arr = #{profiles_to_rewrite}; To_destroy arr = #{profiles_to_destroy}."
            logger.info "Growing: @profiles_relations = #{profiles_relations};"

          end
        end

      end
    end
    @profiles_to_rewrite = profiles_to_rewrite # DEBUGG_TO_VIEW
    @profiles_to_destroy = profiles_to_destroy # DEBUGG_TO_VIEW
    @profiles_relations = profiles_relations # DEBUGG_TO_VIEW
    logger.info "Final Массивы для объединения: To_rewrite arr = #{profiles_to_rewrite}; To_destroy arr = #{profiles_to_destroy}."
    logger.info "Final Массив relations для объединения: @profiles_relations = #{profiles_relations};"
    logger.info "DEBUG in get_opposite_profiles: END"

    return @rewrite_and_destroy_hash, opposite_profiles_arr, profiles_to_rewrite, profiles_to_destroy, profiles_relations
  end

  ConnectUsersTreesController

  # ИСПОЛЬЗУЕТСЯ В ПОИСКЕ И МЕТОДЕ ОБЪЕДИНЕНИЯ ДЕРЕВЬЕВ - connection_of_trees
  # Получение массива дерева соединенных Юзеров из Tree
  # На входе - массив соединенных Юзеров
  def get_connected_tree(connected_users_arr)
    #tree_arr = []
    #check_tree_arr = [] # "опорный массив" - для удаления повторных элементов при формировании tree_arr
    #connected_users_arr.each do |one_user|
    #  user_tree = Tree.where(:user_id => one_user)
    #  row_arr = []
    #  check_row_arr = []
    #
    #  user_tree.each do |tree_row|
    #    row_arr[0] = tree_row.user_id              # user_id ID От_Профиля
    #    row_arr[1] = tree_row.profile_id           # ID От_Профиля (From_Profile)
    #    row_arr[2] = tree_row.name_id              # name_id ID От_Профиля
    #    row_arr[3] = tree_row.relation_id          # ID Родства От_Профиля с К_Профилю (To_Profile)
    #    row_arr[4] = tree_row.is_profile_id        # ID К_Профиля
    #    row_arr[5] = tree_row.is_name_id           # name_id К_Профиля
    #    row_arr[6] = tree_row.is_sex_id            # sex К_Профиля
    #
    #    check_row_arr[0] = tree_row.profile_id           # ID От_Профиля (From_Profile)
    #    check_row_arr[1] = tree_row.name_id              # name_id ID От_Профиля
    #    check_row_arr[2] = tree_row.relation_id          # ID Родства От_Профиля с К_Профилю (To_Profile)
    #    check_row_arr[3] = tree_row.is_profile_id        # ID К_Профиля
    #    check_row_arr[4] = tree_row.is_name_id           # name_id К_Профиля
    #    check_row_arr[5] = tree_row.is_sex_id            # sex К_Профиля
    #
    #    #logger.info "DEBUG IN get_connection_of_trees: #{tree_arr.include?(row_arr).inspect}" # == false
    #    #logger.info "DEBUG IN get_connection_of_trees: #{tree_arr.inspect} --- #{row_arr}"
    #    if !check_tree_arr.include?(check_row_arr) # контроль на наличие повторов
    #      tree_arr << row_arr
    #      check_tree_arr << check_row_arr
    #    end
    #    row_arr = []
    #    check_row_arr = []
    #  end
    #end
    #logger.info "IN get_connected_tree: check_tree_arr: #{check_tree_arr.inspect} "

    tree_arr = Tree.where(:user_id => connected_users_arr).select(:profile_id,:name_id,:relation_id,:is_profile_id,:is_name_id,:is_sex_id).distinct
    return tree_arr
  end




  ######  Запуск поиска 1-й версии - самый первый
  ## ПЕРВЫЙ МЕТОД ОПРЕДЕЛЕНИЯ СОВПАДАЮЩИХ ПРОФИЛЕЙ ДЛЯ ПЕРЕЗАПИСИ ПРИ ОБЪЕДИНЕНИИ
  ## Метод дла получения массива обратных профилей для
  ## перезаписи профилей в таблицах
  ## opposite_profiles_arr # DEBUGG_TO_VIEW
  ## who_conn_users_arr - массив id, входящих в объед-ное дерево автора (того, кто соединяется)
  ## with_who_con_usrs_ar - массив id, входящих в объед-ное дерево того, с кем соединяется автор
  ## found_profiles, found_relations
  #
  ## Управляемый Метод для изготовления 2-х синхронных UNIQ массивов: found_profiles_uniq, found_relations_uniq
  ##found_profiles_uniq, found_relations_uniq = make_uniq_arrays(found_profiles, found_relations)
  #
  def get_opposite_profiles_first(search_results,who_conn_users_arr, with_who_con_usrs_ar) #, final_reduced_profiles_hash, final_reduced_relations_hash)

    final_reduced_profiles_hash = search_results[:final_reduced_profiles_hash]
    final_reduced_relations_hash = search_results[:final_reduced_relations_hash]

    ######## Обработка результатов поиска для определения профилей для перезаписи
    ######## для метода get_opposite_profiles_old
    # !! СОБИРАЕМ МАССИВЫ НАЙДЕННЫХ ПРОФИЛЕЙ ПО ВСЕМ ЮЗЕРАМ В ДЕРЕВЬЯХ - Т.Е.
    # ПО ВСЕМУ @with_whom_connect_users_arr.
    matched_profiles_in_tree = []
    matched_relations_in_tree = []
    users_in_results = final_reduced_profiles_hash.keys # users, найденные в поиске
    @users_in_results = users_in_results#.uniq # DEBUGG_TO_VIEW
    with_who_con_usrs_ar.each do |user_id_in_conn_tree|
      if users_in_results.include?(user_id_in_conn_tree.to_i) # для исключения случая,
        # когда в рез-тах поиска (@final_reduced_profiles_hash)
        # не для всех юзеров из объед-го дерева (with_whom_connect_users_arr) - есть рез-ты
        matched_profiles_arr = final_reduced_profiles_hash.values_at(user_id_in_conn_tree.to_i)[0].values.flatten
        matched_relations_arr = final_reduced_relations_hash.values_at(user_id_in_conn_tree.to_i)[0].values.flatten
        matched_profiles_in_tree << matched_profiles_arr
        matched_relations_in_tree << matched_relations_arr
      end
    end
    found_profiles = matched_profiles_in_tree.flatten(1)  # get one dimension arr
    @found_profiles = found_profiles#.uniq # DEBUGG_TO_VIEW
    found_relations = matched_relations_in_tree.flatten(1) # get one dimension arr
    @found_relations = found_relations#.uniq # DEBUGG_TO_VIEW
    @matched_profiles_in_tree = matched_profiles_in_tree # DEBUGG_TO_VIEW


    opposite_profiles_arr = []  # DEBUGG_TO_VIEW
    profiles_to_rewrite = [] # - массив профилей, которые остаются
    profiles_to_destroy = [] # - массив профилей, которые удаляются
    profiles_relations = [] # - массив отношений, для тех, которые сохраняются в массивах
    @rewrite_and_destroy_hash = Hash.new
    logger.info "DEBUG in get_opposite_profiles: START "
    logger.info " Input users: who_conn_users_arr = #{who_conn_users_arr},  with_who_con_usrs_ar = #{with_who_con_usrs_ar}"
    logger.info " Input arrays: found_profiles = #{found_profiles},  found_relations = #{found_relations}"

    for arr_ind in 0 .. found_profiles.length-1
      one_profile = found_profiles[arr_ind]
      #@one_profile = one_profile # DEBUGG_TO_VIEW
      one_relation = found_relations[arr_ind]
      logger.info " For:  one_profile = #{one_profile},  one_relation = #{one_relation}"
      logger.info " Before each: with_who_con_usrs_ar = #{with_who_con_usrs_ar}"
      with_who_con_usrs_ar.each do |one_user_in_tree|
        logger.info " In with_who-Each:  with_who_con_usrs_ar[each] = #{one_user_in_tree} "
        where_found_tree_row = Tree.where(:user_id => one_user_in_tree, :is_profile_id => one_profile.to_i)[0]
        #@where_found_tree_row = where_found_tree_row # DEBUGG_TO_VIEW
        if !where_found_tree_row.blank?
          logger.info " In with-Each:  where_found_tree_row.is_name_id = #{where_found_tree_row.is_name_id} "
          logger.info " Before each: who_conn_users_arr = #{who_conn_users_arr} "
          who_conn_users_arr.each do |one_user_in_conn_tree|
            logger.info " In who_conn-Each:  who_conn_users_arr[each] = #{one_user_in_conn_tree} "
            who_found_tree_row = Tree.where(:user_id => one_user_in_conn_tree, :is_name_id => where_found_tree_row.is_name_id.to_i, :relation_id => one_relation,:is_sex_id => where_found_tree_row.is_sex_id.to_i)[0]

            if !who_found_tree_row.blank?
              logger.info " In who_conn-Each:  who_found_tree_row.is_profile_id = #{who_found_tree_row.is_profile_id} "
              opposite_profiles_arr << who_found_tree_row.is_profile_id # DEBUGG_TO_VIEW
              if who_found_tree_row.is_profile_id < found_profiles[arr_ind].to_i
                profiles_to_rewrite << who_found_tree_row.is_profile_id
                profiles_to_destroy << found_profiles[arr_ind].to_i
                @rewrite_and_destroy_hash.merge!({who_found_tree_row.is_profile_id => found_profiles[arr_ind].to_i})
                # NB перезапись под одним key, если несколько записей!
                profiles_relations << one_relation.to_i
              else
                profiles_to_rewrite << found_profiles[arr_ind].to_i
                profiles_to_destroy  << who_found_tree_row.is_profile_id
                @rewrite_and_destroy_hash.merge!({found_profiles[arr_ind].to_i => who_found_tree_row.is_profile_id})
                # NB перезапись под одним key, если несколько записей!
                profiles_relations << one_relation.to_i
              end
            end
            logger.info "Growing: To_rewrite arr = #{profiles_to_rewrite}; To_destroy arr = #{profiles_to_destroy}."
            logger.info "Growing: @profiles_relations = #{profiles_relations};"

          end
        end

      end
    end
    @profiles_to_rewrite = profiles_to_rewrite # DEBUGG_TO_VIEW
    @profiles_to_destroy = profiles_to_destroy # DEBUGG_TO_VIEW
    @profiles_relations = profiles_relations # DEBUGG_TO_VIEW
    logger.info "Final Массивы для объединения: To_rewrite arr = #{profiles_to_rewrite}; To_destroy arr = #{profiles_to_destroy}."
    logger.info "Final Массив relations для объединения: @profiles_relations = #{profiles_relations};"
    logger.info "DEBUG in get_opposite_profiles: END"

    return profiles_to_rewrite, profiles_to_destroy
  end

  ## Для SEARCH_HARD!
  ## Метод определения массивов перезаписи профилей при объединении деревьев
  ## На входе: рез-тат жесткого поиска совпавших профилей - при совпадении их БК
  ## Далее начинаем цикл по профилям, кот-е участвуют в БК совпавших профилей при жестком поиске
  ## Поэтапное наполнение массивов перезаписи
  ##
  def get_rewrite_profiles_by_bk(search_results) # используется только вместе с start_hard_search

    ######## Сбор рез-тов поиска, необходимых для объединения:
    # !!!! ЗДЕСЬ - ВАЖЕН ПОРЯДОК ПРИСВАИВАНИЯ !!! - КАК ВПОЛУЧЕНИИ search_results!/
    @final_hard_profiles_to_connect_hash = search_results[:final_hard_profiles_to_connect_hash]
    @final_pos_profiles_arr = search_results[:final_pos_profiles_arr]
    @final_profiles_searched_arr = search_results[:final_profiles_searched_arr]
    @final_profiles_found_arr = search_results[:final_profiles_found_arr]
    @final_search_profiles_step_arr = search_results[:final_search_profiles_step_arr]
    @final_found_profiles_step_arr = search_results[:final_found_profiles_step_arr]

    logger.info ""
    logger.info "** IN connection_of_trees ******** "
    logger.info "@final_hard_profiles_to_connect_hash = #{@final_hard_profiles_to_connect_hash}"
    # Текущий Хэш профилей для объдинения
    # Получен из search_hard
    # Далее - его наращивание новыми парами профилей для объединения.
    #who_connect_users_arr = current_user.get_connected_users
    #with_whom_connect_users_arr = User.find(user_id).get_connected_users  #
    #logger.info "who_connect_users_arr = #{who_connect_users_arr}, with_whom_connect_users_arr = #{with_whom_connect_users_arr}"
    current_profiles_connect_hash = {}

    logger.info "################ TO DO!!! IN HARD SEARCH ##################"
    #@final_search_profiles_step_arr = [[17, 19], [16, 20, 18]] # from hard_search
    #@final_found_profiles_step_arr = [[27, 30], [28, 29, 24]] # from hard_search
    logger.info "@final_search_profiles_step_arr = #{@final_search_profiles_step_arr}"
    logger.info "@final_found_profiles_step_arr = #{@final_found_profiles_step_arr}"

    ######## Дальнейшее Определение массивов профилей для перезаписи ПО ДАННЫМ ИЗ Hard_Search
    ##############################################################################
    logger.info "##### NEW METHOD - TO DETERMINE REWRITE & DESTROY PROFILES BEFORE TREES CONNECTION"
    for arr_ind in 1 .. @final_search_profiles_step_arr.size - 1
      one_search_arr = @final_search_profiles_step_arr[arr_ind]
      one_found_arr = @final_found_profiles_step_arr[arr_ind]
      logger.info "one_search_arr = #{one_search_arr}, one_found_arr = #{one_found_arr}"
      #new_connection_hash = {}

      one_search_arr.each_with_index do |profile_searched, index|
        logger.info "one_search_arr=profile_searched = #{profile_searched}, index = #{index}"
        profile_found = one_found_arr[index]
        logger.info "one_found_arr=profile_found = #{profile_found}, index = #{index}"

        profile_searched_user_id = Profile.find(profile_searched).tree_id
        searched_profile_circle = get_one_profile_BK(profile_searched, profile_searched_user_id)
        logger.info "=== БЛИЖНИЙ КРУГ ИСКОМОГО ПРОФИЛЯ = #{profile_searched} "
        show_in_logger(searched_profile_circle, "= ряд " )  # DEBUGG_TO_LOGG
        search_bk_arr, search_bk_profiles_arr = make_arr_hash_BK(searched_profile_circle)

        profile_found_user_id = Profile.find(profile_found).tree_id
        found_profile_circle = get_one_profile_BK(profile_found, profile_found_user_id)
        logger.info "=== БЛИЖНИЙ КРУГ НАЙДЕННОГО ПРОФИЛЯ = #{profile_found} "
        show_in_logger(found_profile_circle, "= ряд " )  # DEBUGG_TO_LOGG
        found_bk_arr, found_bk_profiles_arr = make_arr_hash_BK(found_profile_circle)

        logger.info " Compare_two_BK: ИСКОМОГО ПРОФИЛЯ = #{profile_searched} и НАЙДЕННОГО ПРОФИЛЯ = #{profile_found}:"
        compare_rezult, rez_bk_arr = compare_two_BK(found_bk_arr, search_bk_arr)
        logger.info " compare_rezult = #{compare_rezult}"
        logger.info " ПЕРЕСЕЧЕНИЕ двух БК: rez_bk_arr = #{rez_bk_arr}"

        if !rez_bk_arr.blank? # Если rez_bk_arr != [] - есть какое-то ПЕРЕСЕЧЕНИЕ при сравнении 2-х БК

          new_field_arr_searched, new_field_arr_found, new_connection_hash = get_fields_arrays_from_bk(search_bk_profiles_arr, found_bk_profiles_arr )
          new_field_arr_searched = new_field_arr_searched.flatten(1)
          new_field_arr_found = new_field_arr_found.flatten(1)
          logger.info "=ВАРИАНТ Extraxt is_profile_id из пересечения 2-х БК если оно есть"
          logger.info " new_field_arr_searched = #{new_field_arr_searched}, new_field_arr_found = #{new_field_arr_found} "
          logger.info " new_connection_hash = #{new_connection_hash} "
          logger.info " "
        else
          new_connection_hash = {}
        end

        @new_connection_hash = new_connection_hash  # DEBUGG_TO_VIEW
        diff_hash = current_profiles_connect_hash.diff(new_connection_hash) ###
        # ## DEPRECATION WARNING: Hash#diff is no longer used inside of Rails, and is being deprecated with no replacement.

        logger.info " current_profiles_connect_hash = #{current_profiles_connect_hash} "
        logger.info " new_connection_hash = #{new_connection_hash} "
        logger.info " diff_hash = #{diff_hash} "
        logger.info " "

        current_profiles_connect_hash = current_profiles_connect_hash.merge!(diff_hash)
        logger.info "current_profiles_connect_hash = #{current_profiles_connect_hash} "
        logger.info " "

      end
      current_profiles_connect_hash = current_profiles_connect_hash.merge!(current_profiles_connect_hash)

    end

    logger.info "@final_hard_profiles_to_connect_hash = #{@final_hard_profiles_to_connect_hash}"
    logger.info "ALL current_profiles_connect_hash = #{current_profiles_connect_hash} "
    logger.info " "

    profiles_to_rewrite = current_profiles_connect_hash.keys
    profiles_to_destroy = current_profiles_connect_hash.values

    logger.info "@final_profiles_searched_arr = #{@final_profiles_searched_arr}, @final_profiles_found_arr = #{@final_profiles_found_arr}"
    logger.info "ALL profiles_to_rewrite = #{profiles_to_rewrite} "
    logger.info "ALL profiles_to_destroy = #{profiles_to_destroy} "

    return profiles_to_rewrite, profiles_to_destroy

  end ## END OF NEW METHOD определения массивов для перезаписи

  ## Для SEARCH_SOFT!
  ## Метод дла получения массива обратных профилей для
  ## перезаписи профилей в таблицах
  ## who_conn_users_arr - массив id, входящих в объед-ное дерево автора (того, кто соединяется)
  ## with_who_con_usrs_ar - массив id, входящих в объед-ное дерево того, с кем соединяется автор
  ## searched_profiles_hash, searched_relations_hash
  def get_opposite_profiles(search_results, who_conn_users_arr, with_who_con_usrs_ar) #, searched_profiles_hash, searched_relations_hash)

    searched_profiles_hash = search_results[:final_reduced_profiles_hash]
    searched_relations_hash = search_results[:final_reduced_relations_hash]

    profiles_to_rewrite = [] # - массив профилей, которые остаются
    profiles_to_destroy = [] # - массив профилей, которые удаляются
    profiles_relations = [] # - массив отношений, для тех, которые сохраняются в массивах
    logger.info "============= DEBUG in get_opposite_profiles: START ========================="
    logger.info " Input users: who_conn_users_arr = #{who_conn_users_arr},  with_who_con_usrs_ar = #{with_who_con_usrs_ar}, searched_profiles_hash = #{searched_profiles_hash},  searched_relations_hash = #{searched_relations_hash} "

    searched_profiles_hash.each do |where_key, what_values|
      if with_who_con_usrs_ar.include?(where_key) # для исключения случая, когда рез-тат поиска не относится
        # к объединяемым деревьям - эти деревья исключаем из рассмотрения и формирования массивов перезаписи.
        relations_hash = searched_relations_hash.values_at(where_key)[0] # параллельное вытягивание relations
        logger.info " In searched_profiles_hash.each: where_key = #{where_key},  with_who_con_usrs_ar = #{with_who_con_usrs_ar},  what_values = #{what_values}, relations_hash = #{relations_hash} "

        what_values.each do |one_profile_who, what_profiles_arr|
          who_conn_user_tree_id = Profile.find(one_profile_who).tree_id
          logger.info " In what_values.each: one_profile_who = #{one_profile_who},  what_profiles_arr = #{what_profiles_arr}, who_conn_user_tree_id = #{who_conn_user_tree_id} "
          if !who_conn_user_tree_id.blank?

            one_relations_arr = relations_hash.values_at(one_profile_who)[0]  # параллельное вытягивание relations
            logger.info " one_relations_arr = #{one_relations_arr}"
            what_profiles_arr.each_with_index do |profile_to_find, index|
              where_found_tree_row = Tree.where(:user_id => where_key, :is_profile_id => profile_to_find)[0]

              if !where_found_tree_row.blank?
                is_name = where_found_tree_row.is_name_id
                is_sex = where_found_tree_row.is_sex_id
                one_relation = one_relations_arr[index] # параллельное вытягивание relations
                logger.info " In what_profiles_arr.each: profile_to_find = #{profile_to_find}, is_name = #{is_name}, is_sex = #{is_sex}, one_relations_arr[#{index}] = #{one_relation} "
                who_found_tree_row = Tree.where(:user_id => who_conn_user_tree_id, :is_name_id => is_name, :relation_id => one_relation, :is_sex_id => is_sex)[0]

                if !who_found_tree_row.blank?
                  found_is_profile = who_found_tree_row.is_profile_id
                  if profile_to_find < found_is_profile
                    if !profiles_to_rewrite.include?(profile_to_find) # для исключения случая повтора профиля в результ. массивах
                      profiles_to_rewrite << profile_to_find
                      profiles_to_destroy << found_is_profile
                      logger.info " In make arrays: profile_to_find = #{profile_to_find}, found_is_profile = #{found_is_profile}, profiles_to_rewrite = #{profiles_to_rewrite} , profiles_to_destroy = #{profiles_to_destroy} "
                      profiles_relations << one_relation  # does not need - for controle
                    end
                  else
                    if !profiles_to_rewrite.include?(found_is_profile) # для исключения случая повтора профиля в результ. массивах
                      profiles_to_rewrite << found_is_profile
                      profiles_to_destroy  << profile_to_find
                      logger.info " In make arrays: profile_to_find = #{profile_to_find}, found_is_profile = #{found_is_profile}, profiles_to_rewrite = #{profiles_to_rewrite} , profiles_to_destroy = #{profiles_to_destroy} "
                      profiles_relations << one_relation  # does not need - for controle
                    end
                  end
                  logger.info "= Ok ====== ONE CICLE IS OVER index = #{index} In Connect_users:each in what_profiles_arr ========= "

                else
                  logger.info "ERROR In Connect_users:each in what_profiles_arr.each: who_found_tree_row - Not found in Tree!"
                end

              else
                logger.info "ERROR In Connect_users:each in what_profiles_arr.each: where_found_tree_row - Not found in Tree!"
              end

            end

          else
            logger.info "ERROR In Connect_users:each in what_values.each: who_conn_user_tree_id - Not found in Profile!"
          end

        end

      else
        logger.info "Ok SKIP In search results: where_key = #{where_key},  with_whom_connnecting_users_ar = #{with_who_con_usrs_ar}!"
      end


    end
    logger.info " Готовы Массивы для объединения: To_rewrite arr = #{profiles_to_rewrite}; To_destroy arr = #{profiles_to_destroy}, (для контроля и отладки): profiles_relations = #{profiles_relations}."
    logger.info "============== get_opposite_profiles = DEBUG END ========================="

    return profiles_to_rewrite, profiles_to_destroy#, profiles_relations
  end










  MainController

  #  @us_id = 2    #    IS DISTINCT FROM 2        # TRY RAILS 4 DEBUGG

  # ПОИСК С ПОМОЩЬЮ СГЕНЕРИРОВАННОЙ СТРОКИ sql
  # search_str = "relation_id = #{@all_fathers_relations_arr[0]} "
  #for str in 1 .. @all_fathers_relations_arr.length-1
  #  add_str = " OR relation_id = #{@all_fathers_relations_arr[str]} " #where( "#{search_str}" )
  #  search_str = search_str.concat(add_str)
  #end
  #@search_relations_str = search_str

Из Нового поиска

  case relation # Определение вида поиска по значению relation внутри БК current_user

    when 1    # "father"
      @search_profiles_relation = "father"   # DEBUGG TO VIEW
      get_relation_match(profiles_tree_arr[tree_index][6])  # На выходе: @all_match_arr по данному виду родства

    when 2    # "mother"
      @search_profiles_relation = "mother"   # DEBUGG TO VIEW
      get_relation_match(profiles_tree_arr[tree_index][6])

    when 3   # "son"
      @search_profiles_relation = "son"   # DEBUGG TO VIEW
      get_relation_match(profiles_tree_arr[tree_index][6])

    when 4   # "daughter"
      @search_profiles_relation = "daughter"   # DEBUGG TO VIEW
      get_relation_match(profiles_tree_arr[tree_index][6])

    when 5  # "brother"
      @search_profiles_relation = "brother"   # DEBUGG TO VIEW
      get_relation_match(profiles_tree_arr[tree_index][6])

    when 6   # "sister"
      @search_profiles_relation = "sister"   # DEBUGG TO VIEW
      get_relation_match(profiles_tree_arr[tree_index][6])

    when 7   # "husband"
      @search_profiles_relation = "husband"   # DEBUGG TO VIEW
      get_relation_match(profiles_tree_arr[tree_index][6])

    when 8   # "wife"
      @search_profiles_relation = "wife"   # DEBUGG TO VIEW
      get_relation_match(profiles_tree_arr[tree_index][6])

    else
      @search_profiles_relation = "ERROR: no relation in tree profile"

  end

  # Для метода формирования путей для каждого из рещультатов поиска
  # Этот вариант - без вложенного метода (закомментин)
  # Делаем один path рез-тов поиска - далее он включается в итоговый хэш
  #
  def make_path(tree_hash, finish_profile, results_qty)
    @one_path_hash = Hash.new
    end_profile = finish_profile

    #qty = 0
    #start_elem_arr = tree_hash.values_at(finish_profile)[0] #
    #@relation_to_next_profile = start_elem_arr[0]
    #@elem_next_profile = start_elem_arr[1]
    #qty = results_qty if end_profile == finish_profile
    #@one_path_hash.merge!(make_one_hash_in_path(end_profile, @relation_to_next_profile, qty))

    @one_path_hash, @relation_to_next_profile, @elem_next_profile = add_one_hash_to_one_path(tree_hash, finish_profile, results_qty, end_profile)

    while @relation_to_next_profile != 0 do

      #qty = 0
      #start_elem_arr = tree_hash.values_at(@elem_next_profile)[0] #
      #@new_elem_relation = start_elem_arr[0]
      #@new_next_profile = start_elem_arr[1]
      #qty = results_qty if @elem_next_profile == finish_profile
      #@one_path_hash.merge!(make_one_hash_in_path(@elem_next_profile, @new_elem_relation, qty))

      @one_path_hash, @new_elem_relation, @new_next_profile = add_one_hash_to_one_path(tree_hash, finish_profile, results_qty, @elem_next_profile)

      @elem_next_profile = @new_next_profile
      @relation_to_next_profile = @new_elem_relation

    end
    return Hash[@one_path_hash.to_a.reverse] #.reverse_order - чтобы шли от автора

  end

  #
  #  Этот Метод - к вышеуказанному
  # Добавляем один хэш в один path рез-тов поиска
  #
  def add_one_hash_to_one_path(tree_hash, finish_profile, results_qty, end_profile)

    qty = 0
    start_elem_arr = tree_hash.values_at(end_profile)[0] #
    relation_to_next_profile = start_elem_arr[0]
    elem_next_profile = start_elem_arr[1]
    qty = results_qty if end_profile == finish_profile
    @one_path_hash.merge!(make_one_hash_in_path(end_profile, relation_to_next_profile, qty))

    return @one_path_hash, relation_to_next_profile, elem_next_profile
  end





  Старый поиск
  #    search_tree_match    # Пeрвый старый вариант - Основной поиск по дереву Автора - Юзера.

  # Поиск id всех жен usera дерева.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_user_wife_profile_ids(user_id)  #
    user_wife_ids = [] # Массив profile_id жен Юзера
    user_wife_ids << Tree.where(user_id: user_id ).where("relation_id = 8").select(:profile_id).pluck(:profile_id)
    user_wife_ids = user_wife_ids.flatten if !user_wife_ids.blank? # массив объединен
  end
  # Поиск id имен жен usera дерева. АВТОР - зареген
  # @note
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_user_wife_names_ids(wives_ids)
    if !wives_ids.blank? # если есть жены в дереве usera
      user_wives_names_ids = []
      wives_ids.each do |wife|
        user_wives_names_ids <<  Profile.find(wife).name_id  # массив имен жен usera
      end
    end
    user_wives_names_ids = user_wives_names_ids.sort if !user_wives_names_ids.blank? #  # массив имен упорядочен
  end

  # Поиск id всех детей usera дерева.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_user_kids_profile_ids(user_id)  #
    user_kids_ids = [] # Массив profile_id всех детей usera
    user_kids_ids << Tree.where(user_id: user_id ).where("relation_id = 3 OR relation_id = 4").select(:profile_id).pluck(:profile_id)
    user_kids_ids = user_kids_ids.flatten if !user_kids_ids.blank? # массив объединен
  end
  # Поиск id имен детей usera дерева. АВТОР - зареген
  # @note
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_user_kids_names_ids(kids_ids)
    if !kids_ids.blank? # если есть дети в дереве usera
      user_kids_names_ids = []
      kids_ids.each do |kid|
        user_kids_names_ids <<  Profile.find(kid).name_id  # массив имен детей usera
      end
    end
    user_kids_names_ids = user_kids_names_ids.sort if !user_kids_names_ids.blank? #  # массив имен упорядочен
  end

  # Поиск id сыновей автора дерева. АВТОР - зареген
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_auther_sons_profile_ids  #
    author_sons_ids = [] # Массив id всех сыновей автора
    author_sons_ids << Tree.where(user_id: current_user.id ).where("relation_id = 3").select(:profile_id).pluck(:profile_id)
    author_sons_ids = author_sons_ids.flatten if !author_sons_ids.blank? # массив объединен
  end

  # Поиск id имен сыновей автора дерева. АВТОР - зареген
  # @note triplex_arr
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_auther_sons_names_ids(son_ids)
    if !son_ids.blank? # если найдены братья и сестры в дереве автора
      author_sons_names_ids = []
      #     author_br_sis_names_ids << triplex_arr[0][2] if !triplex_arr.blank? # массив id имен братьев и сестер автора
      son_ids.each do |brother|
        author_sons_names_ids <<  Profile.find(brother).name_id  # массив имен найденных братьев и сестер автора
      end
    end
    author_sons_names_ids = author_sons_names_ids.sort if !author_sons_names_ids.blank? #  # массив имен упорядочен
  end

  # Поиск id дочерей автора дерева. АВТОР - зареген
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_auther_daughters_profile_ids  #
    author_daughters_ids = [] # Массив id всех дочерей автора
    author_daughters_ids << Tree.where(user_id: current_user.id ).where("relation_id = 4").select(:profile_id).pluck(:profile_id)
    author_daughters_ids = author_daughters_ids.flatten if !author_daughters_ids.blank? # массив объединен
  end

  # Поиск id имен дочерей автора дерева. АВТОР - зареген
  # @note triplex_arr
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_auther_daughters_names_ids(daughter_ids)
    if !daughter_ids.blank? # если найдены братья и сестры в дереве автора
      author_daughters_names_ids = []
      #     author_br_sis_names_ids << triplex_arr[0][2] if !triplex_arr.blank? # массив id имен братьев и сестер автора
      daughter_ids.each do |sister|
        author_daughters_names_ids <<  Profile.find(sister).name_id  # массив имен найденных братьев и сестер автора
      end
    end
    author_daughters_names_ids = author_daughters_names_ids.sort if !author_daughters_names_ids.blank? #  # массив имен упорядочен
  end

  # Поиск id всех братьев автора дерева. АВТОР - зареген
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_bros_profile_ids(user_id)  #
    author_br_ids = [] # Массив id всех братьев
    author_br_ids << Tree.where(user_id: user_id ).where("relation_id = 5").select(:profile_id).pluck(:profile_id)
    author_br_ids = author_br_ids.flatten if !author_br_ids.blank? # массив объединен
  end

  # Поиск имен всех братьев автора дерева. АВТОР - зареген
  # @note triplex_arr
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_bros_names_ids(bros_ids_arr) #,user_name_id)
    if !bros_ids_arr.blank? # если найдены братья в дереве автора
      br_names_ids = []
      #  br_names_ids << user_name_id #if !triplex_arr.blank? # массив id имен братьев автора
      bros_ids_arr.each do |sister|
        br_names_ids <<  Profile.find(sister).name_id  # массив имен найденных братьев автора
      end
    end
    br_names_ids = br_names_ids.sort if !br_names_ids.blank? #  # массив имен упорядочен
  end

  # Поиск id всех братьев и сестер автора дерева. АВТОР - зареген
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_bros_sist_profile_ids(user_id)  #
    author_br_sis_ids = [] # Массив id всех братьев и сестер
    author_br_sis_ids << Tree.where(user_id: user_id ).where("relation_id = 6 OR relation_id = 5").select(:profile_id).pluck(:profile_id)
    author_br_sis_ids = author_br_sis_ids.flatten if !author_br_sis_ids.blank? # массив объединен
  end

  # Поиск имен всех братьев и сестер автора дерева. АВТОР - зареген
  # @note triplex_arr
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_bros_sist_names_ids(bros_sist_ids_arr,user_name_id)
    if !bros_sist_ids_arr.blank? # если найдены братья и сестры в дереве автора
      br_sis_names_ids = []
      br_sis_names_ids << user_name_id #if !triplex_arr.blank? # массив id имен братьев и сестер автора
      bros_sist_ids_arr.each do |sister|
        br_sis_names_ids <<  Profile.find(sister).name_id  # массив имен найденных братьев и сестер автора
      end
    end
    br_sis_names_ids = br_sis_names_ids.sort if !br_sis_names_ids.blank? #  # массив имен упорядочен
  end

  # Поиск имен всех братьев и сестер автора дерева. АВТОР - зареген
  # @note triplex_arr
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_auther_bros_sist_names_ids(bros_sist_ids_arr,triplex_arr)
    if !bros_sist_ids_arr.blank? # если найдены братья и сестры в дереве автора
      author_br_sis_names_ids = []
      author_br_sis_names_ids << triplex_arr[0][2] if !triplex_arr.blank? # массив id имен братьев и сестер автора
      bros_sist_ids_arr.each do |sister|
        author_br_sis_names_ids <<  Profile.find(sister).name_id  # массив имен найденных братьев и сестер автора
      end
    end
    author_br_sis_names_ids = author_br_sis_names_ids.sort if !author_br_sis_names_ids.blank? #  # массив имен упорядочен
  end

  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_tree_match

    tree_arr = session[:tree_arr][:value] if !session[:tree_arr].blank?

    all_match_arr = []   # Массив совпадений всех родных с Автором
    match_amount = 0     # Кол-во совпадений всех родных с Автором
    @triplex_arr = []
    make_one_triplex_arr(current_user.id,@triplex_arr,nil,1,2)   # @triplex_arr (nil - автор, 1 - отец, 2 - мать)

    # Поиск массива id имен всех братьев и сестер автора дерева
    @author_bros_sisters_names_ids = get_auther_bros_sist_names_ids(get_bros_sist_profile_ids(current_user.id),@triplex_arr)

    # Поиск массива id имен всех детей автора дерева
    @author_kids_names_ids = get_user_kids_names_ids(get_user_kids_profile_ids(current_user.id))

    @count = 0
    @matched_daughters_user_ids_arr = []  # Массив уже найденных user_id
    @matched_sons_user_ids_arr = []  # Массив уже найденных user_id
    @matched_brothers_user_ids_arr = []  # Массив уже найденных user_id
    @matched_sisters_user_ids_arr = []  # Массив уже найденных user_id
    @matched_husbands_user_ids_arr = []  # Массив уже найденных user_id
    @matched_wives_user_ids_arr = []  # Массив уже найденных user_id

    @messages_fathers_found_arr = []  # Сообщения о найденных user_id
    @messages_mothers_found_arr = []  # Массив уже найденных user_id
    @messages_daughters_found_arr = []  # Сообщения о найденных user_id
    @messages_sons_found_arr = []  # Массив уже найденных user_id
    @messages_brothers_found_ids_arr = []  # Массив уже найденных user_id
    @messages_sisters_found_arr = []  # Массив уже найденных user_id
    @messages_husbands_found_ids_arr = []  # Массив уже найденных user_id
    @messages_wives_found_arr = []  # Массив уже найденных user_id


    if !tree_arr.blank?

      for tree_index in 0 .. tree_arr.length-1

        relation = tree_arr[tree_index][5]  # Выбор очередности поиска в зависимости от relation

        case relation # Определение вида поиска по значению relation

          when 1    # "father"
            @search_relation = "father"   # DEBUGG TO VIEW
            search_farther(@triplex_arr)
            all_match_arr << @father_match_arr if !@father_match_arr.blank?
            match_amount = @match_father_amount if !@match_father_amount.blank?

          when 2    # "mother"
            @search_relation = "mother"   #
#            search_mother(@triplex_arr)
            all_match_arr << @mother_match_arr if !@mother_match_arr.blank?
            match_amount = match_amount + @match_mother_amount if !@match_mother_amount.blank?

          when 3   # "son"
            @search_relation = "son"   #
#            search_son
            all_match_arr << @son_match_arr if !@son_match_arr.blank?
            match_amount = match_amount + @match_son_amount if !@match_son_amount.blank?

          when 4   # "daughter"
            @search_relation = "daughter"   #
#            search_daughter
            all_match_arr << @daughter_match_arr if !@daughter_match_arr.blank?
            match_amount = match_amount + @match_daughter_amount if !@match_daughter_amount.blank?
            @count += 1

          when 5  # "brother"
            @search_relation = "brother"   #
#            search_brothers

#            search_bros_sist(@triplex_arr)  # найдены потенциальные братья

            all_match_arr << @brothers_match_arr if !@brothers_match_arr.blank? #
            match_amount = match_amount + @match_brothers_amount if !@match_brothers_amount.blank?

          when 6   # "sister"
            @search_relation = "sister"   #
          #search_bros_sist(@triplex_arr)  # найдены потенциальные сестры
          #all_match_arr << @sisters_match_arr if !@sisters_match_arr.blank? #
          #match_amount = match_amount + @match_sisters_amount if !@match_sisters_amount.blank?

          when 7   # "husband"
            @search_relation = "husband"   #

          when 8   # "wife"
            @search_relation = "wife"   #

            match_amount = match_amount + @match_wife_amount if !@match_wife_amount.blank?

          else
            @search_relation = "ERROR: no relation in tree profile"
          # TODO: call error_processing

        end

      end

    end

    @match_amount = match_amount # DEBUGG TO VIEW
    @all_match_arr = all_match_arr # DEBUGG TO VIEW

  end


  # Поиск ОТЦА ЮЗЕРА во всех сущ-х деревьях на основе данных в дереве Юзера.
  # НАЧАЛО ПОИСКА ОТЦА ЮЗЕРА ПО СОВПАДЕНИЯМ ИМЕНИ ОТЦА, ИМЕНИ ЖЕНЫ И/ИЛИ ИМЕН ДЕТЕЙ (БРАТЬЕВ И СЕСТЕР АВТОРА)
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # 1. Ищем всех отцов
  # 2. У найденных отцов ищем их жен - могут быть указаны
  # 3. У найденных отцов ищем их детей - могут быть указаны
  # 4. находим общие для всех трех поисков ИД Юзеров - отцов. Эти ИД образуют массив совпадения.
  # 5. По этому массиву - можно формировать вопросы для подтверждения и дальнейщего рукопожатия
  # Father_Profile_ID = triplex_arr[1][0])
  # Father_Sex_ID = triplex_arr[1][1])
  # Father_Name_ID = triplex_arr[1][2])
  # Father_Relation_ID = triplex_arr[1][3])
  def search_farther(triplex_arr)

    #@found_father = false
    # 1. Массив № 1 = @all_fathers_name_user_ids. Ищем всех отцов father's profile_id с именем отца автора
    #all_fathers_name_user_ids = Profile.where.not(user_id: current_user.id ).where.not(user_id: 0 ).where(:name_id => triplex_arr[1][2]).select(:user_id).pluck(:user_id)
    all_fathers_name_profile_ids = Profile.where.not(user_id: current_user.id ).where(:name_id => triplex_arr[1][2]).select(:id).pluck(:id)

#    @all_fathers_name_len = all_fathers_name_profile_ids.length  if !all_fathers_name_user_ids.blank? #  # DEBUGG TO VIEW
    @all_fathers_name_profile_ids = all_fathers_name_profile_ids  # DEBUGG TO VIEW

    if !all_fathers_name_profile_ids.blank? # если такие отцы-профили найдены

      @mothers_profile_ids_arr = []           # массив матерей с совпавшими именами матери автора
      @fathers_user_ids_arr = []
      fathers_mothers_users_ids_arr = []     # Массив № 2. массив user_id отцов с совпавшими матерями автора
      @kids_profile_ids_arr = []           # # DEBUGG TO VIEW
      fathers_kids_users_ids_arr = []     # Массив № 3/ж

      all_fathers_name_profile_ids.each do |father_profile| # для каждого из найденных отцов - поиск жен, указанных в деревьях отцов

        # 2. Массив № 2 = fathers_mothers_users_ids_arr.
        # У найденных отцов ищем их жен - могут быть указаны в дереве: 1) все жены (8) в деревьях @all_fathers_name_user_ids user_id
        # 2) имя == имени матери в триплексе автора
        @fathers_user_ids = Tree.where(:profile_id => father_profile).select(:user_id)#.pluck(:user_id)
        if !@fathers_user_ids.blank? #
          @fathers_user_ids_arr << @fathers_user_ids[0].user_id  # DEBUGG TO VIEW
        else
          @fathers_user_ids_authors = User.where(:profile_id => father_profile).select(:id)#.pluck(:user_id)
          @fathers_user_ids_arr << @fathers_user_ids_authors[0].id  # DEBUGG TO VIEW
        end


      end
      @fathers_user_ids_arr.each do |father_tree| # для каждого из найденных отцов - поиск жен, указанных в деревьях отцов



      end
      #if !fathers_wife_profile_id.blank? # у отца - в принципе есть жена (указана в его дереве)
      #  # todo: здесь могут быть несколько жен! - делать как с детьми (как ниже)
      #  @mothers_name = Profile.find(fathers_wife_profile_id).name_id # находим имя найденной жены одного из отцов
      #  if !@mothers_name.blank? && @mothers_name == triplex_arr[2][2] # если имя жены отца найдено и оно - такое же, что имя матери автора
      #    @mothers_profile_ids_arr << fathers_wife_profile_id  # DEBUGG TO VIEW
      #    fathers_mothers_users_ids_arr << father  # Массив № 2.
      #    # формирование массива user_id отцов, у кот-х есть жены и их имена совпадают с именем матери автора.
      #    @fathers_mothers_users_ids_arr = fathers_mothers_users_ids_arr  # DEBUGG TO VIEW
      #  end
      #end

      # У найденных отцов father ищем fathers_kids_profile_ids - их детей: всех сынов (relation = 3), всех дочей (relation = 4)
      #fathers_kids_profile_ids = Tree.where(user_id: father).where("relation_id = 3 OR relation_id = 4").select(:profile_id).pluck(:profile_id) #[0].profile_id
      #@fathers_kids_profile_ids = fathers_kids_profile_ids     # DEBUGG TO VIEW
      ## ищем всех детей в дереве отца
      #if !fathers_kids_profile_ids.blank? # если найдены дети у отца
      #  fathers_kids_name_arr = []
      #  fathers_kids_profile_ids.each do |daughter|
      #    fathers_kids_name_arr << Profile.find(daughter).name_id # находим имя найденного ребенка отца и формируем массив id имен детей отца
      #  end
      #  @fathers_kids_name_arr = fathers_kids_name_arr     # DEBUGG TO VIEW
      #
      #  if !fathers_kids_name_arr.blank?
      #    fathers_kids_name_arr.sort
      #    if fathers_kids_name_arr == @author_bros_sisters_names_ids
      #      # если массивы имен детей отца и массив сестер и братьев автора  - СОВПАДАЮТ
      #      # Если массивы совпадают, то у них вероятно общий отец. Заносим его user_id в массив id найденных отцов
      #      @kids_profile_ids_arr << fathers_kids_name_arr   # # DEBUGG TO VIEW Массив № 3Kids.
      #      fathers_kids_users_ids_arr << father  # Массив № 3.
      #      # заполнение массива user_id отцов, у кот-х есть дети и их имена совпадают с именем автора и именами братьев и сестер автора.
      #      @fathers_kids_users_ids_arr = fathers_kids_users_ids_arr     # DEBUGG TO VIEW
      #    end
      #  end
      #end

      # 4. находим общие для всех поисков ИД Юзеров - отцов. Эти ИД образуют массив совпадения.
      # Пересечение массивов - результатов поиска совпадения id всех Отцов, отцов с совпавшими женами (матерью автора) и с совпавшими детьми Отца с братьями сестрами автора
      # Это - основа для предложения рукопожатия
      #      @father_match_arr = all_fathers_name_user_ids & fathers_mothers_users_ids_arr  & fathers_kids_users_ids_arr #
      ##  КОНЕЦ ПОИСКА ОТЦА

      #if !@father_match_arr.blank? # если найдены
      #  @match_father_amount = @father_match_arr.length
      #  @msg_father = "Найден твой Отец на сайте. Хочешь пожать ему руку? Это позволит тебе увидеть дерево его родных и объединиться с ним."
      #else
      #  @msg_father = "Твой Отец не найден на сайте. Пригласи его!"
      #end

    else
      @msg_father = "Твой Отец не найден на сайте. Пригласи его!"
    end

  end

  # Поиск матери ЮЗЕРА во всех сущ-х деревьях на основе данных в дереве Юзера.
  # НАЧАЛО ПОИСКА матери ЮЗЕРА ПО СОВПАДЕНИЯМ ИМЕНИ матери, ИМЕНИ мужа И/ИЛИ ИМЕН ДЕТЕЙ (БРАТЬЕВ И СЕСТЕР АВТОРА)
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_mother(triplex_arr)

    # взять имя матери автора
    # Mother_Profile_ID = triplex_arr[2][0])
    # Mother_Sex_ID = triplex_arr[2][1])
    # Mother_Name_ID = triplex_arr[2][2])
    # Mother_Relation_ID = triplex_arr[2][3])

    @found_mother = false
    # 1. Массив № 1 = @all_mothers_name_user_ids. Ищем всех отцов father's user_id с именем отца автора && !nil
    all_mothers_name_user_ids = Profile.where.not(user_id: current_user.id ).where.not(user_id: 0 ).where(:name_id => triplex_arr[2][2]).select(:user_id).pluck(:user_id)
    @all_mothers_name_len = all_mothers_name_user_ids.length  if !all_mothers_name_user_ids.blank? #  # DEBUGG TO VIEW
    @all_mothers_name_user_ids = all_mothers_name_user_ids  # DEBUGG TO VIEW

    if !all_mothers_name_user_ids.blank? # если такие отцы-Юзеры найдены

      @fathers_profile_ids_arr = []           # массив отцов с совпавшими именами отца автора
      mothers_fathers_users_ids_arr = []     # Массив № 2. массив user_id матерей с совпавшими отцами автора
      @kids_profile_ids_arr = []           # # DEBUGG TO VIEW
      mothers_kids_users_ids_arr = []     # Массив № 3

      all_mothers_name_user_ids.each do |mother| # для каждого из найденных матерей - поиск жен, указанных в деревьях отцов

        # 2. Массив № 2 = mothers_mothers_users_ids_arr.
        # У найденных матерей ищем их мужей - могут быть указаны в дереве: 1) все мужья (7) в деревьях @all_mothers_name_user_ids user_id
        # 2) имя == имени отца в триплексе автора
        mothers_wife_profile_id = Tree.where(user_id: mother).where(:relation_id => 7).select(:profile_id)[0].profile_id
        if !mothers_wife_profile_id.blank? # у отца - в принципе есть жена (указана в его дереве)
          # todo: здесь могут быть несколько жен! - делать как с детьми (как ниже)
          @fathers_name = Profile.find(mothers_wife_profile_id).name_id # находим имя найденного мужа одной из матерей
          if !@fathers_name.blank? && @fathers_name == triplex_arr[1][2] # если имя жены отца найдено и оно - такое же, что имя матери автора
            @fathers_profile_ids_arr << mothers_wife_profile_id  # DEBUGG TO VIEW
            mothers_fathers_users_ids_arr << mother  # Массив № 2.
            # формирование массива user_id отцов, у кот-х есть жены и их имена совпадают с именем матери автора.
            @mothers_fathers_users_ids_arr = mothers_fathers_users_ids_arr  # DEBUGG TO VIEW
          end
        end

        # У найденных матерей father ищем fathers_kids_profile_ids - их детей: всех сынов (relation = 3), всех дочей (relation = 4)
        mothers_kids_profile_ids = Tree.where(user_id: mother).where("relation_id = 3 OR relation_id = 4").select(:profile_id).pluck(:profile_id) #[0].profile_id
        @mothers_kids_profile_ids = mothers_kids_profile_ids     # DEBUGG TO VIEW
        # ищем всех детей в дереве матерей
        if !mothers_kids_profile_ids.blank? # если найдены дети у отца
          mothers_kids_name_arr = []
          mothers_kids_profile_ids.each do |daughter|
            mothers_kids_name_arr << Profile.find(daughter).name_id # находим имя найденного ребенка отца и формируем массив id имен детей отца
          end
          @mothers_kids_name_arr = mothers_kids_name_arr     # DEBUGG TO VIEW

          if !mothers_kids_name_arr.blank?
            mothers_kids_name_arr.sort
            if mothers_kids_name_arr == @author_bros_sisters_names_ids
              # если массивы имен детей матерей и массив сестер и братьев автора  - СОВПАДАЮТ
              # Если массивы совпадают, то у них вероятно общяя мать. Заносим его user_id в массив id найденных отцов
              @kids_profile_ids_arr << mothers_kids_name_arr   # # DEBUGG TO VIEW Массив № 3Kids.
              mothers_kids_users_ids_arr << mother  # Массив № 3.
              # заполнение массива user_id матерей, у кот-х есть дети и их имена совпадают с именем автора и именами братьев и сестер автора.
              @mothers_kids_users_ids_arr = mothers_kids_users_ids_arr     # DEBUGG TO VIEW
            end
          end
        end

      end

      # 4. находим общие для всех поисков ИД Юзеров - отцов. Эти ИД образуют массив совпадения.
      # Пересечение массивов - результатов поиска совпадения id всех Отцов, отцов с совпавшими женами (матерью автора) и с совпавшими детьми Отца с братьями сестрами автора
      # Это - основа для предложения рукопожатия
      @mother_match_arr = all_mothers_name_user_ids & mothers_fathers_users_ids_arr  & mothers_kids_users_ids_arr #
      ##  КОНЕЦ ПОИСКА ОТЦА

      if !@mother_match_arr.blank? # если найдены
        @match_mother_amount = @father_match_arr.length
        @msg_mother = "Найдена твоя Мать на сайте. Хочешь пожать ей руку? Это позволит тебе увидеть дерево её родных и объединиться с ней."
      else
        @msg_mother = "Твоя Мать не найдена на сайте. Пригласи её!"
      end

    else
      @msg_mother = "Твоя Мать не найдена на сайте. Пригласи её!"
    end

    #  @brothers_search_results = "No brothers results yet!!"


  end

  # Поиск БРАТЬЕВ во всех сущ-х деревьях на основе данных в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_brothers #(triplex_arr)

    # Father_Profile_ID = triplex_arr[1][0])
    # Father_Sex_ID = triplex_arr[1][1])
    # Father_Name_ID = triplex_arr[1][2])
    # Father_Relation_ID = triplex_arr[1][3])
    # 1.Находим всех братьев-сестер Автора.
    # 2.Массив № 1. взять имена братьев автора и найти всех Братьев-Юзеров
    # 3. Для каждого Брата-Юзера находим его Отца и Мать. Сравниваем с отцом и матерью Автора.
    # 4. Для каждого Брата-Юзера находим его братьев-сестер. Сравниваем с братьями-сестрами Автора.\

    # 1. Массив № 1 = @author_son_names_ids.
    # Ищем всех братьев-сестер автора = user_id с именем братьев-сестер автора
    all_authors_bros_profile_ids = get_bros_profile_ids(current_user.id)

    @all_authors_bros_profiles_len = all_authors_bros_profile_ids.length  if !all_authors_bros_profile_ids.blank? #  # DEBUGG TO VIEW
    @all_authors_bros_profile_ids = all_authors_bros_profile_ids  # DEBUGG TO VIEW
    @author_bros_names_ids = get_bros_names_ids(all_authors_bros_profile_ids) #,@triplex_arr[0][2])  # Поиск массива id имен всех братьев и сестер автора дерева

    if !all_authors_bros_profile_ids.blank? # если такие братья-Юзеры найдены

      @brothers_match_arr = []

      #son_br_sis_kids_users_ids_arr = []     # Check-Массив № 3
      #son_father_users_ids_arr = []     # Check-Массив № 3/ж
      #son_mother_users_ids_arr = []     # Check-Массив № 3/ж

      @author_bros_names_ids.each do |bros_profile_id| # для каждого из найденных братьев - поиск жен, указанных в деревьях отцов

        # 2. Массив № 2  Среди профилей братьев ищем Users с именем, равным имени брата Автора
        bros_user_ids = Profile.where.not(user_id: current_user.id ).where.not(user_id: 0 ).where(:name_id => bros_profile_id).select(:user_id).pluck(:user_id)
        if !bros_user_ids.blank? # 1. у автора - в принципе есть братья (указаны в его дереве)
          @bros_user_ids = bros_user_ids #  # # DEBUGG TO VIEW
          bros_user_ids.each do |bros_user_id|

            # 3. CHECK SON'S BROS AND SISTERS WITH AUTHOR'S KIDS - ALL NAMES
            # 3. найти всех братов и сестер этого сына
            #      @son_br_sis_profile_ids = get_bros_sist_profile_ids(son_user_id) #
            #      @son_user_name_id = Profile.where(user_id: son_user_id).select(:name_id)[0].name_id
            #      @son_br_sis_names_ids = get_bros_sist_names_ids(@son_br_sis_profile_ids,@son_user_name_id)
            #      if !@son_br_sis_names_ids.blank? && @son_br_sis_names_ids == @author_kids_names_ids # если имена братьев и сестер сына совпадают с именами детей отца-автора
            #        #@mothers_profile_ids_arr << fathers_wife_profile_id  # DEBUGG TO VIEW
            #        son_br_sis_kids_users_ids_arr << son_user_id  # Массив № 3.
            #        # формирование массива user_id сынов, у кот-х есть братья и сестры  и их имена совпадают с именами детей отца-автора.
            #        @son_br_sis_kids_users_ids_arr = son_br_sis_kids_users_ids_arr  # DEBUGG TO VIEW
            #      end

            # 4. CHECK SON'S father AND Mother WITH AUTHOR'S father AND Mother NAMES
            # 4. найти отца и мать этого сына и сравнить их имена с именами отца и матери автора.
            # имена отца и матери автора - triplex_arr
            # имена отца и матери сына - @son_triplex_arr

            @bros_triplex_arr = []
            make_one_triplex_arr(bros_user_id,@bros_triplex_arr,nil,1,2)   # @triplex_arr (nil - автор, 1 - отец, 2 - мать)
            # 4.1. CHECK? BROS'S father = Author
            #      if @triplex_arr[0][2] == @bros_triplex_arr[1][2]  # имена отца сына и автора - совпадают,
            #        # этот сын - возможно сын автора\
            #        son_father_users_ids_arr << son_user_id
            #        @son_father_users_ids_arr = son_father_users_ids_arr     # DEBUGG TO VIEW
            #      end

            # 4.2. CHECK? BROS'S mother = Author's WIFE
            # find Author's WIFE
            # ЗДЕСЬ ЖЕНЫ АВТОРА - ЭТО МАССИВ. НА СЛУЧАЙ, КОГДА БЫЛИ ЕЩЕ ЖЕНЫ И ОНИ УКАЗАНЫ В ДЕРЕВЕ АВТОРА,
            # ПРИ ЭТОМ, БЫВШАЯ ЖЕНА АВТОРА - МАТЬ СЫНА
            #      authors_wives_names_ids = get_user_wife_names_ids(get_user_wife_profile_ids(current_user.id))
            #      @authors_wives_names_ids = authors_wives_names_ids     # DEBUGG TO VIEW
            #      if !authors_wives_names_ids.blank? # если есть жены в дереве автора
            #        authors_wives_names_ids.each do |wife|
            #          if wife == @son_triplex_arr[2][2]  # имена матери сына и жены автора - совпадают,
            #            # этот сын - возможно сын автора\
            #            son_mother_users_ids_arr << son_user_id  # хотя бы одна из жен автора = мать потенциального сына
            #            @son_mother_users_ids_arr = son_mother_users_ids_arr     # DEBUGG TO VIEW
            #          end
            #        end
            #      end

          end
        end

      end

      # 4. находим общие для всех поисков ИД Юзеров - сынов. Эти ИД образуют массив совпадения.
      # Пересечение массивов - результатов поиска совпадения id Сына автора с братьями и сестрами сына автора, сынов с совпавшими отцом и матерью автора и с совпавшими детьми автора
      # Это - основа для предложения рукопожатия
      @brothers_match_arr = @bros_user_ids #& son_br_sis_kids_users_ids_arr & son_father_users_ids_arr & son_mother_users_ids_arr #

      if !@brothers_match_arr.blank? # если найдены
        @match_brothers_amount = @brothers_match_arr.length
        @msg_brother = "Найден твой Брат на сайте. Хочешь пожать ему руку? Это позволит тебе увидеть дерево его родных и объединиться с ним."

      else
        @msg_brother = "Твой Брат не найден на сайте. Пригласи его!"
      end

    else
      @msg_brother = "Твой Брат не найден на сайте. Пригласи его!"
    end




    #  @brothers_search_results = "No brothers results yet!!"


  end

  # Поиск БРАТЬЕВ во всех сущ-х деревьях В КАЧЕСТВЕ АВТОРОВ на основе данных в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_sisters


    @sisters_search_results = "No sisters results yet!!"


  end

  # Поиск братьев/сестер по триплекс-массиву
  # У братьев/сестер - те же отец и мать.
  # [profile_id, sex_id, name_id, relation_id]
  # @triplex_arr: [[22, 0, 506, nil], [23, 1, 45, 1], [24, 0, 453, 2]]
  # @fathers_names_arr - профили отцов с таким же именем, что у отца current_user, т.е. у возможных братьев/сестер.
  # @fathers_trees_arr - номера СД отцов (user_id) с таким же именем, что у отца current_user, т.е. у возможных братьев/сестер.
  # @mothers_names_arr - профили матерей с таким же именем, что у матери current_user, т.е. у возможных братьев/сестер.
  # @mothers_trees_arr - номера СД матерей с таким же именем, что у матери current_user, т.е. у возможных братьев/сестер.
  # todo: Разделить этот метод на 2: поиск братьев и поиск сестер
  # @see News
  def search_bros_sist(triplex_arr)
    @sisters_match_arr = []

    # Father_Profile_ID = triplex_arr[1][0])
    # Father_Sex_ID = triplex_arr[1][1])
    # Father_Name_ID = triplex_arr[1][2])
    # Father_Relation_ID = triplex_arr[1][3])

    # Mother_Profile_ID = triplex_arr[2][0])
    # Mother_Sex_ID = triplex_arr[2][1])
    # Mother_Name_ID = triplex_arr[2][2])
    # Mother_Relation_ID = triplex_arr[2][3])

    # НАЧАЛО ПОИСКА ОТЦА - организовать параллельный поиск матери!!! Т.е. ИЩЕМ - ПАРУ!!
    #@found_father = false
    @all_fathers_profiles = Tree.where.not(user_id: current_user.id).where(:relation_id => triplex_arr[1][3]).select(:id).select(:profile_id).select(:user_id)
    # все profiles отцов, кроме отца current_user
    #    all_fathers_name_user_ids = Profile.where.not(user_id: current_user.id ).where.not(user_id: 0 ).where(:name_id => triplex_arr[1][2]).select(:user_id).pluck(:user_id)

    @fathers_names_arr = []
    @fathers_trees_arr = []
    @all_fathers_profiles.each do |father_profile|
      @fathers_name = Profile.where(:id => father_profile.profile_id).where(:name_id => triplex_arr[1][2]).select(:id)
      if !@fathers_name.blank?
        @fathers_names_arr << @fathers_name[0].id   # Fathers Profile ID
        @fathers_trees_arr << father_profile.user_id  # Tree Nos (user_id)
      end
    end

    @qty_fathers_found = @fathers_names_arr.length if !@fathers_names_arr.blank?
    @found_father = true if !@fathers_names_arr.blank?  # DEBUGG TO VIEW  если найдены профили отцов
    # Profiles с таким же именем, что у отца current_user
    #  КОНЕЦ ПОИСКА ОТЦА

    # НАЧАЛО ПОИСКА МАТЕРИ В ПАРЕ С ОТЦОМ
    @found_mother = false
    @all_mothers_profiles = Tree.where.not(user_id: current_user.id).where(:relation_id => triplex_arr[2][3]).select(:id).select(:profile_id).select(:user_id)
    # все profiles матерей, кроме матери current_user
    @mothers_names_arr = []
    @mothers_trees_arr = []
    @all_mothers_profiles.each do |mother_profile|
      @mothers_name = Profile.where(:id => mother_profile.profile_id).where(:name_id => triplex_arr[2][2]).select(:id)
      if !@mothers_name.blank?
        @mothers_names_arr << @mothers_name[0].id   # Mothers Profile ID
        @mothers_trees_arr << mother_profile.user_id  # Tree Nos (user_id)
      end
    end

    @qty_mothers_found = @mothers_names_arr.length if !@mothers_names_arr.blank?
    @found_mother = true if !@mothers_names_arr.blank?  # DEBUGG TO VIEW если найдены профили матерей
    # с таким же именем, что у матери current_user
    #  КОНЕЦ ПОИСКА МАТЕРИ В ПАРЕ С ОТЦОМ

    # ВЫЯВЛЕНИЕ ПОТЕНЦИАЛЬНЫХ БРАТЬЕВ/СЕСТЕР
    # У current_user есть БРАТ/СЕСТРА - ЕСЛИ у них у всех есть ОБЩИЕ ОТЕЦ И МАТЬ - ПАРА
    @brothers_profile_id_arr = []
    @brothers_match_arr = []
    @sisters_profile_id_arr = []
    #@sisters_match_arr = []
    @common_trees_arr = @fathers_trees_arr & @mothers_trees_arr # Пересечение массивов - общие номера trees
    # ID Users = No Tree.
    if !@common_trees_arr.blank?

      @common_trees_arr.each do |tree|
        @child_profile = Profile.find_by_user_id(tree)

        if @child_profile.sex_id == 1
          @brothers_match_arr << tree   # Массив ID TREES БРАТЬЕВ к current_user
          @brothers_profile_id_arr << User.find(tree).profile_id   # Массив ID PROFILES БРАТЬЕВ к current_user
          @nm = Name.find(@child_profile.name_id).name  # определение имени брата
          @msg_brother = "Твой брат ".concat(@nm).concat(" также есть на сайте. Хочешь пожать ему руку? Это позволит тебе увидеть дерево его родных и объединиться с ним.") # формирование сообщения о найденном брате
        else
          @sisters_match_arr << tree    # Массив ID СЕСТЕР к current_user
          @sisters_profile_id_arr << User.find(tree).profile_id   # Массив ID PROFILES СЕСТЕР к current_user
          @nm = Name.find(@child_profile.name_id).name  # определение имени сестры
          @msg_sister = "Твоя сестра ".concat(@nm).concat(" также есть на сайте. Хочешь пожать ей руку? Это позволит тебе увидеть дерево её родных и объединиться с ним.") # формирование сообщения о найденной сестре
        end

        if !@brothers_match_arr.blank? # если найдены
          @match_brothers_amount = @brothers_match_arr.length
          @msg_brother = "Найден твой брат на сайте. Хочешь пожать ему руку? Это позволит тебе увидеть дерево его родных и объединиться с ним."
        else
          @msg_brother = "Твой брат не найден на сайте. Пригласи его!"
        end
        if !@sisters_match_arr.blank? # если найдены
          @match_sisters_amount = @sisters_match_arr.length
          @msg_sister = "Найдена твоя сестра на сайте. Хочешь пожать ей руку? Это позволит тебе увидеть дерево её родных и объединиться с ней."
        else
          @msg_sister = "Твоя сестра не найдена на сайте. Пригласи её!"
        end

      end
    end
    #  КОНЕЦ ВЫЯВЛЕНИЯ ПОТЕНЦИАЛЬНЫХ БРАТЬЕВ/СЕСТЕР

    #  ГОТОВ МАССИВ ПРОФИЛЕЙ ПОТЕНЦИАЛЬНЫХ БРАТЬЕВ/СЕСТЕР


  end

  # Поиск СЫНА АВТОРА-ЮЗЕРА во всех сущ-х деревьях на основе данных в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # 1. Ищем всех детей=сынов автора
  # 3. найти всех братов и сестер этого сына
  # 4. найти отца и мать этого сына и сравнить их имена с именами отца и матери автора.

  def search_son

    # 1. Массив № 1 = @author_son_names_ids.
    # Ищем всех сынов автора = user_id с именем сынов автора
    all_authors_son_profile_ids = get_auther_sons_profile_ids

    @all_authors_son_profiles_len = all_authors_son_profile_ids.length  if !all_authors_son_profile_ids.blank? #  # DEBUGG TO VIEW
    @all_authors_son_profile_ids = all_authors_son_profile_ids  # DEBUGG TO VIEW
    @author_son_names_ids = get_auther_sons_names_ids(all_authors_son_profile_ids)  # Поиск массива id имен всех братьев и сестер автора дерева

    if !all_authors_son_profile_ids.blank? # если такие отцы-Юзеры найдены

      son_br_sis_kids_users_ids_arr = []     # Check-Массив № 3
      son_father_users_ids_arr = []     # Check-Массив № 3/ж
      son_mother_users_ids_arr = []     # Check-Массив № 3/ж

      @author_son_names_ids.each do |son_profile_id| # для каждого из найденных отцов - поиск жен, указанных в деревьях отцов

        # 2. Массив № 2 = @sons_user_ids - массив сынов = user_ids с именем, равным сыну Автора.
        # Среди профилей сынов ищем Users с именем, равным сыну Автора
        sons_user_ids = Profile.where.not(user_id: current_user.id ).where.not(user_id: 0 ).where(:name_id => son_profile_id).select(:user_id).pluck(:user_id)
        if !sons_user_ids.blank? # 1. у автора - в принципе есть сыны (указаны в его дереве)
          @sons_user_ids = sons_user_ids #  # # DEBUGG TO VIEW
          sons_user_ids.each do |son_user_id|

            # 3. CHECK SON'S BROS AND SISTERS WITH AUTHOR'S KIDS - ALL NAMES
            # 3. найти всех братов и сестер этого сына
            @son_br_sis_profile_ids = get_bros_sist_profile_ids(son_user_id) #
            @son_user_name_id = Profile.where(user_id: son_user_id).select(:name_id)[0].name_id
            @son_br_sis_names_ids = get_bros_sist_names_ids(@son_br_sis_profile_ids,@son_user_name_id)
            if !@son_br_sis_names_ids.blank? && @son_br_sis_names_ids == @author_kids_names_ids # если имена братьев и сестер сына совпадают с именами детей отца-автора
              #@mothers_profile_ids_arr << fathers_wife_profile_id  # DEBUGG TO VIEW
              son_br_sis_kids_users_ids_arr << son_user_id  # Массив № 3.
              # формирование массива user_id сынов, у кот-х есть братья и сестры  и их имена совпадают с именами детей отца-автора.
              @son_br_sis_kids_users_ids_arr = son_br_sis_kids_users_ids_arr  # DEBUGG TO VIEW
            end

            # 4. CHECK SON'S father AND Mother WITH AUTHOR'S father AND Mother NAMES
            # 4. найти отца и мать этого сына и сравнить их имена с именами отца и матери автора.
            # имена отца и матери автора - triplex_arr
            # имена отца и матери сына - @son_triplex_arr

            @son_triplex_arr = []
            make_one_triplex_arr(son_user_id,@son_triplex_arr,nil,1,2)   # @triplex_arr (nil - автор, 1 - отец, 2 - мать)
            # 4.1. CHECK? SON'S father = Author
            if @triplex_arr[0][2] == @son_triplex_arr[1][2]  # имена отца сына и автора - совпадают,
              # этот сын - возможно сын автора\
              son_father_users_ids_arr << son_user_id
              @son_father_users_ids_arr = son_father_users_ids_arr     # DEBUGG TO VIEW
            end

            # 4.2. CHECK? SON'S mother = Author's WIFE
            # find Author's WIFE
            # ЗДЕСЬ ЖЕНЫ АВТОРА - ЭТО МАССИВ. НА СЛУЧАЙ, КОГДА БЫЛИ ЕЩЕ ЖЕНЫ И ОНИ УКАЗАНЫ В ДЕРЕВЕ АВТОРА,
            # ПРИ ЭТОМ, БЫВШАЯ ЖЕНА АВТОРА - МАТЬ СЫНА
            authors_wives_names_ids = get_user_wife_names_ids(get_user_wife_profile_ids(current_user.id))
            @authors_wives_names_ids = authors_wives_names_ids     # DEBUGG TO VIEW
            if !authors_wives_names_ids.blank? # если есть жены в дереве автора
              authors_wives_names_ids.each do |wife|
                if wife == @son_triplex_arr[2][2]  # имена матери сына и жены автора - совпадают,
                  # этот сын - возможно сын автора\
                  son_mother_users_ids_arr << son_user_id  # хотя бы одна из жен автора = мать потенциального сына
                  @son_mother_users_ids_arr = son_mother_users_ids_arr     # DEBUGG TO VIEW
                end
              end
            end

          end
        end

      end

      # 4. находим общие для всех поисков ИД Юзеров - сынов. Эти ИД образуют массив совпадения.
      # Пересечение массивов - результатов поиска совпадения id Сына автора с братьями и сестрами сына автора, сынов с совпавшими отцом и матерью автора и с совпавшими детьми автора
      # Это - основа для предложения рукопожатия
      @son_match_arr = @sons_user_ids & son_br_sis_kids_users_ids_arr & son_father_users_ids_arr & son_mother_users_ids_arr #
      ##  КОНЕЦ ПОИСКА СЫНА

      if !@son_match_arr.blank? # если найдены
        @match_son_amount = @son_match_arr.length
        @msg_son = "Найден твой Сын на сайте. Хочешь пожать ему руку? Это позволит тебе увидеть дерево его родных и объединиться с ним."
        @messages_sons_found_arr << @msg_son
      else
        @msg_son = "Твой Сын не найден на сайте. Пригласи его!"
      end

    else
      @msg_son = "Твой Сын не найден на сайте. Пригласи его!"
    end

  end

  # Поиск ДОЧЕРИ АВТОРА-ЮЗЕРА во всех сущ-х деревьях на основе данных в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # 1. Ищем всех детей=дочей автора
  # 3. найти всех братов и сестер этой дочи
  # 4. найти отца и мать этой дочи и сравнить их имена с именами отца и матери автора.

  def search_daughter

    # 1. Массив № 1 = @@author_daughter_names_ids.
    # Ищем всех дочей автора = user_id с именем дочей автора
    all_authors_daughter_profile_ids = get_auther_daughters_profile_ids

    @all_authors_daughter_profile_ids = all_authors_daughter_profile_ids  # DEBUGG TO VIEW
    @all_authors_daughter_profiles_len = all_authors_daughter_profile_ids.length  if !all_authors_daughter_profile_ids.blank? #  # DEBUGG TO VIEW
    @author_daughter_names_ids = get_auther_daughters_names_ids(all_authors_daughter_profile_ids)  # Поиск массива id имен всех братьев и сестер автора дерева

    if !all_authors_daughter_profile_ids.blank? # если такие отцы-Юзеры найдены

      daughter_br_sis_kids_users_ids_arr = []     # Check-Массив № 3
      daughter_father_users_ids_arr = []     # Check-Массив № 3/ж
      daughter_mother_users_ids_arr = []     # Check-Массив № 3/ж

      @author_daughter_names_ids.each do |daughter_profile_id| # для каждого из найденных отцов - поиск жен, указанных в деревьях отцов

        # 2. Массив № 2 = @daughters_user_ids - массив дочей = user_ids с именем, равным доче Автора.
        # Среди профилей дочей ищем Users с именем, равным доче Автора
        daughters_user_ids = Profile.where.not(user_id: current_user.id ).where.not(user_id: 0 ).where(:name_id => daughter_profile_id).select(:user_id).pluck(:user_id)
        if !daughters_user_ids.blank? # 1. у автора - в принципе есть дочи (указаны в его дереве)
          @daughters_user_ids = daughters_user_ids #  # # DEBUGG TO VIEW

          daughters_user_ids.each do |daughter_user_id|
            @ind = daughter_user_id # DEBUGG TO VIEW
            if !@matched_daughters_user_ids_arr.include?(daughter_user_id)  # проверка: этот user_id = дочь уже был найден?

              # 3. CHECK daughter'S BROS AND SISTERS WITH AUTHOR'S KIDS - ALL NAMES
              # 3. найти всех братов и сестер этой дочи
              @daughter_br_sis_profile_ids = get_bros_sist_profile_ids(daughter_user_id) #
              @daughter_user_name_id = Profile.where(user_id: daughter_user_id).select(:name_id)[0].name_id
              @daughter_br_sis_names_ids = get_bros_sist_names_ids(@daughter_br_sis_profile_ids,@daughter_user_name_id)
              if !@daughter_br_sis_names_ids.blank? && @daughter_br_sis_names_ids == @author_kids_names_ids # если имена братьев и сестер дочи совпадают с именами детей отца-автора
                #@mothers_profile_ids_arr << fathers_wife_profile_id  # DEBUGG TO VIEW
                daughter_br_sis_kids_users_ids_arr << daughter_user_id  # Массив № 3.
                # формирование массива user_id дочей, у кот-х есть братья и сестры  и их имена совпадают с именами детей отца-автора.
                @daughter_br_sis_kids_users_ids_arr = daughter_br_sis_kids_users_ids_arr  # DEBUGG TO VIEW
              end

              # 4. CHECK daughter'S father AND Mother WITH AUTHOR'S father AND Mother NAMES
              # 4. найти отца и мать этой дочи и сравнить их имена с именами отца и матери автора.
              # имена отца и матери автора - triplex_arr
              # имена отца и матери дочи - @daughter_triplex_arr

              @daughter_triplex_arr = []
              make_one_triplex_arr(daughter_user_id,@daughter_triplex_arr,nil,1,2)   # @triplex_arr (nil - автор, 1 - отец, 2 - мать)
              # 4.1. CHECK? daughter'S father = Author
              if @triplex_arr[0][2] == @daughter_triplex_arr[1][2]  # имена отца дочи и автора - совпадают,
                # этa дочь - возможно дочь автора\
                daughter_father_users_ids_arr << daughter_user_id
                @daughter_father_users_ids_arr = daughter_father_users_ids_arr     # DEBUGG TO VIEW
              end

              # 4.2. CHECK? daughter'S mother = Author's WIFE
              # find Author's WIFE
              # ЗДЕСЬ ЖЕНЫ АВТОРА - ЭТО МАССИВ. НА СЛУЧАЙ, КОГДА БЫЛИ ЕЩЕ ЖЕНЫ И ОНИ УКАЗАНЫ В ДЕРЕВЕ АВТОРА,
              # ПРИ ЭТОМ, БЫВШАЯ ЖЕНА АВТОРА - МАТЬ ДОЧЕРИ
              authors_wives_names_ids = get_user_wife_names_ids(get_user_wife_profile_ids(current_user.id))
              @authors_wives_names_ids = authors_wives_names_ids     # DEBUGG TO VIEW
              if !authors_wives_names_ids.blank? # если есть жены в дереве автора
                authors_wives_names_ids.each do |wife|
                  if wife == @daughter_triplex_arr[2][2]  # имена матери дочи и жены автора - совпадают,
                    # этa дочь - возможно дочь автора\
                    daughter_mother_users_ids_arr << daughter_user_id  # хотя бы одна из жен автора = мать потенциальной дочи
                    @daughter_mother_users_ids_arr = daughter_mother_users_ids_arr     # DEBUGG TO VIEW
                  end
                end
              end
            end
          end
        end

      end

      # 4. находим общие для всех поисков ИД Юзеров - дочей. Эти ИД образуют массив совпадения.
      # Пересечение массивов - результатов поиска совпадения id Дочи автора, с братьями и сестрами дочи автора, дочей с совпавшими отцом и матерью автора и с совпавшими детьми автора
      # Это - основа для предложения рукопожатия
      @daughter_match_arr = @daughters_user_ids & daughter_br_sis_kids_users_ids_arr & daughter_father_users_ids_arr & daughter_mother_users_ids_arr #
      @matched_daughters_user_ids_arr << @daughter_match_arr # запоминание уже найденных user_ids
      @matched_daughters_user_ids_arr = @matched_daughters_user_ids_arr.flatten #

      ##  КОНЕЦ ПОИСКА ДОЧЕРИ

      if !@daughter_match_arr.blank? # если найдены
        @match_daughter_amount = @daughter_match_arr.length
        @msg_daughter = "Найдена твоя Дочь на сайте. Хочешь пожать ей руку? Это позволит тебе увидеть дерево её родных и объединиться с ней."
        @messages_daughters_found_arr << @msg_daughter
        #else
        #  if @messages_daughters_found_arr.size > 0
        #  @msg_daughter = "Твоя Дочь не найдена на сайте. Пригласи её!"
        #  end
      end

    else
      @msg_daughter = "Твоя Дочь не найдена на сайте. Пригласи её!"
    end

  end

  # Получение одного массива для включения в массив триплекс
  # get_profile_arr - метод сбор данных для массива по profile_id .
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_profile_arr(user_id,triplex_arr,relation)
    if user_signed_in?
      one_triplex_arr = []
      if !relation.blank?
        one_triplex_arr[0] = Tree.where(:user_id => user_id, :relation_id => relation)[0][:profile_id]
      else
        one_triplex_arr[0] = User.find(user_id).profile_id
      end
      one_triplex_arr[1] = Profile.find(one_triplex_arr[0]).sex_id
      one_triplex_arr[2] = Profile.find(one_triplex_arr[0]).name_id
      one_triplex_arr[3] = relation
      triplex_arr << one_triplex_arr
    end
  end

  # Получение массива массивов Триплекс: дочь - отец - мать.
  # [profile_id, name_id, relation_id, sex_id]
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def make_one_triplex_arr(user_id,triplex_arr, first_relation, second_relation, third_relation)
    get_profile_arr(user_id,triplex_arr,first_relation)
    get_profile_arr(user_id,triplex_arr,second_relation)
    get_profile_arr(user_id,triplex_arr,third_relation)
  end






  Hash

         @fathers_hash = Hash.new  # { Tree No (user_id) =>  Father Profile ID }
             arr_terms = terms_hash.keys  #           arr_freqs = terms_hash.values
             @fathers_hash.merge!({father_profile.user_id  => @fathers_name[0].id}) #
 # @fathers_hash = { Tree No (user_id) =>  Father Profile ID }.

 #           @mothers_hash.merge!({mother_profile.user_id  => @mothers_name[0].id}) #
 # @@others_hash - профили матерей с таким же именем, что у матери current_user, т.е. у возможных братьев/сестер
 # @mothers_hash = { Tree No (user_id) =>  Mother Profile ID }.


HASH ЭШИ - Merge

# склеивание 2-х хэшей  без потери элементов
  @hash1 = {2=>8, 3=>15}
  @hash2 = {2=>9, 3=>18}

  @hash2.each_key do |key|
    if ( @hash1.has_key?(key) )
      @hash1[ "hash2-originated-#{key}" ] = @hash2[key]
    else
      @hash1[key]=@hash2[key]
    end
  end

  # result: @hash1: {2=>8, 3=>15, "hash2-originated-2"=>9, "hash2-originated-3"=>18}

#####################################

# MERGE TWO HASHES. при этом значения для одинаковых ключей собираются в массивы
  @nhash1 = {2=>8, 3=>15}
  @nhash2 = {2=>9, 3=>18}
  @nhash4 = {2=>7, 3=>19}

  @nhash3 = @nhash1.merge(@nhash2){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }

  @nhash5 = @nhash3.merge(@nhash4){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
########################################################################

# h.values_at("cow", "cat")


ARRAYS  FGF

   @all_match_arr_sorted = @all_match_arr.sort_by!{ |elem| elem[0]}




  StartController

  def store_profile(id,relation,name,sex)

    tree_profile_arr = []

    tree_profile_arr[0] = id              # id Profile
    tree_profile_arr[1] = relation        # Relation
    tree_profile_arr[2] = name            # Name
    tree_profile_arr[3] = sex             # Sex

    return tree_profile_arr

  end


  def process_questions

    @navigation_var = "Navigation переменная - START контроллер/process_questions метод"

    @tree_array = []  # Финальный массив стартового дерева
    @id_profile = 1

    ##### MYSELF ##########
    @user_name = params[:name_select] #
    # извлечение пола из введенного имени
    if !@user_name.blank?
      @user_sex = check_sex_by_name(@user_name) # display sex by name

      @tree_profile_arr = store_profile(@id_profile,nil,@user_name,@user_sex)
      @tree_array << @tree_profile_arr
    end


    ##### FATHER ##########
    @father_name = params[:father_name_select] #
    # проверка, действ-но ли введено мужское имя?
    if !@father_name.blank?
      @user_sex = check_sex_by_name(@father_name) # sex by name
      if check_sex_by_name(@father_name)
        @father_name_correct = true
      else
        @father_name_correct = false
      end
      @id_profile += 1

      @tree_profile_arr = store_profile(@id_profile,1,@father_name,@user_sex)
      @tree_array << @tree_profile_arr

    end


    ##### MOTHER ##########
    @mother_name = params[:mother_name_select] #
    # проверка, действ-но ли введено женское имя?
    if !@mother_name.blank?
      @user_sex = check_sex_by_name(@mother_name) # sex by name
      if !check_sex_by_name(@mother_name)
        @mother_name_correct = true
      else
        @mother_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,2,@mother_name,@user_sex)
      @tree_array << @tree_profile_arr

    end




    ##### BROTHER ##########
    @brother_name = params[:brother_name_select] #
    # проверка, действ-но ли введено мужское имя?
    if !@brother_name.blank?
      @user_sex = check_sex_by_name(@brother_name) # sex by name
      if check_sex_by_name(@brother_name)
        @brother_name_correct = true
      else
        @brother_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,3,@brother_name,@user_sex)
      @tree_array << @tree_profile_arr

    end


    ##### SISTER ##########
    @sister_name = params[:sister_name_select] #
    # проверка, действ-но ли введено женское имя?
    if !@sister_name.blank?
      @user_sex = check_sex_by_name(@sister_name) # sex by name
      if !check_sex_by_name(@sister_name)
        @sister_name_correct = true
      else
        @sister_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,4,@sister_name,@user_sex)
      @tree_array << @tree_profile_arr

    end


    ##### SON ##########
    @son_name = params[:son_name_select] #
    # проверка, действ-но ли введено женское имя?
    if !@son_name.blank?
      @user_sex = check_sex_by_name(@son_name) # sex by name
      if !check_sex_by_name(@son_name)
        @son_name_correct = true
      else
        @son_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,5,@son_name,@user_sex)
      @tree_array << @tree_profile_arr
    end


    ##### DAUGTER ##########
    @daugter_name = params[:daugter_name_select] #
    # проверка, действ-но ли введено мужское имя?
    if !@daugter_name.blank?
      @user_sex = check_sex_by_name(@daugter_name) # sex by name
      if check_sex_by_name(@daugter_name)
        @daugter_name_correct = true
      else
        @daugter_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,6,@daugter_name,@user_sex)
      @tree_array << @tree_profile_arr
    end

    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}

    redirect_to show_start_tree_path

  end




end