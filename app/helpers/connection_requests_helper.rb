module ConnectionRequestsHelper

  # подсчет новых, полученных current_user, необработанных запросов на рукопожатия
  def count_new_requests  #
    @new_requests_count = ConnectionRequest.where(:user_id => current_user.id).select(:created_at).distinct.order('created_at').reverse_order.count if current_user
    #logger.info "current_user.id = #{current_user.id}"
    #logger.info "@new_requests_count = #{@new_requests_count}"
  end





end
