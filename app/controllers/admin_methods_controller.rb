class AdminMethodsController < ApplicationController
  # Админский контроллер
  # Содержит различные служебные методы - не связанные с просмотром и редактированием таблиц БД


  # Админский служебный метод 1
  # Метод, который ....
  # @note GET /  POST
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place
  def service_method_1

    #### ПОКА ЧТО - ЗАГОТОВКА ! ДЛЯ БУДУЩЕГО МЕТОДА АДМИНСКОГО СЛУЖЕБНОГО
    @test_string_1 = "This is 1-st service admin method"  # DEBUGG
    @var_qty_1 = 111  # DEBUGG

    @choice_to_start = params[:start].to_i #         # FOR ALL USERS MANUAL

    if  @choice_to_start == 111 # FOR ALL USERS MANUAL
      @start_calc = true # Заполняем!          # FOR ALL USERS MANUAL
    else # FOR ALL USERS MANUAL
      @start_calc = false # НЕ Заполняем       # FOR ALL USERS MANUAL
    end # FOR ALL USERS MANUAL

  end

  # Админский служебный метод 2
  # Метод, который ....
  # @note GET /  POST
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place
  def service_method_2

    @test_string_2 = "This is 2-st service admin method"  # DEBUGG

    @var_qty_2 = 222  # DEBUGG

    @choice_to_start = params[:start].to_i #         # FOR ALL USERS MANUAL

    if  @choice_to_start == 222 # FOR ALL USERS MANUAL
      @start_calc = true # Заполняем!          # FOR ALL USERS MANUAL
    else # FOR ALL USERS MANUAL
      @start_calc = false # НЕ Заполняем       # FOR ALL USERS MANUAL
    end # FOR ALL USERS MANUAL

  end

end
