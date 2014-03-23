# encoding: utf-8

class PagesController < ApplicationController
  #include PagesHelper

  #@session_id = request.session_options[:id]

  Time::DATE_FORMATS[:ru_datetime] = "%Y.%m.%d в %k:%M:%S"
  @time = Time.current #  Ок  - Greenwich   instead of Time.now - Moscow



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

    @first_var = "Первая страница - LOGIN"

#    form_select_fields  # Формирование массивов значений для форм ввода типа select.

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

    @first_var = "Первая страница - START"

    form_select_fields  # Формирование массивов значений для форм ввода типа select.

    # Ввод стартового древа - ближний круг.
    # @note GET /
    # @note
    # @param admin_page [Integer] опциональный номер страницы
    # @see News
    # @see Paginated
    # @see Place
    def enter_bk

      @user_name = params[:name_select] #
      # извлечение пола из введенного имени
      if !@user_name.blank?
        @user_sex = check_sex_by_name(@user_name) # display sex by name
      end
 #     !@user_name.blank?  @user_sex = check_sex_by_name(@user_name)  #; @user_sex_found = @user_sex }

      @father_name = params[:father_name_select] #
      # проверка, действ-но ли введено мужское имя?
      if !@father_name.blank?
     #    @user_sex ? @father_name_correct == true : @father_name_correct == false
         if check_sex_by_name(@father_name)
           @father_name_correct = true
         else
           @father_name_correct = false
         end
      end

      @mother_name = params[:mother_name_select] #
      # проверка, действ-но ли введено женское имя?
      if !@mother_name.blank?
      #      !@user_sex ? @mother_name_correct == true : @mother_name_correct == false
         if !check_sex_by_name(@mother_name)
           @mother_name_correct = true
         else
           @mother_name_correct = false
         end
      end

    end









    # Автоматическое определение пола по имени.
    # @note GET /
    # @note
    # @param admin_page [Integer] опциональный номер страницы
    # @see News
    # @see Paginated
    # @see Place
    def check_sex_by_name(user_name)

      user_sex = false    # Female name
      find_name=Name.select(:only_male).where(:name => user_name)
      if !find_name.blank? and find_name[0]['only_male']
        user_sex = true   # Male name
      end
      return user_sex
    end


    # Поиск совпадений среди всех деревьев, введенных ранее относительно вводимого.
    # @note GET /
    # @note
    # @param admin_page [Integer] опциональный номер страницы
    # @see News
    # @see Paginated
    # @see Place
    def find_match

    end

    # Отображение найденных совпадений среди всех деревьев относительно вводимого.
    # @note GET /
    # @note
    # @param admin_page [Integer] опциональный номер страницы
    # @see News
    # @see Paginated
    # @see Place
    def display_match

    end

    enter_bk

    find_match

    display_match

    #admin

    #respond_to do |format|
    #  format.html { redirect_to pages_start_path }
    #  format.js { render "index/opinions/opinionsRender" }
    #end



  end

  # Админа страница. Запуск админских методов, просмотр всех таблиц.
  # @note GET /
  # @note
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def admin

    @first_var = "Первая страница - ADMIN"

  end

  # Страница Регистрации.
  # @note GET /
  # @note
  # @param regis_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def registration

    @first_var = "Первая страница - REGISTRATION"

  end

  # Страница Главная. - основная страница сайта. На ней отображение древа, все переходы и т.п.
  # @note GET /
  # @note
  # @param main_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def main

    # Отображение дерева Юзера в виде графа и таблицы.
    # @note GET /
    # @note
    # @param admin_page [Integer] опциональный номер страницы
    # @see News
    # @see Paginated
    # @see Place
    def display_drevo

    end

    # Подтверждение найденных совпадений среди всех деревьев относительно дерева Юзера.
    # @note GET /
    # @note
    # @param admin_page [Integer] опциональный номер страницы
    # @see News
    # @see Paginated
    # @see Place
    def confirm_match

    end


    display_drevo


    confirm_match


    @first_var = "Первая страница - MAIN"

  end

  # Страница Новостей и Обновлений. На ней отображается инфа о предложениях на объединение, а также другие новости
  # @note GET /
  # @note
  # @param news_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def news

    @first_var = "Первая страница - NEWS"
    @updates_count = 4  # кол-во обновлений - должно вычисляться отдельно в своем контроллере


  end

  # Страница Сообщений и Бесед Юзера. На ней отображаются инфа обо всех новостях и обновлениях юзера
  # @note GET /
  # @note
  # @param news_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def mail

    @first_var = "Первая страница - MAIL"
    @new_mail_count = 6  # кол-во сообщений - должно вычисляться отдельно в своем контроллере


  end

  # Страница Сообщений и Бесед Юзера. На ней отображаются инфа обо всех новостях и обновлениях юзера
  # @note GET /
  # @note
  # @param settings_page [Integer] опциональный номер страницы
  # @see News
  # @see Paginated
  # @see Place
  def settings

    @first_var = "Первая страница - SETTINGS"
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

    @first_var = "Первая страница - MYPAGE"
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

    @first_var = "Первая страница - SEARCH"
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

    @first_var = "Первая страница - CONVERSATION"
#    @new_mail_count = 13  # кол-во сообщений - должно вычисляться отдельно в своем контроллере


  end





end # КОНЕЦ КОНТРОЛЛЕРА PAGES
