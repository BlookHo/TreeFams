module ConnectionTrees
  extend ActiveSupport::Concern
  # in User model

  # @note: основной метод объединения деревьев
  #   Центральный метод соединения деревьев = перезапись профилей в таблицах
  #   Заполнение таблицы Connected_Trees - записью о том, что деревья с current_user_id и user_id - соединились
  #  connection_data = {:who_connect=>[1, 2], :with_whom_connect=>[3],
  # :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18], :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
  # :current_user_id=>1, :user_id=>3, :connection_id=>3}
  def connection_in_tables(connection_data)

    # who_connect_arr         = connection_data[:who_connect_arr]
    # with_whom_connect_arr   = connection_data[:with_whom_connect_arr]
    profiles_to_rewrite     = connection_data[:profiles_to_rewrite]
    profiles_to_destroy     = connection_data[:profiles_to_destroy]
    current_user_id         = connection_data[:current_user_id]
    user_id                 = connection_data[:user_id]
    # connection_id           = connection_data[:connection_id]
    # puts "In connection_in_tables"

    # [1 2] c [3]
    # @profiles_to_rewrite: [14, 21, 19, 11, 20, 12, 13, 18]
    # @profiles_to_destroy: [22, 29, 27, 25, 28, 23, 24, 26]
    # init_connection_hash = {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26}
    ###################################################################
    ######## Собственно Центральный метод соединения деревьев = перезапись профилей в таблицах
      connect_trees(connection_data)
    ####################################################################
    ######## Заполнение таблицы ConnectedUser - записью о том, что деревья с current_user_id и user_id - соединились
      ConnectedUser.set_users_connection(connection_data) # здесь сохраняются массивы профилей
    ##################################################################
    ## Update connection requests - to yes connect
      ConnectionRequest.request_connection(connection_data)
      ConnectionRequest.connected_requests_update(current_user_id)
    ##################################################################
    ##########  UPDATES FEEDS - № 2  ############## В обоих направлениях: Кто с Кем и Обратно
    profile_current_user = User.find(current_user_id).profile_id   #
    profile_user_id = User.find(user_id).profile_id  #
    UpdatesFeed.create(user_id: current_user_id, update_id: 2, agent_user_id: user_id, agent_profile_id: profile_user_id, read: false)
    UpdatesFeed.create(user_id: user_id, update_id: 2, agent_user_id: current_user_id, agent_profile_id: profile_current_user, read: false)

    ######## Перезапись profile_id при объединении деревьев
    UpdatesFeed.connect_update_profiles(profiles_to_rewrite, profiles_to_destroy)
    ##################################################################

    ######## Перезапись profile_data при объединении деревьев
       # ProfileData.connect!(profiles_to_rewrite, profiles_to_destroy)
    ##################################################################

  end


  # @note: Перезапись профилей в таблицах
  # @param connection_data
  def connect_trees(connection_data)

    # profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    # profiles_to_destroy = connection_data[:profiles_to_destroy]
    # who_connect         = connection_data[:who_connect_arr]
    # with_whom_connect   = connection_data[:with_whom_connect_arr]
    # current_user_id     = connection_data[:current_user_id]
    # user_id             = connection_data[:user_id]
    # connection_id       = connection_data[:connection_id]

    # todo: Сделать логирование перезаписи Profile_datas - или см. в файле SimilarsProfileMerge.rb строки 28 ?
    # Перезапись profile_data при объединении профилей
    #  ProfileData.connect!(profiles_to_rewrite, profiles_to_destroy)

    #####################################################
    # todo: Раскоммитить 1 строки ниже и закоммитить 1 строки за ними  - для полной перезаписи логов и отладки
   log_connection_user_profile = Profile.merge(connection_data)
    # log_connection_user_profile = []
    #####################################################
    # todo: Раскоммитить 2 строки ниже и закоммитить 2 строки за ними  - для полной перезаписи логов и отладки
   log_connection_tree       = update_table_connection(connection_data, Tree, ConnectionLog)
   log_connection_profilekey = update_table_connection(connection_data, ProfileKey, ConnectionLog)
    #####################################################
    # log_connection_tree = []
    # log_connection_profilekey = []

    connection_log = { log_user_profile: log_connection_user_profile,
                       log_tree: log_connection_tree,
                       log_profilekey: log_connection_profilekey }
    complete_connection_log_arr = connection_log[:log_user_profile] + connection_log[:log_tree] +
                                  connection_log[:log_profilekey]
    # Запись массива лога в таблицу ConnectionLog
    ConnectionLog.store_log(complete_connection_log_arr) unless complete_connection_log_arr.blank?
    # Запись строки Общего лога в таблицу CommonLog
    make_connection_common_log(connection_data)

  end

  # перезапись значений в полях одной таблицы
  def update_table_connection(connection_data, table, log_table )
    # name_of_table = table.table_name
    # logger.info "*** In update_table: name_of_table = #{name_of_table.inspect} "
    # model = name_of_table.classify.constantize
    # logger.info "*** In update_table: model = #{model.inspect} "
    # logger.info "*** In update_table: table = #{table.inspect} "

    log_connection = []
    connection_data[:table_name] = table.table_name #
    logger.info "IN connect_trees update_table: connection_data[:table_name] = #{connection_data[:table_name]}" # DEBUGG_TO

    ['profile_id', 'is_profile_id'].each do |table_field|
      table_update_data = { table: table, table_field: table_field, log_table: log_table}
      log_connection = update_field_connection(connection_data, table_update_data, log_connection)
    end
    log_connection
  end


  # Делаем общий массив юзеров, для update_field в таблицах
  def users_connecting_scope(who_connect, with_whom_connect)
    who_connect + with_whom_connect
  end

  # перезапись значений в одном поле одной таблицы
  # profiles_to_destroy[arr_ind] - один profile_id для замены
  # profiles_to_rewrite[arr_ind] - один profile_id, которым меняем
  def update_field_connection(connection_data, table_update_data, log_connection)

    who_connect         = connection_data[:who_connect_arr]
    with_whom_connect   = connection_data[:with_whom_connect_arr]
    table_name          = connection_data[:table_name]
    current_user_id     = connection_data[:current_user_id]
    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]
    user_id             = connection_data[:user_id]
    connection_id       = connection_data[:connection_id]

    table       = table_update_data[:table]
    table_field = table_update_data[:table_field]
    log_table   = table_update_data[:log_table]

    all_users_to_connect = users_connecting_scope(who_connect, with_whom_connect)

    for arr_ind in 0 .. profiles_to_destroy.length-1 # ищем этот profile_id для его замены
      rows_to_update = table.where(:user_id => all_users_to_connect)
                           .where(" #{table_field} = #{profiles_to_destroy[arr_ind]} " )
      unless rows_to_update.blank?
        rows_to_update.each do |rewrite_row|

     # todo:Раскоммитить 1 строкy ниже  - для полной перезаписи данных в таблицах и логов
   rewrite_row.update_attributes(:"#{table_field}" => profiles_to_rewrite[arr_ind], :updated_at => Time.now)
      #####################################################

          # logger.info "IN connect_trees update_field: rewrite_row.id = #{rewrite_row.id},
          #                  rewrite_row.profile_id = #{rewrite_row.profile_id},
          #                rewrite_row.is_profile_id = #{rewrite_row.is_profile_id},
          #                  profiles_to_rewrite[arr_ind] = #{profiles_to_rewrite[arr_ind]} "

          one_connection_data = { connected_at: connection_id,                # int
                                  current_user_id: current_user_id,           # int
                                  with_user_id: user_id,                      # int
                                  table_name: table_name,                     # string
                                  table_row: rewrite_row.id,                  # int
                                  field: table_field,                         # string
                                  written: profiles_to_rewrite[arr_ind],      # int
                                  overwritten: profiles_to_destroy[arr_ind] } # int
          log_connection << log_table.new(one_connection_data)

        end

      end

    end
    log_connection

  end


  # @note: Сделать 1 запись в общие логи: в Common_logs
  def make_connection_common_log(connection_data)
    # logger.info "In add_new_profile: Before create_add_log"
    current_log_type          = 4  # connection trees: rollback == disconnect trees. Тип = разъединение деревьев при rollback
    current_user_id           = connection_data[:current_user_id]
    user_id                   = connection_data[:user_id]
    common_connect_log_number = connection_data[:connection_id] # Берем тот номер соединения деревьев,
    # который идет из Conn_requests - номер запроса на соединение деревьев. Он - единый и не является порядковым, как
    # номера логов на добавление и удаление профилей, номера которыхформируются прямо в табл. CommonLogs.

    # new_common_log_number = CommonLog.new_log_id(current_user_id, current_log_type) # No use

    common_log_data = { user_id:         current_user_id,
                        log_type:        current_log_type,
                        log_id:          common_connect_log_number,
                        profile_id:      User.find(current_user_id).profile_id,
                        base_profile_id: User.find(user_id).profile_id, # после объединения деревьев: профиль может
                        # отличаться от того, кот. был до объединения
                        new_relation_id: 999 }  # Условный код для лога объединения деревьев
    CommonLog.create_common_log(common_log_data)
  end



  # @note: Контроль корректности массивов перед объединением
  #    # Tested
  # @param: connection_data = {:who_connect=>[1, 2], :with_whom_connect=>[3],
  #   :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18], :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
  #   :current_user_id=>1, :user_id=>3, :connection_id=>3}
  # def check_connection_arrs_old(connection_data )
  #   profiles_to_rewrite = connection_data[:profiles_to_rewrite]
  #   profiles_to_destroy = connection_data[:profiles_to_destroy]
  #
  #   stop_by_arrs = false
  #   logger.info "== In check_connection_arrs:  connection_data = #{connection_data}"
  #   commons = check_commons(profiles_to_rewrite, profiles_to_destroy)
  #
  #   ######## Контроль корректности массивов перед объединением
  #   if !profiles_to_rewrite.blank? && !profiles_to_destroy.blank?   # 1
  #     logger.info "Ok to connect. Array(s) - Dont blank."
  #
  #     # Проверка на наличие общих (совпадающих) эл-тов у массивов перезаписи
  #     # commons = check_commons(profiles_to_rewrite, profiles_to_destroy)
  #     logger.info "== In check_uniqness:  commons = #{commons}"
  #     if commons.blank?  # Нет пересечения commons=[]- общих профилей - Ок   # 2
  #
  #       if profiles_to_rewrite.size == profiles_to_destroy.size    # 3
  #         # logger.info "Ok to connect. Connection array(s) - Equal. Size = #{profiles_to_rewrite.size}."
  #
  #         # Проверка найденных массивов перезаписи перед объединением - на повторы
  #         complete_dubles_hash = check_duplications(profiles_to_rewrite, profiles_to_destroy)
  #
  #         if complete_dubles_hash.empty? # Если НЕТ дублирования в массивах   # 5
  #           connection_message = "Данные для объединения деревьев - корректны. "  # Tested
  #           # logger.info "Ok to connect. НЕТ Дублирований in Connection array(s).
  #           #             complete_dubles_hash = #{complete_dubles_hash};  connection_message = #{connection_message};"
  #         else    # 4
  #           connection_message =
  #               "Нельзя объединить ваши деревья, т.к. данные для объединения - некорректны! ЕСТЬ дублирования в массивах"  # Tested
  #           # logger.info "ERROR: STOP connection! ЕСТЬ дублирования в массивах:
  #           #              complete_dubles_hash = #{complete_dubles_hash};  connection_message = #{connection_message};"
  #           stop_by_arrs = true #
  #         end
  #
  #       else
  #         connection_message = "Объединение остановлено, т.к. массив(ы) объединения - имеют разный размер"  # Tested
  #         # logger.info "ERROR: STOP connection! Array(s) - NOT Equal! connection_message = #{connection_message} "
  #         stop_by_arrs = true
  #       end
  #
  #     else
  #       connection_message = "Объединение остановлено. В массивах объединения - есть общие (совпадающие) профили!" # Tested
  #       # logger.info "ERROR: В массивах объединения - есть общие профили! connection_message = #{connection_message};."
  #       stop_by_arrs = true
  #     end
  #
  #   else
  #     connection_message = "Объединение остановлено, т.к. массив(ы) объединения - пустые" # Tested
  #     # logger.info "ERROR: Connection array(s) - blank! connection_message = #{connection_message};."
  #     stop_by_arrs = true
  #   end
  #
  #   @complete_dubles_hash = complete_dubles_hash  # DEBUGG_TO_VIEW
  #   # logger.info "== After in check_connection_arrs:  stop_by_arrs = #{stop_by_arrs}, connection_message = #{connection_message} "
  #
  #   { stop_by_arrs: stop_by_arrs,
  #     diag_connection_message: connection_message,
  #     common_profiles: commons,
  #     complete_dubles_hash: complete_dubles_hash
  #   }
  #
  # end



  # @note: Контроль корректности массивов перед объединением
  #    # Tested
  # @param: connection_data = {:who_connect=>[1, 2], :with_whom_connect=>[3],
  #   :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18], :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
  #   :current_user_id=>1, :user_id=>3, :connection_id=>3}
  def check_connection_arrs(connection_data )
    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]

    # Корректные значения - для корректных массивов
    stop_by_arrs = false
    item = 5                  # Параметр для выбора корректного сообщения
    commons = []              # Исходное значение общих (совпадающих) эл-тов у массивов перезаписи перед проверкой
    complete_dubles_hash = {} # Исходное значение Хаша дубликатов перед проверкой

    # Если массивы - пустые
    if profiles_to_rewrite.blank? or profiles_to_destroy.blank?   # 1
      stop_by_arrs = true
      item = 1
    end

    if item == 5  # До этой проверки все было Ок с массивами
      commons = check_commons(profiles_to_rewrite, profiles_to_destroy)
      # Проверка на наличие общих (совпадающих) эл-тов у массивов перезаписи
      unless commons.blank?  # ЕСТЬ пересечения общих профилей - commons != []  # 2
        stop_by_arrs = true
        item = 2
      end
    end

    if item == 5  # До этой проверки все было Ок с массивами
      # Проверка найденных массивов перезаписи перед объединением - на повторы
      if profiles_to_rewrite.size == profiles_to_destroy.size    # 3
        complete_dubles_hash = check_duplications(profiles_to_rewrite, profiles_to_destroy)
      else
        stop_by_arrs = true
        item = 3
      end
    end

    if item == 5  # До этой проверки все было Ок с массивами
      # Проверка хэша дублей: Если ЕСТЬ дублирования в массивах   # 5
      unless complete_dubles_hash.empty?
        stop_by_arrs = true #
        item = 4
      end
    end

    connection_message = diagnoze_message(item)

    { stop_by_arrs:            stop_by_arrs,
      diag_connection_message: connection_message,
      common_profiles:         commons,
      complete_dubles_hash:    complete_dubles_hash  }

  end

  # @note:  Выбор соответствующего диагностического сообщения по результатам проверки
  #   массивов перезаписи перед объединением деревьев.
  def diagnoze_message(item)
    case item
      when 1
        connection_message = "Объединение остановлено, т.к. массив(ы) объединения - пустые" # Tested
      when 2
        connection_message = "Объединение остановлено. В массивах объединения - есть общие (совпадающие) профили!" # Tested
      when 3
        connection_message = "Объединение остановлено, т.к. массив(ы) объединения - имеют разный размер"  # Tested
      when 4
        connection_message =
            "Нельзя объединить ваши деревья, т.к. данные для объединения - некорректны! ЕСТЬ дублирования в массивах"  # Tested
      when 5
        connection_message = "Данные для объединения деревьев - корректны. "  # Tested
      else
        connection_message = "Внимание: Диагноз массивов объединения деревьев - не был поставлен"  # Tested
    end
    connection_message
  end


  # todo: refactor?
  # ИСПОЛЬЗУЕТСЯ В МЕТОДЕ ОБЪЕДИНЕНИЯ ДЕРЕВЬЕВ - connection_of_trees
  # Проверка найденных массивов перезаписи при объединении - на повторы
  def check_duplications(profiles_to_rewrite, profiles_to_destroy)

    # Извлечение из массива - повторяющиеся эл-ты в виде массива
    def repeated(array)
      counts = Hash.new(0)
      array.each{|val|counts[val]+=1}
      counts.reject{|val,count|count==1}.keys
    end

    repeated_destroy = repeated(profiles_to_destroy)
    indexs_hash_destroy = {}
    unless repeated_destroy.blank?
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

    # @complete_dubles_hash = complete_dubles_hash # DEBUGG_TO_VIEW

    # complete_dubles_hash = {11=>[25, 26]}  # for DEBUGG ONLY!!!

    complete_dubles_hash

  end

  # Проверка на наличие общих (совпадающих) эл-тов у массивов перезаписи
  # Что - не должно быть!.
  def check_commons(array1, array2)
    # logger.info "== In check_uniqness:  array1 = #{array1}"
    # logger.info "== In check_uniqness:  array2 = #{array2}"
    array1 & array2
  end




end # End of ConnectionTrees module
