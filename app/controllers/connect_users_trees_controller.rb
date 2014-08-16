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

  #    table_row.save  ####

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

  #     table_row.save  ####

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

  # Метод дла получения массива обратных профилей для
  # перезаписи профилей в таблицах
  # opposite_profiles_arr # DEBUGG_TO_VIEW
  # who_conn_users_arr - массив id, входящих в объед-ное дерево автора (того, кто соединяется)
  # with_who_con_usrs_ar - массив id, входящих в объед-ное дерево того, с кем соединяется автор
  # found_profiles, found_relations
  def get_opposite_profiles(who_conn_users_arr, with_who_con_usrs_ar, searched_profiles_hash, searched_relations_hash)
    opposite_profiles_arr = []  # DEBUGG_TO_VIEW
    profiles_to_rewrite = [] # - массив профилей, которые остаются
    profiles_to_destroy = [] # - массив профилей, которые удаляются
    profiles_relations = [] # - массив отношений, для тех, которые сохраняются в массивах
    @rewrite_and_destroy_hash = Hash.new
    logger.info "DEBUG in get_opposite_profiles: START "
    logger.info " Input users: who_conn_users_arr = #{who_conn_users_arr},  with_who_con_usrs_ar = #{with_who_con_usrs_ar}"
    logger.info " Input arrays: searched_profiles_hash = #{searched_profiles_hash},  searched_relations_hash = #{searched_relations_hash}"

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


  # Метод дла получения массива обратных профилей для
  # перезаписи профилей в таблицах
  # opposite_profiles_arr # DEBUGG_TO_VIEW
  # who_conn_users_arr - массив id, входящих в объед-ное дерево автора (того, кто соединяется)
  # with_who_con_usrs_ar - массив id, входящих в объед-ное дерево того, с кем соединяется автор
  # found_profiles, found_relations
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

  # Метод дла перезаписи профилей в таблицах
  # who_found_user_id - Автор дерева, который ищет
  # where_found_user_id - Автор дерева, в котором найдено
  ## (остаются): profiles_to_rewrite -
  ## (уходят): profiles_to_destroy -
  # who_connect_ids_arr - массив id, входящих в объед-ное дерево автора (того, кто соединяется)
  # with_who_conn_ids_ar - массив id, входящих в объед-ное дерево того, с кем соединяется автор
  #
  def connect_trees(profiles_to_rewrite, profiles_to_destroy, who_connect_ids_arr, with_who_conn_ids_ar)

    #@profiles_to_rewrite = profiles_to_rewrite # DEBUGG_TO_VIEW
    #@profiles_to_destroy = profiles_to_destroy # DEBUGG_TO_VIEW


    ####### !!!!! ЗДЕСЬ - ВАЖНО, ЧТОБЫ СОХРАНЯЛОСЬ СООТВЕТСТВИЕ ПРИ УДАЛЕНИИ - СДЕЛАТЬ ХЭШ!
    # И УДАЛЯТЬ ПО ОДИНАКОВОЫМ keys.

    profiles_to_rewrite = profiles_to_rewrite.uniq
    profiles_to_destroy = profiles_to_destroy.uniq

    @profiles_to_rewrite = profiles_to_rewrite # DEBUGG_TO_VIEW
    @profiles_to_destroy = profiles_to_destroy # DEBUGG_TO_VIEW

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

  # Управляемый Метод для изготовления 2-х синхронных UNIQ массивов
  # Вход:
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


  # Главный стартовый метод дла перезаписи профилей в таблицах
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



    # link current_user_id: current_user.id,  , matched_profiles: @final_reduced_profiles_hash, matched_relations: @final_reduced_relations_hash
    #current_user_id = params[:current_user_id] #
    current_user_id = current_user.id #
    user_id = params[:user_id_to_connect] #
    connected_user = User.find(user_id)


    ## Check users lock status and connect if all ok
    #if current_user.tree_is_locked? or connected_user.tree_is_locked?
    #  redirect_to :back, :alert => "Дерево находится в процессе реорганизации, повторите попытку позже"
    #else
    #
    #      current_user.lock!
    #      connected_user.lock!

            @current_user_id = current_user_id # DEBUGG_TO_VIEW
            @user_id = user_id # DEBUGG_TO_VIEW
            who_connect_users_arr = current_user.get_connected_users # DEBUGG_TO_VIEW
            @who_connect_users_arr = who_connect_users_arr # DEBUGG_TO_VIEW

            # Проверка: может быть дерево автора уже было соединено с выбранным юзером?
            if !who_connect_users_arr.include?(user_id.to_i) # check_connection: IF NOT CONNECTED
              logger.info "DEBUG IN connection_of_trees: NOT CONNECTED - #{who_connect_users_arr.include?(user_id).inspect}" # == false

              with_whom_connect_users_arr = User.find(user_id).get_connected_users  #
              @with_whom_connect_users_arr = with_whom_connect_users_arr # DEBUGG_TO_VIEW
              @first_tree = get_connected_tree(who_connect_users_arr) # # DEBUGG_TO_VIEW Массив объединенного дерева из Tree
              @second_tree = get_connected_tree(with_whom_connect_users_arr) # # DEBUGG_TO_VIEW Массив объединенного дерева из Tree

              ################################
              ######## ПОВТОРНЫЙ запуск Основного метода поиска от дерева Автора (вместе с соединенными с ним)
              ######## среди других деревьев.
              beg_search_time = Time.now   # Начало отсечки времени поиска
              search_results = current_user.start_search  #####  Запуск поиска
              end_search_time = Time.now   # Конец отсечки времени поиска
              @elapsed_search_time = (end_search_time - beg_search_time).round(5) # Длительность поиска - для инфы

              ######## Сбор части рез-тов поиска, необходимых для объединения:
              @final_reduced_profiles_hash = search_results[:final_reduced_profiles_hash]
              @final_reduced_relations_hash = search_results[:final_reduced_relations_hash]

              # Определение массивов профилей для перезаписи
              profiles_rewrite, profiles_destroy, output_relations = get_opposite_profiles(who_connect_users_arr, with_whom_connect_users_arr, @final_reduced_profiles_hash, @final_reduced_relations_hash)
              @profiles_rewrite = profiles_rewrite # DEBUGG_TO_VIEW
              @profiles_destroy = profiles_destroy # DEBUGG_TO_VIEW
              @output_relations = output_relations # DEBUGG_TO_VIEW


              ######## Обработка результатов поиска для определения профилей для перезаписи
              ######## !! СОБИРАЕМ МАССИВЫ НАЙДЕННЫХ ПРОФИЛЕЙ ПО ВСЕМ ЮЗЕРАМ В ДЕРЕВЬЯХ - Т.Е.
              # ПО ВСЕМУ @with_whom_connect_users_arr.
              matched_profiles_in_tree = []
              matched_relations_in_tree = []

              users_in_results = @final_reduced_profiles_hash.keys # users, найденные в поиске
              @users_in_results = users_in_results#.uniq # DEBUGG_TO_VIEW
              with_whom_connect_users_arr.each do |user_id_in_conn_tree|
                if users_in_results.include?(user_id_in_conn_tree.to_i) # для исключения случая,
                  # когда в рез-тах поиска (@final_reduced_profiles_hash)
                  # не для всех юзеров из объед-го дерева (with_whom_connect_users_arr) - есть рез-ты
                  matched_profiles_arr = @final_reduced_profiles_hash.values_at(user_id_in_conn_tree.to_i)[0].values.flatten
                  matched_relations_arr = @final_reduced_relations_hash.values_at(user_id_in_conn_tree.to_i)[0].values.flatten
                  matched_profiles_in_tree << matched_profiles_arr
                  matched_relations_in_tree << matched_relations_arr
                end
              end
              found_profiles = matched_profiles_in_tree.flatten(1)  # get one dimension arr
              @found_profiles = found_profiles#.uniq # DEBUGG_TO_VIEW
              found_relations = matched_relations_in_tree.flatten(1) # get one dimension arr
              @found_relations = found_relations#.uniq # DEBUGG_TO_VIEW
              @matched_profiles_in_tree = matched_profiles_in_tree # DEBUGG_TO_VIEW

              # Управляемый Метод для изготовления 2-х синхронных UNIQ массивов: found_profiles_uniq, found_relations_uniq
              #found_profiles_uniq, found_relations_uniq = make_uniq_arrays(found_profiles, found_relations)

              # Определение массивов профилей для перезаписи
              #@rewrite_and_destroy_hash, opposite_profiles_arr, profiles_to_rewrite, profiles_to_destroy = get_opposite_profiles(who_connect_users_arr, with_whom_connect_users_arr, found_profiles_uniq, found_relations_uniq)
              @rewrite_and_destroy_hash, opposite_profiles_arr, profiles_to_rewrite, profiles_to_destroy, profiles_relations = get_opposite_profiles_old(who_connect_users_arr, with_whom_connect_users_arr, found_profiles, found_relations)
              # Контроль корректности массивов перед объединением
              if !@profiles_to_rewrite.blank? && !@profiles_to_destroy.blank?
                logger.info "Connection proceed. Array(s) - Dont blank."
                @test_arrrs_blank = "Connection proceed. Array(s) - Dont blank "
                if @profiles_to_rewrite.size == @profiles_to_destroy.size
                  logger.info "Ok to connect. Connection array(s) - Equal. Size = #{@profiles_relations.size}."
                  logger.info "Ok to connect. Connection array(s) - Equal. Relations Size = #{@profiles_to_rewrite.size}."
                  @test_arrrs = "Ok to connect. Connection array(s) - Equal. Size profiles = #{@profiles_to_rewrite.size} "
                    @opposite_profiles_arr = opposite_profiles_arr # DEBUGG_TO_VIEW
                    @profiles_to_rewrite = profiles_to_rewrite # DEBUGG_TO_VIEW
                    @profiles_to_destroy = profiles_to_destroy # DEBUGG_TO_VIEW
                    @profiles_relations = profiles_relations # DEBUGG_TO_VIEW

                  # Собственно - соединение деревьев = перезапись профилей в таблицах
                  connect_trees(profiles_to_rewrite, profiles_to_destroy, who_connect_users_arr, with_whom_connect_users_arr)
                  # Заполнение таблицы - записью о том, что деревья с current_user_id и user_id - соединились
   #               connect_users(current_user_id.to_i, user_id.to_i)

                else
                 logger.info "STOP connection! Array(s) - NOT Equal! To_rewrite arr.size = #{@profiles_to_rewrite.size}; To_destroy arr.size = #{@profiles_to_destroy.size}."
                 @test_arrrs = "STOP connection! Array(s) - NOT Equal! To_rewrite arr.size = #{@profiles_to_rewrite.size}; To_destroy arr.size = #{@profiles_to_destroy.size}"
                end
              else
                logger.info "STOP connection! Connection array(s) - blank! ."
                @test_arrrs_blank = "STOP connection! Connection array(s) - blank! "
              end

            else
              logger.info "DEBUG IN connection_of_trees: USERS ALREADY CONNECTED! Current_user_arr =#{who_connect_users_arr.inspect}, user_id_arr=#{with_whom_connect_users_arr.inspect}."
            end

      #      # Afrer all unlock unlock user tree
      #      current_user.unlock_tree!
      #      connected_user.unlock_tree!
      #end

  end

# My LOG 16.08.14
  # 103 Denis   [[103, 819, 151, 0, 819, 151, 1, false], [103, 819, 151, 1, 820, 73, 1, false], [103, 819, 151, 2, 821, 516, 0, false], [103, 819, 151, 6, 822, 214, 0, false], [103, 819, 151, 6, 823, 331, 0, false], [103, 819, 151, 8, 824, 103, 0, false], [103, 819, 151, 4, 825, 172, 0, false], [103, 819, 151, 4, 826, 147, 0, false]]
  # 104 Natalia  [[104, 827, 331, 0, 827, 331, 0, false], [104, 827, 331, 1, 828, 73, 1, false], [104, 827, 331, 2, 829, 516, 0, false], [104, 827, 331, 5, 830, 151, 1, false], [104, 827, 331, 6, 831, 214, 0, false], [104, 827, 331, 7, 832, 162, 1, false]]
  # 104+103: @profiles_to_rewrite: [823, 820, 821, 819, 822]  @profiles_to_destroy: [827, 828, 829, 830, 831]
  # connected_tree_arr: [[104, 823, 331, 7, 832, 162, 1, false], [104, 823, 331, 0, 823, 331, 0, false], [104, 823, 331, 1, 820, 73, 1, false], [104, 823, 331, 2, 821, 516, 0, false], [104, 823, 331, 5, 819, 151, 1, false], [104, 823, 331, 6, 822, 214, 0, false], [103, 819, 151, 0, 819, 151, 1, false], [103, 819, 151, 1, 820, 73, 1, false], [103, 819, 151, 2, 821, 516, 0, false], [103, 819, 151, 6, 822, 214, 0, false], [103, 819, 151, 6, 823, 331, 0, false], [103, 819, 151, 8, 824, 103, 0, false], [103, 819, 151, 4, 825, 172, 0, false], [103, 819, 151, 4, 826, 147, 0, false]]
  # 105 Irina [[105, 833, 214, 0, 833, 214, 0, false], [105, 833, 214, 1, 834, 73, 1, false], [105, 833, 214, 2, 835, 516, 0, false], [105, 833, 214, 5, 836, 151, 1, false], [105, 833, 214, 6, 837, 331, 0, false], [105, 833, 214, 7, 838, 318, 1, false], [105, 833, 214, 3, 839, 194, 1, false]]
  # 106 Mihail [[106, 840, 318, 0, 840, 318, 1, false], [106, 840, 318, 1, 841, 122, 1, false], [106, 840, 318, 2, 842, 173, 0, false], [106, 840, 318, 5, 843, 37, 1, false], [106, 840, 318, 5, 844, 122, 1, false], [106, 840, 318, 8, 845, 214, 0, false], [106, 840, 318, 3, 846, 194, 1, false]]
  # 105+(103+104):@profiles_to_rewrite: [822, 820, 821, 819, 823]
  #               @profiles_to_destroy: [833, 834, 835, 836, 837]
  # [822, 822, 820, 820, 821, 821, 819, 819, 823, 823, 822, 822, 820, 820, 821, 821, 819, 819, 823, 823];
  # [833, 833, 834, 834, 835, 835, 836, 836, 837, 837, 833, 833, 834, 834, 835, 835, 836, 836, 837, 837].
  # connected_tree_arr: [[105, 822, 214, 7, 838, 318, 1, false], [105, 822, 214, 3, 839, 194, 1, false], [105, 822, 214, 0, 822, 214, 0, false], [105, 822, 214, 1, 820, 73, 1, false], [105, 822, 214, 2, 821, 516, 0, false], [105, 822, 214, 5, 819, 151, 1, false], [105, 822, 214, 6, 823, 331, 0, false], [103, 819, 151, 0, 819, 151, 1, false], [103, 819, 151, 1, 820, 73, 1, false], [103, 819, 151, 2, 821, 516, 0, false], [103, 819, 151, 6, 822, 214, 0, false], [103, 819, 151, 6, 823, 331, 0, false], [103, 819, 151, 8, 824, 103, 0, false], [103, 819, 151, 4, 825, 172, 0, false], [103, 819, 151, 4, 826, 147, 0, false], [104, 823, 331, 7, 832, 162, 1, false], [104, 823, 331, 0, 823, 331, 0, false], [104, 823, 331, 1, 820, 73, 1, false], [104, 823, 331, 2, 821, 516, 0, false], [104, 823, 331, 5, 819, 151, 1, false], [104, 823, 331, 6, 822, 214, 0, false]]
  # debugg (103+104+105) + 106:
  # To_rewrite arr = [838, 839, 822, 822, 822, 822, 822];
  # To_destroy arr = [840, 846, 845, 845, 845, 845, 845].
  #  @profiles_relations = [7, 3, 0, 6, 6, 6, 6];
  #
  # /

end

# DEBUGG_TO_VIEW
