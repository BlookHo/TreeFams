class ConnectionRequestsController < ApplicationController
  include ConnectionRequestsHelper


  before_action :set_connection_request, only: [:show, :edit, :update, :destroy] #, :show_one_request]

  # GET /connection_requests
  # GET /connection_requests.json
  def index
    @connection_requests = ConnectionRequest.all.order('created_at').reverse_order
  end

  # GET /connection_requests/1
  # GET /connection_requests/1.json
  def show

  end

  # GET /connection_requests/new
  def make_connection_request

    if current_user

      current_user_id = current_user.id #
      with_user_id = params[:user_id_to_connect] # From view
      @current_user_id = current_user_id # DEBUGG_TO_VIEW
      @with_user_id = with_user_id # DEBUGG_TO_VIEW

      find_users_connectors(with_user_id) if current_user # определение Юзеров - участников объединения деревьев

      max_connection_id = ConnectionRequest.maximum(:connection_id)
      logger.info " max_connection_id = #{max_connection_id}"

      @with_whom_connect_users_arr.each do |user_to_connect|

        new_connection_request = ConnectionRequest.new
    #    new_connection_request.connection_id = current_user.id
        new_connection_request.user_id = current_user.id
        new_connection_request.with_user_id = user_to_connect
        new_connection_request.save

      end

      @all_connection_requests = ConnectionRequest.all.order('created_at').reverse_order

    end


  end


  # определение Юзеров - участников объединения деревьев
  # who_connect_users_arr:   кто объединяется = инициатор
  # with_whom_connect_users_arr:  с кем объединяется = ответчик
  def find_users_connectors(with_user_id)

    who_connect_users_arr = current_user.get_connected_users
    with_whom_connect_users_arr = User.find(with_user_id).get_connected_users  #
    @who_connect_users_arr = who_connect_users_arr # DEBUGG_TO_VIEW
    @with_whom_connect_users_arr = with_whom_connect_users_arr # DEBUGG_TO_VIEW

  end

  # GET /connection_requests/1
  # GET /connection_requests/1.json
  def show_one_request

    if current_user
      @new_requests_count = count_new_requests
      #logger.info "== show_one_dialoge == @new_messages_count = #{@new_messages_count}"

      with_user_id = params[:with_user_id] # From view
      @with_user_id = with_user_id # DEBUGG_TO_VIEW

      find_users_connectors(with_user_id) if current_user # определение Юзеров - участников объединения деревьев

      connection_id = params[:connection_id] # From view
      @connection_id = connection_id # DEBUGG_TO_VIEW

      id = params[:id] # From view
      @id = id # DEBUGG_TO_VIEW


    else
      redirect_to login_path
      flash[:info] = "Для этого нужно авторизоваться"
    end

  end

  # GET /connection_requests/new
  def new
    @connection_request = ConnectionRequest.new
  end

  # GET /connection_requests/1/edit
  def edit
  end

  # Ответ ДА на запрос на объединение
  # Действия: сохраняем инфу - кто дал добро какому объединению
  # После этого - запуск собственно процесса объединения
  #
  # GET /connection_requests/yes_connect
  def yes_connect
    yes_user_id = params[:yes_user_id].to_i # From view
    logger.info "== yes_user_id = #{yes_user_id}"

    # update request data - to yes connect
    request_to_update = ConnectionRequest.where(:user_id => current_user.id, :with_user_id => yes_user_id, :done => false)[0]
    request_to_update.confirm = 1
    request_to_update.done = true
    request_to_update.save
    logger.info "== request_to_update.confirm = #{request_to_update.confirm}"
    logger.info "== request_to_update.done = #{request_to_update.done}"

    # Взять значение из Settings
    @certain_koeff = 4

  #  redirect_to connection_of_trees_path( user_id_to_connect: yes_user_id, certain_koeff: @certain_koeff), class: :green
    redirect_to connection_requests_path

  end

  # Ответ НЕТ на запрос на объединение
  # Действия: сохраняем инфу - кто отказал какому объединению
  # После этого - пометить, что-то?
  # GET /connection_requests/no_connect
  def no_connect
    no_user_id = params[:no_user_id].to_i # From view
    logger.info "== no_user_id = #{no_user_id}"

    # update request data - to no connect
    request_to_update = ConnectionRequest.where(:user_id => current_user.id, :with_user_id => no_user_id, :done => false)[0]
    request_to_update.confirm = 0
    request_to_update.done = true # больше не объединяем в дальнейшем (?)
    request_to_update.save
    logger.info "== request_to_update.confirm = #{request_to_update.confirm}"
    logger.info "== request_to_update.done = #{request_to_update.done}"

    redirect_to connection_requests_path

  end

  # POST /connection_requests
  # POST /connection_requests.json
  def create



    @connection_request = ConnectionRequest.new(connection_request_params)

    respond_to do |format|
      if @connection_request.save
        format.html { redirect_to @connection_request, notice: 'Connection request was successfully created.' }
        format.json { render :show, status: :created, location: @connection_request }
      else
        format.html { render :new }
        format.json { render json: @connection_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /connection_requests/1
  # PATCH/PUT /connection_requests/1.json
  def update
    respond_to do |format|
      if @connection_request.update(connection_request_params)
        format.html { redirect_to @connection_request, notice: 'Connection request was successfully updated.' }
        format.json { render :show, status: :ok, location: @connection_request }
      else
        format.html { render :edit }
        format.json { render json: @connection_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /connection_requests/1
  # DELETE /connection_requests/1.json
  def destroy
    @connection_request.destroy
    respond_to do |format|
      format.html { redirect_to connection_requests_url, notice: 'Connection request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


# As in BL. Need to create table
def update_settings

  settings = BlSetting.first   # Берем из Таблицы настроек пороговое значение sdc_save_limit = 650
  save_limit = settings.sdc_save_limit   # To take from Bl_settings == 650 !
  @sdc_save_limit = save_limit # DEBUGG

end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_connection_request
      @connection_request = ConnectionRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def connection_request_params
      params.require(:connection_request).permit(:user_id, :with_user_id, :confirm, :done, :created_at)
    end
end
