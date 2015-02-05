class HomeController < ApplicationController

  before_filter :logged_in?
  layout 'application.new'


  # All profiles in user's tree
  def index
    tree_info, sim_data, similars = current_user.start_similars
    @log_connection_id = current_tree_log_id(tree_info[:connected_users]) unless tree_info.empty?

    if sim_data.empty?
      # if similars.empty?
        #flash[:notice] = "В дереве - все Ок. - /home/index"
      # else
        flash.now[:alert] = "Предупреждение: В дереве есть 'похожие' профили. Объединиться будет невозможно - /home/index" unless similars.empty?
      # end
    else
      flash.now[:alert] = "Предупреждение: В дереве есть 'похожие' профили. Объединиться будет невозможно - /home/index"
      @tree_info = tree_info  # To View
      view_tree_data(tree_info, sim_data) unless @tree_info.empty?
      render :template => 'similars/show_similars_data'
    end
  end


  def show
  end


  def search
  end



  private

  # Для текущего дерева - получение номера id лога для прогона разъединения Похожих,
  # ранее объединенных.
  # Последний id (максимальный) из существующих логов - :connected_at
  def current_tree_log_id(connected_users)
    # Сбор всех id логов, относящихся к текущему дереву
    current_tree_logs_ids = SimilarsLog.where(current_user_id: connected_users).pluck(:connected_at).uniq
    logger.info "In SimilarsStart 1b: @current_tree_logs_ids = #{current_tree_logs_ids} " unless current_tree_logs_ids.blank?
    log_connection_id = current_tree_logs_ids.max
    logger.info "In SimilarsStart 1b: MAX log_connection_id = #{log_connection_id} " unless log_connection_id.blank?
    log_connection_id
  end


  # Отобр-е параметров дерева и sim_data во вьюхе
  def view_tree_data(tree_info, sim_data)

    @tree_info = tree_info
    logger.info "In similars_contrler 1:  @tree_info[:connected_users] = #{tree_info[:connected_users]}, @tree_info = #{tree_info},  "  if !tree_info.blank?
    logger.info "In similars_contrler 1a: @tree_info.profiles.size = #{tree_info[:profiles].size} "  if !tree_info.blank?
   # @log_connection_id = sim_data[:log_connection_id]
    @current_user_id = current_user.id

    view_similars(sim_data) unless sim_data.empty?

  end


  # Отображение во вьюхе Похожих и - для них - непохожих, если есть
  def view_similars(sim_data)

    @sim_data = sim_data  #
    logger.info "In similars_contrler 01:  @sim_data = #{@sim_data} "
    @similars = sim_data[:similars]
    @similars_qty = @similars.size unless sim_data[:similars].empty?
    #################################################
    @paged_similars_data = pages_of(@similars, 10) # Пагинация - по 10 строк на стр.
    ################################################
    unless sim_data[:unsimilars].empty?
      @unsimilars = sim_data[:unsimilars]
      @unsimilars_qty = @unsimilars.size
    end

  end


end
