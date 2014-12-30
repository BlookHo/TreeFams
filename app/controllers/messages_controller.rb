# encoding: utf-8

class MessagesController < ApplicationController
  include MessagesHelper

  layout 'application.new'
  before_filter :logged_in?


  # if current_user # && !banned?

  # GET /messages
  # GET /messages.json
  # Показываем все диалоги текущего юзера
  # с возможностью перехода к просмотру одного выбранного диалога
  # с одним юзером.
  def index
    @new_messages_count = count_new_messages  # To show in View
    agents_talks = Message.find_agents(current_user) # find all contragent of current_user by messages
    @talks_and_messages = Message.view_messages_data(agents_talks, current_user)  # To show in View
    @one_dialoge_length = 1
    @current_user = current_user
  end


  def new
    @receiver = User.find(params[:receiver_id])
    @message = Message.new
    @message.receiver_id = @receiver.id
  end


  def create
    @message = Message.new(message_params)
    @message.sender_id = current_user.id
    if @message.save
      flash.now[:notice] = "Cообщение отправлено"
    else
      flash.now[:alert] = "Ошибка при отправке сообщения"
      render :new
    end
  end



  # Получаем диалог одного юзера
  def show_one_dialoge

      @new_messages_count = count_new_messages

      user_id = params[:user_talk_id] # From view
      user_dialoge = Message.get_user_messages(user_id, current_user)
      @talks_and_messages = []
      @talks_and_messages << user_dialoge
      @one_dialoge_length = user_dialoge[user_id].length if !user_dialoge[user_id].blank?
      @display_receiver_name4 = User.show_user_name(user_id, 4)
      @display_receiver_name2 = User.show_user_name(user_id, 2)

  end

  # Удаление одного диалога - всех взаимных сообщений с Юзером = user_talk_id
  # @param data [params[:user_talk_id]] юзер с которым диалог - акщь мшуц
  def delete_one_dialogue
    user_dialogue = params[:user_talk_id]
   # @user_dialogue = user_dialogue
    unless user_dialogue.blank?
      @user_dialogue_name = User.show_user_name(user_dialogue, 4)
      #logger.info "In delete_one_dialoge: user_dialogue_name = #{@user_dialogue_name}"
      flash[:notice] = "Происходит удаление твоего диалога с #{@user_dialogue_name} "
      Message.delete_one_dialogue(user_dialogue, current_user)
      @deleted =
      @text_to_js = " Удален! "
      flash[:notice] = "Удаление твоего диалога с #{@user_dialogue_name} - завершено"
    end
  end


  # Пометка в БД выбранного сообщения как Удаленного
  # @param data [params[:message_id]] ID выбранного для удаления сообщения - из view
  #
  def delete_message
    unless params[:message_id].blank?
      one_message = Message.find(params[:message_id])
      one_message.delete_one_message(one_message, current_user)
      @receiver_del = one_message.receiver_deleted  # to js
      @sender_del = one_message.sender_deleted  # to js
      check_deletion(one_message)
      #flash[:notice] = "Сообщение удалено"
    end

  end

  # Сигнал-я о корректности "удаления"
  def check_deletion(one_message)
    if one_message.persisted?
      flash[:success] = "Сообщение удалено"
    else
      flash[:error] = "Ошибки при удалении сообщения"
    end
  end


  # Пометка сообщения как Важного (important_message) и обратно - в Неважное
  # @param data [params[:message_id]] ID помеченного как важного сообщения - из view
  def mark_important
    unless params[:message_id].blank?
      Message.important_message(params[:message_id], current_user ) #
      flash[:notice] = "Изменена пометка важности сообщения"
      @mark_important = Message.find(params[:message_id]).important  # to js
      # todo: отображение изменения значения (js)
    end

    respond_to do |format|
      format.html
      format.js { render 'messages/mark_important' }
    end


  end


  # later - Пометка сообщения как Spam
  def spam_dialoge
    user_id = params[:user_id] # From view
    #
  end




  # Создание и сохранение нового сообщения
  def new_message
    receiver_id = params[:receiver_id].to_i # From view Index
    #flash.now.alert = "Подтвердите выбор адресата"
    @text = params[:text] # From view New_message
    unless (receiver_id.blank? || @text.blank?)
      create_data= {
          text: @text,
          receiver_id: receiver_id,
          sender_id: current_user.id
          }
      Message.create(create_data)
      @receiver_to_name = get_name(User.find(receiver_id).profile_id)
      redirect_to "/show_one_dialoge?user_talk_id=#{receiver_id}"
    else
      # flash.now[:alert] = "Ошибка при отправке сообщения"
      render :new_message
    end
  end



  # Извлечение имени профиля
  def get_name(profile_id)
    profile = Profile.where(id: profile_id).first
    profile.nil? ? "Merged profile" : profile.to_name
  end



  private

  def message_params
    params[:message].permit(:text, :receiver_id)
  end



end
