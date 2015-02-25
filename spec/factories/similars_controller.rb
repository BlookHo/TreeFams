FactoryGirl.define do

factory :similars, class: SimilarsController do

  # factory for internal_similars_search

  #     connected_users = []
       #  current_user.get_connected_users
       # first_users_arr = ConnectedUser.connected_users_ids(self)

  #     SimilarsFound.clear_tree_similars(connected_users)
       # found_sims = SimilarsFound.at_user_id(connected_users_arr).pluck(:id)

  #     tree_info, sim_data, similars = current_user.start_similars
       #  log_connection_id = 0
       #  similars = User.similars_init_search(tree_info)
          #  tree_circles = get_tree_circles(tree_info) # Получаем круги для каждого профиля в дереве
          #  compare_tree_circles(tree_info, tree_circles) # Сравниваем все круги на похожесть (совпадение)
             # compare_tree_circles returns similars
             # certain_koeff_for_connect ||= WeafamSetting.first.certain_koeff

  #     @log_connection_id = SimilarsLog.current_tree_log_id(tree_info[:connected_users]) unless tree_info.empty?


  # profile_key - 112 rows

  # connected_at      5
    # current_user_id   15
    # table_name        "profiles"
    # table_row         225
    # field             "user_id" # or "trees"
    # written           446
    # overwritten       555
    #
    # trait :big_IDs do
    #   connected_at    3333333333
    #   current_user_id 1000000000
    #   table_row       5555555555
    #   written         2222222222
    #   overwritten     9999999999
    # end
    #

  # tree - 20 rows

  # user - 2 rows

  # WeafamSetting - 1 rows


  end

end
