class HomeController < ApplicationController

  before_filter :logged_in?
  layout 'application.new'


  # All profiles in user's tree
  def index
    tree_info, sim_data = current_user.start_similars
    if !sim_data.empty?
      @tree_info = tree_info  # To View
      @log_connection_id = current_tree_log_id(tree_info[:connected_users]) unless tree_info.empty?
      view_tree_data(tree_info, sim_data) unless @tree_info.empty?
      render :template => 'similars/internal_similars_search'
    end
  end


  def show
  end


  def search
  end



  private

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
