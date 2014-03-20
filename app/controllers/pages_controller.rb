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

  # Входная страница. На ней - логин. Если уже зареген, то переход на Главную страницу - отображение древа и т.п..
  # или если впервые - переход на Стартовую стр-цу.
  # @note GET /
  # @note
  # @param login_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def login

    @first_var = "Первая переменная - LOGIN"

    #admin

  end


  # Стартовая страница. На ней - Ввод БК.
  # по завершении ввода БК, то переход на страницу регистрации.
  # @note GET /
  # @note
  # @param start_page [Integer] опциональный номер страницы
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
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def admin

    @first_var = "Первая переменная - ADMIN"

  end

  # Страница Регистрации.
  # @note GET /
  # @note
  # @param regis_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def registration

    @first_var = "Первая переменная - REGISTRATION"

  end

  # Страница Главная. - основная страница сайта. На ней отображение древа, все переходы и т.п.
  # @note GET /
  # @note
  # @param main_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def main

    @first_var = "Первая переменная - MAIN"

  end

  # Страница Новостей и Обновлений. На ней отображается инфа обо всех новостях и обновлениях юзера
  # @note GET /
  # @note
  # @param news_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def news

    @first_var = "Первая переменная - NEWS"
    @updates_count = 3  # кол-во обновлений - должно вычисляться отдельно в своем контроллере


  end

  # Страница Сообщений и Бесед Юзера. На ней отображаются инфа обо всех новостях и обновлениях юзера
  # @note GET /
  # @note
  # @param news_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def mail

    @first_var = "Первая переменная - MAIL"
    @new_mail_count = 13  # кол-во сообщений - должно вычисляться отдельно в своем контроллере


  end

  # Страница Сообщений и Бесед Юзера. На ней отображаются инфа обо всех новостях и обновлениях юзера
  # @note GET /
  # @note
  # @param settings_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def settings

    @first_var = "Первая переменная - SETTINGS"
#    @new_mail_count = 13  # кол-во сообщений - должно вычисляться отдельно в своем контроллере


  end


  # Страница Юзера: вся инфа о Юзере, настройки и т.д.
  # @note GET /
  # @note
  # @param settings_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def mypage

    @first_var = "Первая переменная - MYPAGE"
#    @new_mail_count = 13  # кол-во сообщений - должно вычисляться отдельно в своем контроллере


  end

  # Страница Поиска: поиск среди профилей и Юзеров.
  # @note GET /
  # @note
  # @param settings_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def search

    @first_var = "Первая переменная - SEARCH"
#    @new_mail_count = 13  # кол-во сообщений - должно вычисляться отдельно в своем контроллере


  end

  # Страница общения Юзера: темы беседы события сообщения.
  # @note GET /
  # @note
  # @param conversation_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def conversation

    @first_var = "Первая переменная - CONVERSATION"
#    @new_mail_count = 13  # кол-во сообщений - должно вычисляться отдельно в своем контроллере


  end





end # КОНЕЦ КОНТРОЛЛЕРА PAGES
