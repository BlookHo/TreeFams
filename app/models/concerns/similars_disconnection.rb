module SimilarsDisconnection
  extend ActiveSupport::Concern
# in User model

# todo: check disconnect sims destroy common_log & update_feed
# Обратное разъобъединение профилей похожих - по log_id
# После завершения - удаление данного лога объединения
  def disconnect_sims(common_log_id)
    logger.info "*** In module SimilarsDisconnection disconnect_sims_in_tables: common_log_id = #{common_log_id} "

    connection_common_log = CommonLog.find(common_log_id).attributes.except('created_at','updated_at')
    conn_users_destroy_data = {
        user_id: connection_common_log["user_id"], #    1,
        with_user_id: Profile.find(connection_common_log["base_profile_id"]).user_id,    #        3,
        connection_id: connection_common_log["log_id"]   #    3,
    }

    # logger.info "In disconnect_sims_in_tables : Before destroy common_log   connection_common_log= #{connection_common_log} "

    log_to_redo = restore_log(connection_common_log["log_id"])
    # log_to_redo = restore_log(conn_users_destroy_data[:connection_id]) #               (log_id)
    logger.info "*** In module SimilarsDisconnection disconnect_sims_in_tables: log_to_redo = #{log_to_redo.inspect} "

    redo_log(log_to_redo)

    log_deletion(log_to_redo)

    # From disconnect_trees

    # ##########  UPDATES FEEDS - № 20  # similars_disconnect ###################
    # update_feed_data = { user_id:           self.id,    # 3
    #                      update_id:         20,                  #
    #                      agent_user_id:     @profile.tree_id,   # 3
    #                      read:              false,              #
    #                      agent_profile_id:  @profile.id,        # 215
    #                      who_made_event:    self.id }   # 3
    # logger.info "In SimilarsDisconnection: Before create UpdatesFeed   update_feed_data= #{update_feed_data} "
    # # update_feed_data= {:user_id=>1, :update_id=>4, :agent_user_id=>2, :read=>false, :agent_profile_id=>219, :who_made_event=>1} (pid:16287)
    # UpdatesFeed.create(update_feed_data) #

    CommonLog.find(common_log_id).destroy


  end

# todo: check disconnect sims destroy common_log & update_feed
  # Обратное разъобъединение профилей похожих - по log_id
  # После завершения - удаление данного лога объединения
  def disconnect_sims_in_tables(log_id)
    logger.info "*** In module SimilarsDisconnection disconnect_sims_in_tables: log_id = #{log_id} "

    # From disconnect_trees
    # connection_common_log = CommonLog.find(log_id).attributes.except('created_at','updated_at')
    # conn_users_destroy_data = {
    #     user_id: connection_common_log["user_id"], #    1,
    #     with_user_id: Profile.find(connection_common_log["base_profile_id"]).user_id,    #        3,
    #     connection_id: connection_common_log["log_id"]   #    3,
    # }

    # logger.info "In disconnect_sims_in_tables : Before destroy common_log   connection_common_log= #{connection_common_log} "

    log_to_redo = restore_log(log_id)
    # log_to_redo = restore_log(conn_users_destroy_data[:connection_id]) #               (log_id)
    logger.info "*** In module SimilarsDisconnection disconnect_sims_in_tables: log_to_redo = #{log_to_redo.inspect} "

    redo_log(log_to_redo)

    log_deletion(log_to_redo)

    # From disconnect_trees
    # CommonLog.find(log_id).destroy

    # ##########  UPDATES FEEDS - № 20  # similars_disconnect ###################
    # update_feed_data = { user_id:           self.id,    # 3
    #                      update_id:         20,                  #
    #                      agent_user_id:     @profile.tree_id,   # 3
    #                      read:              false,              #
    #                      agent_profile_id:  @profile.id,        # 215
    #                      who_made_event:    self.id }   # 3
    # logger.info "In SimilarsDisconnection: Before create UpdatesFeed   update_feed_data= #{update_feed_data} "
    # # update_feed_data= {:user_id=>1, :update_id=>4, :agent_user_id=>2, :read=>false, :agent_profile_id=>219, :who_made_event=>1} (pid:16287)
    # UpdatesFeed.create(update_feed_data) #


  end

  # Получение массива логов из таблицы SimilarsLog по номеру лога log_id
  def restore_log(log_id)  # , user_id
    SimilarsLog.where(connected_at: log_id)  # , current_user_id: user_id
  end

  # Исполнение операций по логам - обратная перезапись в таблицах
  def redo_log(log_to_redo)

    unless log_to_redo.blank?
      log_to_redo.each do |log_row|
         #     {:table_name=>"profiles", :table_row=>52, :field=>"tree_id", :written=>5, :overwritten=>4}
        model = log_row[:table_name].classify.constantize
        # logger.info "*** In module SimilarsDisconnection redo_log: model = #{model.inspect} "
        row_to_update = model.find(log_row[:table_row])
        logger.info "*** In module SimilarsDisconnection redo_log: row_to_update = #{log_row.inspect} "
        #<Profile id: 52, user_id: nil, created_at: "2015-01-24 12:08:26", updated_at: "2015-01-24 12:08:26",
        # name_id: 370, sex_id: 1, tree_id: 4, display_name_id: 370>

        row_to_update.update_attributes(:"#{log_row[:field]}" => log_row[:overwritten], :updated_at => Time.now)

      end
    end


  end

  # Удаление разъединенного лога - после обратной перезаписи в таблицах
  def log_deletion(log_to_redo)
    log_to_redo.map(&:destroy)
  end

end