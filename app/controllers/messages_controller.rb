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

    user_id = params[:user_talk_id] # From view
    @new_messages_count = count_new_messages  # To show in View
    agents_talks = Message.find_agents(current_user) # find all contragent of current_user by messages
    @talks_and_messages = Message.view_messages_data(agents_talks, current_user)  # To show in View
    @one_dialoge_length = 1
  end



  # Получаем диалог одного юзера
  def show_one_dialoge

      @new_messages_count = count_new_messages
      #logger.info "== show_one_dialoge == @new_messages_count = #{@new_messages_count}"

      user_id = params[:user_talk_id] # From view

      @talks_and_messages = []
      user_dialoge = Message.get_user_messages(user_id, current_user)
      @talks_and_messages << user_dialoge
      @one_dialoge_length = user_dialoge[user_id].length if !user_dialoge[user_id].blank?

  end

  def delete_one_dialoge


  end


  # Пометка в БД выбранного сообщения как Удаленного
  #
  def delete_message

    message = Message.find(params[:message_id])
    if message.receiver_id == current_user.id
      message.receiver_deleted = true
      message.save
      user_id = message.sender_id
      check_deletion(message)
    else
      flash[:error] = "Ты не можешь удалить это сообщение"
    end
    if message.sender_id == current_user.id
      message.sender_deleted = true
      message.save
      user_id = message.receiver_id
      check_deletion(message)
    else
      flash[:error] = "Ты не можешь удалить это сообщение"
    end
    redirect_to show_one_dialoge_path(user_id: user_id)

  end

  # Сигнал-я о корректности "удаления"
  def check_deletion(message)
    if message.persisted?
      flash[:success] = "Письмо удалено"
    else
      flash[:error] = "Ошибки при удалении письма"
    end
  end

  # Пометка сообщения как Важного (important_message)
  def important_message
    message = Message.find(params[:message_id]) # From view
    if message.receiver_id == current_user.id || message.sender_id == current_user.id
      if !message.important
        message.important = true
        message.save
        if message.receiver_id == current_user.id
          user_id = message.sender_id
        elsif message.sender_id == current_user.id
          user_id = message.receiver_id
        end
      end
      redirect_to show_one_dialoge_path(user_id: user_id)
    else
      flash[:error] = "Ты не можешь удалить это сообщение"
    end
  end

  # later - Пометка сообщения как Spam
  def spam_dialoge
    user_id = params[:user_id] # From view
    #

  end


  # Создание и сохранение нового сообщения
  def create_new_message

    receiver_id = params[:receiver_id] # From view
    text = params[:text] # From view

    if !(receiver_id.blank? || text.blank?)

      @receiver_id = receiver_id # # DEBUGG_TO_VIEW
      @text = text #params[:text] # # DEBUGG_TO_VIEW
      logger.info "receiver_id = #{receiver_id}, text = #{text}" # DEBUGG_TO_VIEW

      message = Message.new(text: text, receiver_id: receiver_id, sender_id: current_user.id)
      message.save

      ## NOTIFICATION #### Установка уведомлений  получателю  ########

    end

  end


end
