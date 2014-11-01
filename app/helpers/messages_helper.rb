# encoding: utf-8
module MessagesHelper

  # подсчет новых, полученных current_user, непрочитанных сообщений
  def count_new_messages  #
    @new_messages_count = Message.where(receiver_id: current_user.id, read:false, receiver_deleted: false).count if current_user
    #logger.info "in _header: @new_messages_count = #{@new_messages_count}"
  end


end