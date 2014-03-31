class PagesController < ApplicationController
  include Access
  before_action :require_admin, only: [:admin]

  # Входная страница. На ней - логин. Если уже зареген, то переход на Главную страницу - отображение древа и т.п..
  # или если впервые - переход на Стартовую стр-цу.
  # @note GET /
  # @param login_page [Integer] опциональный номер страницы
  # @see Place
  def landing

    @navigation_var = "Navigation переменная - PAGES контроллер/login метод"


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


  # Стартовая страница. На ней - Ввод БК.
  # по завершении ввода БК, то переход на страницу регистрации.
  # @note GET /
  # @param start_page [Integer] опциональный номер страницы
  # @see Place
  def start_enter

    @navigation_var = "Navigation переменная - Cтраница - START      PAGES контроллер/START метод"
    form_select_arrays  # Формирование массивов значений для форм ввода типа select. # Call from Applic-n.cntrl

  end

    ## Поэтапный диалог - ввод стартового древа - ближний круг
    ## Перебор по массиву вопросов-предложений по вводу имен: автора древа, Отца, Матери.
    ## @note @start_one_quest_arr[0] = profile_logo, [1] = question, [2] = select_names_arr, [3] = id_relation
    ## @param admin_page [Integer] опциональный номер страницы
    ## @see Place
    #def start_quest
    #
    #  @start_quest_arr = []
    #
    #  @start_tree_arr = []
    #  @start_tree_profile_arr = []
    #
    #
    #  @start_quest_arr = [["1.Твое имя","Введи свое имя:",@sel_names,nil],
    #                      ["2.Имя Отца","Введи имя отца:",@sel_names_male,1],
    #                      ["3.Имя Матери","Введи имя матери:",@sel_names_female,2]]
    #
    #  for arr_i in 0 .. @start_quest_arr.length-1 # 3 asc
    #
    #    @one_quest_arr = @start_quest_arr[arr_i]  # DEBUGG
    #    @arr_i = arr_i # DEBUGG
    #
    #    asc_one_quest(@start_quest_arr[arr_i], arr_i ) if !@start_quest_arr[arr_i].blank?
    #
    #
    #  end
    #
    #end
    #
    #
    ## Спрашивает один вопрос в Поэтапном диалоге
    ## @note
    ## @param admin_page [Integer] опциональный номер страницы
    ## @see Place
    #def asc_one_quest(one_quest_arr, arr_i)
    #
    #  @profile_logo = one_quest_arr[0]
    #  @profile_question = one_quest_arr[1]
    #  @select_names_arr = one_quest_arr[2]
    #  @profile_relation = one_quest_arr[3]
    #
    #  @profile_name = params[:name_select] # КАК ВЗЯТЬ id ВЫБРАННОГО ИМЕНИ ПО ИНДЕКСУ МАССИВА ??
    #
    #  if !@profile_name.blank?
    #    # извлечение пола из введенного имени
    #    @profile_sex = check_sex_by_name(@profile_name) #
    #
    #    @start_tree_profile_arr = make_one_profile_arr(arr_i, @profile_relation, @profile_name, @profile_sex)
    #
    #    @start_tree_arr << @start_tree_profile_arr  #
    #    @start_tree_profile_arr = []
    #
    #  end
    #
    #end

 # end

    # Ввод одного профиля древа. Проверка Имя-Пол.
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see Place
    def enter_profile_bk(profile_name)    # NO USE
      # проверка, действ-но ли введено женское имя?
      if !profile_name.blank?
        if !check_sex_by_name(profile_name)
          name_correct = true
        else
          name_correct = false
        end
      end
      return name_correct
    end




    # Начало диалога - ввода стартового древа - ближний круг
    # Ввод автора древа, Отца, Матери.
    # @note
    # @param admin_page [Integer] опциональный номер страницы
    # @see Place
    #def start_dialoge
    #
    #  @user_name = params[:name_select] #
    #  # извлечение пола из введенного имени
    #  if !@user_name.blank?
    #    @user_sex = check_sex_by_name(@user_name) # display sex by name
    #  end
    #
    #  @father_name = params[:father_name_select] #
    #  # проверка, действ-но ли введено мужское имя?
    #  if !@father_name.blank?
    #    if check_sex_by_name(@father_name)
    #      @father_name_correct = true
    #    else
    #      @father_name_correct = false
    #    end
    #  end
    #
    #  @mother_name = params[:mother_name_select] #
    #  # проверка, действ-но ли введено женское имя?
    #  if !@mother_name.blank?
    #    if !check_sex_by_name(@mother_name)
    #      @mother_name_correct = true
    #    else
    #      @mother_name_correct = false
    #    end
    #  end
    #
    #end # END OF start_dialoge

    # Отображение найденных совпадений среди всех деревьев относительно вводимого.
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see Place
    def set_prompts

    end

    ## Поиск совпадений среди всех деревьев, введенных ранее относительно вводимого.
    ## @note GET /
    ## @param admin_page [Integer] опциональный номер страницы
    ## @see Place
    #def find_match
    #
    #end
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
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see Place
    def user_registration

    end

    # Отображение найденных совпадений среди всех деревьев относительно вводимого.
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see Paginated
    def save_new_user

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

      user_registration

      save_new_user

    end


  #  enter_bk

    #respond_to do |format|
    #  format.js
    #  format.html
    #end


 # end

  # Админа страница. Запуск админских методов, просмотр всех таблиц.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place
  # @todo перенести админские методы в отдельный контроллер
  def admin

    @first_var = "Первая переменная - ADMIN"
    @navigation_var = "Navigation переменная - PAGES контроллер/admin метод"

  end

  # Страница Регистрации.
  # @note GET /
  # @param regis_page [Integer] опциональный номер страницы
  # @see Paginated
  # @see Place
  def registration

    @first_var = "Первая переменная - REGISTRATION"
    @navigation_var = "Navigation переменная - PAGES контроллер/registration метод"

  end


   # Страница Главная. - основная страница сайта. На ней отображение древа, все переходы и т.п.
  # @note GET /
  # @param main_page [Integer] опциональный номер страницы
  # @see Paginated
  # @see Place
  def main


    @navigation_var = "Navigation переменная - PAGES контроллер/main метод"


    # Формирование массива древа Юзера для отображения на Главной .
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see News
    def form_tree #формирование массива дерева для отображения на Главной

      @tree_array = [[1, "Я", "Денис", "м"], [2, "Отец", "Борис", "м"], [3, "Мать", "Вера", "ж"], [4, "Жена", "Юлия", "ж"]]

    end


    form_tree # use

    find_match  #  USE - поместить в applic-n contr  ??

  end



  # Страница Новостей и Обновлений. На ней отображается инфа о предложениях на объединение, а также другие новости
  # @note GET /
  # @param news_page [Integer] опциональный номер страницы
  # @see Place
  def news

    @first_var = "Первая переменная - NEWS"
    @updates_count = 4  # кол-во обновлений - должно вычисляться отдельно в своем контроллере
    @navigation_var = "Navigation переменная - PAGES контроллер/news метод"


  end

  # Страница Сообщений и Бесед Юзера. На ней отображаются инфа обо всех новостях и обновлениях юзера
  # @note GET /
  # @param news_page [Integer] опциональный номер страницы
  # @see Place
  def mail

    @first_var = "Первая страница - MAIL"
    @new_mail_count = 6  # кол-во сообщений - должно вычисляться отдельно в своем контроллере
    @navigation_var = "Navigation переменная - PAGES контроллер/mail метод"


  end


  # Страница Юзера: вся инфа о Юзере, настройки и т.д.
  # @note GET /
  # @param settings_page [Integer] опциональный номер страницы
  # @see Place
  def mypage

    @first_var = "Первая переменная - MYPAGE"
    @navigation_var = "Navigation переменная - PAGES контроллер/mypage метод"


  end

  # Страница Поиска: поиск среди профилей и Юзеров.
  # @note GET /
  # @param settings_page [Integer] опциональный номер страницы
  # @see Place
  def search

    @first_var = "Первая переменная - SEARCH"
    @navigation_var = "Navigation переменная - PAGES контроллер/search метод"

  end

  # Страница общения Юзера: темы беседы события сообщения.
  # @note GET /
  # @param conversation_page [Integer] опциональный номер страницы
  # @see Place
  def conversation

    @first_var = "Первая переменная - CONVERSATION"
    @navigation_var = "Navigation переменная - PAGES контроллер/conversation метод"


  end





end # КОНЕЦ КОНТРОЛЛЕРА PAGES
