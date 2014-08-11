class ConnectUsersTreesController < ApplicationController

  # Получение дерева из таблицы
  def get_tree(user_id)
    tree_of_user = Tree.where(:user_id => user_id)
    return tree_of_user
  end

  # Получение дерева в виде массива
  def tree_arr(user_id)
    get_tree(user_id).map {|t|  [t.user_id, t.profile_id, t.name_id, t.relation_id, t.is_profile_id, t.is_name_id, t.is_sex_id] }
  end



  def connect_users(current_user_id, user_id)

    if current_user_id != user_id
      new_users_connection = ConnectedUser.new
      new_users_connection.user_id = current_user_id
      new_users_connection.with_user_id = user_id
      #new_users_connection.connected = true
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

 #      table_row.save  ####

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

 #       table_row.save  ####

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

  ## Получение массива соединенных Юзеров
  ## для заданного "стартового" Юзера
  ##
  #def get_connected_users_new(user_id) # аналогичный метод - в Users.rb - c self
  #  connected_users_arr = []
  #  connected_users_arr << user_id.to_i# self.id
  #  #first_users_arr = ConnectedUser.where(user_id: self.id).pluck(:with_user_id)
  #  first_users_arr = ConnectedUser.where(user_id: user_id).pluck(:with_user_id)
  #  if first_users_arr.blank?
  #    #first_users_arr = ConnectedUser.where(with_user_id: self.id).pluck(:user_id)
  #    first_users_arr = ConnectedUser.where(with_user_id: user_id).pluck(:user_id)
  #  end
  #  one_connected_users_arr = first_users_arr
  #  if !one_connected_users_arr.blank?
  #    connected_users_arr << one_connected_users_arr
  #    connected_users_arr.flatten!.uniq! if !connected_users_arr.blank?
  #    one_connected_users_arr.each do |conn_arr_el|
  #      next_connected_users_arr = ConnectedUser.where("(user_id = #{conn_arr_el} or with_user_id = #{conn_arr_el})").pluck(:user_id, :with_user_id)
  #      if !next_connected_users_arr.blank?
  #        one_connected_users_arr << next_connected_users_arr
  #        one_connected_users_arr.flatten!.uniq! if !one_connected_users_arr.blank?
  #        connected_users_arr << next_connected_users_arr
  #        connected_users_arr.flatten!.uniq! if !connected_users_arr.blank?
  #      end
  #    end
  #  end
  #  return connected_users_arr
  #end
  #

  # Метод дла получения массива обратных профилей для
  # перезаписи профилей в таблицах
  # opposite_profiles_arr
  #
  def get_opposite_profiles(who_connect_users_arr, with_whom_connect_users_arr, match_profiles_arr, match_relations_arr)
    opposite_profiles_arr = []
    profiles_to_rewrite = [] # - массив профилей, которые остаются
    profiles_to_destroy = [] # - массив профилей, которые удаляются

    for arr_ind in 0 .. match_profiles_arr.length-1
      one_profile = match_profiles_arr[arr_ind]
      #@one_profile = one_profile # DEBUGG_TO_VIEW
      one_relation = match_relations_arr[arr_ind]
      #where_found_tree_row = Tree.where(:user_id => with_whom_connect, :is_profile_id => one_profile.to_i)[0]
      with_whom_connect_users_arr.each do |one_user_in_tree|
        where_found_tree_row = Tree.where(:user_id => one_user_in_tree, :is_profile_id => one_profile.to_i)[0]
        #@where_found_tree_row = where_found_tree_row # DEBUGG_TO_VIEW
        if !where_found_tree_row.blank?
          #who_found_tree_row = Tree.where(:user_id => who_connect.to_i, :is_name_id => where_found_tree_row.is_name_id.to_i, :relation_id => one_relation,:is_sex_id => where_found_tree_row.is_sex_id.to_i)[0]

          who_connect_users_arr.each do |one_user_in_conn_tree|
            who_found_tree_row = Tree.where(:user_id => one_user_in_conn_tree, :is_name_id => where_found_tree_row.is_name_id.to_i, :relation_id => one_relation,:is_sex_id => where_found_tree_row.is_sex_id.to_i)[0]

            if !who_found_tree_row.blank?
              opposite_profiles_arr << who_found_tree_row.is_profile_id
              if who_found_tree_row.is_profile_id < match_profiles_arr[arr_ind].to_i
                profiles_to_rewrite << who_found_tree_row.is_profile_id
                profiles_to_destroy << match_profiles_arr[arr_ind].to_i
              else
                profiles_to_destroy  << who_found_tree_row.is_profile_id
                profiles_to_rewrite << match_profiles_arr[arr_ind].to_i
              end

            end

          end
        end

      end
    end

    return opposite_profiles_arr, profiles_to_rewrite, profiles_to_destroy
  end

  # Метод дла перезаписи профилей в таблицах
  # who_found_user_id - Автор дерева, который ищет
  # where_found_user_id - Автор дерева, в котором найдено
  #
  #def connect_trees_new(who_found_user_id, where_found_user_id, match_profiles_arr, match_relations_arr)
  def connect_trees(who_connect, with_whom_connect, match_profiles_arr, match_relations_arr)

    @match_profiles_arr = match_profiles_arr # DEBUGG_TO_VIEW
    @who_connect = who_connect # DEBUGG_TO_VIEW
    #@start_user = User.find(who_connect) # DEBUGG_TO_VIEW
    who_connect_users_arr = User.find(who_connect).get_connected_users #
    #who_connect_users_arr = get_connected_users_new(who_connect) # DEBUGG_TO_VIEW
    @who_connect_users_arr = who_connect_users_arr # DEBUGG_TO_VIEW

    @with_whom_connect = with_whom_connect # DEBUGG_TO_VIEW
    with_whom_connect_users_arr = User.find(with_whom_connect).get_connected_users  #
    @with_whom_connect_users_arr = with_whom_connect_users_arr # DEBUGG_TO_VIEW

    #opposite_profiles_arr, profiles_to_rewrite, profiles_to_destroy = get_opposite_profiles(who_found_user_id.to_i, where_found_user_id.to_i, match_profiles_arr, match_relations_arr)
    opposite_profiles_arr, profiles_to_rewrite, profiles_to_destroy = get_opposite_profiles(who_connect_users_arr, with_whom_connect_users_arr, match_profiles_arr, match_relations_arr)
    @opposite_profiles_arr = opposite_profiles_arr # DEBUGG_TO_VIEW
    #@profiles_to_rewrite = profiles_to_rewrite # DEBUGG_TO_VIEW
    #@profiles_to_destroy = profiles_to_destroy # DEBUGG_TO_VIEW

    profiles_to_rewrite = profiles_to_rewrite.uniq
    profiles_to_destroy = profiles_to_destroy.uniq

    @profiles_to_rewrite = profiles_to_rewrite # DEBUGG_TO_VIEW
    @profiles_to_destroy = profiles_to_destroy # DEBUGG_TO_VIEW

    logger.info "DEBUG IN CONNECT_TREES: match_profiles_arr = #{match_profiles_arr}; opposite_profiles_arr = #{opposite_profiles_arr} "

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

      with_whom_connect_users_arr.each do |one_user_in_tree|
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

      who_connect_users_arr.each do |one_user_in_tree|
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


  # Метод дла перезаписи профилей в таблицах
  # who_found_user_id - Автор дерева, который ищет
  # where_found_user_id - Автор дерева, в котором найдено
  #
  def connect_trees_old(who_found_user_id, where_found_user_id, match_profiles_arr, match_relations_arr)

  # 52 search from 52
    #match_profiles_arr = {"53"=>{"351"=>["361", "357", "362"]}, "54"=>{"351"=>["364", "365", "363"]}}
    #match_relations_arr = {"53"=>{"351"=>["0", "8", "3"]}, "54"=>{"351"=>["0", "8", "3"]}}
    #@matched_profiles_in_tree = ["361", "357", "362"]
    #@matched_relations_in_tree = ["0", "8", "3"]
    #@matched_profiles_arr = ["361", "357", "362"]
    #@opposite_profiles_arr = [351, 355, 356]


  opposite_profiles_arr = get_opposite_profiles(who_found_user_id, where_found_user_id, match_profiles_arr, match_relations_arr)
    @opposite_profiles_arr = opposite_profiles_arr # DEBUGG_TO_VIEW
    @match_profiles_arr = match_profiles_arr # DEBUGG_TO_VIEW
    logger.info "DEBUG IN CONNECT_TREES: match_profiles_arr = #{match_profiles_arr}; opposite_profiles_arr = #{opposite_profiles_arr} "

    rewrite_tree_arr1 = []
    rewrite_tree_arr2 = []
    rewrite_profilekey_arr1 = []
    rewrite_profilekey_arr2 = []
    #if who_found_user_id < where_found_user_id
    #  # если where_found_user_id - более поздний по времени создания
    #  # значит его профили в where_found_user_id (в match_profiles_arr)- заменяем на более ранние, т.е. - из who_found_user_id (из opposite_profiles_arr).
    #  @msg = "who_found_user_id < where_found_user_id" ## DEBUGG_TO_VIEW
    #
    #  #########  перезапись profile_id's & update User
    #  ## (остаются): opposite_profiles_arr - противоположные, найденным в поиске
    #  ## (уходят): match_profiles_arr - найден в поиске
    #  # Первым параметром идут те профили, которые остаются
    #  Profile.merge(opposite_profiles_arr, match_profiles_arr)
    #
    #  for arr_ind in 0 .. match_profiles_arr.length-1 # ищем этот profile_id для его замены
    #    # меняем profile_id в match_profiles_arr на profile_id из opposite_profiles_arr
    #    one_profile = match_profiles_arr[arr_ind] # profile_id для замены
    #    logger.info one_profile
    #
    #    # Получение массивов для Замены профилей в Tree
    #    one_arr1 = get_rewrite_profiles_ids(Tree, "profile_id", where_found_user_id.to_i, one_profile.to_i, opposite_profiles_arr[arr_ind].to_i)
    #    rewrite_tree_arr1 << one_arr1 if !one_arr1.blank?
    #    one_arr2 = get_rewrite_profiles_ids(Tree, "is_profile_id", where_found_user_id.to_i, one_profile.to_i, opposite_profiles_arr[arr_ind].to_i)
    #    rewrite_tree_arr2 << one_arr2 if !one_arr2.blank?
    #
    #    # Получение массивов для Замены профилей в ProfileKey
    #    one_arr1 = get_rewrite_profiles_ids(ProfileKey, "profile_id", where_found_user_id.to_i, one_profile.to_i, opposite_profiles_arr[arr_ind].to_i)
    #    rewrite_profilekey_arr1 << one_arr1 if !one_arr1.blank?
    #    one_arr2 = get_rewrite_profiles_ids(ProfileKey, "is_profile_id", where_found_user_id.to_i, one_profile.to_i, opposite_profiles_arr[arr_ind].to_i)
    #    rewrite_profilekey_arr2 << one_arr2 if !one_arr2.blank?
    #  end
    #
    #else
    #  # если where_found_user_id - более ранний по времени создания
    #  # значит его профилями в where_found_user_id (из match_profiles_arr)- заменяем более поздние, т.е. - в who_found_user_id (из opposite_profiles_arr).
    #  @msg = "who_found_user_id > where_found_user_id" ## DEBUGG_TO_VIEW
    #
    #  ######### перезапись profile_id's & update User
    #  ## (уходят):   opposite_profiles_arr - противоположные, найденным в поиске
    #  ## (остаются): match_profiles_arr - найден в поиске
    #  # Первым параметром идут те профили, которые остаются
    #  Profile.merge(match_profiles_arr, opposite_profiles_arr)
    #
    #  for arr_ind in 0 .. opposite_profiles_arr.length-1 # ищем этот profile_id для его замены
    #    # меняем profile_id из match_profiles_arr на profile_id из opposite_profiles_arr
    #    one_profile = opposite_profiles_arr[arr_ind] # profile_id для замены
    #    logger.info one_profile
    #
    #    # Получение массивов для Замены профилей в Tree
    #    one_arr1 = get_rewrite_profiles_ids(Tree, "profile_id", who_found_user_id.to_i, one_profile.to_i, match_profiles_arr[arr_ind].to_i)
    #    rewrite_tree_arr1 << one_arr1 if !one_arr1.blank?
    #    one_arr2 = get_rewrite_profiles_ids(Tree, "is_profile_id", who_found_user_id.to_i, one_profile.to_i, match_profiles_arr[arr_ind].to_i)
    #    rewrite_tree_arr2 << one_arr2 if !one_arr2.blank?
    #
    #    # Получение массивов для Замены профилей в ProfileKey
    #    one_arr1 = get_rewrite_profiles_ids(ProfileKey, "profile_id", who_found_user_id.to_i, one_profile.to_i, match_profiles_arr[arr_ind].to_i)
    #    rewrite_profilekey_arr1 << one_arr1 if !one_arr1.blank?
    #    one_arr2 = get_rewrite_profiles_ids(ProfileKey, "is_profile_id", who_found_user_id.to_i, one_profile.to_i, match_profiles_arr[arr_ind].to_i)
    #    rewrite_profilekey_arr2 << one_arr2 if !one_arr2.blank?
    #  end
    #
    #end
    #
    #save_rewrite_profiles_ids(Tree, rewrite_tree_arr1 + rewrite_tree_arr2)
    #@save_in_tree = @saved_profiles_arr # DEBUGG_TO_VIEW
    #save_rewrite_profiles_ids(ProfileKey, rewrite_profilekey_arr1 + rewrite_profilekey_arr2)
    #@save_in_profilekey = @saved_profiles_arr # DEBUGG_TO_VIEW

  end


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

    current_user_id = params[:current_user_id] # DEBUGG_TO_VIEW#
    user_id = params[:user_id_to_connect] # DEBUGG_TO_VIEW#
    matched_profiles_in_tree = params[:matched_profiles].values_at(user_id)[0].values.flatten
    matched_relations_in_tree = params[:matched_relations].values_at(user_id)[0].values.flatten

    @matched_profiles_hash = params[:matched_profiles] # DEBUGG_TO_VIEW @final_reduced_profiles_hash
    @matched_relations_hash = params[:matched_relations] # DEBUGG_TO_VIEW @final_reduced_relations_hash
    @current_user_id = current_user_id # DEBUGG_TO_VIEW
    @user_id = user_id # DEBUGG_TO_VIEW
    @matched_profiles_in_tree = matched_profiles_in_tree # DEBUGG_TO_VIEW
    @matched_relations_in_tree = matched_relations_in_tree # DEBUGG_TO_VIEW
    @first_tree = tree_arr(current_user_id) # DEBUGG_TO_VIEW
    @second_tree = tree_arr(user_id) # DEBUGG_TO_VIEW
    @connected_users_arr = current_user.get_connected_users#_new(current_user.id) # DEBUGG_TO_VIEW

    if !@connected_users_arr.include?(user_id.to_i) # check_connection: IF NOT CONNECTED
      logger.info "DEBUG IN connection_of_trees: NOT CONNECTED - #{@connected_users_arr.include?(user_id).inspect}" # == false

      connect_trees(params[:current_user_id], params[:user_id_to_connect], matched_profiles_in_tree, matched_relations_in_tree)

#      connect_users(current_user_id.to_i, user_id.to_i)
    else
      logger.info "DEBUG IN connection_of_trees: USERS ALREADY CONNECTED! Current_user=#{current_user_id.inspect}, user_id=#{user_id.inspect}."
    end

  end



end

# DEBUGG_TO_VIEW

