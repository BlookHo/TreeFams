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


    # Получение одного массива для включения в массив триплекс
    # get_profile_arr - метод сбор данных для массива по profile_id .
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see News
    def get_profile_arr(triplex_arr,relation)
      one_triplex_arr = []
      if !relation.blank?
        one_triplex_arr[0] = Tree.where(:user_id => current_user.id, :relation_id => relation)[0][:profile_id]
      else
        one_triplex_arr[0] = current_user.profile_id
      end
      one_triplex_arr[1] = Profile.find(one_triplex_arr[0]).name_id
      one_triplex_arr[2] = Profile.find(one_triplex_arr[0]).sex_id
      one_triplex_arr[3] = relation
      triplex_arr << one_triplex_arr
    end

    # Получение массива массивов Триплекс: дочь - отец - мать.
    # [profile_id, name_id, relation_id, sex_id]
    # @note GET /
    # @param admin_page [Integer] опциональный номер страницы
    # @see News
    def make_one_triplex_arr(triplex_arr, first_relation, second_relation, third_relation)

      get_profile_arr(triplex_arr,first_relation)
      get_profile_arr(triplex_arr,second_relation)
      get_profile_arr(triplex_arr,third_relation)

    end

    @triplex_arr = []
    make_one_triplex_arr(@triplex_arr,nil,1,2)   # @triplex_arr - ready!





  end




end
