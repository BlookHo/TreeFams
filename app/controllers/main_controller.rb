class MainController < ApplicationController
 # include MainHelper  #


# Отображение дерева Юзера .
# @note GET /
# @param admin_page [Integer] опциональный номер страницы
# @see News
  def main_page

    if !session[:profiles_array].blank?                    # DEBUGG
      @profiles_array = session[:profiles_array][:value]       # DEBUGG
    end
    if !session[:profile_arr].blank?                    # DEBUGG
      @profile_arr = session[:profile_arr][:value]      # DEBUGG
    end

    @user_tree = Tree.where(:user_id => current_user.id).select(:id, :profile_id, :relation_id, :connected)

    @row_arr = []
    @tree_arr = []

    @user_tree.each do |tree_row|
      @row_arr[0] = tree_row.id
      @row_arr[1] = tree_row.profile_id
      @row_arr[2] = tree_row.relation_id
      @row_arr[3] = tree_row.connected

      @tree_arr << @row_arr
      @row_arr = []

    end




  end

  # Отображение дерева Юзера .
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def main_display_tree

    if !session[:profiles_array].blank?                        # DEBUGG
      @profiles_array = session[:profiles_array][:value]       # DEBUGG
    end








  end


  # Отображение меню действий для родственника в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def relative_menu

    @menu_choice = "No choice yet - in Relative_menu"

  end

  # Подтверждение совпадения родственника в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def match_approval

    @new_approved_qty = 3

    @total_approved_qty = @@approved_match_qty + @new_approved_qty

    @rest_to_approve = @@match_qty - @total_approved_qty

  end




end
