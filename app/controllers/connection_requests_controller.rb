class ConnectionRequestsController < ApplicationController
  include ConnectionRequestsHelper

  layout 'application.new'

  before_filter :logged_in?

  # @note: формируется запрос для каждого из Юзеров в дереве, с кот-м объединяемся
  #   Присваиваем текущий Номер для connection_id
  def create_requests(with_whom_connect_users_arr, max_connection_id)
    with_whom_connect_users_arr.each do |user_to_connect|
      new_connection_request = ConnectionRequest.new
      new_connection_request.connection_id = max_connection_id
      new_connection_request.user_id = current_user.id
      new_connection_request.with_user_id = user_to_connect
      ##########################################
            new_connection_request.save
      ##########################################
      profile_user_to_connect = User.find(user_to_connect).profile_id unless user_to_connect.blank?
      ##########  UPDATES - № 1  ####################
      logger.info "In create_requests:  user_id = #{current_user.id}, agent_user_id = #{user_to_connect}, agent_profile_id = #{profile_user_to_connect} " #
      UpdatesFeed.create(user_id: current_user.id, update_id: 1, agent_user_id: user_to_connect,
                         agent_profile_id: profile_user_to_connect,  who_made_event: current_user.id, read: false)
      logger.info "In create_requests: UpdatesFeed.create"
      ###############################################
    end
  end


  # todo: refact
  # @note: Формирование нового запроса на объединение деревьев
  #   От кого - от текущего Юзера
  #   С кем - из формы просмотра рез-тов поиска
  def make_connection_request

      current_user_id = current_user.id #
      with_user_id = params[:user_id_to_connect].to_i # From view

      @current_user_id = current_user_id # DEBUGG_TO_VIEW
      @with_user_id = with_user_id # DEBUGG_TO_VIEW

      # TODO проверить, существует ли уже такой запрос  если да, то вернуть его данные
      if  !ConnectionRequest.exists?(:user_id => current_user.id , :with_user_id => with_user_id, :done => false )


        find_users_connectors(with_user_id) if current_user # определение Юзеров - участников объединения деревьев

        # Если деревья еще не объединялись?
        if !@who_connect_users_arr.include?(with_user_id.to_i) # check_connection: IF NOT CONNECTED

          # Если нет уже встречного запроса на объединение
          if !ConnectionRequest.exists?(:user_id => with_user_id, :with_user_id => current_user.id, :done => false )

            max_connection_id = ConnectionRequest.maximum(:connection_id) # next connection No
            if max_connection_id == nil # to start numeration of connections
              max_connection_id = 1
            else
              max_connection_id += 1
            end
            logger.info " max_connection_id = #{max_connection_id.inspect}"

            # формируется запрос для каждого из Юзеров в дереве, с кот-м объединяемся
            create_requests(@with_whom_connect_users_arr, max_connection_id)

            # Формирование хэша данных всех запросов current_user для view
            current_user_connection_ids = ConnectionRequest.where(:user_id => current_user.id, :done => false )
                                              .order('created_at').reverse_order.pluck('connection_id').uniq
            @user_requests_data = fill_requests_data(current_user_connection_ids)
            @current_user_connection_ids = current_user_connection_ids

            @request_msg = "ВАШ ЗАПРОС НА ОБЪЕДИНЕНИЕ С ВЫБРАННЫМ ВАМИ ДЕРЕВОМ Юзера = #{@with_user_id.inspect} - СФОРМИРОВАН
            И ОТПРАВЛЕН ДЛЯ ПОДТВЕРЖДЕНИЯ ВСЕМ УЧАСТНИКАМ ЭТОГО ДЕРЕВА: #{@with_whom_connect_users_arr.inspect}.
            ОЖИДАЙТЕ ПОЛУЧЕНИЯ ПОДТВЕРЖДЕНИЯ ОБЪЕДИНЕНИЯ "
          else
            logger.info "In Встречный запрос = #{counter_request_exists(with_user_id) } "
            @request_msg = "УЖЕ ЕСТЬ ЗАПРОС, ВСТРЕЧНЫЙ ВАШЕМУ "
            logger.info "Warning:: Встречный запрос на объединение! "
          end

        else
          @request_msg = "Warning:: Current_user &  with_user_id - Already connected!  "
          logger.info "Warning:: Current_user &  with_user_id - Already connected! "
        end

        @all_connection_requests = ConnectionRequest.all.order('created_at').reverse_order

      end
      redirect_to :show_user_requests, notice: "Ваш запрос на объединение успешно отправлен!"
  end


  # @note: Проверка на существование встречного запроса на объединение
  def counter_request_exists(with_user_id)
    ConnectionRequest.exists?(:user_id => with_user_id, :with_user_id => current_user.id, :done => false )
    logger.info "In check_counter_request: Встречный запрос = #{ConnectionRequest.exists?(:user_id => with_user_id, :with_user_id => current_user.id, :done => false )} "
  end


  # @note: определение Юзеров - участников объединения деревьев
  #   who_connect_users_arr:   кто объединяется = инициатор
  #   with_whom_connect_users_arr:  с кем объединяется = ответчик
  def find_users_connectors(with_user_id)
    @who_connect_users_arr = current_user.get_connected_users
    @with_whom_connect_users_arr = User.find(with_user_id).get_connected_users  #
  end


  # @note: Заполнение хэша данными о запросах по их [IDs]
  def fill_requests_data(connection_ids)
    requests_data = {}
    connection_ids.each do |one_connection_id|
      request = ConnectionRequest.where(:connection_id => one_connection_id, :done => false )
                    .order('created_at').reverse_order.first
      one_request = {}
      one_request.merge!(:request_from_user_id  => request.user_id)
      one_request.merge!(:request_to_user_id => request.with_user_id)
      one_request.merge!(:confirm => request.confirm)
      one_request.merge!(:done => request.done)
      one_request.merge!(:created_at => (request.read_attribute_before_type_cast(:created_at)).to_datetime.strftime('%d.%m.%Y в %k:%M:%S'))

      requests_data.merge!(request.connection_id => one_request)
    end
    return requests_data
  end


  # @note: Показываем все запросы на объединение текущего Юзера
  #   Переход сюда из Хэдера.
  #   GET /connection_requests/1
  #   GET /connection_requests/1.json
  def show_user_requests
    # flash[:notice] = "Ваш запрос отправлен"
    # Полученные Вами НОВЫЕ запросы на объединение - в ожидании Вашего решения
    connection_ids_to_current_user = ConnectionRequest.where(:with_user_id => current_user.id, :done => false )
                                         .order('created_at').reverse_order.pluck('connection_id').uniq
    @requests_to_user_data = fill_requests_data(connection_ids_to_current_user)

    # Все ваши запросы - в ожидании на объединение
    current_user_connection_ids = ConnectionRequest.where(:user_id => current_user.id, :done => false )
                                      .order('created_at').reverse_order.pluck('connection_id').uniq
    @user_requests_data = fill_requests_data(current_user_connection_ids)
  end


  # @note: Формирование структуры данных для отображения запросов
  def get_one_request_data(connection_id)
    one_user_request_data = {}
    requests_arr = []

    request = ConnectionRequest.where(:connection_id => connection_id, :done => false ).order('created_at').reverse_order
    request.each do |request_row|
      one_request = {}
      one_request.merge!(:request_id  => request_row.id)
      one_request.merge!(:request_from_user_id  => request_row.user_id)
      one_request.merge!(:request_to_user_id => request_row.with_user_id)
      one_request.merge!(:confirm => request_row.confirm)
      one_request.merge!(:done => request_row.done)
      one_request.merge!(:created_at => (request_row.read_attribute_before_type_cast(:created_at)).to_datetime.strftime('%d.%m.%Y в %k:%M:%S'))

      requests_arr << one_request
    end
    one_user_request_data.merge!(connection_id => requests_arr)
    @user_request_data = one_user_request_data
  end


  # @note: Формируем состав одного запроса по connection_id для view
  def show_one_request
      connection_id = params[:connection_id].to_i # From view Link
      get_one_request_data(connection_id)
  end


  # @note: Ответ НЕТ на запрос на объединение
  #   No to connect
  # Make DONE=refused == 0 for all connected requests
  # - update all requests - with users, connected with current_user
  #   Действия: сохраняем инфу - кто отказал какому объединению
  #   GET /connection_requests/no_connect
  def no_connect
    connection_id = params[:connection_id].to_i # From view Link
    # logger.info "=== IN no_connect: connection_id = #{connection_id}"
    conn_request_data = {
        connection_id: connection_id,
        current_user_id: current_user.id
    }
    ConnectionRequest.no_to_request(conn_request_data)
    redirect_to show_user_requests_path
  end




end
