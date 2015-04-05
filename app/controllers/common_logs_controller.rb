class CommonLogsController < ApplicationController
  include CommonLogsHelper

  layout 'application.new'

  before_filter :logged_in?

  # Show All types of Common_logs for connected_users
  def index
    # get & show tree data
    tree_info = Tree.get_tree_info(current_user)
    # logger.info "In CommonLog: tree_info[:connected_users] = #{tree_info[:connected_users]}, tree_info = #{tree_info} "

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
      # flash[:notice] = "Изменена пометка mark_rollback"
      @common_log_type = CommonLog.find(params[:common_log_id].to_i).log_type
      @common_log_date = CommonLog.find(params[:common_log_id].to_i).created_at#.strftime("%F")
      @log_date_to_show = @common_log_date.strftime("%F")
    end
    respond_to do |format|
      format.html
      format.js { render 'common_logs/mark_rollback' }
    end
  end


  # todo: All types of rollback
  # @note Возврат дерева - откат на выбранную дату
  # вставить этот метод в вызов в _rollback_adds
  # поменять название /
  # @param params[:rollback_date]
  # @param params[:rollback_id]
  def rollback_logs
    rollback_date = params[:rollback_date]
    rollback_id   = params[:rollback_id]
    connected_users_arr = current_user.get_connected_users
    logger.info "In CommonLog controller: rollback_logs      rollback_id = #{rollback_id},  rollback_date = #{rollback_date} "
    common_logs_arr = CommonLog.where(user_id: connected_users_arr) # current_user.id)
                       .where("id >= ?", rollback_id)    # .where("created_at > #{rollback_date}")
                       .order("created_at DESC")
    common_logs_arr.each do |common_log|
      case common_log.log_type
        when 1 #  Добавление профиля
          logger.info "In CommonLog controller: rollback_logs:   common_log.log_type = #{common_log.log_type}, common_log.id = #{common_log.id} "
          rollback_add_profile(common_log.id)
        when 2 #  Удаление профиля
          rollback_delete_profile(common_log.id)
        when 3 #  Объединение похожих профилей в одном дереве
          rollback_similars_profiles(common_log.id)
        when 4 #  Объединение деревьев
          rollback_connection_trees(common_log.id)
        else
          @error = "Тип лога - не определен! common_log.log_type = #{common_log.log_type} "
      end
    end

    logger.info "In CommonLog controller: After All rollback_logs: Возврат дерева в состояние на выбранную дату.
                     rollback_date = #{rollback_date}"
    # flash.now[:info] = "Возврат дерева в состояние на выбранную дату. rollback_date = #{rollback_date} "
  end


  # @note Возврат Add Logs
  #   Возврат дерева - откат на выбранную дату
  # @param params[:rollback_date]
  # @param params[:rollback_id]
  def rollback_add_profile(common_log_id)
    profile_id = CommonLog.find(common_log_id).profile_id
    rollback_add_log_data = { current_user:  current_user,
                                  log_type:  1,
                                profile_id:  profile_id,
                             common_log_id:  common_log_id }

    CommonLog.rollback_add_one_profile(rollback_add_log_data)
  end

  # @note Возврат delete Logs
  # @note Возврат дерева - откат на выбранную дату
  # @param params[:rollback_date]
  # @param params[:rollback_id]
  def rollback_delete_profile(common_log_id)
    one_common_log = CommonLog.find(common_log_id)
    destroy_log_data = {current_user:     current_user,
                        log_type:         2,
                        profile_id:       one_common_log.profile_id,
                        base_profile_id:  one_common_log.base_profile_id,
                        relation_id:      one_common_log.relation_id,
                        common_log_id:    common_log_id   }

    CommonLog.rollback_destroy_one_profile(destroy_log_data)
    # logger.info "In CommonLog controller: rollback_delete_profile для common_log_id = #{common_log_id},
    #                                destroy_log_data = #{destroy_log_data} "
  end


  # @note Add Logs
  # @note Возврат дерева - откат на выбранную дату
  # @param params[:rollback_date]
  # @param params[:rollback_id]
  def rollback_similars_profiles(common_log_id)

    logger.info "In CommonLog controller: rollback_similars_profiles для common_log_id = #{common_log_id} "

  end

  # @note Disconnect
  #    Возврат дерева - откат на выбранную дату
  # @param params[:rollback_date]
  # @param params[:rollback_id]
  def rollback_connection_trees(common_log_id)

    logger.info "In CommonLog controller: rollback_connection_trees для common_log_id = #{common_log_id.inspect} "
    # Не заблокировано ли дерево пользователя
    if current_user.tree_is_locked?
      flash[:warning] = "Объединения в данный момент невозможно. Временная блокировка пользователя.
                     Можно повторить попытку позже."
      return redirect_to home_path #:back
    else
      current_user.lock!
    end

    # common_log_row_fields = CommonLog.find(common_log_id).attributes.except('created_at','updated_at')
    # # expect(common_log_row_fields).to eq({
    # # "id"=>1,
    # # "user_id"=>1,
    # # "log_type"=>4,
    # # "log_id"=>3,
    # # "profile_id"=>17,
    # #  "base_profile_id"=>14,
    # # "relation_id"=>999} )
    #
    # # with_user_id = User.where(profile_id: common_log_row_fields["base_profile_id"])
    # conn_users_destroy_data = {
    #     user_id: common_log_row_fields["user_id"], #    1,
    #     with_user_id: User.where(profile_id: common_log_row_fields["base_profile_id"]),    #        3,
    #     connection_id: common_log_row_fields["log_id"]   #    3,
    # }
    one_common_log = CommonLog.find(common_log_id)
    logger.info "In CommonLog controller: rollback_connection_trees: common_log_id = #{common_log_id.inspect} "
    logger.info "In CommonLog controller: rollback_connection_trees: one_common_log = #{one_common_log.inspect} "

    ############ call of User.module Disconnection_tree #####################
    current_user.disconnect_tree(common_log_id)

    ##########  UPDATES FEEDS - № 2  ############## В обоих направлениях: Кто с Кем и Обратно
    # profile_id:       one_common_log.profile_id,
    base_profile_id =  one_common_log.base_profile_id
    agent_user_id = Profile.find(base_profile_id).user_id

    logger.info "In CommonLog controller: rollback_connection_trees: base_profile_id = #{base_profile_id.inspect} "
    logger.info "In CommonLog controller: rollback_connection_trees: agent_user_id = #{agent_user_id.inspect} "

    # logger.info "== in connection_of_trees UPDATES :  profile_current_user = #{profile_current_user}, profile_user_id = #{profile_user_id} "
    UpdatesFeed.create(user_id: current_user.id, update_id: 17, agent_user_id: one_common_log.user_id, agent_profile_id: one_common_log.profile_id, read: false)
    UpdatesFeed.create(user_id: one_common_log.user_id, update_id: 17, agent_user_id: current_user.id, agent_profile_id: current_user.profile_id, read: false)
    ###############################################


    current_user.unlock_tree! # unlock tree

  end




end
