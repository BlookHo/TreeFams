class ConnectUsersTreesController < ApplicationController

  def get_tree(user_id)
    tree_of_user = Tree.where(:user_id => user_id)
    return tree_of_user
  end

  def tree_arr(user_id)
    get_tree(user_id).map {|t|  [t.user_id, t.profile_id, t.name_id, t.relation_id, t.is_profile_id, t.is_name_id, t.is_sex_id] }
  end

  def get_trees_to_connect(first_user_id, second_user_id)
    @first_tree_author = first_user_id
    @second_tree_author = second_user_id

    @first_tree = tree_arr(first_user_id)
    @second_tree = tree_arr(second_user_id)



  end




  def connect_users

  end

  def connect_profiles

  end

  def connect_trees

  end

  def connect_profiles_keys

  end


  def connection_of_trees

    @current_user_id = params[:first_user_id]
    @user_id = params[:second_user_id]

    get_trees_to_connect(@current_user_id,@user_id)

    connect_users

    connect_profiles

    connect_trees

    connect_profiles_keys


  end


end
