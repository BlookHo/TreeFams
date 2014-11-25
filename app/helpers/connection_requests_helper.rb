module ConnectionRequestsHelper

  # подсчет новых, полученных current_user, необработанных запросов на рукопожатия
  def count_new_requests  #
    @new_requests_count = ConnectionRequest.where(:with_user_id => current_user.id, :done => false ).select(:created_at).distinct.order('created_at').reverse_order.count if current_user
    #logger.info "current_user.id = #{current_user.id}"
    #logger.info "@new_requests_count = #{@new_requests_count}"
  end

  # Найти все запросы, в которых участвуют члены нового объединенного дерева
  # 1.Get connected users - arr
  # where(user-id - in Arr and with_user in Arr)
  # set to DONE all.
  def after_conn_update_requests
    new_tree_users = current_user.get_connected_users
    @new_tree_users = new_tree_users  # DEBUGG_TO_VIEW
    # arr = [11,2,14,7]
    #  @str_arr = arr.map(&:inspect).join('; ')
    #  @str_arr = arr.join('; ')

    # Find Array of all requests - included in just connected
    @requests_from_arr = ConnectionRequest.where("user_id in (?)", new_tree_users).pluck(:connection_id).uniq
    @requests_with_arr = ConnectionRequest.where("with_user_id in (?)", new_tree_users).pluck(:connection_id).uniq
    @all_requests_to_update = (@requests_from_arr + @requests_with_arr).uniq

    # Update all included requests - just connected
    @all_requests_to_update.each do |connection_id|
      requests_to_update = ConnectionRequest.where(:connection_id => connection_id, :done => false )
      if !requests_to_update.blank?
        requests_to_update.each do |request_row|
          request_row.done = true
          request_row.confirm = 2 # for all requests - system done
          request_row.save
        end
        logger.info "All just connected update_requests DONE!"
      else
        logger.info "WARNING: NO update_requests!"
        #redirect_to show_user_requests_path
        # flash - no connection requests data in table
      end
    end

  end




end
