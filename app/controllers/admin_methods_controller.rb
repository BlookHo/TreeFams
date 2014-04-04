class AdminMethodsController < ApplicationController



  # Админа страница. Запуск админских сервисный методов, просмотр всех таблиц.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place
  # @ перенести админские методы в отдельный контроллер
  def service_method_1

    @test_string_1 = "This is 1-st service admin method"  # DEBUGG
    @var_qty_1 = 111  # DEBUGG

  end

  # Админа страница. Запуск админских сервисный методов, просмотр всех таблиц.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place
  # @ перенести админские методы в отдельный контроллер
  def service_method_2

    @test_string_2 = "This is 2-st service admin method"  # DEBUGG
    @var_qty_2 = 222  # DEBUGG

  end

end
