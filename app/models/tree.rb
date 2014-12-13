class Tree < ActiveRecord::Base
  belongs_to :profile, foreign_key: "is_profile_id"
  belongs_to :name, foreign_key: "is_name_id"
  belongs_to :relation

  # Считаем кол-во профилей в дереве:
  # Кол-во рядов объединеннного дерева +
  # кол-во Юзеров в объед-м дереве
  # т.к. у них нет своих рядов в Tree
  def self.tree_amount(current_user)
    connected_users = current_user.get_connected_users
    if !connected_users.blank?
      return Tree.where(user_id: connected_users).count + connected_users.size
    #else
    #  a =  nil
    end
    #logger.info "In self.tree_amount: a = #{a} "
    #return a
  end



end
