class DeletionLog < ActiveRecord::Base


  # From -Module ProfileDestroying
  # Сохранение массива логов в таблицу DeletionLog
  def self.store_deletion_log(deletion_log)
    puts "In model DeletionLog store_log: deletion_log.size = #{deletion_log.size} " unless deletion_log.blank?
    deletion_log.each(&:save)
  end


  # Получение массива логов из таблицы DeletionLog по номеру лога log_id
  def self.restore_deletion_log(log_id, current_user)

    connected_users_arr = current_user.get_connected_users

    # puts "In DeletionLog model: restore_deletion_log: log_id = #{log_id}, user_id.id = #{user_id.id}"
    DeletionLog.where(log_number: log_id, current_user_id: connected_users_arr)
  end


  # @note
  #   Исполнение операций по deletion_log - обратная перезапись в таблицах
  def self.redo_deletion_log(log_to_redo)

    # def check_profiles_exists(profile_id, is_profile_id)
    #   yes = false
    #   yes = true if Profile.where(id: profile_id, deleted: 0) && Profile.where(id: is_profile_id, deleted: 0)
    #   yes
    # end

    puts "In DeletionLog model: redo_deletion_log: log_to_redo.size = #{log_to_redo.size}" unless log_to_redo.blank?

    unless log_to_redo.blank?
      log_to_redo.each do |log_row|
        #     {:table_name=>"profiles", :table_row=>52, :field=>"tree_id", :written=>5, :overwritten=>4}
        model = log_row[:table_name].classify.constantize
        if model.exists? id: log_row[:table_row]
          row_to_update = model.find(log_row[:table_row])
          # logger.info "*** In module DisconnectionTrees redo_connection_log: row_to_update = #{row_to_update.inspect} "
          # todo:Раскоммитить 1 строкy ниже  - для полной перезаписи логов и отладки

          if Profile.check_profiles_exists(row_to_update.profile_id, row_to_update.is_profile_id)
            row_to_update.update_attributes(:"#{log_row[:field]}" => log_row[:overwritten],
                                            :updated_at => Time.now) unless row_to_update.blank?
          end
        end

      end
    end


  end


  # Удаление deletion_log лога - после обратной перезаписи 1 in 0  в таблицах
  def self.deletion_logs_deletion(log_to_redo)
    log_to_redo.map(&:destroy)
  end




end
