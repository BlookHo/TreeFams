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
  def self.tree_amounts(current_user)
    connected_users = current_user.get_connected_users
    unless connected_users.blank?

      users_tree_data = User.get_users_male_female(connected_users)

      profiles = Tree.where(user_id: connected_users).select(:profile_id,:name_id,:relation_id,:is_profile_id,:is_name_id,:is_sex_id).distinct

      # all tree profiles
      tree_is_profiles = profiles.map {|p| p.is_profile_id }.uniq.sort
      profiles_qty = tree_is_profiles.size

      # all tree male profiles
      tree_male_profiles, profiles_male_qty = Tree.get_tree_sex_profiles(profiles, 1)
      # all tree female profiles
      tree_female_profiles, profiles_female_qty = Tree.get_tree_sex_profiles(profiles, 0)

      { profiles_qty: profiles_qty,
        tree_is_profiles: tree_is_profiles,
        profiles_male_qty: profiles_male_qty,
        tree_male_profiles: tree_male_profiles,
        profiles_female_qty: profiles_female_qty,
        tree_female_profiles: tree_female_profiles,
        user_males: users_tree_data[:user_males],
        user_females: users_tree_data[:user_females],
        user_males_qty: users_tree_data[:user_males_qty],
        user_females_qty: users_tree_data[:user_females_qty] }
    end
  end

  # @note: Получение массива профилей в дереве по Полу
  # all tree sex profiles
  def self.get_tree_sex_profiles(tree_profiles, sex)
    tree_sex_profiles = tree_profiles.map {|p| p.is_profile_id if p.is_sex_id == sex; }.compact.uniq.sort
    profiles_sex_qty = tree_sex_profiles.size
    return tree_sex_profiles, profiles_sex_qty
  end


  # Used in Search & MainController
  # ИСПОЛЬЗУЕТСЯ В ПОИСКЕ И МЕТОДЕ ОБЪЕДИНЕНИЯ ДЕРЕВЬЕВ - connection_of_trees
  # Получение массива дерева соединенных Юзеров из Tree
  # На входе - массив соединенных Юзеров
  def self.get_connected_tree(connected_users_arr)
    tree_arr = Tree.where(:user_id => connected_users_arr).select(:profile_id,:name_id,:relation_id,:is_profile_id,:is_name_id,:is_sex_id).distinct
    return tree_arr
  end



  # Кол-во профилей в дереве
  # и другая инфа о дереве и профилях дерева
  def self.get_tree_info(current_user)
    logger.info "In Tree - get_tree_info: current_user = #{current_user} "
    tree_profiles_info = get_tree_profiles_info(current_user)
    all_tree_profiles_info = get_all_tree_profiles_info(tree_profiles_info)
    logger.info "In Tree - get_tree_info: tree_profiles_info[:connected_users] = #{tree_profiles_info[:connected_users]} " unless tree_profiles_info[:connected_users].blank?
    { current_user:  current_user,
      users_profiles_ids: all_tree_profiles_info[:users_profiles_ids], # Массив users_profiles_ids в дереве (авторы)

      tree_is_profiles: tree_profiles_info[:tree_is_profiles], # Массив профилей в дереве
      tree_profiles_amount: tree_profiles_info[:tree_profiles_amount], # Количество профилей в дереве

      all_tree_profiles: all_tree_profiles_info[:all_tree_profiles], # Весь Массив профилей в дереве (с авторами)
      all_tree_profiles_amount: all_tree_profiles_info[:all_tree_profiles_amount], # Количество всего массива профилей в дереве (с авторами)

      connected_users: tree_profiles_info[:connected_users],    # Пользователи - авторы дерева
      profiles: collect_tree_profiles(tree_profiles_info[:author_tree_arr])   # Инфа о профилях в дереве
    }
  end


  # Сбор инфы о профилях дерева - без профилей авторов
  def self.get_tree_profiles_info(current_user)
    connected_users = current_user.get_connected_users
    author_tree_arr = get_connected_tree(connected_users) # DISTINCT Массив объединенного дерева из Tree

    tree_content_data = tree_amounts(current_user)
    profiles_qty = tree_content_data[:profiles_qty]
    tree_is_profiles = tree_content_data[:tree_is_profiles]
    {   connected_users: connected_users,    # Пользователи - авторы дерева
        author_tree_arr: author_tree_arr,    # Пользователи - авторы дерева
        tree_profiles_amount: profiles_qty,  # Количество профилей в дереве
        tree_is_profiles: tree_is_profiles   # Массив профилей в дереве
    }
  end

  # Сбор полной инфы о профилях дерева - с профилями авторов
  def self.get_all_tree_profiles_info(tree_profiles_info)
    users_profiles_ids = []
    tree_profiles_info[:connected_users].each do |user_id|
      user_profile_id = User.find(user_id).profile_id
      users_profiles_ids << user_profile_id
    end
    all_tree_profiles = (tree_profiles_info[:tree_is_profiles] + users_profiles_ids).uniq
    all_tree_profiles_amount = all_tree_profiles.size unless all_tree_profiles.blank?

    {   all_tree_profiles: all_tree_profiles,    # Весь Массив профилей в дереве (с авторами)
        all_tree_profiles_amount: all_tree_profiles_amount,    # Количество всего массива профилей в дереве (с авторами)
        users_profiles_ids: users_profiles_ids # Массив users_profiles_ids в дереве (авторы)
    }
  end

  # Сбор данных обо всех профилях в дереве - для исп-я далее
  def self.collect_tree_profiles(tree_arr)
    profiles = {}
    tree_arr.map {|p|
      ( one_profile_data = { :is_name_id => p.is_name_id, :is_sex_id => p.is_sex_id , :profile_id => p.profile_id, :relation_id => p.relation_id}
      profiles.merge!( p.is_profile_id => one_profile_data )  unless one_profile_data.empty?
      ) }
    profiles
  end






end
