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
    # log_type = 1
    tree_add_logs = CommonLog.get_tree_add_logs(tree_info[:connected_users]) #, log_type)

    # get & show connected tree all types common_logs
    view_common_logs_data(tree_add_logs) unless tree_add_logs.empty?  # to index.html.haml
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
  # @note Общий Возврат дерева - откат на выбранную дату
  # вставить этот метод в вызов в _rollback_adds
  # поменять название /
  # @param params[:rollback_date]
  # @param params[:rollback_id]
  def rollback_logs
    rollback_date = params[:rollback_date]
    rollback_id   = params[:rollback_id]
    logger.info "In CommonLog controller: rollback_logs      rollback_id = #{rollback_id},  rollback_date = #{rollback_date} "
    common_logs_arr = CommonLog.where(user_id: current_user.id)
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


  # @note Add Logs
  # @note Возврат дерева - откат на выбранную дату
  # @param params[:rollback_date]
  # @param params[:rollback_id]
  def rollback_add_profile(common_log_id)
    one_common_log = CommonLog.find(common_log_id)
    profile_id = one_common_log.profile_id
    CommonLog.rollback_add_one_profile(current_user, 1, profile_id)
    logger.info "In CommonLog controller: rollback_add_profile After rollback_destroy "
  end

  # @note Add Logs
  # @note Возврат дерева - откат на выбранную дату
  # @param params[:rollback_date]
  # @param params[:rollback_id]
  def rollback_delete_profile(common_log_id)
    one_common_log = CommonLog.find(common_log_id)
    base_profile_id = one_common_log.base_profile_id
    profile_id = one_common_log.profile_id
    relation_id = one_common_log.relation_id

    CommonLog.rollback_destroy_one_profile(current_user, 2, profile_id, base_profile_id, relation_id)
    logger.info "In CommonLog controller: rollback_delete_profile для common_log_id = #{common_log_id},
                                   profile_id = #{profile_id} ,   base_profile_id = #{base_profile_id}"
  end


  # @note Add Logs
  # @note Возврат дерева - откат на выбранную дату
  # @param params[:rollback_date]
  # @param params[:rollback_id]
  def rollback_similars_profiles(common_log_id)

    logger.info "In CommonLog controller: rollback_similars_profiles для common_log_id = #{common_log_id} "

  end

  # @note Add Logs
  # @note Возврат дерева - откат на выбранную дату
  # @param params[:rollback_date]
  # @param params[:rollback_id]
  def rollback_connection_trees(common_log_id)

    logger.info "In CommonLog controller: rollback_connection_trees для common_log_id = #{common_log_id} "

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
