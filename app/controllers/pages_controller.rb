# encoding: utf-8



class PagesController < ApplicationController
#  include PlacesCache

  #@session_id = request.session_options[:id]



  # Главная страница. Готовит новости, причины и места к отображению.
  # @note GET /
  # @note Также вызывается в случае пагинации. Тогда выдает либо пагинацию новостей, либо пагинацию причин.
  # @param news_page [Integer] опциональный номер страницы пагинации новостей
  # @see News
  # @see Paginated
  # @see Place
  #def index
  ##  if params[:news_page].present?
  ##    render_file = paginate_news
  ##  elsif params[:reasons_page].present?
  ##    render_file = paginate_reasons
  ##  else
  ##    render_file = initial_index
  ##  end
  ##
  ##  respond_to do |format|
  ##    format.html
  ##    format.js { render render_file }
  ##  end
  #end


  # Стартовая страница. На ней - вход на сайт. Если первый раз - то переход к вводу БК.
  # Если уже зареген, то переход на Главную страницу - отображение древа и т.п..
  # @note GET /
  # @note
  # @param start_page [Integer] опциональный номер страницы пагинации новостей
  # @see News
  # @see Paginated
  # @see Place
  def start

    @first_var = "Первая переменная - START"

    #admin

  end

  # Админа страница. Запуск админских методов, просмотр всех таблиц.
  # @note GET /
  # @note
  # @param admin_page [Integer] опциональный номер страницы пагинации новостей
  # @see News
  # @see Paginated
  # @see Place
  def admin

    @first_var = "Первая переменная - ADMIN"

  end



end # КОНЕЦ КОНТРОЛЛЕРА PAGES
