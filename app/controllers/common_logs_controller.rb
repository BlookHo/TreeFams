class CommonLogsController < ApplicationController
  include CommonLogsHelper

  layout 'application.new'

  before_filter :logged_in?

  # Show All types of Common_logs for connected_users
  def index
    # get & show tree data
    # tree_info = CommonLog.collect_tree_info(current_user)
    tree_info = Tree.get_tree_info(current_user)
    logger.info "In CommonLog: tree_info[:connected_users] = #{tree_info[:connected_users]}, tree_info = #{tree_info} "

    # to show similars connected in view & for RSpec
    @tree_info = tree_info
    @connected_users = tree_info[:connected_users]
    @current_user_id = current_user.id
    view_tree_data(tree_info) unless tree_info.empty?  # to index.html.haml

    # get & show one tree add_profiles common_logs
    log_type = 1
    tree_add_logs = CommonLog.get_tree_add_logs(current_user.id, log_type)
    logger.info "In CommonLog controller: tree_add_logs = #{tree_add_logs} "

    # get & show connected tree all types common_logs
    # common_logs_data = CommonLog.collect_common_logs(tree_info[:connected_users])
    # logger.info "In CommonLog controller: common_logs_data = #{common_logs_data} "

    view_common_logs_data(tree_add_logs) unless tree_add_logs.empty?  # to index.html.haml
  end

  # Add Logs
  # Возврат дерева - откат на выбранную дату
  def rollback_add_logs
    rollback_date  = params[:rollback_date]#.to_i
    logger.info "In CommonLog controller: rollback_add_logs      rollback_date = #{rollback_date} "

    flash.now[:notice] = "Возврат дерева в состояние на выбранную дату. rollback_date = #{rollback_date} "


  end


  # def new
  #   one_common_log = CommonLog.new
  #   one_common_log.user_id = common_log_data[:user_id]
  #   one_common_log.log_type = common_log_data[:log_type]
  #   one_common_log.log_id = common_log_data[:log_id]
  #   one_common_log.profile_id = common_log_data[:profile_id]
  #
  # end
  #
  #
  # def create
  #   one_common_log = CommonLog.new(params[:common_log])
  #   # one_common_log.sender_id = current_user.id
  #   if one_common_log.save
  #     flash.now[:notice] = "Cообщение отправлено"
  #   else
  #     flash.now[:alert] = "Ошибка при отправке сообщения"
  #     # render :new
  #   end

    # connected_users = common_log_data[:user_id]#.get_connected_users
    # logger.info "In CommonLog model: create_common_log: connected_users = #{connected_users} "
    # # connected_users = 2
    #
    #
    # one_common_log = self.new
    # common_log.user_id = common_log_data[:user_id]
    # common_log.log_type = common_log_data[:log_type]
    # common_log.log_id = common_log_data[:log_id]
    # common_log.profile_id = common_log_data[:profile_id]
    # logger.info "In CommonLog model: create_common_log: common_log = #{common_log} "
    #
    # if common_log.save
    #   logger.info "In CommonLog model: create_common_log: good save "
    # else
    #   flash.now[:alert] = "Ошибка при создании CommonLog"
    #   logger.info "In CommonLog model: create_common_log: BAD save "
    # end

  # end


end
