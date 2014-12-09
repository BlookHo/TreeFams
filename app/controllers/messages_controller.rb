# encoding: utf-8

class MessagesController < ApplicationController
  include MessagesHelper

  before_filter :logged_in?


  # if current_user # && !banned?

  # GET /messages
  # GET /messages.json
  # Показываем все диалоги текущего юзера
  # с возможностью перехода к просмотру одного выбранного диалога
  # с одним юзером.
  def index

    @receiver_id = params[:receiver_id].to_i #
    @text = params[:text] #

    @new_messages_count = count_new_messages
    find_agents # find all contragent of current_user by messages

    @talks_and_messages = []
    @agents_talks.each do |user_id|
      user_dialoge = get_user_messages(user_id)
      @talks_and_messages << user_dialoge
    end

  end



  ## NO USE with show_all_messages.html
  ## Получаем диалоги и сообщения всех контрагентов текущего юзера
  ## Альтернативное отображение.
  #def show_all_messages
  #
  #  @users_ids = User.all.pluck(:id)
  #
  #    @new_messages_count = count_new_messages
  #    logger.info "== show_all_messages == @new_messages_count = #{@new_messages_count}"
  #
  #    find_agents # find all contragent of current_user by messages
  #    @talks_and_messages = []
  #    @agents_talks.each do |user_id|
  #      user_dialoge = get_user_messages(user_id)
  #      @talks_and_messages << user_dialoge
  #
  #    end
  #
  #end
  #


  # Получаем диалоги всех контрагентов текущего юзера
  def show_all_dialoges

      @new_messages_count = count_new_messages
      logger.info "== show_all_dialoges == @new_messages_count = #{@new_messages_count}"
      find_agents # find all contragent of current_user by messages

      @talks_and_messages = []
      @agents_talks.each do |user_id|
        user_dialoge = get_user_messages(user_id)
        @talks_and_messages << user_dialoge
      end
    @new_mail_count = count_new_messages
    logger.info "===== @new_mail_count = #{@new_mail_count}"

  end

  # Получаем массив сообщений для одного юзера
  # чтение всех сообщений получателем при открывании диалога
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
      one_message_hash.merge!(:important => one_message.important)
      user_messages << one_message_hash

      # чтение одного сообщения получателем при открывании диалога
      if user_id == params[:user_id]
        read_one_message(one_message)
        one_message.save
      end

    end
    user_dialoge.merge!(user_id => user_messages)
    return user_dialoge
  end

  # чтение всех сообщений получателем при открывании диалога
  # используется для управления отображения сообщений
  def read_one_message(message)
    message.read = true  if !message.read && message.receiver_id == current_user.id

    ## NOTIFICATION #### Установка уведомлений отправителю  ########

  end


  # Получаем диалог одного юзера
  def show_one_dialoge

      @new_messages_count = count_new_messages
      #logger.info "== show_one_dialoge == @new_messages_count = #{@new_messages_count}"

      find_agents # find all contragent of current_user by messages
      user_id = params[:user_id] # From view

      @talks_and_messages = []
      user_dialoge = get_user_messages(user_id)
      @talks_and_messages << user_dialoge

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

  # Найти всех контрагентов current_user по сообщениям
  # Исп-ся при отображении сообщений
  def find_agents

    agents_senders = Message.where(:receiver_id => current_user.id).pluck(:sender_id).uniq
    agents_receivers = Message.where(:sender_id => current_user.id).pluck(:receiver_id).uniq
    #logger.info "@agents_senders = #{agents_senders}"
    #logger.info "@agents_receivers = #{agents_receivers}"

    @agents_talks = (agents_senders + agents_receivers).uniq

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
