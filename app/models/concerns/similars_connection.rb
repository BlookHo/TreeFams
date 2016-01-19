module SimilarsConnection
  extend ActiveSupport::Concern
  # in User model

  # @note Основной метод объединения похожих профилей в одном дереве
  # @params Первый и Второй похожие профили из одной пары
  def similars_connection(first_profile_connecting, second_profile_connecting)

    #################################################
    rewrite_to_clean, destroy_to_clean, init_hash = self.similars_complete_search(first_profile_connecting, second_profile_connecting)
    #################################################
    # logger.info "TEST similars_connection : clean_profiles_arrs: rewrite_to_clean = #{rewrite_to_clean} , destroy_to_clean = #{destroy_to_clean} "

    #### update profiles arrays ###########
    profiles_to_rewrite, profiles_to_destroy = clean_profiles_arrs(rewrite_to_clean, destroy_to_clean)
    logger.info "TEST similars_connection : clean_profiles_arrs: profiles_to_rewrite = #{profiles_to_rewrite} , profiles_to_destroy = #{profiles_to_destroy} "

    # Перезапись profile_data при объединении профилей
    ProfileData.connect_profiles_data(profiles_to_rewrite, profiles_to_destroy)

    last_log_id = SimilarsLog.last.connected_at unless SimilarsLog.all.empty?
    # logger.info "*** In connect_similars last_log_id = #{last_log_id.inspect}"
    # порядковый номер connection - взять значение из последнего лога
    last_log_id == nil ? last_log_id = 1 : last_log_id += 1
    # logger.info "*** In connect_similars last_log_id = #{last_log_id.inspect}"

    similars_connection_data = {profiles_to_rewrite: profiles_to_rewrite, #
                                profiles_to_destroy: profiles_to_destroy,
                                current_user_id: self.id,
                                connection_id: last_log_id }
    ######## call of User.module Similars_connection
    log_connection = self.similars_connect_tree(similars_connection_data)

        {init_hash: init_hash,                       # for RSpec & TO_VIEW
         profiles_to_rewrite: profiles_to_rewrite,   # for RSpec & TO_VIEW
         profiles_to_destroy: profiles_to_destroy,   # for RSpec & TO_VIEW
         last_log_id: log_connection
        }

  end


  # @note: exclude equal profile_ids from connection arrays
  #   leave only profile_to_rewrite != profile_to_destroy
  def clean_profiles_arrs(profiles_to_rewrite, profiles_to_destroy)
    clean_to_rewrite = []
    clean_to_destroy = []
    profiles_to_rewrite.each_with_index do |profile_id, index|
      if profile_id != profiles_to_destroy[index]
        clean_to_rewrite << profile_id
        clean_to_destroy << profiles_to_destroy[index]
      end
    end
    return clean_to_rewrite, clean_to_destroy
  end


  # Перезапись профилей в таблицах
  # Формирование лога объединения - получение его log_id
  # Запись лога в таблицу SimilarsLog под номером log_id
  def similars_connect_tree(connection_data)

    connected_users_arr = self.get_connected_users # Состав объединенного дерева в виде массива id
    connection_data[:connected_users_arr] = connected_users_arr

    #########  перезапись profile_id's & update User
     log_connection_user_profile = Profile.profiles_merge(connection_data)
  #  log_connection_user_profile = []
    # todo:Раскоммитить 2 строки ниже и закоммитить 2 строки за ними  - для полной перезаписи логов и отладки
    #########  перезапись profile_id's в Tree и ProfileKey
    log_connection_tree       = update_table(connection_data, Tree)
    log_connection_profilekey = update_table(connection_data, ProfileKey)
    # log_connection_tree = []
    # log_connection_profilekey = []

    common_sims_log = {  log_user_profile: log_connection_user_profile,  log_tree: log_connection_tree, log_profilekey: log_connection_profilekey }
    complete_log_arr = common_sims_log[:log_user_profile] + common_sims_log[:log_tree] + common_sims_log[:log_profilekey]

    # Запись массива лога в таблицу SimilarsLog под номером log_id
    SimilarsLog.store_log(complete_log_arr) unless complete_log_arr.blank?

    data_to_clear = { profiles_to_rewrite: connection_data[:profiles_to_rewrite],
                      profiles_to_destroy: connection_data[:profiles_to_destroy],
                      connected_users_arr: connection_data[:connected_users_arr]   }

    ### Удаление сохраненных ранее найденных пар похожих
    SimilarsFound.clear_similars_found(data_to_clear)
    logger.info "# CONN ##*** In module SimilarsConnection common_sims_logs: #{common_sims_log.inspect} "

    # Запись строки Общего лога в таблицу CommonLog
    make_sims_connec_common_log(connection_data)

    # connection_data = {profiles_to_rewrite: profiles_to_rewrite, #
    #                             profiles_to_destroy: profiles_to_destroy,
    #                             current_user_id: current_user.id,
    #                             connection_id: last_log_id }

    ##########  UPDATES FEEDS - № 19  # similars_connect ###################
    # profile_current_user = User.find(connection_data[:current_user_id]).profile_id
    # update_feed_data = { user_id:           connection_data[:current_user_id] ,    #
    #                      update_id:         19,                  #
    #                      agent_user_id:     connection_data[:current_user_id],   #
    #                      read:              false,              #
    #                      agent_profile_id:  profile_current_user,        #
    #                      who_made_event:    connection_data[:current_user_id] }   #
    # logger.info "In SimilarsConnection: Before create UpdatesFeed   update_feed_data= #{update_feed_data} "
    # update_feed_data= {:user_id=>1, :update_id=>4, :agent_user_id=>2, :read=>false, :agent_profile_id=>219, :who_made_event=>1} (pid:16287)

    # UpdatesFeed.create(update_feed_data) #

    common_sims_log
  end



  # перезапись значений в полях одной таблицы
  def update_table(connection_data, table )
    log_connection = []

    # ТЕСТ
    # name_of_table = table.table_name
    # model = name_of_table.classify.constantize
    # logger.info "*** In module SimilarsConnection update_table: table = #{table.inspect}, name_of_table = #{name_of_table.inspect} , model = #{model.inspect} "

    connection_data[:table_name] = table.table_name
    ['profile_id', 'is_profile_id'].each do |table_field|
      table_update_data = { table: table, table_field: table_field}
      logger.info "*** In module SimilarsConnection update_table: table_update_data = #{table_update_data.inspect} "
      log_connection = update_field(connection_data, table_update_data , log_connection)
    end
    log_connection
  end

  # перезапись значений в одном поле одной таблицы
  # profiles_to_destroy[arr_ind] - один profile_id для замены
  # profiles_to_rewrite[arr_ind] - один profile_id, которым меняем
  def update_field(connection_data, table_update_data, log_connection)

    table_name          = connection_data[:table_name]
    current_user_id     = connection_data[:current_user_id]
    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]
    connected_users_arr = connection_data[:connected_users_arr]
    connection_id       = connection_data[:connection_id]

    table       = table_update_data[:table]
    table_field = table_update_data[:table_field]

    for arr_ind in 0 .. profiles_to_destroy.length-1 # ищем этот profile_id для его замены
      rows_to_update = table.where(:user_id => connected_users_arr).
                             where(" #{table_field} = #{profiles_to_destroy[arr_ind]} " )
      logger.info "*** In module SimilarsConnection update_field: rows_to_update = #{rows_to_update.inspect} "

      unless rows_to_update.blank?
        rows_to_update.each do |rewrite_row|

          # Check: If values in one row in both fields ('profile_id', 'is_profile_id') WILL BE EQUAL?
          # Then -we MARK thie row as DELETED
          table_field == 'profile_id' ?
              other_field_val = rewrite_row.is_profile_id :
              other_field_val = rewrite_row.profile_id
          logger.info "*** In module SimilarsConnection update_field: other_field_val = #{other_field_val.inspect} "

          if other_field_val == profiles_to_rewrite[arr_ind]
            # Generate deleted = 1 log
            rewrite_row.update_attributes(:deleted => 1, :updated_at => Time.now)
            one_connection_data = { connected_at: connection_id,              # int
                                    current_user_id: current_user_id,        # int
                                    table_name: table_name,                  # string
                                    table_row: rewrite_row.id,            # int
                                    field: 'deleted',                 # string
                                    written: 1,        # int
                                    overwritten: 0 }        # int
            logger.info "*** In module update_field: Row Deleted log "
          else
            rewrite_row.update_attributes(:"#{table_field}" => profiles_to_rewrite[arr_ind], :updated_at => Time.now)
            one_connection_data = { connected_at: connection_id,              # int
                                    current_user_id: current_user_id,        # int
                                    table_name: table_name,                  # string
                                    table_row: rewrite_row.id,            # int
                                    field: table_field,                 # string
                                    written: profiles_to_rewrite[arr_ind],        # int
                                    overwritten: profiles_to_destroy[arr_ind] }        # int
            logger.info "*** In module update_field: Row Field update log "
          end

          log_connection << SimilarsLog.new(one_connection_data)

        end

      end

    end
    log_connection

  end

  # todo: check connect sims create common_log & update_feed
  # @note: Сделать 1 запись в общие логи: в common_sims_logs
  def make_sims_connec_common_log(connection_data)
    logger.info "In make_sims_connec_common_log: Before common_log"
    current_log_type          = 3  # connection trees: rollback == disconnect similars. Тип = разъединение similars при rollback
    current_user_id           = connection_data[:current_user_id]
    # user_id                   = connection_data[:user_id]
    common_connect_log_number = connection_data[:connection_id] # Берем тот номер соединения similars,
    # который идет из Conn_requests - номер запроса на соединение деревьев. Он - единый и не является порядковым, как
    # номера логов на добавление и удаление профилей, номера которыхформируются прямо в табл. CommonLogs.

    # puts "In make_sims_connec_common_log: current_user_id = #{current_user_id}"
    # puts "In make_sims_connec_common_log: connection_data = #{connection_data} "

    # new_common_log_number = CommonLog.new_log_id(current_user_id, current_log_type) # No use

    common_log_data = { user_id:         current_user_id,
                        log_type:        current_log_type,
                        log_id:          common_connect_log_number,
                        profile_id:      User.find(current_user_id).profile_id,
                        base_profile_id: User.find(current_user_id).profile_id,
                        new_relation_id: 888 }  # Условный код для лога объединения similars
    logger.info "In SimilarsConnection : Before create_common_log   common_log_data= #{common_log_data} "
    CommonLog.create_common_log(common_log_data)


  end



end
