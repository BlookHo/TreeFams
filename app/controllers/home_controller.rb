
class HomeController < ApplicationController

  before_filter :logged_in?
  layout 'application.new'
  include SimilarsHelper

  # All profiles in user's tree
  def index

    # Start weekly manifest emails deliver - to debug local
    # WeafamMailer.weekly_manifest_email.deliver_now
# User.send_weekly_manifest

    @similars = []
    logger.info "## current_user = #{current_user.id} ## In home/index: Before similars_results_exists?"

    if SimilarsFound.similars_results_exists?(current_user.id)
      @similars = [""]
    else
      search_event = 100
      results = SearchResults.start_search_methods(current_user, search_event)
      logger.info "########## In home/index: results = #{results} "

       if results.has_key?(:similars)
         @similars = results[:similars]
         logger.info "########## In home/index: @similars = #{@similars} "
         @log_connection_id = results[:log_connection_id]
         @tree_info = results[:tree_info]

         unless @similars.empty?  # т.е. есть похожие
           flash.now[:warning] = "Warning from server! Предупреждение: В дереве есть 'похожие' профили. Если не добавить профили, то объединиться с другим деревом будет невозможно..."
           view_tree_similars(@tree_info, @similars) #unless @tree_info.empty?
           render :template => 'similars/show_similars_data' # показываем инфу о похожих
         end
      end
    end

      # todo: проверить: убрать запуск метода SimilarsLog.current_tree_log_id и взять @log_connection_id из sim_data
      # для отображения в show_similars_data
      # @log_connection_id = SimilarsLog.current_tree_log_id(@tree_info[:connected_users]) unless @tree_info.empty?

  end


  def show
  end

  def show_similars

    similars_data = current_user.start_similars
    @tree_info = similars_data[:tree_info]
    new_sims = similars_data[:new_sims]
    @similars = similars_data[:similars]

    unless @similars.empty?  # т.е. есть похожие
      flash.now[:warning] = "Warning from server! Предупреждение: В дереве есть 'похожие' профили. Если не добавить профили, то объединиться с другим деревом будет невозможно..."
      unless new_sims==""   #.empty?  #  т.е. есть новые похожие - отлич. от ранее записанных
        view_tree_similars(@tree_info, @similars) unless @tree_info.empty?
        render 'similars/show_similars_data' # показываем инфу о похожих
      end
    end

  end


  def search
  end



end



