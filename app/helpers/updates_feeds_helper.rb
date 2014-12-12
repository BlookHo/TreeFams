module UpdatesFeedsHelper

  # подсчет новых, полученных current_user, непрочитанных новостных обновлений
  # отображение в _header
  def count_new_updates  #
    #@new_updates_count = UpdatesFeed.where(user_id: current_user.id, read: false).count if current_user
    @new_updates_count = UpdatesFeed.where(user_id: current_user.get_connected_users, read: false).where.not(user_id: current_user.id).count if current_user
  end



end
