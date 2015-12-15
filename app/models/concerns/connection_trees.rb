module ConnectionTrees
  extend ActiveSupport::Concern
  # in User model

  # require 'pry'


  # @note: Стартовый метод объединения деревьев
  def connection(user_id, connection_id)
    User.transaction do
    logger.info "=== IN connection: user_id = #{user_id}, connection_id = #{connection_id}"

    who_connect_users_arr = self.get_connected_users
    connection_results = {}

    # Проверка 1 - уже объединены
    connection_message = "Проверка 1 Нельзя объединить ваши деревья, т.к. есть информация, что они уже объединены!"
    # Проверка: может быть дерево автора уже было соединено с выбранным юзером?
    if who_connect_users_arr.include?(user_id.to_i) # check IF NOT CONNECTED
      logger.info "=== IN check_connection_switch: уже объединены"
      connection_results[:stop_connection] = true # STOP connection
      connection_results[:connection_message] = connection_message #
      connection_results[:diag_connection_item] = 11
          return connection_results
    end

    beg_search_time = Time.now   # Начало отсечки времени поиска

    ##### Запуск стартового ДОСТОВЕРНОГО поиска с certain_koeff_for_connect из Weafam_Settings
    with_whom_connect_users_arr = User.find(user_id).get_connected_users  #
    certain_koeff = WeafamSetting.first.certain_koeff
    search_results = self.start_search(certain_koeff)
    # get_certain_koeff=4 - значение из Settings

    logger.info "@@@@@@ Search Results: search_results = #{search_results} "
    # # [inf] @@@@@@ Search Results: search_results
    # {:connected_author_arr=>[16], :qty_of_tree_profiles=>9,
    #  :profiles_relations_arr=>[{:profile_searched=>347, :profile_relations=>{341=>4, 348=>8, 340=>18, 342=>112, 339=>112}}, {:profile_searched=>341, :profile_relations=>{347=>1, 348=>2, 342=>3, 339=>3, 340=>7, 345=>13, 346=>14, 344=>17, 343=>111}}, {:profile_searched=>342, :profile_relations=>{340=>1, 341=>2, 339=>5, 345=>91, 347=>92, 346=>101, 348=>102, 343=>211}}, {:profile_searched=>343, :profile_relations=>{339=>1, 344=>2, 340=>91, 341=>101, 342=>191}}, {:profile_searched=>348, :profile_relations=>{341=>4, 347=>7, 340=>18, 342=>112, 339=>112}}, {:profile_searched=>340, :profile_relations=>{345=>1, 346=>2, 342=>3, 339=>3, 341=>8, 347=>15, 348=>16, 344=>17, 343=>111}},
    #                            {:profile_searched=>344, :profile_relations=>{343=>3, 339=>7, 340=>13, 341=>14}}, {:profile_searched=>345, :profile_relations=>{340=>3, 346=>8, 341=>17, 342=>111, 339=>111}}, {:profile_searched=>346, :profile_relations=>{340=>3, 345=>7, 341=>17, 342=>111, 339=>111}}], :profiles_found_arr=>[{347=>{17=>{357=>[4, 8, 18, 112, 112]}}}, {341=>{17=>{351=>[1, 2, 3, 3, 7, 13, 14]}}}, {342=>{17=>{349=>[1, 2, 5, 91, 92, 101, 102]}}}, {343=>{}}, {348=>{17=>{358=>[4, 7, 18, 112, 112]}}}, {340=>{17=>{350=>[1, 2, 3, 3, 8, 15, 16]}}}, {344=>{}}, {345=>{17=>{355=>[3, 8, 17, 111, 111]}}}, {346=>{17=>{356=>[3, 7, 17, 111, 111]}}}],
    #  :uniq_profiles_pairs=>{347=>{17=>357}, 341=>{17=>351}, 342=>{17=>349}, 348=>{17=>358}, 340=>{17=>350}, 345=>{17=>355}, 346=>{17=>356}},
    #  :profiles_with_match_hash=>{350=>7, 349=>7, 351=>7, 356=>5, 355=>5, 358=>5, 357=>5},
    #  :by_profiles=>[{:search_profile_id=>340, :found_tree_id=>17, :found_profile_id=>350, :count=>7},
    #                 {:search_profile_id=>342, :found_tree_id=>17, :found_profile_id=>349, :count=>7},
    #                 {:search_profile_id=>341, :found_tree_id=>17, :found_profile_id=>351, :count=>7},
    #                 {:search_profile_id=>346, :found_tree_id=>17, :found_profile_id=>356, :count=>5},
    #                 {:search_profile_id=>345, :found_tree_id=>17, :found_profile_id=>355, :count=>5},
    #                 {:search_profile_id=>348, :found_tree_id=>17, :found_profile_id=>358, :count=>5},
    #                 {:search_profile_id=>347, :found_tree_id=>17, :found_profile_id=>357, :count=>5}],
    #  :by_trees=>[{:found_tree_id=>17, :found_profile_ids=>[357, 351, 349, 358, 350, 355, 356]}],
    #  :duplicates_one_to_many=>{3=>[2, 4]}, :duplicates_many_to_one=>{}}


    ######## Сбор рез-тов поиска:
    uniq_profiles_pairs = search_results[:uniq_profiles_pairs]
    duplicates_one_to_many = search_results[:duplicates_one_to_many]
    duplicates_many_to_one = search_results[:duplicates_many_to_one]

    logger.info "In connection_of_trees, After start_search: duplicates_one_to_many = #{duplicates_one_to_many},
                 duplicates_many_to_one = #{duplicates_many_to_one} "

    stop_connection = false  # for controle & to return, to view

    # Проверка 2 - Контроль на наличие дубликатов из поиска:
    # Если есть дубликаты из Поиска, то устанавливаем stop_connection = true
    # На вьюхе проверяем: продолжать ли объединение.
    # Чтобы протестировать check_connection_permit: в модуле search.rb, после запуска метода
    # search_profiles_from_tree - раскомментить одну или обе строки с # for DEBUGG ONLY!!!
    connection_message = "Проверка 2 Нельзя объединить ваши деревья, т.к. в результатах поиска есть дубликаты!"
    if (!duplicates_one_to_many.empty? || !duplicates_many_to_one.empty?)
      logger.info "=== IN check_connection_switch: ЕСТЬ дубликаты!!"
      connection_results[:stop_connection] = true # STOP connection
      connection_results[:connection_message] = connection_message #
      connection_results[:diag_connection_item] = 22
      connection_results[:duplicates_one_to_many] = duplicates_one_to_many #
      connection_results[:duplicates_many_to_one] = duplicates_many_to_one #

      return connection_results
    end

    ##############################################################################
    ##### запуск ПОЛНОГО метода поиска от дерева Автора
    ##### на основе исходного массива ДОСТОВЕРНЫХ ПАР ПРОФИЛЕЙ - uniq_profiles_pairs -> init_connection_hash
    ##### ПОЛНОЕ Определение массивов профилей для перезаписи: profiles_to_rewrite, profiles_to_destroy
    complete_search_data = { with_whom_connect: with_whom_connect_users_arr,
                             uniq_profiles_pairs: uniq_profiles_pairs,
                             certain_koeff: certain_koeff}
    final_connection_hash = self.complete_search(complete_search_data)
    ##############################################################################
    profiles_to_rewrite = final_connection_hash.keys
    profiles_to_destroy = final_connection_hash.values

    logger.info "AFTER complete_search:"
    logger.info "ALL profiles_to_rewrite = #{profiles_to_rewrite} "
    logger.info "ALL profiles_to_destroy = #{profiles_to_destroy} "

    end_search_time = Time.now   # Конец отсечки времени поиска
    elapsed_search_time = (end_search_time - beg_search_time).round(5)
    # Длительность полного поиска - для инфы
    # profiles_to_rewrite = [ 443, 441,445, 450, 442, 444, 448 ]
    # profiles_to_destroy = [ 677, 675,681, 679, 676, 680, 678 ]
    connection_results = {
        who_connect_arr:          who_connect_users_arr, #
        with_whom_connect_arr:    with_whom_connect_users_arr, #
        uniq_profiles_pairs:      uniq_profiles_pairs, #
        duplicates_one_to_many:   duplicates_one_to_many, #
        duplicates_many_to_one:   duplicates_many_to_one, #
        profiles_to_rewrite:      profiles_to_rewrite, #
        profiles_to_destroy:      profiles_to_destroy, #
        current_user_id:          self.id, #
        user_id:                  user_id ,#
        connection_id:            connection_id, #
        search_time:              elapsed_search_time #
    }
    logger.info "Before check_connection_arrs: connection_results = #{connection_results}"

    # binding.pry          # Execution will stop here.

    ######## Контроль корректности массивов перед объединением
    check_connection_result = self.check_connection_arrs(connection_results)
    stop_by_arrs          = check_connection_result[:stop_by_arrs]
    diag_connection_item  = check_connection_result[:diag_item]
    connection_message    = check_connection_result[:diag_connection_message]
    common_profiles       = check_connection_result[:common_profiles]
    complete_dubles_hash  = check_connection_result[:complete_dubles_hash]

    connection_results[:connection_message]   = connection_message #
    connection_results[:diag_connection_item] = diag_connection_item #

    # Проверка 3 - некорректные массивы профилей для объединения
    # Чтобы протестировать check_connection_permit: в модуле connection_trees.rb, в конце метода
    # check_duplications - раскомментить одну строку с complete_dubles_hash = {11=>[25, 26]} # for DEBUGG ONLY!!!
    if stop_by_arrs
      logger.info "=== Проверка 3: дублирования в массивах Или попытка объединить Юзеров"
      logger.info " stop_by_arrs = #{stop_by_arrs}, connection_message = #{connection_message} "

      connection_results[:stop_connection] = true # STOP connection
      connection_results[:common_profiles] = common_profiles #
      connection_results[:complete_dubles_hash] = complete_dubles_hash #

      # connection_results = TEST!!!
      #     {:who_connect_arr=>[16], :with_whom_connect_arr=>[17],
      #      :uniq_profiles_pairs=>{347=>{17=>357}, 341=>{17=>351}, 342=>{17=>349}, 348=>{17=>358}, 340=>{17=>350}, 345=>{17=>355}, 346=>{17=>356}},
      #      :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{},
      #      :profiles_to_rewrite=>[347, 341, 342, 348, 340, 345, 346, 339],
      #      :profiles_to_destroy=>[357, 351, 349, 358, 350, 355, 356, 352],
      #      :current_user_id=>16, :user_id=>17, :connection_id=>5, :search_time=>0.77329, :connection_message=>"Нельзя объединить ваши деревья, т.к. данные для объединения - некорректны! ЕСТЬ дублирования в массивах",
      #      :stop_connection=>true, :common_profiles=>[], :complete_dubles_hash=>{11=>[25, 26]}}

      return connection_results
    end

    #  Если все предыдущие проверки пройдены, то - запуск объединения в таблицах
    unless stop_connection || stop_by_arrs # for stop_connection & view
      logger.info "Для объединения - все корректно!, stop_connection = #{stop_connection},\n connection_message = #{connection_message}"

      # binding.pry          # Execution will stop here.

      ##### Центральный метод соединения деревьев = перезапись и удаление профилей в таблицах
      self.connection_in_tables(connection_results)
      ##################################################################
    end
    logger.info "stop_connection = #{stop_connection},
            \n diag_connection_item = #{diag_connection_item}, connection_message = #{connection_message}"
    connection_results[:stop_connection] = stop_connection #

    connection_results
    end
  end


  # @note: основной метод объединения деревьев
  #   Центральный метод соединения деревьев = перезапись профилей в таблицах
  #   Заполнение таблицы Connected_Trees - записью о том, что деревья с current_user_id и user_id - соединились
  #  connection_data = {:who_connect=>[1, 2], :with_whom_connect=>[3],
  # :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18], :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
  # :current_user_id=>1, :user_id=>3, :connection_id=>3}
  def connection_in_tables(connection_data)

    who_connect_arr         = connection_data[:who_connect_arr]
    with_whom_connect_arr   = connection_data[:with_whom_connect_arr]
    profiles_to_rewrite     = connection_data[:profiles_to_rewrite]
    profiles_to_destroy     = connection_data[:profiles_to_destroy]
    current_user_id         = connection_data[:current_user_id]
    user_id                 = connection_data[:user_id]
    connection_id           = connection_data[:connection_id]

    ###################################################################
    ######## Собственно Центральный метод соединения деревьев = перезапись профилей в таблицах
      connect_trees(connection_data)
    ####################################################################
    ######## Заполнение таблицы ConnectedUser - записью о том, что деревья с current_user_id и user_id - соединились
      ConnectedUser.set_users_connection(connection_data) # здесь сохраняются массивы профилей
    ##################################################################
      # self.update_connected_users!

    ## Update connection requests - to yes connect
      ConnectionRequest.request_connection(connection_data)
      ConnectionRequest.connected_requests_update(current_user_id)
    ##################################################################
    logger.info "In connection_in_tables: current_user_id = #{current_user_id}"
    # Удаление SearchResults, относящихся к проведенному объединению между двумя деревьями
    # SearchResults.destroy_previous_results(who_connect_arr, with_whom_connect_arr)
    # SearchResults.destroy_previous_results(current_user_id)
    SearchResults.clear_all_prev_results(current_user_id)


    # sims & search
    # puts "In Rails Concern: After creation_profile: start_search_methods "
    # SearchResults.start_search_methods(self)


    ##########  UPDATES FEEDS - № 2  ############## В обоих направлениях: Кто с Кем и Обратно
    profile_current_user = User.find(current_user_id).profile_id   #
    profile_user_id = User.find(user_id).profile_id  #
    UpdatesFeed.create(user_id: current_user_id, update_id: 2,
                       agent_user_id: user_id, agent_profile_id: profile_user_id,
                       who_made_event: current_user_id,
                       read: false)
    UpdatesFeed.create(user_id: user_id,
                       update_id: 2, agent_user_id: current_user_id,
                       agent_profile_id: profile_current_user,
                       who_made_event: current_user_id,
                       read: false)

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

    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]
    # who_connect         = connection_data[:who_connect_arr]
    # with_whom_connect   = connection_data[:with_whom_connect_arr]
    # current_user_id     = connection_data[:current_user_id]
    # user_id             = connection_data[:user_id]
    # connection_id       = connection_data[:connection_id]

    # Перезапись profile_data при объединении профилей
    ProfileData.connect_profiles_data(profiles_to_rewrite, profiles_to_destroy)

    #####################################################
    # todo: Раскоммитить 1 строки ниже и закоммитить 1 строки за ними  - для полной перезаписи логов и отладки
    log_connection_user_profile = Profile.merge(connection_data)
    # log_connection_user_profile = []
    #####################################################

    # todo: Раскоммитить 1 строки ниже и закоммитить 1 строки за ними  - для полной перезаписи логов и отладки
    log_connection_profiles_del = logs_profiles_deleted(connection_data, Profile, ConnectionLog)
    # log_connection_profiles_del = []
    #####################################################



    # todo: Раскоммитить 2 строки ниже и закоммитить 2 строки за ними  - для полной перезаписи логов и отладки
   log_connection_tree       = update_table_connection(connection_data, Tree, ConnectionLog)
   log_connection_profilekey = update_table_connection(connection_data, ProfileKey, ConnectionLog)
    #####################################################
    # log_connection_tree = []
    # log_connection_profilekey = []

    connection_log = { log_profiles_del: log_connection_profiles_del,
                       log_user_profile: log_connection_user_profile,
                       log_tree: log_connection_tree,
                       log_profilekey: log_connection_profilekey }
    complete_connection_log_arr = connection_log[:log_profiles_del] + connection_log[:log_user_profile] +
                                  connection_log[:log_tree] + connection_log[:log_profilekey]
    # logger.info "IN logs_profiles_deleted: complete_connection_log_arr = #{complete_connection_log_arr}"

    # Запись массива лога в таблицу ConnectionLog
    ConnectionLog.store_log(complete_connection_log_arr) unless complete_connection_log_arr.blank?
    # Запись строки Общего лога в таблицу CommonLog
    make_connection_common_log(connection_data)

  end

  # @note генерация логов для "удаляемых" профилей
  def logs_profiles_deleted(connection_data, table, log_table )

    connection_data[:table_name] = table.table_name #

    # who_connect         = connection_data[:who_connect_arr]
    # with_whom_connect   = connection_data[:with_whom_connect_arr]
    table_name          = connection_data[:table_name]
    current_user_id     = connection_data[:current_user_id]
    # profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]
    user_id             = connection_data[:user_id]
    connection_id       = connection_data[:connection_id]
    # logger.info "IN logs_profiles_deleted: table = #{table}, table.table_name = #{table.table_name}"

    log_profiles_del = []
    profiles_to_destroy.each do |one_profile|
      opposite_profile = Profile.find(one_profile)
      # Mark opposite profiles as deleted
      opposite_profile.update_attributes(:deleted => 1, :updated_at => Time.now)

      one_connection_data = { connected_at: connection_id,                # int
                              current_user_id: current_user_id,           # int
                              with_user_id: user_id,                      # int
                              table_name: table_name,                     # string
                              table_row: opposite_profile.id,             # int
                              field: 'deleted',                           # string
                              written: 1,                         # int
                              overwritten: 0 }                    # int
      # logger.info "IN logs_profiles_deleted: one_connection_data = #{one_connection_data}"
      log_profiles_del << log_table.new(one_connection_data)
      # logger.info "IN logs_profiles_deleted: log_profiles_del = #{log_profiles_del}"

    end
    log_profiles_del
  end


  # перезапись значений в полях одной таблицы
  # Good to Know:
  # name_of_table = table.table_name
  # logger.info "*** In update_table: name_of_table = #{name_of_table.inspect} "
  # model = name_of_table.classify.constantize
  # logger.info "*** In update_table: model = #{model.inspect} "
  # logger.info "*** In update_table: table = #{table.inspect} "
  def update_table_connection(connection_data, table, log_table )

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

    # prof_to_store = []  # Если учитывать, какой профиль старее, моложе

    for arr_ind in 0 .. profiles_to_destroy.length-1 # ищем этот profile_id для его замены
      rows_to_update = table.where(:user_id => all_users_to_connect)
                           .where(" #{table_field} = #{profiles_to_destroy[arr_ind]} " )
      unless rows_to_update.blank?
        rows_to_update.each do |rewrite_row|

          # Если учитывать, какой профиль старее, моложе
          # if profiles_to_rewrite[arr_ind] > profiles_to_destroy[arr_ind]
          #   profile_to_store = profiles_to_rewrite[arr_ind]
          # else
          #   profile_to_store = profiles_to_destroy[arr_ind]
          # end
          # prof_to_store << profile_to_store

     # todo:Раскоммитить 1 строкy ниже  - для полной перезаписи данных в таблицах и логов
   rewrite_row.update_attributes(:"#{table_field}" => profiles_to_rewrite[arr_ind], :updated_at => Time.now)

   # Если учитывать, какой профиль старее, моложе
   # rewrite_row.update_attributes(:"#{table_field}" => profile_to_store, :updated_at => Time.now)
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

    # Если учитывать, какой профиль старее, моложе
    # prof_to_store = #{prof_to_store} "

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
    # номера логов на добавление и удаление профилей, номера которых формируются прямо в табл. CommonLogs.

    common_log_data = { user_id:         current_user_id,
                        log_type:        current_log_type,
                        log_id:          common_connect_log_number,
                        profile_id:      User.find(current_user_id).profile_id,
                        base_profile_id: User.find(user_id).profile_id, # после объединения деревьев: профиль может
                        # отличаться от того, кот. был до объединения
                        new_relation_id: 999 }  # Условный код для лога объединения деревьев
    CommonLog.create_common_log(common_log_data)
  end

   # results =
      {:connected_author_arr=>[49], :qty_of_tree_profiles=>7,
       :profiles_relations_arr=>[
           {:profile_searched=>682, :profile_relations=>{683=>1, 684=>2, 687=>3, 685=>5, 686=>6, 688=>8}},
           {:profile_searched=>683, :profile_relations=>{682=>3, 685=>3, 686=>4, 684=>8, 688=>17, 687=>111}},
           {:profile_searched=>685, :profile_relations=>{683=>1, 684=>2, 682=>5, 686=>6, 687=>211}},
           {:profile_searched=>687, :profile_relations=>{682=>1, 688=>2, 683=>91, 684=>101, 685=>191, 686=>201}},
           {:profile_searched=>688, :profile_relations=>{687=>3, 682=>7, 683=>13, 684=>14}},
           {:profile_searched=>684, :profile_relations=>{682=>3, 685=>3, 686=>4, 683=>7, 688=>17, 687=>111}},
           {:profile_searched=>686, :profile_relations=>{683=>1, 684=>2, 682=>5, 685=>5, 687=>211}}],
       :profiles_found_arr=>[
           {682=>{24=>{448=>[1, 1, 2, 6]}, 48=>{678=>[1, 2, 6]}}},
           {683=>{24=>{442=>[3, 3, 3, 3, 4, 4, 8, 8, 17, 17, 111, 111]}, 48=>{676=>[3, 3, 4, 8, 17, 111]}}},
           {685=>{24=>{448=>[1, 1, 2, 6, 211]}, 48=>{678=>[1, 2, 6, 211]}}},
           {687=>{24=>{444=>[2, 91, 91, 101, 191, 201]}, 48=>{680=>[2, 91, 101, 191, 201]}}},
           {688=>{24=>{445=>[3, 13, 13, 14]}, 48=>{681=>[3, 13, 14]}}},
           {684=>{24=>{443=>[3, 3, 4, 7, 7, 17, 111]}, 48=>{677=>[3, 3, 4, 7, 17, 111]}}},
           {686=>{24=>{450=>[1, 1, 2, 5, 5, 211]}, 48=>{679=>[1, 2, 5, 5, 211]}}}],
       :uniq_profiles_pairs=>{683=>{24=>442, 48=>676}, 685=>{48=>678}, 687=>{24=>444, 48=>680}, 688=>{24=>445}, 684=>{24=>443, 48=>677}, 686=>{24=>450, 48=>679}},
       :profiles_with_match_hash=>{442=>12, 443=>7, 450=>6, 677=>6, 444=>6, 676=>6, 679=>5, 680=>5, 448=>5, 445=>4, 678=>4},
       :by_profiles=>[
           {:search_profile_id=>683, :found_tree_id=>24, :found_profile_id=>442, :count=>12},
           {:search_profile_id=>684, :found_tree_id=>24, :found_profile_id=>443, :count=>7},
           {:search_profile_id=>686, :found_tree_id=>24, :found_profile_id=>450, :count=>6},
           {:search_profile_id=>684, :found_tree_id=>48, :found_profile_id=>677, :count=>6},
           {:search_profile_id=>687, :found_tree_id=>24, :found_profile_id=>444, :count=>6},
           {:search_profile_id=>683, :found_tree_id=>48, :found_profile_id=>676, :count=>6},
           {:search_profile_id=>686, :found_tree_id=>48, :found_profile_id=>679, :count=>5},
           {:search_profile_id=>687, :found_tree_id=>48, :found_profile_id=>680, :count=>5},
           {:search_profile_id=>688, :found_tree_id=>24, :found_profile_id=>445, :count=>4},
           {:search_profile_id=>685, :found_tree_id=>48, :found_profile_id=>678, :count=>4}],
       :by_trees=>[
           {:found_tree_id=>24, :found_profile_ids=>[442, 444, 445, 443, 450]},
           {:found_tree_id=>48, :found_profile_ids=>[676, 678, 680, 677, 679]}],
       :duplicates_one_to_many=>{},
       :duplicates_many_to_one=>{685=>{24=>448}, 682=>{24=>448}}}


   #  results =
      {:connected_author_arr=>[24], :qty_of_tree_profiles=>7,
       :profiles_relations_arr=>[
           {:profile_searched=>441, :profile_relations=>{442=>1, 443=>2, 444=>3, 448=>5, 450=>6, 445=>8}},
           {:profile_searched=>443, :profile_relations=>{448=>3, 441=>3, 450=>4, 442=>7, 445=>17, 444=>111}},
           {:profile_searched=>445, :profile_relations=>{444=>3, 441=>7, 442=>13, 443=>14}},
           {:profile_searched=>450, :profile_relations=>{442=>1, 443=>2, 448=>5, 441=>5, 444=>211}},
           {:profile_searched=>442, :profile_relations=>{448=>3, 441=>3, 450=>4, 443=>8, 445=>17, 444=>111}},
           {:profile_searched=>444, :profile_relations=>{441=>1, 445=>2, 442=>91, 443=>101, 448=>191, 450=>201}},
           {:profile_searched=>448, :profile_relations=>{442=>1, 443=>2, 441=>5, 450=>6, 444=>211}}],
       :profiles_found_arr=>[{441=>{48=>{675=>[1, 2, 3, 5, 6, 8]}}},
                             {443=>{48=>{677=>[3, 3, 4, 7, 17, 111]}, 49=>{684=>[3, 3, 4, 7, 17, 111]}}},
                             {445=>{48=>{681=>[3, 7, 13, 14]}, 49=>{688=>[3, 13, 14]}}},
                             {450=>{48=>{679=>[1, 2, 5, 5, 211]}, 49=>{686=>[1, 2, 5, 5, 211]}}},
                             {442=>{48=>{676=>[3, 3, 4, 8, 17, 111]}, 49=>{683=>[3, 3, 4, 8, 17, 111]}}},
                             {444=>{48=>{680=>[1, 2, 91, 101, 191, 201]}, 49=>{687=>[2, 91, 101, 191, 201]}}},
                             {448=>{48=>{678=>[1, 2, 5, 6, 211]}, 49=>{682=>[1, 2, 6], 685=>[1, 2, 6, 211]}}}],
       :uniq_profiles_pairs=>{441=>{48=>675}, 443=>{48=>677, 49=>684}, 445=>{48=>681}, 450=>{48=>679, 49=>686}, 442=>{48=>676, 49=>683}, 444=>{48=>680, 49=>687}, 448=>{48=>678, 49=>685}},
       :profiles_with_match_hash=>{680=>6, 683=>6, 676=>6, 684=>6, 677=>6, 675=>6, 678=>5, 687=>5, 686=>5, 679=>5, 685=>4, 681=>4},
       :by_profiles=>[{:search_profile_id=>444, :found_tree_id=>48, :found_profile_id=>680, :count=>6},
                      {:search_profile_id=>442, :found_tree_id=>49, :found_profile_id=>683, :count=>6},
                      {:search_profile_id=>442, :found_tree_id=>48, :found_profile_id=>676, :count=>6},
                      {:search_profile_id=>443, :found_tree_id=>49, :found_profile_id=>684, :count=>6},
                      {:search_profile_id=>443, :found_tree_id=>48, :found_profile_id=>677, :count=>6},
                      {:search_profile_id=>441, :found_tree_id=>48, :found_profile_id=>675, :count=>6},
                      {:search_profile_id=>448, :found_tree_id=>48, :found_profile_id=>678, :count=>5},
                      {:search_profile_id=>444, :found_tree_id=>49, :found_profile_id=>687, :count=>5},
                      {:search_profile_id=>450, :found_tree_id=>49, :found_profile_id=>686, :count=>5},
                      {:search_profile_id=>450, :found_tree_id=>48, :found_profile_id=>679, :count=>5},
                      {:search_profile_id=>448, :found_tree_id=>49, :found_profile_id=>685, :count=>4},
                      {:search_profile_id=>445, :found_tree_id=>48, :found_profile_id=>681, :count=>4}],
       :by_trees=>[{:found_tree_id=>48, :found_profile_ids=>[675, 677, 681, 679, 676, 680, 678]},
                   {:found_tree_id=>49, :found_profile_ids=>[684, 686, 683, 687, 685]}],
       :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}



  # results =
      {:connected_author_arr=>[48],
       :qty_of_tree_profiles=>7,
       :profiles_relations_arr=>[
           {:profile_searched=>675, :profile_relations=>{676=>1, 677=>2, 680=>3, 678=>5, 679=>6, 681=>8}},
           {:profile_searched=>678, :profile_relations=>{676=>1, 677=>2, 675=>5, 679=>6, 680=>211}},
           {:profile_searched=>679, :profile_relations=>{676=>1, 677=>2, 678=>5, 675=>5, 680=>211}},
           {:profile_searched=>676, :profile_relations=>{678=>3, 675=>3, 679=>4, 677=>8, 681=>17, 680=>111}},
           {:profile_searched=>681, :profile_relations=>{680=>3, 675=>7, 676=>13, 677=>14}},
           {:profile_searched=>680, :profile_relations=>{675=>1, 681=>2, 676=>91, 677=>101, 678=>191, 679=>201}},
           {:profile_searched=>677, :profile_relations=>{678=>3, 675=>3, 679=>4, 676=>7, 681=>17, 680=>111}}],
       :profiles_found_arr=>[
           {675=>{24=>{441=>[1, 1, 2, 3, 5, 6, 8]}}},
           {678=>{24=>{448=>[1, 1, 2, 5, 6, 211]}, 49=>{682=>[1, 2, 6], 685=>[1, 2, 6, 211]}}},
           {679=>{24=>{450=>[1, 1, 2, 5, 5, 211]}, 49=>{686=>[1, 2, 5, 5, 211]}}},
           {676=>{24=>{442=>[3, 3, 3, 3, 4, 4, 8, 8, 17, 17, 111, 111]}, 49=>{683=>[3, 3, 4, 8, 17, 111]}}},
           {681=>{24=>{445=>[3, 7, 13, 13, 14]}, 49=>{688=>[3, 13, 14]}}},
           {680=>{24=>{444=>[1, 2, 91, 91, 101, 191, 201]}, 49=>{687=>[2, 91, 101, 191, 201]}}},
           {677=>{24=>{443=>[3, 3, 4, 7, 7, 17, 111]}, 49=>{684=>[3, 3, 4, 7, 17, 111]}}}],
       :uniq_profiles_pairs=>{675=>{24=>441}, 678=>{24=>448, 49=>685}, 679=>{24=>450, 49=>686}, 676=>{24=>442, 49=>683}, 681=>{24=>445}, 680=>{24=>444, 49=>687}, 677=>{24=>443, 49=>684}},
       :profiles_with_match_hash=>{442=>12, 443=>7, 444=>7, 441=>7, 684=>6, 683=>6, 450=>6, 448=>6, 687=>5, 445=>5, 686=>5, 685=>4},
       :by_profiles=>[{:search_profile_id=>676, :found_tree_id=>24, :found_profile_id=>442, :count=>12},
                      {:search_profile_id=>677, :found_tree_id=>24, :found_profile_id=>443, :count=>7},
                      {:search_profile_id=>680, :found_tree_id=>24, :found_profile_id=>444, :count=>7},
                      {:search_profile_id=>675, :found_tree_id=>24, :found_profile_id=>441, :count=>7},
                      {:search_profile_id=>677, :found_tree_id=>49, :found_profile_id=>684, :count=>6},
                      {:search_profile_id=>676, :found_tree_id=>49, :found_profile_id=>683, :count=>6},
                      {:search_profile_id=>679, :found_tree_id=>24, :found_profile_id=>450, :count=>6},
                      {:search_profile_id=>678, :found_tree_id=>24, :found_profile_id=>448, :count=>6},
                      {:search_profile_id=>680, :found_tree_id=>49, :found_profile_id=>687, :count=>5},
                      {:search_profile_id=>681, :found_tree_id=>24, :found_profile_id=>445, :count=>5},
                      {:search_profile_id=>679, :found_tree_id=>49, :found_profile_id=>686, :count=>5},
                      {:search_profile_id=>678, :found_tree_id=>49, :found_profile_id=>685, :count=>4}],
       :by_trees=>[{:found_tree_id=>24, :found_profile_ids=>[441, 448, 450, 442, 445, 444, 443]},
                   {:found_tree_id=>49, :found_profile_ids=>[685, 686, 683, 687, 684]}],
       :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}



  #
  # current_user = 49
  # collect found users: from search_results
  # :by_trees=>[
  #     {:found_tree_id=>24, :found_profile_ids=>[442, 444, 445, 443, 450]},
  #     {:found_tree_id=>48, :found_profile_ids=>[676, 678, 680, 677, 679]}],
  # [24, 48]
  # collect user's profiles
  # for each user_profile_id start method (modified!) = simplified + add profiles names
  #
  # To collect profiles_relations hashes:

  # unless tree_is_profiles.blank?
  #   tree_is_profiles.each do |profile_id_searched|
  #     logger.info " "
  #     logger.info "***** Цикл ПОИСКa: #{i+1}-я ИТЕРАЦИЯ - Ищем профиль: #{profile_id_searched.inspect};"
  #     ###### ЗАПУСК ПОИСКА ОДНОГО ПРОФИЛЯ
  #     search_match(connected_users_arr, profile_id_searched, certain_koeff)
  #     ###################################
  #     i += 1  # DEBUGG_TO_LOGG
  #   end
  # end
  # Compare user's_profiles relation's hashes:
  # Criteria: Find an collect Matches. Match- is: Profile_name + Relation name
  # If Match amount >= 5 => current_user and user - double_users



# @note: Контроль корректности массивов перед объединением
  # Tested
  # @param: connection_data = {:who_connect=>[1, 2], :with_whom_connect=>[3],
  #   :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18], :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
  #   :current_user_id=>1, :user_id=>3, :connection_id=>3}
  def check_connection_arrs(connection_data )
    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]

    # Корректные значения - для корректных массивов
    stop_by_arrs = false
    item = 1                  # Параметр для выбора корректного сообщения
    commons = []              # Исходное значение общих (совпадающих) эл-тов у массивов перезаписи перед проверкой
    complete_dubles_hash = {} # Исходное значение Хаша дубликатов перед проверкой

    # Если массивы - пустые
    if profiles_to_rewrite.blank? or profiles_to_destroy.blank?   # 1
      stop_by_arrs = true
      item = 2
    end

    if item == 1  # До этой проверки все было Ок с массивами
      commons = check_commons(profiles_to_rewrite, profiles_to_destroy)
      # Проверка на наличие общих (совпадающих) эл-тов у массивов перезаписи
      unless commons.blank?  # ЕСТЬ пересечения общих профилей - commons != []  # 2
        stop_by_arrs = true
        item = 3
      end
    end

    if item == 1  # До этой проверки все было Ок с массивами
      # Проверка найденных массивов перезаписи перед объединением - на повторы
      if profiles_to_rewrite.size == profiles_to_destroy.size    # 3
        complete_dubles_hash = check_duplications(profiles_to_rewrite, profiles_to_destroy)
      else
        stop_by_arrs = true
        item = 4
      end
    end

    if item == 1  # До этой проверки все было Ок с массивами
      # Проверка хэша дублей: Если ЕСТЬ дублирования в массивах   # 5
      unless complete_dubles_hash.empty?
        stop_by_arrs = true #
        item = 5
      end
    end

    if item == 1  # До этой проверки все было Ок с массивами
      # Проверка: Если перезаписываются два юзера в массивах  # 6
      # two profiles are user's profiles -> No to connect
      if check_profiles_users?(profiles_to_rewrite, profiles_to_destroy)
        stop_by_arrs = true #
        item = 6
      end
    end

    connection_message = diagnoze_message(item)

    { stop_by_arrs:            stop_by_arrs,
      diag_item:               item,
      diag_connection_message: connection_message,
      common_profiles:         commons,
      complete_dubles_hash:    complete_dubles_hash  }
  end

  # @note: Проверка: Если перезаписываются два юзера в массивах   #
  # two profiles are user's profiles -> No to connect
  def check_profiles_users?(profiles_to_rewrite, profiles_to_destroy)
    profiles_to_rewrite.each_with_index do |profile_id, index|
      main_profile     = Profile.find(profile_id)
      opposite_profile = Profile.find(profiles_to_destroy[index])
      if User.where(profile_id: main_profile).exists? && User.where(profile_id: opposite_profile).exists?
        logger.info "In check_profiles_users = true"
        return true
      end
    end
    logger.info "In check_profiles_users = false"
    false
  end


  # @note:  Выбор соответствующего диагностического сообщения по результатам проверки
  #   массивов перезаписи перед объединением деревьев.
  def diagnoze_message(item)
    case item
      when 1
        connection_message = "Данные для объединения деревьев - корректны. "  # Tested
      when 2
        connection_message = "Объединение остановлено, т.к. массив(ы) объединения - пустые" # Tested
      when 3
        connection_message = "Объединение остановлено. В массивах объединения - есть общие (совпадающие) профили!" # Tested
      when 4
        connection_message = "Объединение остановлено, т.к. массив(ы) объединения - имеют разный размер"  # Tested
      when 5
        connection_message =
            "Нельзя объединить ваши деревья, т.к. данные для объединения - некорректны! ЕСТЬ дублирования в массивах"  # Tested
      when 6
        connection_message =
            "Нельзя объединить ваши деревья, т.к. объединяются два Юзера! Их нельзя объединять"  # Tested
      else
        connection_message = "Внимание: Диагноз массивов объединения деревьев - не был поставлен"  # Tested
    end
    connection_message
  end


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

    # TO TEST WHEN CONNECTION FAILS
    # @complete_dubles_hash = complete_dubles_hash # DEBUGG_TO_VIEW
    # complete_dubles_hash = {11=>[25, 26]}  # for DEBUGG ONLY!!!

    complete_dubles_hash
  end


  # Проверка на наличие общих (совпадающих) эл-тов у массивов перезаписи
  # Что - не должно быть!.
  def check_commons(array1, array2)
    array1 & array2
  end




end # End of ConnectionTrees module
