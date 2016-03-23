class ConnectionRequest < ActiveRecord::Base

  #############################################################
  # Иванищев А.В. 2014-2015
  # Запрос на объединение
  #############################################################
  # Расчет параметров запросов на объединение и сохранение их в БД
  # @note: Here is the storage of ConnectionRequest class methods
  #   to evaluate data to be stored
  #   as proper requests
  #############################################################

  validates_presence_of :user_id, :with_user_id, :connection_id,
                        :message => "Должно присутствовать в ConnectionRequest"
  validates_numericality_of :user_id, :with_user_id, :connection_id, :only_integer => true,
                            :message => "ID объединяемых Юзеров: должны быть целым числом в ConnectionRequest"
  validates_numericality_of :user_id, :with_user_id, :connection_id, :greater_than => 0,
                            :message => "ID объединяемых Юзеров: должны быть больше 0 в ConnectionRequest"
  validate :request_users_ids_not_equal  # :user_id  AND :with_user_id
  # custom validation
  def request_users_ids_not_equal
    self.errors.add(:connection_requests, 'Юзеры IDs в одном ряду не должны быть равны в ConnectionRequest.') if self.user_id == self.with_user_id
  end

  validates_inclusion_of :confirm, :in => [nil, 0, 1, 2],
                         :message => "Значение поля подтверждения объединения: должно быть [nil, 0, 1, 2] в ConnectionRequest"
  # nil - default
  # 0 - No to connect
  # 1 - Yes to connect
  # 2 - Request deleted by System (trees already connected)

  validates_inclusion_of :done, :in => [true, false],
                         :message => "done должно быть [true, false] в ConnectionRequest"




  # @note: Определение кол-ва совершенных объединений
  #   От всех Юзеров
  def self.connections_amount
    where(done: true, confirm: 1).count
  end

  # @note: Определение кол-ва совершенных объединений
  #   От всех Юзеров
  def self.connections_refuses
    where(done: true, confirm: 0).count
  end

  # @note: Формирование нового запроса на объединение деревьев
  #   От кого - от текущего Юзера
  #   С кем - из формы просмотра рез-тов поиска
  def self.make_request(current_user, with_user_id)
    puts "In make_request: current_user.id = #{current_user.id}, with_user_id = #{with_user_id} "
    msg = ""
    msg_code = 1
    if  !ConnectionRequest.exists?(:user_id => current_user.id , :with_user_id => with_user_id, :done => false )

      # определение Юзеров - участников объединения деревьев
      who_connect_ids, with_whom_connect_ids = find_users_connectors(current_user, with_user_id) if current_user

      # Если деревья еще не объединялись?
      if !who_connect_ids.include?(with_user_id.to_i) # check_connection: IF NOT CONNECTED

        # Если нет уже встречного запроса на объединение
        if !ConnectionRequest.exists?(:user_id => with_user_id, :with_user_id => current_user.id, :done => false )

          # Определение текущего номера запроса
          connection_id = get_connection_id

          # формируется запрос для каждого из Юзеров в дереве, с кот-м объединяемся
          create_requests(who_connect_ids, with_whom_connect_ids, connection_id, current_user.id)

        else
          puts "Warning:: Встречный запрос на объединение! "
          msg = "Уже существует встречный запрос на объединение! "
          msg_code = 2
        end
      else
        puts "Warning:: Current_user &  with_user_id - Already connected! "
        msg = "Деревья уже объединены! "
        msg_code = 3
      end
    else
      puts "Запрос уже существует! "
      msg = "Запрос уже существует! "
      msg_code = 4
    end
    return msg, msg_code
  end


  # @note: формируется запрос для каждого из Юзеров в дереве, с кот-м объединяемся
  #   Присваиваем текущий Номер для connection_id
  def self.create_requests(who_connect_ids, with_whom_connect_ids, max_connection_id, current_user_id)
    with_whom_connect_ids.each do |user_to_connect|
      new_connection_request = ConnectionRequest.new
      new_connection_request.connection_id = max_connection_id
      new_connection_request.user_id = current_user_id
      new_connection_request.with_user_id = user_to_connect
      ##########################################
      new_connection_request.save
      #########################################
      # profile_user_to_conn = User.find(user_to_connect).profile_id unless user_to_connect.blank?
      # ##########  UPDATES - № 1  ####################
      # # logger.info "In create_requests:  user_id = #{current_user_id}, agent_user_id = #{user_to_connect},
      # #              agent_profile_id = #{profile_user_to_connect} " #
      # UpdatesFeed.create(user_id: current_user_id, update_id: 1, agent_user_id: user_to_connect,
      #                    agent_profile_id: profile_user_to_conn,  who_made_event: current_user_id, read: false)

    end
    puts "In create_requests: New requests created"

    # update pending & connection_id in SearchResults
    SearchResults.make_results_pending(who_connect_ids, with_whom_connect_ids)
    SearchResults.set_connection_id_results(who_connect_ids, with_whom_connect_ids, max_connection_id)

  end


  # @note: определение Юзеров - участников объединения деревьев
  #   who_connect_users_arr:   кто объединяется = инициатор
  #   with_whom_connect_users_arr:  с кем объединяется = ответчик connected_users
  def self.find_users_connectors(current_user, with_user_id)
    who_connect_users_arr = User.find(current_user).connected_users
    with_whom_connect_users_arr = User.find(with_user_id).connected_users
    # who_connect_users_arr = current_user.get_connected_users
    # with_whom_connect_users_arr = User.find(with_user_id).get_connected_users
    return who_connect_users_arr, with_whom_connect_users_arr
  end


  # @note: Определение текущего номера запроса
  def self.get_connection_id
    #(current_user, with_user_id)
    connection_id = ConnectionRequest.maximum(:connection_id) # next connection No
    if connection_id == nil # to start numeration of connections
      connection_id = 1
    else
      connection_id += 1
    end
    logger.info " connection_id = #{connection_id.inspect}"
    connection_id
  end


  # @note: 'НЕТ' to connect  Ответ НЕТ на запрос на объединение
  #   по номеру запроса на объединение connection_id
  #   Здесь confirm уст-ся в 0, тем самым указывается, какой юзер сказал НЕТ на запрос.
  def self.no_to_request(conn_request_data)
    connection_id    = conn_request_data[:connection_id]
    current_user_id  = conn_request_data[:current_user_id]

    requests_to_update = self.where(:connection_id => connection_id, :done => false )
                             .order('created_at').reverse_order
    if !requests_to_update.blank?
      requests_to_update.each do |request_row|
        request_row.done    = true
        request_row.confirm = 0 if request_row.with_user_id == current_user_id
        request_row.save
      end

      # SearchResults.update_no_to_connect()

      # else
    #   redirect_to show_user_requests_path
      # flash - no connection requests data in table
    end
  end


  # @note: update request data - to 'yes' to connect
  #   Ответ ДА на запрос на объединение
  #   Действия: сохраняем инфу - кто дал добро (= 1) какому объединению
  #   Перед этим - запуск собственно процесса объединения
  #   Здесь confirm уст-ся в 1, тем самым указывается, какой юзер сказал ДА на запрос.
  def self.request_connection(connection_data)
    # who_connect_arr         = connection_data[:who_connect_arr]
    # with_whom_connect_arr   = connection_data[:with_whom_connect_arr]
    # profiles_to_rewrite     = connection_data[:profiles_to_rewrite]
    # profiles_to_destroy     = connection_data[:profiles_to_destroy]
    current_user_id         = connection_data[:current_user_id]
    user_id                 = connection_data[:user_id]
    connection_id           = connection_data[:connection_id]

    requests_to_update = self.where(connection_id: connection_id,
                                    user_id: user_id,
                                    done: false )
    unless requests_to_update.blank?
      requests_to_update.each do |request_row|
        request_row.done    = true
        request_row.confirm = 1 if request_row.with_user_id == current_user_id  # тот, кто сказал "Да"
        request_row.save
      end
    end

  end


  # @note: Find Array of connection_ids of all requests - included in just connected [1,2,3]
  #   Найти все запросы, в которых участвуют члены нового объединенного дерева
  #   Make DONE all connected requests
  #   - update all requests - with users, connected with current_user  # 1.Get connected users - arr
  #   where(user-id - in Arr and with_user in Arr)
  #   set to DONE all.
  #   Здесь confirm уст-ся в 2, тем самым СИСТЕМОЙ указывается, что все юзеры, имевшие ранее запросы на объединения -
  #   - объединяются СИСТЕМОЙ, ПО ФАКТУ ПРИСУТСТВИЯ  в деревьях участников объединения.
  # @param: current_user_id=>1
  def self.connected_requests_update(current_user_id)
    new_tree_users = User.find(current_user_id).get_connected_users
    self.where("user_id in (?)", new_tree_users).where("with_user_id in (?)", new_tree_users)
        .where(done: false).update_all({done: true, confirm: 2})
  end


  # @note: rollback ConnectionRequest - update request data - to 'yes' to connect
  #   Ответ ДА на запрос на объединение
  # Здесь - обратный update того conn._requests, который был установлены как выполненные ЮЗЕРОМ, т.е. у которых
  # confirm был установлен в 1. Теперь - опять nil.
  def self.request_disconnection(disconnect_data)
    self.where(connection_id: disconnect_data[:connection_id],   # 3
               user_id: disconnect_data[:with_user_id],          # 3
               done: true )
        .update_all({done: false, confirm: nil})
  end


  # @note rollback ConnectionRequest - update request data - to 'yes' to connect
  # conn_users_destroy_data = {
  #     user_id: connection_common_log["user_id"], #    1,
  #     with_user_id: Profile.find(connection_common_log["base_profile_id"]).user_id,    #        3,
  #     connection_id: connection_common_log["log_id"]   #    3,
  # }
  # Здесь - обратный update тех conn._requests, которые были установлены как выполненные СИСТЕМОЙ, т.е. те, у которых
  # confirm был установлен в 2. Теперь - опять nil.
  def self.disconnected_requests_update(disconnect_data)
    connected_tree = User.find(disconnect_data[:user_id]).get_connected_users
    self.where("user_id in (?)", connected_tree).where("with_user_id in (?)", connected_tree)
        .where(done: true, confirm: 2)
        .update_all({done: false, confirm: nil})
  end


  # @note: update connection_requests if search_results does not include trees to be connected in requests
  #
  def self.check_requests_with_search(current_user, connected_users_arr)
    search_data = current_user.start_search#(WeafamSetting.first.certain_koeff)
    self.check_valid_requests(search_data, connected_users_arr)
  end


  # @note:
  #
  def self.check_valid_requests(search_data, connected_users_arr)

    search_res_trees = []
    search_data[:by_trees].each do |one_tree|
      search_res_trees << one_tree[:found_tree_id]
    end

    current_to_connect = self.where("user_id in (?)", connected_users_arr)
                             .where("with_user_id in (?)", connected_users_arr)
                             .where(done: false)

    current_to_connect.each do |one_request|
      unless search_res_trees.include?(one_request.user_id)
        puts "In disconnect_tree: include check:: one_request.user_id = #{one_request.user_id}, one_request.id = #{one_request.id}"
        ConnectionRequest.find(one_request.id).destroy
      end
    end

  end

  # @note: Find Array of connection_ids of all requests - included in just connected [1,2,3]
  #   Найти все запросы, в которых участвуют члены объединенного дерева
  # @param: current_user_id=>1
  def self.connection_requests_exists(connected_users)
    week_ago_time = 1.week.ago
    p "week_ago_time = #{week_ago_time} "
    users_ids = self.where("user_id in (?)", connected_users).where(done: false)
                    .where("date_trunc('day', created_at) >= ?", "#{week_ago_time}")
                    .pluck(:with_user_id)
    with_users_ids = self.where("with_user_id in (?)", connected_users).where(done: false)
                         .where("date_trunc('day', created_at) >= ?", "#{week_ago_time}")
                         .pluck(:with_user_id)
    # users_ids = [1,2,3,4,5,10,11]
    # with_users_ids = [2,3,4,5, 6,7,8]
    all_users_ids = users_ids + with_users_ids
    p "users_ids = #{users_ids}, with_users_ids = #{with_users_ids} "
    conn_req_users_ids = all_users_ids.uniq - connected_users
    p "all_users_ids = #{all_users_ids}, conn_req_users_ids = #{conn_req_users_ids} "
    request_users_profiles = User.users_profiles(conn_req_users_ids)

    # connections_info =
        { request_users_ids: conn_req_users_ids,
                         request_users_qty:          conn_req_users_ids.size,
                         request_users_profiles:  request_users_profiles
    }

  end



end
