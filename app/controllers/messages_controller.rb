# encoding: utf-8

class MessagesController < ApplicationController
  include MessagesHelper


  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # Получаем диалоги и сообщения всех контрагентов текущего юзера
  # Альтернативное отображение.
  def show_all_messages

    if current_user
      find_agents # find all contragent of current_user by messages
      @talks_and_messages = []
      @agents_talks.each do |user_id|
        user_dialoge = get_user_messages(user_id)
        @talks_and_messages << user_dialoge
      end
    else
      redirect_to login_path
      flash[:info] = "Для этого нужно авторизоваться"
    end

  end

  # Получаем диалоги всех контрагентов текущего юзера
  def show_all_dialoges

    if current_user
      find_agents # find all contragent of current_user by messages

      @talks_and_messages = []
      @agents_talks.each do |user_id|
        user_dialoge = get_user_messages(user_id)
        @talks_and_messages << user_dialoge
      end
    else
      redirect_to login_path
      flash[:info] = "Для этого нужно авторизоваться"
    end
 #   redirect_to show_one_dialoge_path
    @new_mail_count = count_messages
    logger.info "===== @new_mail_count = #{@new_mail_count}"

  end

  # Получаем массив сообщений для одного юзера
  def get_user_messages(user_id)
    user_dialoge = {}
    user_messages = []
    one_user_talk =  Message.where(:receiver_deleted => false).where(:sender_deleted => false).where("(receiver_id = #{current_user.id} and sender_id = #{user_id}) or (sender_id = #{current_user.id} and receiver_id = #{user_id})").order('created_at').reverse_order
    one_user_talk.each do |one_message|
      one_message_hash = {}
      one_message_hash.merge!(:message_id => one_message.id)
      one_message_hash.merge!(:text => one_message.text)
      one_message_hash.merge!(:sender_id => one_message.sender_id)
      one_message_hash.merge!(:receiver_id => one_message.receiver_id)
      one_message_hash.merge!(:read => one_message.read)
      one_message_hash.merge!(:sender_deleted => one_message.sender_deleted)
      one_message_hash.merge!(:receiver_deleted => one_message.receiver_deleted)
      user_messages << one_message_hash
    end
    user_dialoge.merge!(user_id => user_messages)
    return user_dialoge
  end


  # Получаем диалог одного юзера
  def show_one_dialoge

    if current_user
      find_agents # find all contragent of current_user by messages
      user_id = params[:user_id] # From view

      @talks_and_messages = []
      user_dialoge = get_user_messages(user_id)
      @talks_and_messages << user_dialoge
    else
      redirect_to login_path
      flash[:info] = "Для этого нужно авторизоваться"
    end

  end

  # later
  def search_dialoge_agent

    # Выбор Юзера по имени(?)
    #if params[:receiver_name]
    #  user = User.find_by_nick(params[:receiver_name])
    #  unless user.blank?
    #    receiver_id = user.id
    #  end
    #else
    #  receiver_id = params[:receiver_id]
    #end

  end

  def send_message # отправление нового сообщения

    if current_user # && !banned?

      receiver_id = params[:receiver_id] # From view
      text = params[:text] # From view

      if !(receiver_id.blank? || text.blank?)
        @receiver_id = receiver_id # # DEBUGG_TO_VIEW
        @text = text #params[:text] # # DEBUGG_TO_VIEW
        logger.info "receiver_id = #{receiver_id}, text = #{text}" # DEBUGG_TO_VIEW

        message = Message.new(text: text, receiver_id: receiver_id, sender_id: current_user.id)
        message.save

        # Установка уведомления

      end

    else
      redirect_to login_path
      flash[:info] = "Для этого нужно авторизоваться"
    end

  end

  # Удаление выбранного one_message
  # GET /messages
  def delete_message

    #user_id = params[:user_id] # From view # всего диалога

    if current_user

      #one_user_dialoge =  Message.where("(receiver_id = #{current_user.id} and sender_id = #{user_id}) or (sender_id = #{current_user.id} and receiver_id = #{user_id})")#.where(:receiver_deleted => false)#, :sender_deleted => false)#.order('created_at').reverse_order
      #one_user_dialoge.each do |one_message|
      #
      #  one_message.receiver_deleted = true if one_message.receiver_id == current_user.id
      #  one_message.sender_deleted = true   if one_message.sender_id == current_user.id
      #  one_message.save
      #
      #
      #end

      message = Message.find(params[:message_id])
      if message.receiver_id == current_user.id
        message.receiver_deleted = true
        message.save
        user_id = message.sender_id
        if message.persisted?
          flash[:success] = "Письмо удалено"
        else
          flash[:error] = "Ошибки при удалении письма"
        end
      else
        flash[:error] = "Ты не можешь удалить это сообщение"
      end
      if message.sender_id == current_user.id
        message.sender_deleted = true
        message.save
        user_id = message.receiver_id

        if message.persisted?
          flash[:success] = "Письмо удалено"
        else
          flash[:error] = "Ошибки при удалении письма"
        end
      else
        flash[:error] = "Ты не можешь удалить это сообщение"
      end
      redirect_to show_one_dialoge_path(user_id: user_id)

    else
      redirect_to login_path
      flash[:info] = "Для этого нужно авторизоваться"
    end


  end

  # GET /messages
  def spam_dialoge
    user_id = params[:user_id] # From view


  end

  def read_message # чтение сообщения

    if current_user
      message = Message.find(params[:message_id])
      if message.receiver_id == current_user.id || message.sender_id == current_user.id
        if message.read == false #
          message.read = true
          message.save
        end
        user_id = message.sender_id  if message.receiver_id == current_user.id
        user_id = message.receiver_id  if message.sender_id == current_user.id

        # Изменение счетчика непрочитанных сообщений - для уведомлений

      end

      new_messages_count = count_messages
      logger.info "===== new_messages_count = #{new_messages_count}"

      respond_to do |format|
        format.html { redirect_to show_one_dialoge_path(user_id: user_id) }
        format.js { render "messages/mail/renderMessage" }
      end
    else
      redirect_to login_path
      flash[:info] = "Для этого нужно авторизоваться"
    end

  end


  # Найти всех контрагентов current_user по сообщениям
  def find_agents

    agents_senders = Message.where(:receiver_id => current_user.id).pluck(:sender_id).uniq
    agents_receivers = Message.where(:sender_id => current_user.id).pluck(:receiver_id).uniq

    logger.info "@agents_senders = #{agents_senders}"
    logger.info "@agents_receivers = #{agents_receivers}"

    @agents_talks = (agents_senders + agents_receivers).uniq

  end


  #def mail #страница сообщений юзера
  #  unless user_signed_in?
  #    redirect_to index_path
  #    flash[:info] = "Для этого нужно авторизоваться"
  #  end
  #
  #  set_meta_tags :title => 'Личные сообщения',
  #                :description => "Твои личные сообщения на Brainlook.",
  #                :keywords => "Brainlook, мнение, мнения, общество, анализ, статистика, социальный анализ, маркетологические исследования, исследования, Мозгозыр, социум, социология, веб-анализатор, опросы, голосования, опросники, брейнлук, бреинлук, браинлук, брайнлук, брэйнлук, брэинлук"
  #
  #  set_meta_tags :og => {
  #      :site_name => "Brainlook",
  #      :image => "http://brainlook.org/assets/logo/square/with_title.svg",
  #      :title => 'Brainlook | Личные сообщения',
  #      :description => "Твои личные сообщения на Brainlook.",
  #      :keywords => "Brainlook, мнения, общество, анализ, статистика, социальный анализ, маркетологические исследования, исследования, Мозгозыр, мнение, социум, социология, веб-анализатор, опросы, голосования, опросники, брейнлук, бреинлук, браинлук, брайнлук, брэйнлук, брэинлук"
  #  }
  #
  #  set_meta_tags :twitter => {
  #      :image => "http://brainlook.org/assets/logo/square/with_title.svg",
  #      :title => 'Brainlook | Личные сообщения',
  #      :description => "Твои личные сообщения на Brainlook."
  #  }
  #end
  #def show_messages_box #
  #  if user_signed_in?
  #    count_messages
  #    page_number = params[:page]
  #    limit = page_number.blank? ? 26 : page_number.to_i*25 + 1
  #
  #    input_messages = Message.where(:receiver_id => current_user.id, :receiver_deleted => false).order('created_at').reverse_order.limit(limit)
  #
  #    messages = input_messages(input_messages)
  #    @messages = Kaminari.paginate_array(messages).page(params[:page]).per(25)
  #
  #    respond_to do |format|
  #      format.html { redirect_to index_opinions_path }
  #      format.js { render "messages/mail/renderMessages" }
  #    end
  #  else
  #    redirect_to index_path
  #    flash[:info] = "Для этого нужно авторизоваться"
  #  end
  #end
  #
  #def render_inbox #рендерит входящие
  #  if user_signed_in?
  #    count_messages
  #    page_number = params[:page]
  #    limit = page_number.blank? ? 26 : page_number.to_i*25 + 1
  #    input_messages = Message.where(:receiver_id => current_user.id, :receiver_deleted => false).order('created_at').reverse_order.limit(limit)
  #
  #    messages = input_messages(input_messages)
  #    @messages = Kaminari.paginate_array(messages).page(params[:page]).per(25)
  #
  #    respond_to do |format|
  #      format.html { redirect_to index_opinions_path }
  #      format.js { render "messages/mail/renderMessages" }
  #    end
  #  else
  #    redirect_to index_path
  #    flash[:info] = "Для этого нужно авторизоваться"
  #  end
  #end
  #
  #
  #def render_sent #рендерит отправленные
  #  if user_signed_in?
  #    count_messages
  #    page_number = params[:page]
  #    limit = page_number.blank? ? 26 : page_number.to_i*25 + 1
  #    sent_messages = Message.where(:sender_id => current_user.id, :sender_deleted => false).order('created_at').reverse_order.limit(limit)
  #
  #    messages = sent_messages(sent_messages)
  #    @messages = Kaminari.paginate_array(messages).page(params[:page]).per(25)
  #
  #    respond_to do |format|
  #      format.html { redirect_to index_opinions_path }
  #      format.js { render "messages/mail/renderMessages" }
  #    end
  #  else
  #    redirect_to index_path
  #    flash[:info] = "Для этого нужно авторизоваться"
  #  end
  #end
  #
  #def render_send_message #рендерит форму отправления письма
  #  if user_signed_in?
  #    count_messages
  #
  #    nicks = User.find_by_sql " SELECT DISTINCT nick FROM users"
  #    @arr_nicks = []
  #    nicks.each do |row|
  #      nick = row.nick
  #      unless nick.blank?
  #        @arr_nicks << nick
  #      end
  #    end
  #    @arr_nicks.sort_by! { |elem| elem }
  #
  #    respond_to do |format|
  #      format.html { redirect_to index_opinions_path }
  #      format.js { render "messages/mail/renderSend" }
  #    end
  #  else
  #    redirect_to index_path
  #    flash[:info] = "Для этого нужно авторизоваться"
  #  end
  #end



  #def spam_message #отметка автора сообщения как спаммера
  #  if user_signed_in? && !banned?
  #    message = Message.find(params[:message_id])
  #    user_spam_row = UserSpamer.where(reporter_id: current_user.id, reported_id: message.sender_id, active: true)
  #    spammed_user = User.find(message.sender_id)
  #    if user_spam_row.blank?
  #      UserSpamer.create(reporter_id: current_user.id, reported_id: message.sender_id, active: true)
  #
  #      flash[:success] = "Автор письма помечен как спамер"
  #    else
  #      flash[:error] = "Ты уже отмечал автора этого письма как спамера. Мы разберемся с ним"
  #    end
  #
  #    if message.receiver_id == current_user.id
  #      message.receiver_deleted = true
  #      message.save
  #    end
  #    redirect_to mail_path
  #  else
  #    redirect_to index_path
  #    flash[:info] = "Для этого нужно авторизоваться"
  #  end
  #end
  #

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all.order('created_at desc')

    @receiver_id = params[:receiver_id].to_i #
    @text = params[:text] #

  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
   # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

  #  Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:text, :sender_id, :receiver_id, :read, :sender_deleted, :receiver_deleted)
    end


end
