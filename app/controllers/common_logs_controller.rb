class CommonLogsController < ApplicationController
  include CommonLogsHelper

  layout 'application.new'

  before_filter :logged_in?

  # @note Show All types of Common_logs for connected_users
  def index
    # get & show tree data
    tree_info = Tree.get_tree_info(current_user)

    # to show similars connected in view & for RSpec
    @tree_info = tree_info
    @connected_users = tree_info[:connected_users]
    @current_user_id = current_user.id
    view_tree_data(tree_info) unless tree_info.empty?  # to index.html.haml

    # get one tree all types common_logs
    tree_all_logs = CommonLog.get_tree_all_logs(tree_info[:connected_users])

    # show connected tree all types common_logs
    view_common_logs(tree_all_logs) unless tree_all_logs.empty?  # to index.html.haml
  end


  # @note Пометка Common_log - граница отката дерева
  # @param params[:common_log_id]  ID помеченного Common_log - из view
  def mark_rollback
    unless params[:common_log_id].blank?
      @common_log_id = params[:common_log_id].to_i
      @common_log_type = CommonLog.find(params[:common_log_id].to_i).log_type
      @common_log_date = CommonLog.find(params[:common_log_id].to_i).created_at#.strftime("%F")
      @log_date_to_show = @common_log_date.strftime("%F")
    end
    respond_to do |format|
      format.html
      format.js { render 'common_logs/mark_rollback' }
    end
  end


  # @note Возврат дерева - откат на выбранную дату
  # @param params[:rollback_date]
  # @param current_user
  def rollback_logs
    rollback_id   = params[:rollback_id]
    CommonLog.rollback(rollback_id, current_user)
  end


end
