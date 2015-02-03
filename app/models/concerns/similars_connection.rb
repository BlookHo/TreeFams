module SimilarsConnection
  extend ActiveSupport::Concern
  # in User model

  # Перезапись профилей в таблицах
  # Формирование лога объединения - получение его log_id
  # Запись лога в таблицу SimilarsLog под номером log_id
  # .
  def similars_connect_tree(connection_data)

    connected_users_arr = self.get_connected_users # Состав объединенного дерева в виде массива id
    connection_data[:connected_users_arr] = connected_users_arr

    # todo: Организовать перезапись Profile_datas - или см. в файле SimilarsProfileMerge.rb строки 28 ?
    # Перезапись profile_data при объединении профилей
    #  ProfileData.connect!(profiles_to_rewrite, profiles_to_destroy)

    #########  перезапись profile_id's & update User
  log_connection_user_profile = Profile.profiles_merge(connection_data)
    # log_connection_user_profile = []
    # todo:Раскоммитить 2 строки ниже и закоммитить 2 строки за ними  - для полной перезаписи логов и отладки
    log_connection_tree       = update_table(connection_data, Tree)
    log_connection_profilekey = update_table(connection_data, ProfileKey)
    # log_connection_tree = []
    # log_connection_profilekey = []

    common_log = {  log_user_profile: log_connection_user_profile,  log_tree: log_connection_tree, log_profilekey: log_connection_profilekey }
    complete_log_arr = common_log[:log_user_profile] + common_log[:log_tree] + common_log[:log_profilekey]

    store_log(complete_log_arr) unless complete_log_arr.blank?
    # Запись массива лога в таблицу SimilarsLog под номером log_id

    ### Удаление сохраненных ранее найденных пар похожих
    SimilarsFound.clear_similars_found(connection_data)

    common_log
  end


  # перезапись значений в полях одной таблицы
  def update_table(connection_data, table )
    log_connection = []

    # ТЕСТ
    # name_of_table = table.table_name
    # logger.info "*** In module SimilarsConnection update_table: name_of_table = #{name_of_table.inspect} "
    # model = name_of_table.classify.constantize
    # logger.info "*** In module SimilarsConnection update_table: model = #{model.inspect} "
    # logger.info "*** In module SimilarsConnection update_table: table = #{table.inspect} "

    connection_data[:table_name] = table.table_name
    ["profile_id", "is_profile_id"].each do |table_field|
      table_update_data = { table: table, table_field: table_field}
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
      unless rows_to_update.blank?
        rows_to_update.each do |rewrite_row|

          # todo:Раскоммитить 1 строкy ниже  - для полной перезаписи логов и отладки
  #       rewrite_row.update_column(:"#{table_field}", profiles_to_rewrite[arr_ind] )
          rewrite_row.update_attributes(:"#{table_field}" => profiles_to_rewrite[arr_ind], :updated_at => Time.now)

          one_connection_data = { connected_at: connection_id,              # int
                                  current_user_id: current_user_id,        # int
                                  table_name: table_name,                  # string
                                  table_row: rewrite_row.id,            # int
                                  field: table_field,                 # string
                                  written: profiles_to_rewrite[arr_ind],        # int
                                  overwritten: profiles_to_destroy[arr_ind] }        # int

          log_connection << SimilarsLog.new(one_connection_data)

        end

      end

    end
    log_connection

  end


  # Сохранение массива логов в таблицу SimilarsLog
  #
  def store_log(common_log)
    logger.info "*** In module SimilarsConnection store_log "
    common_log.each(&:save)
  end




end
