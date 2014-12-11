module UpdatesFeedsHelper

  # подсчет новых, полученных current_user, непрочитанных новостных обновлений   , read:false
  def count_new_updates  #
    @new_updates_count = UpdatesFeed.where(user_id: current_user.id).count if current_user
    #logger.info "in _header: @new_updates_count = #{@new_updates_count}"
  end




end
