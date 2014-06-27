class ConnectUsersTreesController < ApplicationController

  def get_tree(user_id)
    tree_of_user = Tree.where(:user_id => user_id)
    return tree_of_user
  end

  def tree_arr(user_id)
    get_tree(user_id).map {|t|  [t.user_id, t.profile_id, t.name_id, t.relation_id, t.is_profile_id, t.is_name_id, t.is_sex_id] }
  end

  def make_opposite_profiles_arr(profiles_arr)
    opposite_profiles_arr = profiles_arr.reverse!
    @opposite_profiles_arr = opposite_profiles_arr # DEBUGG_TO_VIEW
    return opposite_profiles_arr
  end

  def rewrite_profiles_in_tree(profiles_arr, tree)

    @msg = "Put profiles " + "#{profiles_arr}" + " in tree: "
    @tree_to_write = tree

  end

  def connect_trees(first_user_id, second_user_id, matched_profiles, matched_relations)
    @first_tree_author = first_user_id
    @second_tree_author = second_user_id
    @change_profiles_arr = "No_change"

    if first_user_id < second_user_id
      @first_tree = tree_arr(first_user_id)
      @second_tree = tree_arr(second_user_id)
      @change_profiles_arr = "Change_Profiles_arr"
      profiles_to_write = make_opposite_profiles_arr(matched_profiles)
    else
      @first_tree = tree_arr(second_user_id)
      @second_tree = tree_arr(first_user_id)
      profiles_to_write = matched_profiles
    end

    rewrite_profiles_in_tree(profiles_to_write, @second_tree)



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
    @matched_relations_in_tree = @matched_relations_hash.values_at(@user_id)[0]

    #if @current_user_id < @user_id
    #  @first_tree_author = @current_user_id
    #  @second_tree_author = @user_id
    #else
    #  @first_tree_author = @user_id
    #  @second_tree_author = @current_user_id
    #end

    connect_trees(@current_user_id, @user_id, @matched_profiles_in_tree, @matched_relations_in_tree)

    connect_users

    connect_profiles

    #connect_trees

    connect_profiles_keys


  end


end
