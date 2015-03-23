module CommonLogsHelper

  # Отобр-е параметров дерева и sim_data во вьюхе
  def view_tree_data(tree_info)
    @tree_info = tree_info
    @current_user_id = current_user.id
    # @paged_similars_data = pages_of(@similars, 10) # Пагинация ТОЛЬКО ДЛЯ МАССИВА ХЭШЕЙ - по 10 строк на стр.
  end

  # Отобр-е истории дерева - логов его развития - во вьюхе
  def view_common_logs(tree_all_logs)
    @current_user_id = current_user.id
 #   @paged_common_logs_data = pages_of(common_logs_data, 10) # Пагинация - по 10 строк на стр.
 #    logger.info "In view_common_logs_data: tree_all_logs = #{tree_all_logs} "
    @tree_all_logs = tree_all_logs
  end

  # # Отображение логов в вьюхе
  # def show_log_data(log_connection)
  #   @log_connection = log_connection
  #   logger.info "*** In  SimilarsHelper show_log_data: @log_connection = \n     #{@log_connection} "
  #   @log_connection_id = @log_connection[:log_user_profile][0][:connected_at] unless @log_connection[:log_user_profile].blank?
  #   logger.info "*** In  SimilarsHelper show_log_data: @log_connection_id = #{@log_connection_id} "
  #   @log_user_profile_size = @log_connection[:log_user_profile].size unless @log_connection[:log_user_profile].blank?
  #   @log_connection_tree_size = @log_connection[:log_tree].size unless @log_connection[:log_tree].blank?
  #   @log_connection_profilekey_size = @log_connection[:log_profilekey].size unless @log_connection[:log_profilekey].blank?
  #   @complete_log = @log_connection[:log_user_profile] + @log_connection[:log_tree] + @log_connection[:log_profilekey]
  #   logger.info "*** In  SimilarsHelper show_log_data: @complete_log = \n     #{@complete_log} "
  #   @complete_log_size = @complete_log.size unless @complete_log.blank?
  #   logger.info "*** In  SimilarsHelper show_log_data: @complete_log_size = #{@complete_log_size} "
  # end




end
