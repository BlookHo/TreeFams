# encoding: utf-8



class PagesController < ApplicationController
#  include PlacesCache

  # Главная страница. Готовит новости, причины и места к отображению.
  # @note GET /
  # @note Также вызывается в случае пагинации. Тогда выдает либо пагинацию новостей, либо пагинацию причин.
  # @param news_page [Integer] опциональный номер страницы пагинации новостей
  # @see News
  # @see Paginated
  # @see Place
  def index
    if params[:news_page].present?
      render_file = paginate_news
    elsif params[:reasons_page].present?
      render_file = paginate_reasons
    else
      render_file = initial_index
    end

    respond_to do |format|
      format.html
      format.js { render render_file }
    end
  end






end
