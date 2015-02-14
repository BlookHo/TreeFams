class HomeController < ApplicationController

  before_filter :logged_in?
  layout 'application.new'


  # All profiles in user's tree
  def index
    # flash.now[:warning] = "Alert message from server!"
    tree_info, sim_data, similars = current_user.start_similars
    # todo: проверить: убрать запуск метода SimilarsLog.current_tree_log_id и взять @log_connection_id из sim_data
    # для отображения в show_similars_data
    @log_connection_id = SimilarsLog.current_tree_log_id(tree_info[:connected_users]) unless tree_info.empty?
    unless similars.empty?  # т.е. есть похожие
      # flash_obj = {
      #   type: :alert,
      #   message: "Предупреждение: В дереве есть 'похожие' профили. Если не добавить профили, то объединиться с другим деревом будет невозможно",
      #   link: internal_similars_search_path
      # }
      # flash.now[:link] = flash_obj # unless similars.empty?
      flash.now[:warning] = "Warning from server! Предупреждение: В дереве есть 'похожие' профили. Если не добавить профили, то объединиться с другим деревом будет невозможно..."
      unless sim_data.empty?  #  т.е. есть новые похожие - отлич. от ранее записанных
        @tree_info = tree_info  # To View
        view_tree_data(tree_info, sim_data) unless tree_info.empty?
        render :template => 'similars/show_similars_data' # показываем инфу о похожих
      end
    end
  end


  def show
  end


  def search
  end



  private

  # # Для текущего дерева - получение номера id лога для прогона разъединения Похожих,
  # # ранее объединенных.
  # # Последний id (максимальный) из существующих логов - :connected_at
  #  def current_tree_log_id(connected_users)
  #   # Сбор всех id логов, относящихся к текущему дереву
  #   current_tree_logs_ids = SimilarsLog.where(current_user_id: connected_users).pluck(:connected_at).uniq
  #   # logger.info "In SimilarsStart 1b: @current_tree_logs_ids = #{current_tree_logs_ids} " unless current_tree_logs_ids.blank?
  #   current_tree_logs_ids.max
  # end


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

  end


end
