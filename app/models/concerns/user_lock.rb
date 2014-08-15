module UserLock
  extend ActiveSupport::Concern

  # def can_proceed?
  #   begin
  #     self.reload
  #     if self.tree_is_locked?
  #       logger.info "User is locked - waiting to proceed..."
  #       raise "user_is_locked"
  #     else
  #       self.lock!
  #       return true
  #     end
  #   rescue
  #     sleep 1
  #     retry
  #   end
  # end


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
