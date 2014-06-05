class PagesController < ApplicationController
  include Access
  before_action :require_admin, only: [:admin]

  # Входная страница. На ней - логин. Если уже зареген, то переход на Главную страницу - отображение древа и т.п..
  # или если впервые - переход на Стартовую стр-цу.
  # @note GET /
  # @param login_page [Integer] опциональный номер страницы
  # @see Place
  def landing
  end


  # Поиск совпадений профилей из древа Юзера с другими деревьями .
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def find_match # Поиск совпадений профилей из древа Юзера с другими деревьями

    @@match_qty = 17
    @match_qty_loc = @@match_qty  # DEBUGG
    @@approved_match_qty = 10
    @approved_match_qty_loc = @@approved_match_qty   # DEBUGG

  end


   # Отображение найденных совпадений среди всех деревьев относительно вводимого.
    # Начало диалога - ввода стартового древа - ближний круг
    # Ввод автора древа, Отца, Матери. - через контроллер START
    # @note
    # @param admin_page [Integer] опциональный номер страницы
    # @see Place
    def start_dialoge  # запуск процесса диалогового ввода стартового древа

      form_select_arrays  # Формирование массивов значений для форм ввода типа select. # Call from Applic-n.cntrl

    end #


     # Отображение найденных совпадений среди всех деревьев относительно вводимого.
    # @note GET /
    # @note
    # @param admin_page [Integer] опциональный номер страницы
    # @see Place
    def make_next_prompt

    end
    # Отображение найденных совпадений среди всех деревьев относительно вводимого.
    # @note
    # @param admin_page [Integer] опциональный номер страницы
    # @see Place
    def get_input_profile

    end
    # Отображение найденных совпадений среди всех деревьев относительно вводимого.
    # @note
    # @param admin_page [Integer] опциональный номер страницы
    # @see Place
    def save_profile

    end
    # Отображение найденных совпадений среди всех деревьев относительно вводимого.
    # @note
    # @param admin_page [Integer] опциональный номер страницы
    # @see Place
    def save_tree_node

    end

    # Отображение найденных совпадений среди всех деревьев относительно вводимого.
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see Place
    def check_exit

    end

    # Отображение найденных совпадений среди всех деревьев относительно вводимого.
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see Place
    def check_continue

    end

    # Отображение найденных совпадений среди всех деревьев относительно вводимого.
    # @note
    # @param admin_page [Integer] опциональный номер страницы
    # @see Place
    def display_match_results

    end


    # Ввод стартового древа - ближний круг.
    # @note
    # @param admin_page [Integer] опциональный номер страницы
    # @see Place
    def enter_bk

      exit_n_save = false
      bk_completed = false

      unless exit_n_save or bk_completed

  #      start_quest
        start_dialoge #

        make_next_prompt

        get_input_profile

        save_profile

        save_tree_node

        display_match_results

        check_exit

        check_continue

      end



    end



  # Админа страница. Запуск админских методов, просмотр всех таблиц.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place
  # @ перенести админские методы в отдельный контроллер
  def admin



  end

  # Страница Регистрации.
  # @note GET /
  # @param regis_page [Integer] опциональный номер страницы
  # @see Paginated
  # @see Place
  def registration


  end


  # Страница Новостей и Обновлений. На ней отображается инфа о предложениях на объединение, а также другие новости
  # @note GET /
  # @param news_page [Integer] опциональный номер страницы
  # @see Place
  def news

    @updates_count = 4  # кол-во обновлений - должно вычисляться отдельно в своем контроллере


  end

  # Страница Сообщений и Бесед Юзера. На ней отображаются инфа обо всех новостях и обновлениях юзера
  # @note GET /
  # @param news_page [Integer] опциональный номер страницы
  # @see Place
  def mail

    @new_mail_count = 6  # кол-во сообщений - должно вычисляться отдельно в своем контроллере


  end


  # Страница Юзера: вся инфа о Юзере, настройки и т.д.
  # @note GET /
  # @param settings_page [Integer] опциональный номер страницы
  # @see Place
  def mypage



  end

  # Страница Поиска: поиск среди профилей и Юзеров.
  # @note GET /
  # @param settings_page [Integer] опциональный номер страницы
  # @see Place
  def search


  end

  # Страница общения Юзера: темы беседы события сообщения.
  # @note GET /
  # @param conversation_page [Integer] опциональный номер страницы
  # @see Place
  def conversation



  end





end # КОНЕЦ КОНТРОЛЛЕРА PAGES
