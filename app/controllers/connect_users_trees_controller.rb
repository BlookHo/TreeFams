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


  # Изготовление массива профилей под замену
  # who_found_user_id - Автор дерева, который ищет
  # where_found_user_id - Автор дерева, в котором найдено
  # /
  # @note first_user_id - Дерево Юзера, который ищет
  # @note second_user_id - Дерево Юзера, в котором найдено
  # @see News
  def connect_trees(who_found_user_id, where_found_user_id, matched_profiles_arr, matched_relations_arr)


# записывать true в первое дерево после объединения !!!
# обобщить методы

    opposite_profiles_arr = []
    @replaced_profiles = []
    for arr_ind in 0 .. matched_profiles_arr.length-1
      one_profile = matched_profiles_arr[arr_ind]
      @one_profile = one_profile # DEBUGG_TO_VIEW
      one_relation = matched_relations_arr[arr_ind]

      where_found_tree_row = Tree.where(:connected => false, :user_id => where_found_user_id.to_i, :is_profile_id => one_profile.to_i)[0]
      if !where_found_tree_row.blank?
          @where_found_name_id = where_found_tree_row.name_id ## DEBUGG_TO_VIEW
          @where_found_is_name_id = where_found_tree_row.is_name_id ## DEBUGG_TO_VIEW
          @where_found_is_sex_id = where_found_tree_row.is_sex_id # DEBUGG_TO_VIEW
        who_found_tree_row = Tree.where(:connected => false, :user_id => who_found_user_id.to_i, :is_name_id => where_found_tree_row.is_name_id.to_i, :relation_id => one_relation,:is_sex_id => where_found_tree_row.is_sex_id.to_i)[0]
        if !who_found_tree_row.blank?
          opposite_profiles_arr << who_found_tree_row.is_profile_id
            @who_found_tree_row = who_found_tree_row # DEBUGG_TO_VIEW
            @opposite_profiles_arr = opposite_profiles_arr # DEBUGG_TO_VIEW
          who_found_profile_id = who_found_tree_row.profile_id # Author who_found_user_id profile_id
        end
        where_found_profile_id = where_found_tree_row.profile_id ## Author where_found_user_id profile_id
      end
    end
      @where_found_profile_id = where_found_profile_id # DEBUGG_TO_VIEW
      @who_found_profile_id = who_found_profile_id # DEBUGG_TO_VIEW

    if who_found_user_id < where_found_user_id
      # если who_found_user_id - более поздний по времени создания
      # значит его профили в who_found_user_id - заменяем на более ранние, т.е. - из where_found_user_id.
      @msg = "who_found_user_id < where_found_user_id" ## DEBUGG_TO_VIEW
      @replaced_profiles << where_found_user_id ## DEBUGG_TO_VIEW

      if !where_found_tree_row.blank?
        author_index = matched_profiles_arr.index("#{where_found_tree_row.profile_id}")
        author_profile_id = opposite_profiles_arr[author_index]
          @author_profile_id = author_profile_id # DEBUGG_TO_VIEW
      end

      for arr_ind in 0 .. matched_profiles_arr.length-1
        one_profile = matched_profiles_arr[arr_ind]
        where_found_to_replace = Tree.where(:user_id => where_found_user_id.to_i, :is_profile_id => one_profile.to_i)[0]
        if !where_found_to_replace.blank?
            @where_found_to_replace = where_found_to_replace ## DEBUGG_TO_VIEW
            @replaced_profiles << opposite_profiles_arr[arr_ind] ## DEBUGG_TO_VIEW
            @replaced_profiles << "replace" ## DEBUGG_TO_VIEW
            @replaced_profiles << where_found_to_replace.is_profile_id ## DEBUGG_TO_VIEW
          where_found_to_replace.is_profile_id = opposite_profiles_arr[arr_ind] # Rewrite of Profiles_ids
          where_found_to_replace.profile_id = author_profile_id # Rewrite of Profiles_ids
          where_found_to_replace.connected = true # Rewrite of Profiles_ids
            @profile_to_replace = author_profile_id # Rewrite of Author Profile_id
  #        where_found_to_replace.save
        end
      end

    else
      @msg = "who_found_user_id > where_found_user_id" ## DEBUGG_TO_VIEW
      @replaced_profiles << who_found_user_id ## DEBUGG_TO_VIEW

      author_index = opposite_profiles_arr.index(who_found_tree_row.profile_id)
      author_profile_id = matched_profiles_arr[author_index]
        @author_profile_id = author_profile_id # DEBUGG_TO_VIEW

      for arr_ind in 0 .. opposite_profiles_arr.length-1
        one_profile = opposite_profiles_arr[arr_ind]
        who_found_to_replace = Tree.where(:user_id => who_found_user_id.to_i, :is_profile_id => one_profile.to_i)[0]
        if !who_found_to_replace.blank?
            @who_found_to_replace = who_found_to_replace ## DEBUGG_TO_VIEW
            @replaced_profiles << matched_profiles_arr[arr_ind] ## DEBUGG_TO_VIEW
            @replaced_profiles << "replace" ## DEBUGG_TO_VIEW
            @replaced_profiles << who_found_to_replace.is_profile_id ## DEBUGG_TO_VIEW
          who_found_to_replace.is_profile_id = matched_profiles_arr[arr_ind]  # Rewrite of Profiles_ids
          who_found_to_replace.profile_id = @author_profile_id # Rewrite of Profiles_ids
          who_found_to_replace.connected = true # Rewrite of Profiles_ids
            @profile_to_replace = @author_profile_id # Rewrite of Author Profile_id
  #        who_found_to_replace.save
        end
      end

    end


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

  end

  def connect_profiles

  end

  def connect_profiles_keys

  end

  # Проверка того,что current_user_id и user_id уже соединены
  #
   def check_connected(current_user_id, user_id)
    connection_row = ConnectedUser.where("(user_id = #{current_user_id} and with_user_id = #{user_id}) or (user_id = #{user_id} and with_user_id = #{current_user_id}) ")
    connection = connection_row[0].connected if !connection_row.blank?
    @connection = connection ## DEBUGG_TO_VIEW
    return connection
  end

  def connection_of_trees

    @current_user_id = params[:first_user_id]# ||= 'default value'
    @user_id = params[:second_user_id]
    @matched_profiles_hash = params[:matched_profiles]
    @matched_relations_hash = params[:matched_relations]
    @matched_profiles_in_tree = @matched_profiles_hash.values_at(@user_id)[0].values.flatten
    @matched_relations_in_tree = @matched_relations_hash.values_at(@user_id)[0].values.flatten

    @first_tree = tree_arr(@current_user_id)
    @second_tree = tree_arr(@user_id)

    #@current_user_id = 323
    #@user_id = 42

    if !check_connected(@current_user_id, @user_id) # IF NOT CONNECTED
      connect_trees(@current_user_id, @user_id, @matched_profiles_in_tree, @matched_relations_in_tree)
      connect_users(@current_user_id, @user_id)

      connect_profiles

      connect_profiles_keys

      @conn_msg = "Connection exists" ## DEBUGG_TO_VIEW
    else
      logger.info "Users ALREADY CONNECTED! Current_user=#{@current_user_id.inspect}, user_id=#{@user_id.inspect}."
      @conn_msg = "Users ALREADY CONNECTED!"
    end


  end




end
