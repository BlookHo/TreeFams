class MainController < ApplicationController
 # include MainHelper  #


 ## Формирование массива древа Юзера для отображения на Главной .
 ## @note GET /
 ## @param admin_page [Integer] опциональный номер страницы
 ## @see News
 # def form_tree #формирование массива дерева для отображения
 #
 #   @tree_array = [[1, "Я", "Денис", "м"], [2, "Отец", "Борис", "м"], [3, "Мать", "Вера", "ж"], [4, "Жена", "Юлия", "ж"]]
 #
 # end
 #
 #
#  form_tree # Call from Main


# Отображение дерева Юзера .
# @note GET /
# @param admin_page [Integer] опциональный номер страницы
# @see News
  def main_page

    @navigation_var = "Navigation переменная - MAIN контроллер/main_display_tree метод"

    @tree_array = session[:tree_array][:value]       # DEBUGG
    @profile_arr = session[:profile_arr][:value] # DEBUGG
     @new_user_id = session[:new_user_id][:value] # DEBUGG
    @tree_arr = session[:tree_arr][:value] # DEBUGG


  end



  # Отображение дерева Юзера .
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def main_display_tree

    @navigation_var = "Navigation переменная - MAIN контроллер/main_display_tree метод"

    @tree_array = session[:tree_array][:value]


  end



  # Отображение меню действий для родственника в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def relative_menu

    @navigation_var = "Navigation переменная - MAIN контроллер/relative_menu метод"
    @menu_choice = "No choice yet - in Relative_menu"

  end

  # Подтверждение совпадения родственника в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def match_approval

    @navigation_var = "Navigation переменная - MAIN контроллер/match_approval метод"

    @new_approved_qty = 3

    @total_approved_qty = @@approved_match_qty + @new_approved_qty

    @rest_to_approve = @@match_qty - @total_approved_qty


  end


end
