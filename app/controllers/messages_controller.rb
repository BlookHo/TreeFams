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
      flash[:notice] = "Удаление твоего диалога с #{@user_dialogue_name} - завершено"
    end
  end


  # Пометка в БД выбранного сообщения как Удаленного
  # @param data [params[:message_id]] ID выбранного для удаления сообщения - из view
  #
  def delete_message

    unless params[:message_id].blank?
      @message_id_to_delete = params[:message_id]  # to js
      Message.delete_one_message(params[:message_id], current_user)
      flash[:notice] = "Сообщение удалено"
    end

  end

  # Пометка сообщения как Важного (important_message) и обратно - в Неважное
  # @param data [params[:message_id]] ID помеченного как важного сообщения - из view
  def mark_important
    unless params[:message_id].blank?
      Message.important_message(params[:message_id], current_user ) #
      flash[:notice] = "Сообщение помечено как важное"
      #@mark_important = message.important  # to js
      # todo: отображение изменения значения (js)
    end
  end

  # later - Пометка сообщения как Spam
  def spam_dialoge
    user_id = params[:user_id] # From view
    #
  end

  # Создание и сохранение нового сообщения
  def send_message

    @receiver_id = params[:receiver_id]#.to_i # From view
    @receiver_id.present? ? @display_receiver_name = User.show_user_name(@receiver_id, 2) : @receiver_name = ''
    @text = params[:text] # From view
    Message.create(text: @text, receiver_id: @receiver_id, sender_id: current_user.id) if !(@receiver_id.blank? || @text.blank?)

  end




end
