class Tree < ActiveRecord::Base

  # todo: sex_id to check

  validates_presence_of :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id, :is_sex_id,
                        :message => "Должно присутствовать в Tree"
  validates_numericality_of :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id,
                            :greater_than => 0, :message => "Должны быть больше 0 в Tree"
  validates_numericality_of :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id, :is_sex_id,
                            :only_integer => true,  :message => "Должны быть целым числом в Tree"
  # profile_id and .is_profile_id
  validate :profiles_ids_are_not_equal,  :message => "Значения полей в одном ряду не должны быть равны в Tree"
  validates_inclusion_of :relation_id, :in => [1,2,3,4,5,6,7,8,91,92,101,102,111,112,121,122,13,14,15,16,17,18,191,192,
                                               201,202,211,212,221,222],
                         :message => "Должны быть целым числом из заданного множества в Tree"
  validates_inclusion_of :is_sex_id, :in => [1,0], :message => "Должны быть 1 или 0 в Tree"

  # custom validations
  def profiles_ids_are_not_equal
    self.errors.add(:profile_keys,
                    'Значения полей в одном ряду не должны быть равны в Tree') if self.profile_id == self.is_profile_id
  end

  belongs_to :profile, foreign_key: "is_profile_id"
  belongs_to :name, foreign_key: "is_name_id"
  belongs_to :relation

  # Считаем кол-во профилей в дереве:
  # Кол-во рядов объединеннного дерева + кол-во Юзеров в объед-м дереве
  # т.к. у них (авторов) нет своих рядов в Tree
  def self.tree_amount(current_user)
    connected_users = current_user.get_connected_users
    unless connected_users.blank?
      profiles = Tree.where(user_id: connected_users).select(:profile_id,:name_id,:relation_id,:is_profile_id,:is_name_id,:is_sex_id).distinct
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
