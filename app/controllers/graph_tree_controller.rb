class GraphTreeController < ApplicationController



  # Отображение дерева пользователя в виде графа
  # get_profile_arr - метод сбор данных для массива по profile_id .
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def show_graph_tree

    if user_signed_in?

      profiles_tree_arr = session[:profiles_tree_arr][:value] if !session[:profiles_tree_arr].blank?
      @profiles_tree_arr = profiles_tree_arr    # DEBUGG TO VIEW
      @profiles_tree_arr_len = profiles_tree_arr.length  # DEBUGG TO VIEW

      @this_is_graph = "THIS IS GRAPH" # DEBUGG TO VIEW


    end


  end

  # Редактирование дерева пользователя в виде графа
  # get_profile_arr - метод сбор данных для массива по profile_id .
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def edit_graph_tree




  end

  # Движение по экрану дерева пользователя в виде графа
  # get_profile_arr - метод сбор данных для массива по profile_id .
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def move_graph_tree




  end
end
