class ConnectUsersTreesController < ApplicationController

  def get_tree(user_id)
    tree_of_user = Tree.where(:user_id => user_id)
    return tree_of_user
  end

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
  def rewrite_profiles_in_tree(who_found_user_id, where_found_user_id, matched_profiles_arr, matched_relations_arr)

    opposite_profiles_arr = []
    @replaced_profiles = []

    for arr_ind in 0 .. matched_profiles_arr.length-1
      one_profile = matched_profiles_arr[arr_ind]
      @one_profile = one_profile # DEBUGG_TO_VIEW
      one_relation = matched_relations_arr[arr_ind]

      where_found_tree_row = Tree.where(:user_id => where_found_user_id.to_i, :is_profile_id => one_profile.to_i)[0]

      @where_found_name_id = where_found_tree_row.name_id ## DEBUGG_TO_VIEW
      @where_found_is_name_id = where_found_tree_row.is_name_id ## DEBUGG_TO_VIEW
      @where_found_is_sex_id = where_found_tree_row.is_sex_id # DEBUGG_TO_VIEW

      who_found_tree_row = Tree.where(:user_id => who_found_user_id.to_i, :is_name_id => where_found_tree_row.is_name_id.to_i, :relation_id => one_relation,:is_sex_id => where_found_tree_row.is_sex_id.to_i)[0]
      opposite_profiles_arr << who_found_tree_row.is_profile_id
      @who_found_tree_row = who_found_tree_row # DEBUGG_TO_VIEW
    end

    if who_found_user_id > where_found_user_id
      # если who_found_user_id - более поздний по времени создания
      # значит его профили в who_found_user_id - заменяем на более ранние, т.е. - из where_found_user_id.
      @msg = "who_found_user_id > where_found_user_id"
      @replaced_profiles << who_found_user_id
      for arr_ind in 0 .. matched_profiles_arr.length-1
        one_profile = matched_profiles_arr[arr_ind]

        who_found_to_replace = Tree.where(:user_id => where_found_user_id.to_i, :is_profile_id => one_profile.to_i)[0]
        @replaced_profiles << who_found_to_replace.is_profile_id
        @replaced_profiles << "replace"
        @replaced_profiles << opposite_profiles_arr[arr_ind]
      end

    else
      @msg = "who_found_user_id < where_found_user_id"
      @replaced_profiles << where_found_user_id
      for arr_ind in 0 .. opposite_profiles_arr.length-1
        one_profile = opposite_profiles_arr[arr_ind]

        where_found_tree_row = Tree.where(:user_id => who_found_user_id.to_i,  :is_profile_id => one_profile.to_i)[0]
        @replaced_profiles << where_found_tree_row.is_profile_id
        @replaced_profiles << "replace"
        @replaced_profiles << matched_profiles_arr[arr_ind]
      end
    end


    return opposite_profiles_arr

  end

  #def rewrite_profiles_in_tree(profiles_arr, tree)
  #
  #  @msg = "Put profiles " + "#{profiles_arr}" + " in tree: "
  #  @tree_to_write = tree
  #
  #end

  def connect_trees(first_user_id, second_user_id, matched_profiles, matched_relations)
    @first_tree_author = first_user_id
    @second_tree_author = second_user_id

    @first_tree = tree_arr(first_user_id)
    @second_tree = tree_arr(second_user_id)

    opposite_profiles_arr = rewrite_profiles_in_tree(first_user_id, second_user_id, matched_profiles, matched_relations)
    @opposite_profiles_arr = opposite_profiles_arr # DEBUGG_TO_VIEW


  end

  def connect_users

  end

  def connect_profiles

  end

  def connect_profiles_keys

  end


  def connection_of_trees

    @current_user_id = params[:first_user_id]
    @user_id = params[:second_user_id]
    @matched_profiles_hash = params[:matched_profiles]
    @matched_relations_hash = params[:matched_relations]
    @matched_profiles_in_tree = @matched_profiles_hash.values_at(@user_id)[0].values.flatten
    @matched_relations_in_tree = @matched_relations_hash.values_at(@user_id)[0].values.flatten

    connect_trees(@current_user_id, @user_id, @matched_profiles_in_tree, @matched_relations_in_tree)

    connect_users

    connect_profiles

    connect_profiles_keys


  end


end
