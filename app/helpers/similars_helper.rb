module SimilarsHelper

  # Отобр-е параметров дерева и sim_data во вьюхе
  def view_tree_similars(tree_info, similars)
    @tree_info = tree_info
     # logger.info "In SimilarsHelper 1a: view_tree_data @tree_info.profiles.size = #{tree_info[:profiles].size} "  unless tree_info.blank?
    @current_user_id = current_user.id
    @similars = similars
    @similars_qty = @similars.size unless similars.empty?
    @paged_similars_data = pages_of(@similars, 10) # Пагинация - по 10 строк на стр.
  end

  # Отображение логов объединения похожих в вьюхе
  def show_log_data(log_connection)
    @log_connection = log_connection
    logger.info "*** In  SimilarsHelper show_log_data: @log_connection = \n     #{@log_connection} "
    @log_connection_id = @log_connection[:log_user_profile][0][:connected_at] unless @log_connection[:log_user_profile].blank?
    logger.info "*** In  SimilarsHelper show_log_data: @log_connection_id = #{@log_connection_id} "
    @log_user_profile_size = @log_connection[:log_user_profile].size unless @log_connection[:log_user_profile].blank?
    @log_connection_tree_size = @log_connection[:log_tree].size unless @log_connection[:log_tree].blank?
    @log_connection_profilekey_size = @log_connection[:log_profilekey].size unless @log_connection[:log_profilekey].blank?
    @complete_log = @log_connection[:log_user_profile] + @log_connection[:log_tree] + @log_connection[:log_profilekey]
    logger.info "*** In  SimilarsHelper show_log_data: @complete_log = \n     #{@complete_log} "
    @complete_log_size = @complete_log.size unless @complete_log.blank?
    logger.info "*** In  SimilarsHelper show_log_data: @complete_log_size = #{@complete_log_size} "
  end



end
