module CommonLogsHelper

  # Отобр-е параметров дерева и sim_data во вьюхе
  def view_tree_data(tree_info)
    @tree_info = tree_info
    @current_user_id = current_user.id
    # @paged_similars_data = pages_of(@similars_founds, 10) # Пагинация ТОЛЬКО ДЛЯ МАССИВА ХЭШЕЙ - по 10 строк на стр.
  end

  # Отобр-е истории дерева - логов его развития - во вьюхе
  def view_common_logs(tree_all_logs)
    @current_user_id = current_user.id
 #   @paged_common_logs_data = pages_of(common_logs_data, 10) # Пагинация - по 10 строк на стр.
 #    logger.info "In view_common_logs_data: tree_all_logs = #{tree_all_logs} "
    @tree_all_logs = tree_all_logs
  end



end
