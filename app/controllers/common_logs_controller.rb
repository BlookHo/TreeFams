class CommonLogsController < ApplicationController
  include CommonLogsHelper

  layout 'application.new'

  before_filter :logged_in?


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

    # get & show common_logs_data
    common_logs_data = CommonLog.collect_common_logs(current_user)
    logger.info "In CommonLog controller: common_logs_data = #{common_logs_data} "
    view_common_logs_data(common_logs_data) unless common_logs_data.empty?  # to index.html.haml


  end

  def create
  end

  def show
  end

  def destroy
  end
end
