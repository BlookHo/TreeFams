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
      new_users_connection.connected = true
      new_users_connection.save
    else
      logger.info "Connection of Users - INVALID! Current_user=#{current_user_id.inspect} EQUALS TO user_id=#{user_id.inspect}"
    end

    #### UPDATE USERS table!

  end

  def connect_profiles

    ##### DELETE MATCHED ID IN Profiles

  end

  # Получение массива соединенных Юзеров
  # для заданного "стартового" Юзера
  #
  def get_connected_users(current_user_id)

    connected_users_arr = []
    connected_users_arr << current_user_id
    first_users_arr = ConnectedUser.where(user_id: current_user_id).where(connected: true).pluck(:with_user_id)
    if first_users_arr.blank?
      first_users_arr = ConnectedUser.where(with_user_id: current_user_id).where(connected: true).pluck(:user_id)
    end
    one_connected_users_arr = first_users_arr
    if !one_connected_users_arr.blank?
      connected_users_arr << one_connected_users_arr
      connected_users_arr.flatten!.uniq! if !connected_users_arr.blank?
      one_connected_users_arr.each do |conn_arr_el|
        next_connected_users_arr = ConnectedUser.where("(user_id = #{conn_arr_el} or with_user_id = #{conn_arr_el})").where(connected: true).pluck(:user_id, :with_user_id)
        if !next_connected_users_arr.blank?
          one_connected_users_arr << next_connected_users_arr
          one_connected_users_arr.flatten!.uniq! if !one_connected_users_arr.blank?
          connected_users_arr << next_connected_users_arr
          connected_users_arr.flatten!.uniq! if !connected_users_arr.blank?
        end
      end
    end
    return connected_users_arr
  end

  # Общий метод дла накапливания массива для перезаписи профилей в таблицах
  #
  def get_rewrite_profiles_ids(db_table, db_field, where_rewrite_user, field_profiles, new_profile_id)

    arr_to_rewrite = []
    one_arr = []
    where_found_to_replace = db_table.where(:user_id => where_rewrite_user.to_i).where(" #{db_field} = #{field_profiles} " )#[0]
    #logger.info "In rewrite_profiles_ids - where_found_to_replace:  #{where_found_to_replace.inspect}" #
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

    logger.info " In #{db_table}, #{db_field}: arr_to_rewrite = #{arr_to_rewrite} "
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

  # Метод дла получения массива обратных профилей для
  # перезаписи профилей в таблицах
  # opposite_profiles_arr
  #
  def get_opposite_profiles(who_found_user_id, where_found_user_id, matched_profiles_arr, matched_relations_arr)
    opposite_profiles_arr = []
    for arr_ind in 0 .. matched_profiles_arr.length-1
      one_profile = matched_profiles_arr[arr_ind]
      one_relation = matched_relations_arr[arr_ind]
      where_found_tree_row = Tree.where(:user_id => where_found_user_id.to_i, :is_profile_id => one_profile.to_i)[0]
      if !where_found_tree_row.blank?
        who_found_tree_row = Tree.where(:user_id => who_found_user_id.to_i, :is_name_id => where_found_tree_row.is_name_id.to_i, :relation_id => one_relation,:is_sex_id => where_found_tree_row.is_sex_id.to_i)[0]
        if !who_found_tree_row.blank?
          opposite_profiles_arr << who_found_tree_row.is_profile_id
        end
      end
    end
    return opposite_profiles_arr # DEBUGG_TO_VIEW
  end


  # Главный стартовый метод дла перезаписи профилей в таблицах
  # who_found_user_id - Автор дерева, который ищет
  # where_found_user_id - Автор дерева, в котором найдено
  #
  def connect_trees(who_found_user_id, where_found_user_id, matched_profiles_arr, matched_relations_arr)

    opposite_profiles_arr = get_opposite_profiles(who_found_user_id, where_found_user_id, matched_profiles_arr, matched_relations_arr)
    @opposite_profiles_arr = opposite_profiles_arr # DEBUGG_TO_VIEW
    @matched_profiles_arr = matched_profiles_arr # DEBUGG_TO_VIEW
    logger.info "=IN CONNECT_TREES: matched_profiles_arr = #{matched_profiles_arr}; opposite_profiles_arr = #{opposite_profiles_arr} "

    rewrite_tree_arr = []
    rewrite_tree_arr1 = []
    rewrite_tree_arr2 = []
    rewrite_profilekey_arr = []
    rewrite_profilekey_arr1 = []
    rewrite_profilekey_arr2 = []
    if who_found_user_id < where_found_user_id
      # если where_found_user_id - более поздний по времени создания
      # значит его профили в where_found_user_id (в matched_profiles_arr)- заменяем на более ранние, т.е. - из who_found_user_id (из opposite_profiles_arr).
      @msg = "who_found_user_id < where_found_user_id" ## DEBUGG_TO_VIEW

      for arr_ind in 0 .. matched_profiles_arr.length-1 # ищем этот profile_id для его замены
        # меняем profile_id в matched_profiles_arr на profile_id из opposite_profiles_arr
        one_profile = matched_profiles_arr[arr_ind] # profile_id для замены
        logger.info one_profile

        # Получение массивов для Замены профилей в Tree
        one_arr1 = get_rewrite_profiles_ids(Tree, "profile_id", where_found_user_id.to_i, one_profile.to_i, opposite_profiles_arr[arr_ind].to_i)
        rewrite_tree_arr1 << one_arr1 if !one_arr1.blank?
        one_arr2 = get_rewrite_profiles_ids(Tree, "is_profile_id", where_found_user_id.to_i, one_profile.to_i, opposite_profiles_arr[arr_ind].to_i)
        rewrite_tree_arr2 << one_arr2 if !one_arr2.blank?

        # Получение массивов для Замены профилей в ProfileKey
        one_arr1 = get_rewrite_profiles_ids(ProfileKey, "profile_id", where_found_user_id.to_i, one_profile.to_i, opposite_profiles_arr[arr_ind].to_i)
        rewrite_profilekey_arr1 << one_arr1 if !one_arr1.blank?
        one_arr2 = get_rewrite_profiles_ids(ProfileKey, "is_profile_id", where_found_user_id.to_i, one_profile.to_i, opposite_profiles_arr[arr_ind].to_i)
        rewrite_profilekey_arr2 << one_arr2 if !one_arr2.blank?
      end

    else
      # если where_found_user_id - более ранний по времени создания
      # значит его профилями в where_found_user_id (из matched_profiles_arr)- заменяем более поздние, т.е. - в who_found_user_id (из opposite_profiles_arr).
      @msg = "who_found_user_id > where_found_user_id" ## DEBUGG_TO_VIEW

      for arr_ind in 0 .. opposite_profiles_arr.length-1 # ищем этот profile_id для его замены
        # меняем profile_id из matched_profiles_arr на profile_id из opposite_profiles_arr
        one_profile = opposite_profiles_arr[arr_ind] # profile_id для замены
        logger.info one_profile

        # Получение массивов для Замены профилей в Tree
        one_arr1 = get_rewrite_profiles_ids(Tree, "profile_id", who_found_user_id.to_i, one_profile.to_i, matched_profiles_arr[arr_ind].to_i)
        rewrite_tree_arr1 << one_arr1 if !one_arr1.blank?
        one_arr2 = get_rewrite_profiles_ids(Tree, "is_profile_id", who_found_user_id.to_i, one_profile.to_i, matched_profiles_arr[arr_ind].to_i)
        rewrite_tree_arr2 << one_arr2 if !one_arr2.blank?

        # Получение массивов для Замены профилей в ProfileKey
        one_arr1 = get_rewrite_profiles_ids(ProfileKey, "profile_id", who_found_user_id.to_i, one_profile.to_i, matched_profiles_arr[arr_ind].to_i)
        rewrite_profilekey_arr1 << one_arr1 if !one_arr1.blank?
        one_arr2 = get_rewrite_profiles_ids(ProfileKey, "is_profile_id", who_found_user_id.to_i, one_profile.to_i, matched_profiles_arr[arr_ind].to_i)
        rewrite_profilekey_arr2 << one_arr2 if !one_arr2.blank?
      end

    end

    rewrite_tree_arr = rewrite_tree_arr1 + rewrite_tree_arr2
    @rewrite_tree_arr1 = rewrite_tree_arr1 # DEBUGG_TO_VIEW
    @rewrite_tree_arr2 = rewrite_tree_arr2 # DEBUGG_TO_VIEW
    @rewrite_tree_arr = rewrite_tree_arr # DEBUGG_TO_VIEW
    rewrite_profilekey_arr = rewrite_profilekey_arr1 + rewrite_profilekey_arr2
    @rewrite_profilekey_arr1 = rewrite_profilekey_arr1 # DEBUGG_TO_VIEW
    @rewrite_profilekey_arr2 = rewrite_profilekey_arr2 # DEBUGG_TO_VIEW
    @rewrite_profilekey_arr = rewrite_profilekey_arr # DEBUGG_TO_VIEW

    save_rewrite_profiles_ids(Tree, rewrite_tree_arr)
    @save_in_tree = @saved_profiles_arr # DEBUGG_TO_VIEW
    save_rewrite_profiles_ids(ProfileKey, rewrite_profilekey_arr)
    @save_in_profilekey = @saved_profiles_arr # DEBUGG_TO_VIEW

  end

  def connection_of_trees

    @current_user_id = params[:first_user_id]#
    @user_id = params[:second_user_id]#
    @matched_profiles_hash = params[:matched_profiles]  # @final_reduced_profiles_hash
    @matched_relations_hash = params[:matched_relations]  # @final_reduced_relations_hash
    @matched_profiles_in_tree = @matched_profiles_hash.values_at(@user_id)[0].values.flatten
    @matched_relations_in_tree = @matched_relations_hash.values_at(@user_id)[0].values.flatten

    @first_tree = tree_arr(@current_user_id)
    @second_tree = tree_arr(@user_id)

    #@current_user_id = 35 # DEBUGG_TO_VIEW
    #@user_id = 334 # DEBUGG_TO_VIEW

    @start_connected_user_id = @current_user_id.to_i #200 # DEBUGG_TO_VIEW

  #     connect_users(@current_user_id, @user_id) # made by Alexey

    @connected_users_arr = get_connected_users(@start_connected_user_id) # DEBUGG_TO_VIEW

    connect_trees(@current_user_id, @user_id, @matched_profiles_in_tree, @matched_relations_in_tree)

    if !@connected_users_arr.include?(@user_id.to_i) # check_connection  IF NOT CONNECTED
      logger.info "In check: NOT CONNECTED - #{@connected_users_arr.include?(@user_id).inspect}" # == false
#      connect_trees(@current_user_id, @user_id, @matched_profiles_in_tree, @matched_relations_in_tree)


    #  connect_profiles # made by Alexey

    #  @conn_msg = "Connection established!! " ## DEBUGG_TO_VIEW
    else
      logger.info "Users ALREADY CONNECTED! Current_user=#{@current_user_id.inspect}, user_id=#{@user_id.inspect}."
      @conn_msg = "Users ALREADY CONNECTED!"
    #  @conn_msg = "Connection exists" ## DEBUGG_TO_VIEW
    end

  end

  #@rewrite_tree_arr=
  #    [[[234, "profile_id", 212, "-->", 212]],
  #     [[215, "profile_id", 215, "-->", 215],
  #      [213, "profile_id", 215, "-->", 215],
  #      [214, "profile_id", 215, "-->", 215],
  #      [212, "profile_id", 215, "-->", 215],
  #      [220, "profile_id", 215, "-->", 215]],
  #     [[215, "is_profile_id", 212, "-->", 212]],
  #     [[213, "is_profile_id", 213, "-->", 213]],
  #     [[214, "is_profile_id", 214, "-->", 214]],
  #     [[212, "is_profile_id", 215, "-->", 215]],
  #     [[234, "is_profile_id", 225, "-->", 225]],
  #     [[220, "is_profile_id", 237, "-->", 237]]]

  #@rewrite_profilekey_arr =
  #    [[[795, "profile_id", 212, "-->", 212],
  #      [796, "profile_id", 212, "-->", 212],
  #      [794, "profile_id", 212, "-->", 212],
  #      [867, "profile_id", 212, "-->", 212]],
  #     [[788, "profile_id", 213, "-->", 213],
  #      [789, "profile_id", 213, "-->", 213],
  #      [790, "profile_id", 213, "-->", 213]],
  #     [[792, "profile_id", 214, "-->", 214],
  #      [793, "profile_id", 214, "-->", 214],
  #      [791, "profile_id", 214, "-->", 214]],
  #     [[786, "profile_id", 215, "-->", 215],
  #      [811, "profile_id", 215, "-->", 215],
  #      [787, "profile_id", 215, "-->", 215],
  #      [785, "profile_id", 215, "-->", 215]],
  #     [[868, "profile_id", 225, "-->", 225]],
  #     [[812, "profile_id", 237, "-->", 237]],
  #     [[793, "is_profile_id", 212, "-->", 212],
  #      [790, "is_profile_id", 212, "-->", 212],
  #      [787, "is_profile_id", 212, "-->", 212],
  #      [868, "is_profile_id", 212, "-->", 212]],
  #     [[791, "is_profile_id", 213, "-->", 213],
  #      [785, "is_profile_id", 213, "-->", 213],
  #      [794, "is_profile_id", 213, "-->", 213]],
  #     [[795, "is_profile_id", 214, "-->", 214],
  #      [786, "is_profile_id", 214, "-->", 214],
  #      [789, "is_profile_id", 214, "-->", 214]],
  #     [[788, "is_profile_id", 215, "-->", 215],
  #      [812, "is_profile_id", 215, "-->", 215],
  #      [792, "is_profile_id", 215, "-->", 215],
  #      [796, "is_profile_id", 215, "-->", 215]],
  #     [[867, "is_profile_id", 225, "-->", 225]],
  #     [[811, "is_profile_id", 237, "-->", 237]]]



end
