class MainController < ApplicationController
 # include MainHelper  #


  # Отображение дерева Юзера .
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def main_display_tree

    @navigation_var = "Navigation переменная - MAIN контроллер/main_display_tree метод"

  end



  # Отображение меню действий для родственника в дереве Юзера.
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see News
    def relative_menu

      @navigation_var = "Navigation переменная - MAIN контроллер/relative_menu метод"
      @menu_choice = "No choice yet - in Relative_menu"


    end



end
