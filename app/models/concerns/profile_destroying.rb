module ProfileDestroying
  extend ActiveSupport::Concern



  # @note: Основной метод удаления профиля
  def destroying_profile(profile_id)
    profile = Profile.where(id: profile_id).first
    if !profile
      error = "Профиль не найден"
    elsif profile.user.present?
      error = "Вы не можете удалить профиль у которого есть реальный владелец (юзер)"
    elsif profile.tree_circle(self.get_connected_users, profile.id).size > 0
      error = "Вы можете удалить только последнего родственника в цепочке"
    else

      tree_row = Tree.where(is_profile_id: profile_id)
      new_relation_id = tree_row[0].relation_id
      # Профиль, от которого растет удаляемый
      base_profile = Profile.find(tree_row[0].profile_id)  #

      # todo: пока удаляем ProfileData
      ProfileData.where(profile_id: profile.id).map(&:destroy)

      current_log_type = 2  #  # delete : rollback == add. Тип = удаление нового профиля при rollback
      new_log_number = CommonLog.new_log_id(base_profile.tree_id, current_log_type)

      common_log_data = { user_id:         self.id,
                          log_type:        current_log_type,
                          log_id:          new_log_number,
                          profile_id:      profile_id,
                          base_profile_id: base_profile.id,
                          new_relation_id: new_relation_id  }
      # Запись строки Общего лога в таблицу CommonLog
      CommonLog.create_common_log(common_log_data)

      #######################################################
      deletion_tables_logs = []
      [Tree, ProfileKey].each do |table|
        destroy_table_data = {
            log_number: new_log_number,
            profile_id: profile.id,
            current_user_id: self.id,
            table: table.table_name
        }
        log_table_del = log_table_rows_deleted(destroy_table_data)
        deletion_tables_logs = deletion_tables_logs +  log_table_del
      end

      # Запись массива лога в таблицу DeletionLog
      DeletionLog.store_deletion_log(deletion_tables_logs) unless deletion_tables_logs.blank?

      # Previous version
      # Tree.where("is_profile_id = ? OR profile_id = ?", profile.id, profile.id).map(&:destroy)
      # ProfileKey.where("is_profile_id = ? OR profile_id = ?", profile.id, profile.id).map(&:destroy)


      ##########  UPDATES FEEDS - № 18  # destroy ###################
      update_feed_data = { user_id:           self.id,    #
                           update_id:         18,                  #
                           agent_user_id:     base_profile.tree_id,   #
                           read:              false,              #
                           agent_profile_id:  profile_id,        #
                           who_made_event:    self.id }   #
      logger.info "In Profile controller: Before destroy UpdatesFeed   update_feed_data= #{update_feed_data} "
      UpdatesFeed.create(update_feed_data) #

      # Mark profile as deleted
      profile.update_attribute('deleted', 1)

      # sims & search
      # puts "In Rails Concern: After destroying_profile: start_search_methods "
      # SearchResults.start_search_methods(self)

    end

    response = error ? {status: 403, message: error} : {status: 200, message: "Профиль удален"}
    puts response
    response

  end


  # @note генерация лога для "удаляемого" ряда Tree при удалении профиля
  def log_table_rows_deleted(destroy_table_data )

    log_number = destroy_table_data[:log_number]
    del_profile_id = destroy_table_data[:profile_id]
    current_user_id = destroy_table_data[:current_user_id]
    table_name = destroy_table_data[:table]
    table_model = table_name.classify.constantize

    logs_table_del = []
    rows_to_update = table_model.where("is_profile_id = ? OR profile_id = ?", del_profile_id, del_profile_id)#.map(&:destroy)
    unless rows_to_update.blank?
      rows_to_update.each do |rewrite_row|
        # Mark opposite profiles as deleted
        rewrite_row.update_attributes(:deleted => 1, :updated_at => Time.now)

        one_deletion_log = {    log_number: log_number,             # int
                                current_user_id: current_user_id,   # int
                                table_name: table_name,             # string
                                table_row: rewrite_row.id,          # int
                                field: 'deleted',                   # string
                                written: 1,                         # int
                                overwritten: 0 }                    # int
        logs_table_del << DeletionLog.new(one_deletion_log)
      end
      logs_table_del
    end

  end




end
