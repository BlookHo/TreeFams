module DisconnectionTrees
  extend ActiveSupport::Concern
  # in User model

  # Обратное разъобъединение профилей похожих - по log_id
  # После завершения - удаление данного лога объединения
  def disconnect_tree(log_id)
    logger.info "*** In module DisconnectionTrees disconnect_sims_in_tables: log_id = #{log_id} "

    log_to_redo = restore_connection_log(log_id)
    logger.info "*** In module DisconnectionTrees disconnect_sims_in_tables: log_to_redo = #{log_to_redo.inspect} "

    redo_connection_log(log_to_redo)

    log_connection_deletion(log_to_redo)

  end

# Получение массива логов из таблицы ConnectionLog по номеру лога log_id
  def restore_connection_log(log_id)
    ConnectionLog.where(connected_at: log_id)
  end

# Исполнение операций по логам - обратная перезапись в таблицах
  def redo_connection_log(log_to_redo)

    unless log_to_redo.blank?
      log_to_redo.each do |log_row|
        #     {:table_name=>"profiles", :table_row=>52, :field=>"tree_id", :written=>5, :overwritten=>4}
        model = log_row[:table_name].classify.constantize
        # logger.info "*** In module DisconnectionTrees redo_log: model = #{model.inspect} "
        row_to_update = model.find(log_row[:table_row])
        logger.info "*** In module DisconnectionTrees redo_log: row_to_update = #{log_row.inspect} "
        #<Profile id: 52, user_id: nil, created_at: "2015-01-24 12:08:26", updated_at: "2015-01-24 12:08:26",
        # name_id: 370, sex_id: 1, tree_id: 4, display_name_id: 370>

        # row_to_update.update_column(:"#{log_row[:field]}", log_row[:overwritten] )  # old
        row_to_update.update_attributes(:"#{log_row[:field]}" => log_row[:overwritten], :updated_at => Time.now)

      end
    end


  end

# Удаление разъединенного лога - после обратной перезаписи в таблицах
  def log_connection_deletion(log_to_redo)
    log_to_redo.map(&:destroy)
  end

end