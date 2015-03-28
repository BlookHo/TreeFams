module ConnectionTrees
  extend ActiveSupport::Concern

# @note: основной метод объединения деревьев
#
# Центральный метод соединения деревьев = перезапись профилей в таблицах
# Заполнение таблицы Connected_Trees - записью о том, что деревья с current_user_id и user_id - соединились
#  connection_data = {:who_connect=>[1, 2], :with_whom_connect=>[3],
# :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18], :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
# :current_user_id=>1, :user_id=>3, :connection_id=>3}
  def connection_in_tables(connection_data) #, current_user_id, user_id, connection_id)

    who_connect         = connection_data[:who_connect]
    with_whom_connect   = connection_data[:with_whom_connect]
    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]
    current_user_id     = connection_data[:current_user_id]
    user_id             = connection_data[:user_id]
    connection_id       = connection_data[:connection_id]

    # [1 2] c [3]
    # @profiles_to_rewrite: [14, 21, 19, 11, 20, 12, 13, 18]
    # @profiles_to_destroy: [22, 29, 27, 25, 28, 23, 24, 26]
    # init_connection_hash = {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26}
    ###################################################################
    ######## Собственно Центральный метод соединения деревьев = перезапись профилей в таблицах
    #    connect_trees(connection_data)
    ####################################################################
    ######## Заполнение таблицы Connected_Trees - записью о том, что деревья с current_user_id и user_id - соединились
    #                          connect_users(current_user_id.to_i, user_id.to_i) # OLD!!

    #    ConnectedUser.set_users_connection(connection_data) #, current_user_id, user_id, connection_id)
    #### это и есть лог объединения - с массивами профилей!!!!

    ##################################################################
    ######## Перезапись profile_id при объединении деревьев
    #              UpdatesFeed.connect_update_profiles(profiles_to_rewrite, profiles_to_destroy)
    ##################################################################

    ######## Перезапись profile_data при объединении деревьев
    #    ProfileData.connect!(profiles_to_rewrite, profiles_to_destroy)
    ##################################################################

  end


# @note: Перезапись профилей в таблицах
# @param connection_data
  def connect_trees(connection_data)

    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]
    who_connect         = connection_data[:who_connect]
    with_whom_connect   = connection_data[:with_whom_connect]
    current_user_id     = connection_data[:current_user_id]
    user_id             = connection_data[:user_id]
    connection_id       = connection_data[:connection_id]

    logger.info "IN connect_trees: profiles_to_rewrite = #{profiles_to_rewrite}; profiles_to_destroy = #{profiles_to_destroy} "

    #####################################################
     Profile.merge(connection_data)
    #####################################################

    # log_connection_tree       = update_table(connection_data, Tree)
    # log_connection_profilekey = update_table(connection_data, ProfileKey)

    #####################################################
    update_table(connection_data, Tree)
    update_table(connection_data, ProfileKey)
    #####################################################

  end

# перезапись значений в полях одной таблицы
# лог не формируем как в похожих, т.к он уже сформирован в табл.Connected_User
  def update_table(connection_data, table )
    # log_connection = []

    # ТЕСТ
    # name_of_table = table.table_name
    # logger.info "*** In module SimilarsConnection update_table: name_of_table = #{name_of_table.inspect} "
    # model = name_of_table.classify.constantize
    # logger.info "*** In module SimilarsConnection update_table: model = #{model.inspect} "
    # logger.info "*** In module SimilarsConnection update_table: table = #{table.inspect} "

    connection_data[:table_name] = table.table_name # DEBUGG_TO
    logger.info "IN connect_trees update_table: connection_data[:table_name] = #{connection_data[:table_name]}" # DEBUGG_TO

    ['profile_id', 'is_profile_id'].each do |table_field|
      table_update_data = { table: table, table_field: table_field}
      # log_connection = update_field(connection_data, table_update_data , log_connection)
      update_field(connection_data, table_update_data)
    end
    # log_connection
  end


# Делаем общий массив юзеров, для update_field
# /
  def users_connecting_scope(who_connect, with_whom_connect)
    all_users_to_connect = who_connect + with_whom_connect
    logger.info "IN connect_trees users_connecting_scope: all_users_to_connect = #{all_users_to_connect}"
    all_users_to_connect
  end

# перезапись значений в одном поле одной таблицы
# profiles_to_destroy[arr_ind] - один profile_id для замены
# profiles_to_rewrite[arr_ind] - один profile_id, которым меняем
  def update_field(connection_data, table_update_data)

    who_connect         = connection_data[:who_connect]
    with_whom_connect   = connection_data[:with_whom_connect]
    # table_name          = connection_data[:table_name]
    # current_user_id     = connection_data[:current_user_id]
    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]
    # connected_users_arr = connection_data[:connected_users_arr]
    # connection_id       = connection_data[:connection_id]

    table       = table_update_data[:table]
    table_field = table_update_data[:table_field]

    all_users_to_connect = users_connecting_scope(who_connect, with_whom_connect)

    for arr_ind in 0 .. profiles_to_destroy.length-1 # ищем этот profile_id для его замены
      rows_to_update = table.where(:user_id => all_users_to_connect)
                           .where(" #{table_field} = #{profiles_to_destroy[arr_ind]} " )
      unless rows_to_update.blank?
        rows_to_update.each do |rewrite_row|

          # todo:Раскоммитить 1 строкy ниже  - для полной перезаписи логов и отладки
          #  rewrite_row.update_attributes(:"#{table_field}" => profiles_to_rewrite[arr_ind], :updated_at => Time.now)

          logger.info "IN connect_trees update_field: rewrite_row.id = #{rewrite_row.id}, #{rewrite_row.profile_id},
                          #{rewrite_row.is_profile_id} "
          logger.info "IN connect_trees update_field: rewrite_row.id = #{rewrite_row.id}, #{profiles_to_rewrite[arr_ind]} "

          # one_connection_data = { connected_at: connection_id,              # int
          #                         current_user_id: current_user_id,        # int
          #                         table_name: table_name,                  # string
          #                         table_row: rewrite_row.id,            # int
          #                         field: table_field,                 # string
          #                         written: profiles_to_rewrite[arr_ind],        # int
          #                         overwritten: profiles_to_destroy[arr_ind] }        # int
          #
          # log_connection << SimilarsLog.new(one_connection_data)

        end

      end

    end
    # log_connection

  end

  # @note: Контроль корректности массивов перед объединением
  #    # Tested
  # @param: connection_data = {:who_connect=>[1, 2], :with_whom_connect=>[3],
  #   :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18], :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
  #   :current_user_id=>1, :user_id=>3, :connection_id=>3}
  def check_connection_arrs(connection_data )
    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]

    stop_by_arrs = false
    logger.info "== In check_connection_arrs:  connection_data = #{connection_data}"
    commons = check_commons(profiles_to_rewrite, profiles_to_destroy)

    ######## Контроль корректности массивов перед объединением
    if !profiles_to_rewrite.blank? && !profiles_to_destroy.blank?
      logger.info "Ok to connect. Array(s) - Dont blank."

      # Проверка на наличие общих (совпадающих) эл-тов у массивов перезаписи
      # commons = check_commons(profiles_to_rewrite, profiles_to_destroy)
      logger.info "== In check_uniqness:  commons = #{commons}"
      if commons.blank?  # Нет пересечения commons=[]- общих профилей - Ок

        if profiles_to_rewrite.size == profiles_to_destroy.size
          logger.info "Ok to connect. Connection array(s) - Equal. Size = #{profiles_to_rewrite.size}."

          # Проверка найденных массивов перезаписи перед объединением - на повторы
          complete_dubles_hash = check_duplications(profiles_to_rewrite, profiles_to_destroy)

          if complete_dubles_hash.empty? # Если НЕТ дублирования в массивах
            connection_message = "Данные для объединения деревьев - корректны. "  # Tested
            logger.info "Ok to connect. НЕТ Дублирований in Connection array(s).
                        complete_dubles_hash = #{complete_dubles_hash};  connection_message = #{connection_message};"
          else
            connection_message =
                "Нельзя объединить ваши деревья, т.к. данные для объединения - некорректны! ЕСТЬ дублирования в массивах"  # Tested
            logger.info "ERROR: STOP connection! ЕСТЬ дублирования в массивах:
                         complete_dubles_hash = #{complete_dubles_hash};  connection_message = #{connection_message};"
            stop_by_arrs = true #
          end

        else
          connection_message = "Объединение остановлено, т.к. массив(ы) объединения - имеют разный размер"  # Tested
          logger.info "ERROR: STOP connection! Array(s) - NOT Equal! connection_message = #{connection_message} "
          stop_by_arrs = true
        end

      else
        connection_message = "Объединение остановлено. В массивах объединения - есть общие (совпадающие) профили!" # Tested
        logger.info "ERROR: В массивах объединения - есть общие профили! connection_message = #{connection_message};."
        stop_by_arrs = true
      end

    else
      connection_message = "Объединение остановлено, т.к. массив(ы) объединения - пустые" # Tested
      logger.info "ERROR: Connection array(s) - blank! connection_message = #{connection_message};."
      stop_by_arrs = true
    end

    @complete_dubles_hash = complete_dubles_hash  # DEBUGG_TO_VIEW
    logger.info "== After in check_connection_arrs:  stop_by_arrs = #{stop_by_arrs}, connection_message = #{connection_message} "

    { stop_by_arrs: stop_by_arrs,
      diag_connection_message: connection_message,
      common_profiles: commons,
      complete_dubles_hash: complete_dubles_hash
    }

  end


# ИСПОЛЬЗУЕТСЯ В МЕТОДЕ ОБЪЕДИНЕНИЯ ДЕРЕВЬЕВ - connection_of_trees
# Проверка найденных массивов перезаписи при объединении - на повторы
# .
  def check_duplications(profiles_to_rewrite, profiles_to_destroy)

    # Извлечение из массива - повторяющиеся эл-ты в виде массива
    def repeated(array)
      counts = Hash.new(0)
      array.each{|val|counts[val]+=1}
      counts.reject{|val,count|count==1}.keys
    end

    repeated_destroy = repeated(profiles_to_destroy)
    indexs_hash_destroy = {}
    if !repeated_destroy.blank?
      for i in 0 .. repeated_destroy.length-1
        arr_of_dubles = []
        profiles_to_destroy.each_with_index do |arr_el, index|
          if arr_el == repeated_destroy[i]
            arr_of_dubles << profiles_to_rewrite[index]
          end
        end
        indexs_hash_destroy.merge!(repeated_destroy[i] => arr_of_dubles)
      end
    end

    repeated_rewrite = repeated(profiles_to_rewrite)
    indexs_hash_rewrite = {}
    unless repeated_rewrite.blank?
      for i in 0 .. repeated_rewrite.length-1
        arr_of_dubles = []
        profiles_to_rewrite.each_with_index do |arr_el, index|
          if arr_el == repeated_rewrite[i]
            arr_of_dubles << profiles_to_destroy[index]
          end
        end
        indexs_hash_rewrite.merge!(repeated_rewrite[i] => arr_of_dubles)
      end
    end

    complete_dubles_hash = {}
    complete_dubles_hash = complete_dubles_hash.merge!(indexs_hash_destroy) unless indexs_hash_destroy.blank?
    complete_dubles_hash = complete_dubles_hash.merge!(indexs_hash_rewrite) unless indexs_hash_rewrite.blank?

    @complete_dubles_hash = complete_dubles_hash # DEBUGG_TO_VIEW

    # complete_dubles_hash = {11=>[25, 26]}  # for DEBUGG ONLY!!!

    complete_dubles_hash

  end

# Проверка на наличие общих (совпадающих) эл-тов у массивов перезаписи
# Что - не должно быть!.
  def check_commons(array1, array2)
    logger.info "== In check_uniqness:  array1 = #{array1}"
    logger.info "== In check_uniqness:  array2 = #{array2}"
    array1 & array2
  end








end # End of ConnectionTrees module

