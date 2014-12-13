module UpdatesFeedsHelper

  # подсчет новых, полученных current_user, непрочитанных новостных обновлений
  # отображение в _header
  # в подсчет включаются те обновления, в кот-х в кач-ве agent_user_id - члены дерева current_user
  # Это обновления связ. с запросами на объединения
  # Дурацкая запись SQL запроса из-за OR /
  def count_new_updates  #
    connected_users = current_user.get_connected_users
    @new_updates_count = UpdatesFeed.where("user_id in (?) or agent_user_id  in (?)", connected_users, connected_users ).where.not(user_id: current_user.id).where(read: false).count if current_user
  end



end
