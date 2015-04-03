module DisconnectionTrees
  extend ActiveSupport::Concern
  # in User model

  # Обратное разъобъединение профилей похожих - по log_id
  # После завершения - удаление данного лога объединения
  def disconnect_tree(common_log_id)
    # puts "In User model: disconnect_tree: common_log_id = #{common_log_id}"

    connection_common_log = CommonLog.find(common_log_id).attributes.except('created_at','updated_at')
    # common_log_row_fields = CommonLog.find(common_log_id).attributes.except('created_at','updated_at')
    # expect(common_log_row_fields).to eq({
    # "id"=>1,
    # "user_id"=>1,
    # "log_type"=>4,
    # "log_id"=>3,
    # "profile_id"=>17,
    #  "base_profile_id"=>14,
    # "relation_id"=>999} )
    # puts "In User model: before restore_connection_log: connection_common_log = #{connection_common_log},
    #        connection_common_log['base_profile_id'] = #{connection_common_log['base_profile_id']}      "  # 114 ok
    #
    # puts " user_id = #{User.where(profile_id: 22)} "
    # puts " user_id = #{User.where(profile_id: connection_common_log["base_profile_id"])} "
    # puts " user_id = #{Profile.find(connection_common_log["base_profile_id"]).user_id} "


    # with_user_id = User.where(profile_id: common_log_row_fields["base_profile_id"])
    conn_users_destroy_data = {
        user_id: connection_common_log["user_id"], #    1,
        with_user_id: Profile.find(connection_common_log["base_profile_id"]).user_id,    #        3,
        connection_id: connection_common_log["log_id"]   #    3,
    }

    log_to_redo = restore_connection_log(connection_common_log["log_id"], connection_common_log["user_id"])
    # logger.info "*** In module Disconnection after restore_connection_log:
    #                   log_to_redo.size = #{log_to_redo.size.inspect}"
    # puts "In User model: before redo_connection_log: log_to_redo.size = #{log_to_redo.size}"  # 114 ok

    redo_connection_log(log_to_redo)

    log_connection_deletion(log_to_redo)

    CommonLog.find(common_log_id).destroy


    ConnectedUser.destroy_connection(conn_users_destroy_data)

    puts "In User model: before request_disconnection: conn_users_destroy_data = #{conn_users_destroy_data}"  # 114 ok

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