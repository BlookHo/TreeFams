module UserLock
  extend ActiveSupport::Concern

  # Установить блокировку юзера
  def lock!
    self.update_column(:is_locked, true)
  end

  # Снять блокировку юзера
  def unlock!
    self.update_column(:is_locked, false)
  end

  # Снять блокировку c дерева юзера
  def unlock_tree!
    User.where(id: self.get_connected_users, is_locked: true).map(&:unlock!)
  end

  # Статус блокировки дерева пользователя
  def tree_is_locked?
    User.where(id: self.get_connected_users, is_locked: true).count > 0
  end

end
