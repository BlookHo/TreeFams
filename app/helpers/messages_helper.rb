# encoding: utf-8
module MessagesHelper

  def count_messages  #(check = false, *user_id) #подсчитывает количество новых писем у юзера
    if current_user
      user_id = current_user.id # if user_id.blank?
      new_messages_count = Message.where(receiver_id: current_user.id, read:false, receiver_deleted: false).count

      #unless check == true
      #  session[:new_messages] = {:value => @new_mail_count, :updated_at => Time.current}
      #end
      #if session[:new_messages].blank?
      #  session[:new_messages] = {:value => @new_mail_count, :updated_at => Time.current}
      #end

    end
    return new_messages_count
  end

  def input_messages(input_messages) #хэш для отображения входящих сообщений юзера
    display_messages = []
    input_messages.each do |message|
      sender = User.find(message.sender_id)
      follower = Follower.where(reader_id: current_user.id, writer_id: message.sender_id, active: true).any? ? true : false
      display_messages << {text: message.text, user_id: message.sender_id, nick: sender.nick, avatar: sender.avatar.url(:medium), created_at: message.created_at, read: message.read, message_id: message.id, type: "inbox", follower: follower}
    end
    display_messages
  end

  def sent_messages(sent_messages) #хэш отправленных сообщений юзера
    display_messages = []
    sent_messages.each do |message|
      receiver = User.find(message.receiver_id)
      follower = Follower.where(reader_id: current_user.id, writer_id: message.receiver_id, active: true).any? ? true : false
      display_messages << {text: message.text, user_id: message.receiver_id, nick: receiver.nick, avatar: receiver.avatar.url(:medium), created_at: message.created_at, read: message.read, message_id: message.id, type: "sent", follower: follower}
    end
    display_messages
  end

end