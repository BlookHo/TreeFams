class GraphTreeController < ApplicationController



  # Отображение дерева пользователя в виде графа
  # get_profile_arr - метод сбор данных для массива по profile_id .
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def show_graph_tree

    if user_signed_in?

      #profiles_tree_arr = session[:profiles_tree_arr][:value] if !session[:profiles_tree_arr].blank?

      @profiles_json = '{"author":{"profile_id":1,"user_id":1,"name":"Корень","sex_id":3,"relation_id":0,"family":{"fathers":[{"profile_id":1,"user_id":1,"name":"Валера","sex_id":1,"relation_id":1}],"mothers":[{"profile_id":1,"user_id":1,"name":"Юлия","sex_id":0,"relation_id":2}],"brothers":[{"profile_id":1,"user_id":1,"name":"Егор","sex_id":1,"relation_id":5},{"profile_id":1,"user_id":1,"name":"Иван","sex_id":1,"relation_id":5}],"sisters":[{"profile_id":1,"user_id":1,"name":"Ксюша","sex_id":0,"relation_id":6},{"profile_id":1,"user_id":1,"name":"Светлана","sex_id":0,"relation_id":6}],"sons":[{"profile_id":1,"user_id":1,"name":"Никита","sex_id":1,"relation_id":3},{"profile_id":1,"user_id":1,"name":"Василий","sex_id":1,"relation_id":3}],"daughters":[{"profile_id":1,"user_id":1,"name":"Вероника","sex_id":0,"relation_id":4},{"profile_id":1,"user_id":1,"name":"Кристина","sex_id":0,"relation_id":4}],"wives":[{"profile_id":1,"user_id":1,"name":"Алла","sex_id":0,"relation_id":8}]}}}'
      #@profiles_json = '{"author":{"name":"Алексей","sex_id":1,"relation_id":0,"family":{"fathers":[{"name":"Сергей","sex_id":1,"relation_id":1,"validation_context":null,"errors":{}}],"mothers":[{"name":"Алла","sex_id":0,"relation_id":2,"validation_context":null,"errors":{}}],"brothers":[],"sisters":[],"sons":[],"daughters":[],"husbands":[],"wives":[]},"errors":{},"validation_context":null}}'

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