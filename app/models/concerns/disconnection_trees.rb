module DisconnectionTrees
  extend ActiveSupport::Concern
  # in User model

  # Обратное разъобъединение профилей похожих - по log_id
  # После завершения - удаление данного лога объединения
  def disconnect_tree(common_log_id)
    # puts "In User model: disconnect_tree: common_log_id = #{common_log_id}"

    connection_common_log = CommonLog.find(common_log_id).attributes.except('created_at','updated_at')

    # Before CommonLog destroy
    conn_users_destroy_data = {
        user_id: connection_common_log["user_id"], #    1,
        with_user_id: Profile.find(connection_common_log["base_profile_id"]).user_id,    #        3,
        connection_id: connection_common_log["log_id"]   #    3,
    }


    log_to_redo = restore_connection_log(connection_common_log["log_id"], connection_common_log["user_id"])

    redo_connection_log(log_to_redo)

    log_connection_deletion(log_to_redo)

    ##########  UPDATES FEEDS - № 17  ############## В обоих направлениях: Кто с Кем и Обратно
    # Before CommonLog destroy_connection
    one_common_log = CommonLog.find(common_log_id)
    profile_current_user = User.find(self.id).profile_id
    UpdatesFeed.create(user_id: self.id, update_id: 17,
                       agent_user_id: one_common_log.user_id, agent_profile_id: one_common_log.profile_id,
                       who_made_event: self.id,
                       read: false)
    UpdatesFeed.create(user_id: one_common_log.user_id, update_id: 17,
                       agent_user_id: self.id, agent_profile_id: profile_current_user,
                       who_made_event: self.id,
                       read: false)
    connected = self.get_connected_users

    connected.each do |each_user|
      if each_user != self.id && each_user != one_common_log.user_id
        UpdatesFeed.create(user_id: each_user, update_id: 17,
                           agent_user_id: self.id, agent_profile_id: profile_current_user,
                           who_made_event: self.id,
                           read: false)
      end
    end
    ###############################################

    CommonLog.find(common_log_id).destroy

    # Before ConnectedUser destroy_connection
    ConnectionRequest.disconnected_requests_update(conn_users_destroy_data)

    ConnectedUser.destroy_connection(conn_users_destroy_data)

    ConnectionRequest.request_disconnection(conn_users_destroy_data)

  end


  # Получение массива логов из таблицы ConnectionLog по номеру лога log_id
  def restore_connection_log(log_id, user_id)
    # puts "In User model: restore_connection_log: log_id = #{log_id}, user_id = #{user_id}"
    # logger.info "*** In module DisconnectionTrees restore_connection_log:
    #              log_id = #{log_id}, user_id = #{user_id} "
    ConnectionLog.where(connected_at: log_id, current_user_id: user_id)
  end


  # @note
  #   Исполнение операций по логам - обратная перезапись в таблицах
  def redo_connection_log(log_to_redo)

    unless log_to_redo.blank?
      log_to_redo.each do |log_row|
        #     {:table_name=>"profiles", :table_row=>52, :field=>"tree_id", :written=>5, :overwritten=>4}
        model = log_row[:table_name].classify.constantize
        # logger.info "*** In module DisconnectionTrees redo_log: model = #{model.inspect} "
        row_to_update = model.find(log_row[:table_row])
        logger.info "*** In module DisconnectionTrees redo_connection_log: log_row = #{log_row.inspect} "
        logger.info "*** In module DisconnectionTrees redo_connection_log: row_to_update = #{row_to_update.inspect} "

        # todo:Раскоммитить 1 строкy ниже  - для полной перезаписи логов и отладки
    row_to_update.update_attributes(:"#{log_row[:field]}" => log_row[:overwritten], :updated_at => Time.now)

      end
    end

  end

  # Удаление разъединенного лога - после обратной перезаписи в таблицах
  def log_connection_deletion(log_to_redo)
    log_to_redo.map(&:destroy)
  end

end