class Message < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :text, :receiver_id, :sender_id, :message => "Должно присутствовать в Messages"
  validates_numericality_of :receiver_id, :sender_id, :only_integer => true, :message => "ID автора сообщения или получателя сообщения должны быть целым числом в Messages"
  validates_numericality_of :receiver_id, :sender_id, :greater_than => 0, :message => "ID автора сообщения или получателя сообщения должны быть больше 0 в Messages"

  validates_inclusion_of :read, :sender_deleted, :receiver_deleted, :in => [true, false]

  validates_length_of :text, :minimum => 2, :maximum => 420, :message => "Поле текста сообщения должно быть длиной от 2 до 420 символов в Messages"

  # Найти всех контрагентов current_user по сообщениям
  # Исп-ся при отображении сообщений
  # @param data [current_user] текущий юзер - logged_in
  def self.find_agents(current_user)
    agents_senders = self.where(receiver_id: current_user.id, receiver_deleted: false).pluck(:sender_id).uniq
    agents_receivers = self.where(sender_id: current_user.id, sender_deleted: false).pluck(:receiver_id).uniq
    (agents_senders + agents_receivers).uniq
  end

  # Формирование выходного массива
  # для отображения сообщений в вьюхе
  # @param data [current_user] текущий юзер - logged_in
  def self.view_messages_data(agents_talks, current_user)
    talks_and_messages = []
    agents_talks.each do |user_id|
      talks_and_messages << Message.get_user_messages(user_id, current_user)
    end
    talks_and_messages
  end

  # Получаем массив сообщений для одного юзера
  # чтение всех сообщений получателем при открывании диалога
  # @param data [current_user] текущий юзер - logged_in
  def self.get_user_messages(user_id, current_user)
    user_dialoge = {}
    user_messages = []
    user_name = User.show_user_name(user_id, 4)

    #one_user_talk =  self.where(receiver_deleted: false).where(sender_deleted: false).where("(receiver_id = #{current_user.id} and sender_id = #{user_id}) or (sender_id = #{current_user.id} and receiver_id = #{user_id})").order('created_at').reverse_order
    one_user_talk =  self.where("(receiver_id = #{current_user.id} and receiver_deleted = #{false} and sender_id = #{user_id}) or (sender_id = #{current_user.id} and sender_deleted = #{false} and receiver_id = #{user_id})").order('created_at').reverse_order
    one_user_talk.each do |one_message|
      sender_name = User.show_user_name(one_message.sender_id, 0)

      one_message_hash = {
       one_message_user_name: user_name,
       one_message_id: one_message.id,
       one_message_text: one_message.text,
       one_message_sender_id: one_message.sender_id,
       one_message_sender_name: sender_name,

       one_message_receiver_id: one_message.receiver_id,
       one_message_read: one_message.read,
       one_message_sender_deleted: one_message.sender_deleted,
       one_message_receiver_deleted: one_message.receiver_deleted,
       one_message_important: one_message.important
      }
      user_messages << one_message_hash
      # чтение одного сообщения получателем при открывании всего диалога
      one_message.read_one_message(one_message, current_user)
    end

    user_dialoge.merge!(user_id => user_messages)
  end


  # чтение всех сообщений получателем при открывании диалога
  # Если текущий юзер явл-ся получателем
  # используется для управления отображения сообщений
  # @param data [current_user] текущий юзер - logged_in
  def read_one_message(message, current_user)
    #logger.info "Bef: message.id = #{message.id}, message.read = #{message.read}"
    message.read = true if !message.read && message.receiver_id == current_user.id
    message.save
    #logger.info "Aft: message.id = #{message.id}, message.read = #{message.read}"

    ## NOTIFICATION #### Установка уведомлений отправителю  ########

  end

  # чтение всех сообщений получателем при открывании диалога
  # Если текущий юзер явл-ся получателем
  # используется для управления отображения сообщений
  # @param data [current_user] текущий юзер - logged_in
  def important_message(message, current_user) #, choosed_message_id)
    message.important = true if !message.important &&
        (message.receiver_id == current_user.id ||
            message.sender_id == current_user.id )
    message.save

    ## NOTIFICATION #### Установка уведомлений отправителю  ########

  end

  # Удаление одного диалога - всех взаимных сообщений с Юзером = user_talk_id
  # @param data [current_user] текущий юзер - logged_in
  def self.delete_one_dialogue(user_dialogue, current_user) #, choosed_message_id)

    one_user_talk =  Message.where("(receiver_id = #{current_user.id} and receiver_deleted = #{false} and sender_id = #{user_dialogue}) or (sender_id = #{current_user.id} and sender_deleted = #{false} and receiver_id = #{user_dialogue})")
    one_user_talk.each do |one_message|
      one_message.receiver_deleted = true if one_message.receiver_id == current_user.id
      one_message.sender_deleted = true if one_message.sender_id == current_user.id
      one_message.save
    end

  end



end
