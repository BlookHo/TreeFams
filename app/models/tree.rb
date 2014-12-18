class Tree < ActiveRecord::Base
  belongs_to :profile, foreign_key: "is_profile_id"
  belongs_to :name, foreign_key: "is_name_id"
  belongs_to :relation

  # Считаем кол-во профилей в дереве:
  # Кол-во рядов объединеннного дерева + кол-во Юзеров в объед-м дереве
  # т.к. у них (авторов) нет своих рядов в Tree
  def self.tree_amount(current_user)
    connected_users = current_user.get_connected_users
    if !connected_users.blank?
      profiles = Tree.where(user_id: connected_users).select(:profile_id,:name_id,:relation_id,:is_profile_id,:is_name_id,:is_sex_id).distinct#.count
      tree_is_profiles = profiles.map {|p| p.is_profile_id }.uniq
      profiles_qty = tree_is_profiles.size #+ connected_users.size

      return profiles_qty, tree_is_profiles
    end
  end

  # Used in Search & MainController
  # ИСПОЛЬЗУЕТСЯ В ПОИСКЕ И МЕТОДЕ ОБЪЕДИНЕНИЯ ДЕРЕВЬЕВ - connection_of_trees
  # Получение массива дерева соединенных Юзеров из Tree
  # На входе - массив соединенных Юзеров
  def self.get_connected_tree(connected_users_arr)
    tree_arr = Tree.where(:user_id => connected_users_arr).select(:profile_id,:name_id,:relation_id,:is_profile_id,:is_name_id,:is_sex_id).distinct
    return tree_arr
  end


end
