class GraphTreeController < ApplicationController



  # Отображение дерева пользователя в виде графа
  # get_profile_arr - метод сбор данных для массива по profile_id .
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def show_graph_tree

    if user_signed_in?

      profiles_tree_arr = session[:profiles_tree_arr][:value] if !session[:profiles_tree_arr].blank?

      @profiles_tree_arr = profiles_tree_arr              # DEBUGG TO VIEW
      @profiles_tree_arr_len = profiles_tree_arr.length   # DEBUGG TO VIEW

      @profiles_json = '{"author":{"profile_id":1,"user_id":1,"name":"Корень","sex_id":1,"relation_id":0,"family":{"fathers":[{"profile_id":1,"user_id":1,"name":"Валера","sex_id":1,"relation_id":1}],"mothers":[{"profile_id":1,"user_id":1,"name":"Юлия","sex_id":0,"relation_id":2}],"wives":[{"profile_id":1,"user_id":1,"name":"Диана","sex_id":0,"relation_id":8}],"brothers":[{"profile_id":1,"user_id":1,"name":"Егор","sex_id":1,"relation_id":5},{"profile_id":1,"user_id":1,"name":"Иван","sex_id":1,"relation_id":5}],"sisters":[{"profile_id":1,"user_id":1,"name":"Ксюша","sex_id":0,"relation_id":6},{"profile_id":1,"user_id":1,"name":"Светлана","sex_id":0,"relation_id":6}],"sons":[{"profile_id":1,"user_id":1,"name":"Никита","sex_id":1,"relation_id":3},{"profile_id":1,"user_id":1,"name":"Василий","sex_id":1,"relation_id":3}],"daughters":[{"profile_id":1,"user_id":1,"name":"Вероника","sex_id":0,"relation_id":4},{"profile_id":1,"user_id":1,"name":"Кристина","sex_id":0,"relation_id":4}]}}}'

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
