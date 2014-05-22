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

      #@profiles_json = '{"family":{"author":{"user_id":1,"profile_id":1,"name":"Корень","relation_id":0,"sex":true},"parents":{"father":{"user_id":0,"profile_id":1,"name":"Корень","relation_id":1,"is_profile_id":1,"is_named":"Отец","sex":true},"mother":{"user_id":0,"profile_id":1,"name":"Корень","relation_id":2,"is_profile_id":2,"is_named":"Мать","sex":false}},"couple":{"wife":{"user_id":0,"profile_id":1,"name":"Корень","relation_id":8,"is_profile_id":11,"is_named":"Жена","sex":false}},"sibs":{"brothers":[{"user_id":0,"profile_id":1,"name":"Корень","relation_id":5,"is_profile_id":3,"is_named":"Брат 1","sex":true},{"user_id":0,"profile_id":1,"name":"Корень","relation_id":5,"is_profile_id":4,"is_named":"Брат 2","sex":true}],"sisters":[{"user_id":0,"profile_id":1,"name":"Корень","relation_id":6,"is_profile_id":5,"is_named":"Сестра 1","sex":false},{"user_id":0,"profile_id":1,"name":"Корень","relation_id":6,"is_profile_id":6,"is_named":"Сестра 2","sex":false}]},"children":{"sons":[{"user_id":0,"profile_id":1,"name":"Корень","relation_id":3,"is_profile_id":7,"is_named":"Сын 1","sex":true},{"user_id":0,"profile_id":1,"name":"Корень","relation_id":3,"is_profile_id":8,"is_named":"Сын 2","sex":true}],"daughters":[{"user_id":0,"profile_id":1,"name":"Корень","relation_id":4,"is_profile_id":9,"is_named":"Дочь 1","sex":false},{"user_id":0,"profile_id":1,"name":"Корень","relation_id":4,"is_profile_id":10,"is_named":"Дочь 2","sex":false}]}}}'
      @profiles_json = '{"family":{"author":{"user_id":1,"profile_id":1,"name":"Корень","relation_id":0,"sex":true},"parents":{"father":{"user_id":0,"profile_id":1,"name":"Корень","relation_id":1,"is_profile_id":1,"is_named":"Отец","sex":true},"mother":{"user_id":0,"profile_id":1,"name":"Корень","relation_id":2,"is_profile_id":2,"is_named":"Мать","sex":false}},"couple":{"wife":{"user_id":0,"profile_id":1,"name":"Корень","relation_id":8,"is_profile_id":11,"is_named":"Жена","sex":false}},"sibs":{"brothers":[{"user_id":0,"profile_id":1,"name":"Корень","relation_id":5,"is_profile_id":3,"is_named":"Брат 1","sex":true},{"user_id":0,"profile_id":1,"name":"Корень","relation_id":5,"is_profile_id":3,"is_named":"Брат 1","sex":true},{"user_id":0,"profile_id":1,"name":"Корень","relation_id":5,"is_profile_id":4,"is_named":"Брат 2","sex":true}],"sisters":[{"user_id":0,"profile_id":1,"name":"Корень","relation_id":6,"is_profile_id":5,"is_named":"Сестра 1","sex":false},{"user_id":0,"profile_id":1,"name":"Корень","relation_id":6,"is_profile_id":6,"is_named":"Сестра 2","sex":false}]},"children":{"sons":[{"user_id":0,"profile_id":1,"name":"Корень","relation_id":3,"is_profile_id":7,"is_named":"Сын 1","sex":true},{"user_id":0,"profile_id":1,"name":"Корень","relation_id":3,"is_profile_id":8,"is_named":"Сын 2","sex":true}],"daughters":[{"user_id":0,"profile_id":1,"name":"Корень","relation_id":4,"is_profile_id":9,"is_named":"Дочь 1","sex":false},{"user_id":0,"profile_id":1,"name":"Корень","relation_id":4,"is_profile_id":10,"is_named":"Дочь 2","sex":false}]}}}'
      #@profiles_json = '{"family":{"author":{"user_id":1,"profile_id":1,"name":"Корень","relation_id":0,"sex":true},"parents":{"father":{"user_id":0,"profile_id":1,"name":"Корень","relation_id":1,"is_profile_id":1,"is_named":"Отец","sex":true},"mother":{"user_id":0,"profile_id":1,"name":"Корень","relation_id":2,"is_profile_id":2,"is_named":"Мать","sex":false}},"couple":{"wife":{"user_id":0,"profile_id":1,"name":"Корень","relation_id":8,"is_profile_id":11,"is_named":"Жена","sex":false},"husband":{"user_id":0,"profile_id":1,"name":"Корень","relation_id":7,"is_profile_id":12,"is_named":"Муж","sex":true}},"sibs":{"brothers":[{"user_id":0,"profile_id":1,"name":"Корень","relation_id":5,"is_profile_id":3,"is_named":"Брат 1","sex":true},{"user_id":0,"profile_id":1,"name":"Корень","relation_id":5,"is_profile_id":4,"is_named":"Брат 2","sex":true}],"sisters":[{"user_id":0,"profile_id":1,"name":"Корень","relation_id":6,"is_profile_id":5,"is_named":"Сестра 1","sex":false},{"user_id":0,"profile_id":1,"name":"Корень","relation_id":6,"is_profile_id":6,"is_named":"Сестра 2","sex":false}]},"children":{"sons":[{"user_id":0,"profile_id":1,"name":"Корень","relation_id":3,"is_profile_id":7,"is_named":"Сын 1","sex":true},{"user_id":0,"profile_id":1,"name":"Корень","relation_id":3,"is_profile_id":8,"is_named":"Сын 2","sex":true}],"daughters":[{"user_id":0,"profile_id":1,"name":"Корень","relation_id":4,"is_profile_id":9,"is_named":"Дочь 1","sex":false},{"user_id":0,"profile_id":1,"name":"Корень","relation_id":4,"is_profile_id":10,"is_named":"Дочь 2","sex":false}]}}}'

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
