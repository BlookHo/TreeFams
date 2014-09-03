class ConnectUsersTreesController < ApplicationController
  include SearchHelper


  def connect_users(current_user_id, user_id)

    if current_user_id != user_id
      new_users_connection = ConnectedUser.new
      new_users_connection.user_id = current_user_id
      new_users_connection.with_user_id = user_id
      new_users_connection.save
    else
      logger.info "ERROR: Connection of Users - INVALID! Current_user=#{current_user_id.inspect} EQUALS TO user_id=#{user_id.inspect}"
    end

  end

  # Общий метод дла накапливания массива для перезаписи профилей в таблицах
  #
  def get_rewrite_profiles_ids(db_table, db_field, where_rewrite_user, field_profiles, new_profile_id)

    arr_to_rewrite = []
    one_arr = []
    where_found_to_replace = db_table.where(:user_id => where_rewrite_user.to_i).where(" #{db_field} = #{field_profiles} " )#[0]
    if !where_found_to_replace.blank?
      where_found_to_replace.each do |rewrite_row|
        one_arr[0] = rewrite_row.id ## DEBUGG_TO_VIEW
        one_arr[1] = db_field ## DEBUGG_TO_VIEW
        one_arr[2] = new_profile_id ## DEBUGG_TO_VIEW
        one_arr[3] = "-->" ## DEBUGG_TO_VIEW
        one_arr[4] = field_profiles #{db_field} ## DEBUGG_TO_VIEW
        arr_to_rewrite << one_arr
        one_arr = []
      end
      arr_to_rewrite
    else
      return nil
    end

    logger.info " In #{db_table}, #{db_field}: arr_to_rewrite = #{arr_to_rewrite} " # DEBUGG_TO_VIEW
    return arr_to_rewrite

  end

  # Общий метод дла перезаписи профилей в таблицах
  #
  def save_rewrite_profiles_ids(db_table, rewrite_arr)

    saved_profiles_arr = [] # DEBUGG_TO_VIEW
    test_arr = [] # DEBUGG_TO_VIEW
    for arr_ind in 0 .. rewrite_arr.length-1


      if rewrite_arr[arr_ind].length == 1
        row_id = rewrite_arr[arr_ind][0][0]
        row_field = rewrite_arr[arr_ind][0][1]
        new_profile_id = rewrite_arr[arr_ind][0][2]

        table_row = db_table.find(row_id)

        case row_field
          when "profile_id"
            table_row.profile_id = new_profile_id
            test_arr[1] = "pr" # DEBUGG_TO_VIEW
          when "is_profile_id"
            table_row.is_profile_id = new_profile_id
            test_arr[1] = "is_pr" # DEBUGG_TO_VIEW
          else
            "No field"
        end

      table_row.save  ####

        test_arr[0] = table_row.id # DEBUGG_TO_VIEW
        test_arr[2] = rewrite_arr[arr_ind][0][2] # DEBUGG_TO_VIEW

        saved_profiles_arr << test_arr # DEBUGG_TO_VIEW
        test_arr = [] # DEBUGG_TO_VIEW

      else  # rewrite_arr[arr_ind].length > 1

        rewrite_arr[arr_ind].each do |one_arr|
          row_id = one_arr[0]
          row_field = one_arr[1]
          new_profile_id = one_arr[2]

          table_row = db_table.find(row_id)

          case row_field
            when "profile_id"
              table_row.profile_id = new_profile_id
              test_arr[1] = "pr" # DEBUGG_TO_VIEW
            when "is_profile_id"
              table_row.is_profile_id = new_profile_id
              test_arr[1] = "is_pr" # DEBUGG_TO_VIEW
            else
              "No field"
          end

       table_row.save  ####

          test_arr[0] = table_row.id # DEBUGG_TO_VIEW
          test_arr[2] = one_arr[2] # DEBUGG_TO_VIEW

          saved_profiles_arr << test_arr # DEBUGG_TO_VIEW
          test_arr = [] # DEBUGG_TO_VIEW
        end

      end

    end

    @saved_profiles_arr = saved_profiles_arr # DEBUGG_TO_VIEW
    return @saved_profiles_arr # DEBUGG_TO_VIEW

  end

  # Для SEARCH_SOFT!
  # Метод дла получения массива обратных профилей для
  # перезаписи профилей в таблицах
  # who_conn_users_arr - массив id, входящих в объед-ное дерево автора (того, кто соединяется)
  # with_who_con_usrs_ar - массив id, входящих в объед-ное дерево того, с кем соединяется автор
  # searched_profiles_hash, searched_relations_hash
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


  # Метод дла перезаписи профилей в таблицах
  # who_found_user_id - Автор дерева, который ищет
  # where_found_user_id - Автор дерева, в котором найдено
  ## (остаются): profiles_to_rewrite -
  ## (уходят): profiles_to_destroy -
  # who_connect_ids_arr - массив id, входящих в объед-ное дерево автора (того, кто соединяется)
  # with_who_conn_ids_ar - массив id, входящих в объед-ное дерево того, с кем соединяется автор
  #
  def connect_trees(profiles_to_rewrite, profiles_to_destroy, who_connect_ids_arr, with_who_conn_ids_ar)

    logger.info "DEBUG IN CONNECT_TREES: profiles_to_rewrite = #{profiles_to_rewrite}; profiles_to_destroy = #{profiles_to_destroy} "

    rewrite_tree_arr1 = []
    rewrite_tree_arr2 = []
    rewrite_profilekey_arr1 = []
    rewrite_profilekey_arr2 = []

    #########  перезапись profile_id's & update User
    ## (остаются): profiles_to_rewrite - противоположные, найденным в поиске
    ## (уходят): profiles_to_destroy - найден в поиске
    # Первым параметром идут те профили, которые остаются
    Profile.merge(profiles_to_rewrite, profiles_to_destroy)

    for arr_ind in 0 .. profiles_to_destroy.length-1 # ищем этот profile_id для его замены
      # меняем profile_id в match_profiles_arr на profile_id из opposite_profiles_arr
      one_profile = profiles_to_destroy[arr_ind] # profile_id для замены
      logger.info one_profile

      with_who_conn_ids_ar.each do |one_user_in_tree|
        # Получение массивов для Замены профилей в Tree
        one_arr1 = get_rewrite_profiles_ids(Tree, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_tree_arr1 << one_arr1 if !one_arr1.blank?
        @rewrite_tree_arr1 = rewrite_tree_arr1 # DEBUGG_TO_VIEW
        one_arr2 = get_rewrite_profiles_ids(Tree, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_tree_arr2 << one_arr2 if !one_arr2.blank?
        @rewrite_tree_arr2 = rewrite_tree_arr2 # DEBUGG_TO_VIEW

        # Получение массивов для Замены профилей в ProfileKey
        one_arr1 = get_rewrite_profiles_ids(ProfileKey, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_profilekey_arr1 << one_arr1 if !one_arr1.blank?
        @rewrite_profilekey_arr1 = rewrite_profilekey_arr1 # DEBUGG_TO_VIEW
        one_arr2 = get_rewrite_profiles_ids(ProfileKey, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_profilekey_arr2 << one_arr2 if !one_arr2.blank?
        @rewrite_profilekey_arr2 = rewrite_profilekey_arr2 # DEBUGG_TO_VIEW
      end

      who_connect_ids_arr.each do |one_user_in_tree|
        # Получение массивов для Замены профилей в Tree
        one_arr1 = get_rewrite_profiles_ids(Tree, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_tree_arr1 << one_arr1 if !one_arr1.blank?
        @rewrite_tree_arr1 = rewrite_tree_arr1 # DEBUGG_TO_VIEW
        one_arr2 = get_rewrite_profiles_ids(Tree, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_tree_arr2 << one_arr2 if !one_arr2.blank?
        @rewrite_tree_arr2 = rewrite_tree_arr2 # DEBUGG_TO_VIEW

        # Получение массивов для Замены профилей в ProfileKey
        one_arr1 = get_rewrite_profiles_ids(ProfileKey, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_profilekey_arr1 << one_arr1 if !one_arr1.blank?
        @rewrite_profilekey_arr1 = rewrite_profilekey_arr1 # DEBUGG_TO_VIEW
        one_arr2 = get_rewrite_profiles_ids(ProfileKey, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_profilekey_arr2 << one_arr2 if !one_arr2.blank?
        @rewrite_profilekey_arr2 = rewrite_profilekey_arr2 # DEBUGG_TO_VIEW
      end

    end


    save_rewrite_profiles_ids(Tree, rewrite_tree_arr1 + rewrite_tree_arr2)
    @save_in_tree = @saved_profiles_arr # DEBUGG_TO_VIEW
    @save_in_tree_LEN = @saved_profiles_arr.length if !@save_in_tree.blank? # DEBUGG_TO_VIEW
    save_rewrite_profiles_ids(ProfileKey, rewrite_profilekey_arr1 + rewrite_profilekey_arr2)
    @save_in_profilekey = @saved_profiles_arr # DEBUGG_TO_VIEW
    @save_in_profilekey_LEN = @saved_profiles_arr.length if !@save_in_profilekey.blank? # DEBUGG_TO_VIEW

  end


  # Для SEARCH_HARD!
  # Метод определения массивов перезаписи профилей при объединении деревьев
  # На входе: рез-тат жесткого поиска совпавших профилей - при совпадении их БК
  # Далее начинаем цикл по профилям, кот-е участвуют в БК совпавших профилей при жестком поиске
  # Поэтапное наполнение массивов перезаписи
  #
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

  ######## Главный стартовый метод дла перезаписи профилей в таблицах
  # Вход:
  # current_user_id = params[:current_user_id] = who_found_user_id - Автор дерева, который ищет
  # user_id = params[:user_id_to_connect] = where_found_user_id - Автор дерева, в котором найдено# DEBUGG_TO_VIEW#
  # matched_profiles_in_tree = ... params[:matched_profiles] = Из поиска: @final_reduced_profiles_hash
  # matched_relations_in_tree = ... params[:matched_relations] = Из поиска:  @final_reduced_relations_hash
  # Выход:
  # 1. перезапись profile_id в таблице Profile.
  # 2. update в таблице User
  # 3. перезапись profile_id в полях "profile_id" и "is_profile_id"
  # в таблицах Tree & ProfileKey.
  def connection_of_trees

    current_user_id = current_user.id #
    user_id = params[:user_id_to_connect] # From view
    @current_user_id = current_user_id # DEBUGG_TO_VIEW
    @user_id = user_id # DEBUGG_TO_VIEW

    connected_user = User.find(user_id) # For lock check

    ######## Check users lock status and connect if all ok
    if current_user.tree_is_locked? or connected_user.tree_is_locked?
      redirect_to :back, :alert => "Дерево находится в процессе реорганизации, повторите попытку позже"
    else
          ######## Check users lock status and connect if all ok
          current_user.lock!
          connected_user.lock!

            who_connect_users_arr = current_user.get_connected_users
            @who_connect_users_arr = who_connect_users_arr # DEBUGG_TO_VIEW
            # Проверка: может быть дерево автора уже было соединено с выбранным юзером?
            if !who_connect_users_arr.include?(user_id.to_i) # check_connection: IF NOT CONNECTED
              logger.info "DEBUG IN connection_of_trees: NOT CONNECTED - #{who_connect_users_arr.include?(user_id).inspect}" # == false
              with_whom_connect_users_arr = User.find(user_id).get_connected_users  #
              @with_whom_connect_users_arr = with_whom_connect_users_arr # DEBUGG_TO_VIEW
              @first_tree = get_connected_tree(who_connect_users_arr) # # DEBUGG_TO_VIEW Массив объединенного дерева из Tree
              @second_tree = get_connected_tree(with_whom_connect_users_arr) # # DEBUGG_TO_VIEW Массив объединенного дерева из Tree

              profiles_to_rewrite = [] # - массив профилей, которые остаются
              profiles_to_destroy = [] # - массив профилей, которые удаляются

              ######## запуск Жесткого метода поиска от дерева Автора (вместе с соединенными с ним)
              ######## Для точного определения массивов профилей для перезаписи
              beg_search_time = Time.now   # Начало отсечки времени поиска

              ##############################################################################
              ##### ВЫБОР ВИДА ПОИСКА: start_hard_search (жесткий) или start_search (мягкий)
              ##############################################################################
              #search_results = current_user.start_hard_search  ##
              ####  Запуск ЖЕСТКОГО поиска
              #profiles_to_rewrite, profiles_to_destroy =  get_rewrite_profiles_by_bk(search_results) ##
              #####  Запуск ЖЕСТКОГО определения совпадающих профилей для объединения
              # Определение массивов профилей для перезаписи: profiles_to_rewrite, profiles_to_destroy

              ##############################################################################
          #    search_results = current_user.start_search_first  #####  Запуск поиска 1-й версии

              search_results = current_user.start_search  ## Запуск поиска с right_profile
              ###  Запуск МЯГКОГО поиска
              profiles_to_rewrite, profiles_to_destroy = get_opposite_profiles(search_results, who_connect_users_arr, with_whom_connect_users_arr)
              #  Запуск МЯГКОГО определения совпадающих профилей для объединения
              # Определение массивов профилей для перезаписи: profiles_to_rewrite, profiles_to_destroy

              ##############################################################################

              end_search_time = Time.now   # Конец отсечки времени поиска
              @elapsed_search_time = (end_search_time - beg_search_time).round(5) # Длительность поиска - для инфы

              logger.info "Array(s) FOR connection: profiles_to_rewrite = #{profiles_to_rewrite}; profiles_to_destroy = #{profiles_to_destroy}."
              # @output_relations = output_relations # Может быть взят в МЯГКОМ определении совпадающих

              @profiles_to_rewrite = profiles_to_rewrite # DEBUGG_TO_VIEW
              @profiles_to_destroy = profiles_to_destroy # DEBUGG_TO_VIEW
              ######## Контроль корректности массивов перед объединением
              if !@profiles_to_rewrite.blank? && !@profiles_to_destroy.blank?

                logger.info "Connection proceed. Array(s) - Dont blank."
                #@test_arrrs_blank = "Connection proceed. Array(s) - Dont blank "
                if @profiles_to_rewrite.size == @profiles_to_destroy.size
                  logger.info "Ok to connect. Connection array(s) - Equal. Relations Size = #{@profiles_to_rewrite.size}."

                  #@profiles_to_rewrite=  [16, 17, 18, 19, 20, 21, 22, 23]
                  #@profiles_to_destroy=  [28, 27, 24, 30, 29, 33, 28, 32]
                  # Проверка найденных массивов перезаписи перед объединением - на повторы
                  complete_dubles_hash = check_duplications(@profiles_to_rewrite, @profiles_to_destroy)

                  if complete_dubles_hash.empty? # Если НЕТ дублирования в массивах

                    @test_arrrs_doubles = "Ok to connect. Connection array(s): - НЕТ Дублирований  "
                    logger.info "Ok to connect. НЕТ Дублирований.  complete_dubles_hash = #{complete_dubles_hash};"

                    ###################################################################
                    ######## Собственно Центральный метод соединения деревьев = перезапись профилей в таблицах
                                  connect_trees(profiles_to_rewrite, profiles_to_destroy, who_connect_users_arr, with_whom_connect_users_arr)
                    ####################################################################
                    ######## Заполнение таблицы Connected_Trees - записью о том, что деревья с current_user_id и user_id - соединились
                                connect_users(current_user_id.to_i, user_id.to_i)
                    ##################################################################
                  else
                    logger.info "STOP connection: ЕСТЬ дублирования в поиске: complete_dubles_hash = #{complete_dubles_hash};"
                    @test_arrrs_dubl = "ERROR - STOP connection! ЕСТЬ дублирования! To_rewrite arr = #{@profiles_to_rewrite}; To_destroy arr = #{@profiles_to_destroy}"
                  end

                else
                 logger.info "ERROR - STOP connection! Array(s) - NOT Equal! To_rewrite arr.size = #{@profiles_to_rewrite.size}; To_destroy arr.size = #{@profiles_to_destroy.size}."
                 @test_arrrs_size = "ERROR - STOP connection! Array(s) - NOT Equal! To_rewrite arr.size = #{@profiles_to_rewrite.size}; To_destroy arr.size = #{@profiles_to_destroy.size}"
                end

              else
                logger.info "ERROR - STOP connection! Connection array(s) - blank! ."
                @test_arrrs_blank = "ERROR - STOP connection! Connection array(s) - blank! "
              end

            else
              logger.info "WARNING: DEBUG IN connection_of_trees: USERS ALREADY CONNECTED! Current_user_arr =#{who_connect_users_arr.inspect}, user_id_arr=#{with_whom_connect_users_arr.inspect}."
            end

            ######## Afrer all unlock unlock user tree
            current_user.unlock_tree!
            connected_user.unlock_tree!
      end

  end





  # Проверка найденных массивов перезаписи при объединении - на повторы
  # .
  def check_duplications(profiles_to_rewrite, profiles_to_destroy)

    logger.info "In check_duplicationst"
    logger.info " profiles_to_rewrite = #{profiles_to_rewrite}; profiles_to_destroy = #{profiles_to_destroy}."

    # Извлечение из массива - повторяющиеся эл-ты в виде массива
    def repeated(array)
      counts = Hash.new(0)
      array.each{|val|counts[val]+=1}
      counts.reject{|val,count|count==1}.keys
    end

    repeated_destroy = repeated(profiles_to_destroy)
    logger.info " repeated_destroy = #{repeated_destroy};"
    indexs_hash_destroy = {}
    if !repeated_destroy.blank?
      for i in 0 .. repeated_destroy.length-1
        arr_of_dubles = []
        profiles_to_destroy.each_with_index do |arr_el, index|
          if arr_el == repeated_destroy[i]
            arr_of_dubles << profiles_to_rewrite[index]
          end
        end
        indexs_hash_destroy.merge!(repeated_destroy[i] => arr_of_dubles)
      end
    end
    logger.info "indexs_hash_destroy = #{indexs_hash_destroy};"

    repeated_rewrite = repeated(profiles_to_rewrite)
    logger.info " repeated_rewrite = #{repeated_rewrite};"
    indexs_hash_rewrite = {}
    if !repeated_rewrite.blank?
      for i in 0 .. repeated_rewrite.length-1
        arr_of_dubles = []
        profiles_to_rewrite.each_with_index do |arr_el, index|
          if arr_el == repeated_rewrite[i]
            arr_of_dubles << profiles_to_destroy[index]
          end
        end
        indexs_hash_rewrite.merge!(repeated_rewrite[i] => arr_of_dubles)
      end
    end
    logger.info "indexs_hash_rewrite = #{indexs_hash_rewrite};"

    complete_dubles_hash = {}
    complete_dubles_hash = complete_dubles_hash.merge!(indexs_hash_destroy) if !indexs_hash_destroy.blank?
    complete_dubles_hash = complete_dubles_hash.merge!(indexs_hash_rewrite) if !indexs_hash_rewrite.blank?

    logger.info " complete_dubles_hash = #{complete_dubles_hash};"
    @complete_dubles_hash = complete_dubles_hash

    if @complete_dubles_hash.empty?
      @rez_duble = true
    else
      @rez_duble = false

    end

    return complete_dubles_hash

  end





end
