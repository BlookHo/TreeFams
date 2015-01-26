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

    # Перезапись profile_data при объединении профилей
    #  ProfileData.connect!(profiles_to_rewrite, profiles_to_destroy)

    #########  перезапись profile_id's & update User
    log_connection_user_profile = Profile.profiles_merge(connection_data)

    # log_connection_tree       = update_table(connection_data, Tree)
    # log_connection_profilekey = update_table(connection_data, ProfileKey)
    log_connection_tree = []
    log_connection_profilekey = []

    common_log = {  log_user_profile: log_connection_user_profile,  log_tree: log_connection_tree, log_profilekey: log_connection_profilekey }
    complete_log_arr = common_log[:log_user_profile] + common_log[:log_tree] + common_log[:log_profilekey]

    store_log(complete_log_arr)
    # Запись массива лога в таблицу SimilarsLog под номером log_id
    common_log
  end


  # перезапись значений в полях одной таблицы
  def update_table(connection_data, table )
    log_connection = []

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
    #logger.info "*** In module SimilarsConnection update_table: log_connection = \n     #{log_connection} "
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

    #logger.info "*** In module SimilarsConnection User update_field before for: profiles_to_rewrite = #{profiles_to_rewrite},
    #             profiles_to_rewrite = #{profiles_to_rewrite} ,  connection_id = #{connection_id} "
    for arr_ind in 0 .. profiles_to_destroy.length-1 # ищем этот profile_id для его замены
      rows_to_update = table.where(:user_id => connected_users_arr).
                             where(" #{table_field} = #{profiles_to_destroy[arr_ind]} " )
      unless rows_to_update.blank?
        rows_to_update.each do |rewrite_row|

  #       rewrite_row.update_column(:"#{table_field}", profiles_to_rewrite[arr_ind] )

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
    #logger.info "*** In module SimilarsConnection User store_log: common_log = #{common_log}"
    common_log.each(&:save)

  end







  # Метод дла перезаписи профилей в таблицах
  # who_found_user_id - Автор дерева, который ищет
  # where_found_user_id - Автор дерева, в котором найдено
  ## (остаются): profiles_to_rewrite -
  ## (уходят): profiles_to_destroy -
  # who_connect_ids_arr - массив id, входящих в объед-ное дерево автора (того, кто соединяется)
  # with_who_conn_ids_ar - массив id, входящих в объед-ное дерево того, с кем соединяется автор
  #
  def connect_sims_in_tables(connection_data)


  #  self.connect_tree(connection_data)




    #########  перезапись profile_id's & update User
    ## (остаются): profiles_to_rewrite - противоположные, найденным в поиске
    ## (уходят): profiles_to_destroy - найден в поиске
    # Первым параметром идут те профили, которые остаются
 #   Profile.merge(profiles_to_rewrite, profiles_to_destroy)

    def connect_trees(profiles_to_rewrite, profiles_to_destroy, who_connect_ids_arr, with_who_conn_ids_ar)

      rewrite_tree_arr1 = []
      rewrite_tree_arr2 = []
      rewrite_profilekey_arr1 = []
      rewrite_profilekey_arr2 = []


      for arr_ind in 0 .. profiles_to_destroy.length-1 # ищем этот profile_id для его замены
        # меняем profile_id в match_profiles_arr на profile_id из opposite_profiles_arr
        one_profile = profiles_to_destroy[arr_ind] # profile_id для замены
        logger.info one_profile

        with_who_conn_ids_ar.each do |one_user_in_tree|
          # Получение массивов для Замены профилей в Tree
          one_arr1 = get_rewrite_profiles_ids(Tree, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
          rewrite_tree_arr1 << one_arr1 if !one_arr1.blank?
          @rewrite_tree_arr1 = rewrite_tree_arr1 # DEBUGG_TO_VIEW
          one_arr2 = get_rewrite_profiles_ids(Tree, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
          rewrite_tree_arr2 << one_arr2 if !one_arr2.blank?
          @rewrite_tree_arr2 = rewrite_tree_arr2 # DEBUGG_TO_VIEW

          # Получение массивов для Замены профилей в ProfileKey
          one_arr1 = get_rewrite_profiles_ids(ProfileKey, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
          rewrite_profilekey_arr1 << one_arr1 if !one_arr1.blank?
          @rewrite_profilekey_arr1 = rewrite_profilekey_arr1 # DEBUGG_TO_VIEW
          one_arr2 = get_rewrite_profiles_ids(ProfileKey, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
          rewrite_profilekey_arr2 << one_arr2 if !one_arr2.blank?
          @rewrite_profilekey_arr2 = rewrite_profilekey_arr2 # DEBUGG_TO_VIEW
        end

        who_connect_ids_arr.each do |one_user_in_tree|
          # Получение массивов для Замены профилей в Tree
          one_arr1 = get_rewrite_profiles_ids(Tree, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
          rewrite_tree_arr1 << one_arr1 if !one_arr1.blank?
          @rewrite_tree_arr1 = rewrite_tree_arr1 # DEBUGG_TO_VIEW
          one_arr2 = get_rewrite_profiles_ids(Tree, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
          rewrite_tree_arr2 << one_arr2 if !one_arr2.blank?
          @rewrite_tree_arr2 = rewrite_tree_arr2 # DEBUGG_TO_VIEW

          # Получение массивов для Замены профилей в ProfileKey
          one_arr1 = get_rewrite_profiles_ids(ProfileKey, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
          rewrite_profilekey_arr1 << one_arr1 if !one_arr1.blank?
          @rewrite_profilekey_arr1 = rewrite_profilekey_arr1 # DEBUGG_TO_VIEW
          one_arr2 = get_rewrite_profiles_ids(ProfileKey, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
          rewrite_profilekey_arr2 << one_arr2 if !one_arr2.blank?
          @rewrite_profilekey_arr2 = rewrite_profilekey_arr2 # DEBUGG_TO_VIEW
        end

      end

      save_rewrite_profiles_ids(Tree, rewrite_tree_arr1 + rewrite_tree_arr2)
      @save_in_tree = @saved_profiles_arr # DEBUGG_TO_VIEW
      @save_in_tree_LEN = @saved_profiles_arr.length if !@save_in_tree.blank? # DEBUGG_TO_VIEW
      save_rewrite_profiles_ids(ProfileKey, rewrite_profilekey_arr1 + rewrite_profilekey_arr2)
      @save_in_profilekey = @saved_profiles_arr # DEBUGG_TO_VIEW
      @save_in_profilekey_LEN = @saved_profiles_arr.length if !@save_in_profilekey.blank? # DEBUGG_TO_VIEW

    end




  end


  # Общий метод дла накапливания массива для перезаписи профилей в таблицах
  #
  def get_rewrite_profiles_ids(db_table, db_field, where_rewrite_user, field_profiles, new_profile_id)

    arr_to_rewrite = []
    one_arr = []
    where_found_to_replace = db_table.where(:user_id => where_rewrite_user.to_i).where(" #{db_field} = #{field_profiles} " )#[0]
    if !where_found_to_replace.blank?
      where_found_to_replace.each do |rewrite_row|
        one_arr[0] = rewrite_row.id ## DEBUGG_TO_VIEW
        one_arr[1] = db_field ## DEBUGG_TO_VIEW
        one_arr[2] = new_profile_id ## DEBUGG_TO_VIEW
        one_arr[3] = "-->" ## DEBUGG_TO_VIEW
        one_arr[4] = field_profiles #{db_field} ## DEBUGG_TO_VIEW
        arr_to_rewrite << one_arr
        one_arr = []
      end
      arr_to_rewrite
    else
      return nil
    end

    logger.info " In #{db_table}, #{db_field}: arr_to_rewrite = #{arr_to_rewrite} " # DEBUGG_TO_VIEW
    return arr_to_rewrite

  end

  # Общий метод дла перезаписи профилей в таблицах
  #
  def save_rewrite_profiles_ids(db_table, rewrite_arr)

    saved_profiles_arr = [] # DEBUGG_TO_VIEW
    test_arr = [] # DEBUGG_TO_VIEW
    for arr_ind in 0 .. rewrite_arr.length-1


      if rewrite_arr[arr_ind].length == 1
        row_id = rewrite_arr[arr_ind][0][0]
        row_field = rewrite_arr[arr_ind][0][1]
        new_profile_id = rewrite_arr[arr_ind][0][2]

        table_row = db_table.find(row_id)

        case row_field
          when "profile_id"
            table_row.profile_id = new_profile_id
            test_arr[1] = "pr" # DEBUGG_TO_VIEW
          when "is_profile_id"
            table_row.is_profile_id = new_profile_id
            test_arr[1] = "is_pr" # DEBUGG_TO_VIEW
          else
            "No field"
        end

        table_row.save  ####

        test_arr[0] = table_row.id # DEBUGG_TO_VIEW
        test_arr[2] = rewrite_arr[arr_ind][0][2] # DEBUGG_TO_VIEW

        saved_profiles_arr << test_arr # DEBUGG_TO_VIEW
        test_arr = [] # DEBUGG_TO_VIEW

      else  # rewrite_arr[arr_ind].length > 1

        rewrite_arr[arr_ind].each do |one_arr|
          row_id = one_arr[0]
          row_field = one_arr[1]
          new_profile_id = one_arr[2]

          table_row = db_table.find(row_id)

          case row_field
            when "profile_id"
              table_row.profile_id = new_profile_id
              test_arr[1] = "pr" # DEBUGG_TO_VIEW
            when "is_profile_id"
              table_row.is_profile_id = new_profile_id
              test_arr[1] = "is_pr" # DEBUGG_TO_VIEW
            else
              "No field"
          end

          table_row.save  ####

          test_arr[0] = table_row.id # DEBUGG_TO_VIEW
          test_arr[2] = one_arr[2] # DEBUGG_TO_VIEW

          saved_profiles_arr << test_arr # DEBUGG_TO_VIEW
          test_arr = [] # DEBUGG_TO_VIEW
        end

      end

    end

    @saved_profiles_arr = saved_profiles_arr # DEBUGG_TO_VIEW
    return @saved_profiles_arr # DEBUGG_TO_VIEW

  end




end
