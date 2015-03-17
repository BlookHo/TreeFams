class CommonLogsController < ApplicationController
  include CommonLogsHelper

  layout 'application.new'

  before_filter :logged_in?

  # Show All types of Common_logs for connected_users
  def index
    # get & show tree data
    # tree_info = CommonLog.collect_tree_info(current_user)
    tree_info = Tree.get_tree_info(current_user)
    # logger.info "In CommonLog: tree_info[:connected_users] = #{tree_info[:connected_users]}, tree_info = #{tree_info} "

    # to show similars connected in view & for RSpec
    @tree_info = tree_info
    @connected_users = tree_info[:connected_users]
    @current_user_id = current_user.id
    view_tree_data(tree_info) unless tree_info.empty?  # to index.html.haml

    # get & show one tree add_profiles common_logs
    log_type = 1
    tree_add_logs = CommonLog.get_tree_add_logs(current_user.id, log_type)

    # get & show connected tree all types common_logs
    view_common_logs_data(tree_add_logs) unless tree_add_logs.empty?  # to index.html.haml
  end

  # @note Add Logs
  # @note Возврат дерева - откат на выбранную дату
  # @param params[:rollback_date]
  # @param params[:rollback_id]
  def rollback_add_logs
    rollback_date = params[:rollback_date]
    rollback_id   = params[:rollback_id]
    logger.info "In CommonLog controller: rollback_add_logs      rollback_id = #{rollback_id},  rollback_date = #{rollback_date} "
    log_type = 1
    profiles_arr = CommonLog.profiles_for_rollback(rollback_id, rollback_date, current_user.id, log_type)
    CommonLog.rollback_add(current_user, log_type, profiles_arr)
    logger.info "In CommonLog controller: rollback_add_logs After rollback_destroy "
    # flash.now[:warning] = "Возврат дерева в состояние на выбранную дату. rollback_date = #{rollback_date} "
  end


  # @note Пометка сообщения как Важного (important_message) и обратно - в Неважное
  # @param params[:common_log_id]  ID помеченного как важного сообщения - из view
  def mark_rollback
    unless params[:common_log_id].blank?
      @common_log_id = params[:common_log_id].to_i
      flash[:notice] = "Изменена пометка mark_rollback"
      @common_log_type = CommonLog.find(params[:common_log_id].to_i).log_type
      @common_log_date = CommonLog.find(params[:common_log_id].to_i).created_at#.strftime("%F")
      @log_date_to_show = @common_log_date.strftime("%F")
    end
    respond_to do |format|
      format.html
      format.js { render 'common_logs/mark_rollback' }
    end
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
