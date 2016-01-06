module DisconnectionTrees
  extend ActiveSupport::Concern
  # in User model
  # require 'pry'
  # binding.pry          # Execution will stop here.

  # @note Обратное разъобъединение профилей похожих - по log_id
  # После завершения - удаление данного лога объединения
  def disconnect_tree(common_log_id)

    # Before CommonLog destroy
    connection_common_log = CommonLog.find(common_log_id).attributes.except('created_at','updated_at')
    conn_users_destroy_data = { user_id:       connection_common_log["user_id"],
                                with_user_id:  Profile.find(connection_common_log["base_profile_id"]).user_id,
                                connection_id: connection_common_log["log_id"] }
    connection_id = connection_common_log["log_id"]
    logger.info  "In DisconnectionTrees: common_log_id = #{common_log_id}, connection_id = #{connection_id}"

    log_to_redo = restore_connection_log(connection_common_log["log_id"])#, connection_common_log["user_id"])

    redo_connection_log(log_to_redo)

    log_connection_deletion(log_to_redo)

    Counter.increment_disconnects

    connected = self.get_connected_users

    CommonLog.find(common_log_id).destroy
    ProfileData.destroy_profile_data(conn_users_destroy_data)

    # Before ConnectedUser destroy_connection для всех запросов на объединение, ранее установленных как выполненные,
    # confirm был равен 2, т.е. для всех входящих в запросы юзеров (деревьев)
    # Этот метод ниже выключен, чтобы не возвращать запросы на объед-е в состояние, перед объединением.
    #  См. также изменения в user_spec.rb, lines: 1626,1632,1653,1659,1677,1683
    #   ConnectionRequest.disconnected_requests_update(conn_users_destroy_data)

    SearchResults.clear_all_prev_results(self.id)
    ConnectedUser.destroy_connection(conn_users_destroy_data)
    self.update_disconnected_users!

    # Этот метод ниже выключен, чтобы не возвращать запросы на объед-е в состояние, перед объединением.
    #  См. также изменения в user_spec.rb, lines: 1626,1632,1653,1659,1677,1683
    #   ConnectionRequest.request_disconnection(conn_users_destroy_data)

  end


  # @note Получение массива логов из таблицы ConnectionLog по номеру лога log_id
  def restore_connection_log(log_id)#, user_id)
  # def restore_connection_log(log_id, user_id)
    # ConnectionLog.where(connected_at: log_id, current_user_id: user_id)
    ConnectionLog.where(connected_at: log_id)#, current_user_id: user_id)
  end


  # @note Исполнение операций по логам - обратная перезапись в таблицах
  def redo_connection_log(log_to_redo)
    unless log_to_redo.blank?
      log_to_redo.each do |log_row|
        model = log_row[:table_name].classify.constantize
        row_to_update = model.find(log_row[:table_row]) if model.exists? id: log_row[:table_row]
        logger.info "In redo_connection_log: row_to_update = #{row_to_update.inspect}"
    # row_to_update.update_attributes(:"#{log_row[:field]}" => log_row[:overwritten], :updated_at => Time.now) unless row_to_update.blank?
        row_to_update.update_columns(:"#{log_row[:field]}" => log_row[:overwritten], :updated_at => Time.now) unless row_to_update.blank?
      end
    end
  end


  # Удаление разъединенного лога - после обратной перезаписи в таблицах
  def log_connection_deletion(log_to_redo)
    log_to_redo.map(&:destroy)
  end

end
