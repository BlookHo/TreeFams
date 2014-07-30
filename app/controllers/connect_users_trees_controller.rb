class ConnectUsersTreesController < ApplicationController

  # Получение дерева из таблицы
  def get_tree(user_id)
    tree_of_user = Tree.where(:user_id => user_id)
    return tree_of_user
  end

  # Получение дерева в виде массива
  def tree_arr(user_id)
    get_tree(user_id).map {|t|  [t.user_id, t.profile_id, t.name_id, t.relation_id, t.is_profile_id, t.is_name_id, t.is_sex_id] }
  end



  def connect_users(current_user_id, user_id)

    if current_user_id != user_id
      new_users_connection = ConnectedUser.new
      new_users_connection.user_id = current_user_id
      new_users_connection.with_user_id = user_id
      #new_users_connection.connected = true
      new_users_connection.save
    else
      logger.info "ERROR: Connection of Users - INVALID! Current_user=#{current_user_id.inspect} EQUALS TO user_id=#{user_id.inspect}"
    end

  end

  # Общий метод дла накапливания массива для перезаписи профилей в таблицах
  #
  def get_rewrite_profiles_ids(db_table, db_field, where_rewrite_user, field_profiles, new_profile_id)

    arr_to_rewrite = []
    one_arr = []
    where_found_to_replace = db_table.where(:user_id => where_rewrite_user.to_i).where(" #{db_field} = #{field_profiles} " )#[0]
    if !where_found_to_replace.blank?
      where_found_to_replace.each do |rewrite_row|
        one_arr[0] = rewrite_row.id ## DEBUGG_TO_VIEW
        one_arr[1] = db_field ## DEBUGG_TO_VIEW
        one_arr[2] = new_profile_id ## DEBUGG_TO_VIEW
        one_arr[3] = "-->" ## DEBUGG_TO_VIEW
        one_arr[4] = field_profiles #{db_field} ## DEBUGG_TO_VIEW
        arr_to_rewrite << one_arr
        one_arr = []
      end
      arr_to_rewrite
    else
      return nil
    end

    logger.info " In #{db_table}, #{db_field}: arr_to_rewrite = #{arr_to_rewrite} " # DEBUGG_TO_VIEW
    return arr_to_rewrite

  end

  # Общий метод дла перезаписи профилей в таблицах
  #
  def save_rewrite_profiles_ids(db_table, rewrite_arr)

    saved_profiles_arr = [] # DEBUGG_TO_VIEW
    test_arr = [] # DEBUGG_TO_VIEW
    for arr_ind in 0 .. rewrite_arr.length-1


      if rewrite_arr[arr_ind].length == 1
        row_id = rewrite_arr[arr_ind][0][0]
        row_field = rewrite_arr[arr_ind][0][1]
        new_profile_id = rewrite_arr[arr_ind][0][2]

        table_row = db_table.find(row_id)

        case row_field
          when "profile_id"
            table_row.profile_id = new_profile_id
            test_arr[1] = "pr" # DEBUGG_TO_VIEW
          when "is_profile_id"
            table_row.is_profile_id = new_profile_id
            test_arr[1] = "is_pr" # DEBUGG_TO_VIEW
          else
            "No field"
        end

        table_row.save  ####

        test_arr[0] = table_row.id # DEBUGG_TO_VIEW
        test_arr[2] = rewrite_arr[arr_ind][0][2] # DEBUGG_TO_VIEW

        saved_profiles_arr << test_arr # DEBUGG_TO_VIEW
        test_arr = [] # DEBUGG_TO_VIEW

      else  # rewrite_arr[arr_ind].length > 1

        rewrite_arr[arr_ind].each do |one_arr|
          row_id = one_arr[0]
          row_field = one_arr[1]
          new_profile_id = one_arr[2]

          table_row = db_table.find(row_id)

          case row_field
            when "profile_id"
              table_row.profile_id = new_profile_id
              test_arr[1] = "pr" # DEBUGG_TO_VIEW
            when "is_profile_id"
              table_row.is_profile_id = new_profile_id
              test_arr[1] = "is_pr" # DEBUGG_TO_VIEW
            else
              "No field"
          end

          table_row.save  ####

          test_arr[0] = table_row.id # DEBUGG_TO_VIEW
          test_arr[2] = one_arr[2] # DEBUGG_TO_VIEW

          saved_profiles_arr << test_arr # DEBUGG_TO_VIEW
          test_arr = [] # DEBUGG_TO_VIEW
        end

      end

    end

    @saved_profiles_arr = saved_profiles_arr # DEBUGG_TO_VIEW
    return @saved_profiles_arr # DEBUGG_TO_VIEW

  end

  # Метод дла получения массива обратных профилей для
  # перезаписи профилей в таблицах
  # opposite_profiles_arr
  #
  def get_opposite_profiles(who_found_user_id, where_found_user_id, match_profiles_arr, match_relations_arr)
    opposite_profiles_arr = []
    for arr_ind in 0 .. match_profiles_arr.length-1
      one_profile = match_profiles_arr[arr_ind]
      one_relation = match_relations_arr[arr_ind]
      where_found_tree_row = Tree.where(:user_id => where_found_user_id.to_i, :is_profile_id => one_profile.to_i)[0]
      if !where_found_tree_row.blank?
        who_found_tree_row = Tree.where(:user_id => who_found_user_id.to_i, :is_name_id => where_found_tree_row.is_name_id.to_i, :relation_id => one_relation,:is_sex_id => where_found_tree_row.is_sex_id.to_i)[0]
        if !who_found_tree_row.blank?
          opposite_profiles_arr << who_found_tree_row.is_profile_id
        end
      end
    end
    return opposite_profiles_arr
  end


  # Метод дла перезаписи профилей в таблицах
  # who_found_user_id - Автор дерева, который ищет
  # where_found_user_id - Автор дерева, в котором найдено
  #
  def connect_trees(who_found_user_id, where_found_user_id, match_profiles_arr, match_relations_arr)

    opposite_profiles_arr = get_opposite_profiles(who_found_user_id, where_found_user_id, match_profiles_arr, match_relations_arr)
    @opposite_profiles_arr = opposite_profiles_arr # DEBUGG_TO_VIEW
    @match_profiles_arr = match_profiles_arr # DEBUGG_TO_VIEW
    logger.info "DEBUG IN CONNECT_TREES: match_profiles_arr = #{match_profiles_arr}; opposite_profiles_arr = #{opposite_profiles_arr} "

    rewrite_tree_arr1 = []
    rewrite_tree_arr2 = []
    rewrite_profilekey_arr1 = []
    rewrite_profilekey_arr2 = []
    if who_found_user_id < where_found_user_id
      # если where_found_user_id - более поздний по времени создания
      # значит его профили в where_found_user_id (в match_profiles_arr)- заменяем на более ранние, т.е. - из who_found_user_id (из opposite_profiles_arr).
      @msg = "who_found_user_id < where_found_user_id" ## DEBUGG_TO_VIEW

      #########  перезапись profile_id's & update User
      ## (остаются): opposite_profiles_arr - противоположные, найденным в поиске
      ## (уходят): match_profiles_arr - найден в поиске
      # Первым параметром идут те профили, которые остаются
      Profile.merge(opposite_profiles_arr, match_profiles_arr)

      for arr_ind in 0 .. match_profiles_arr.length-1 # ищем этот profile_id для его замены
        # меняем profile_id в match_profiles_arr на profile_id из opposite_profiles_arr
        one_profile = match_profiles_arr[arr_ind] # profile_id для замены
        logger.info one_profile

        # Получение массивов для Замены профилей в Tree
        one_arr1 = get_rewrite_profiles_ids(Tree, "profile_id", where_found_user_id.to_i, one_profile.to_i, opposite_profiles_arr[arr_ind].to_i)
        rewrite_tree_arr1 << one_arr1 if !one_arr1.blank?
        one_arr2 = get_rewrite_profiles_ids(Tree, "is_profile_id", where_found_user_id.to_i, one_profile.to_i, opposite_profiles_arr[arr_ind].to_i)
        rewrite_tree_arr2 << one_arr2 if !one_arr2.blank?

        # Получение массивов для Замены профилей в ProfileKey
        one_arr1 = get_rewrite_profiles_ids(ProfileKey, "profile_id", where_found_user_id.to_i, one_profile.to_i, opposite_profiles_arr[arr_ind].to_i)
        rewrite_profilekey_arr1 << one_arr1 if !one_arr1.blank?
        one_arr2 = get_rewrite_profiles_ids(ProfileKey, "is_profile_id", where_found_user_id.to_i, one_profile.to_i, opposite_profiles_arr[arr_ind].to_i)
        rewrite_profilekey_arr2 << one_arr2 if !one_arr2.blank?
      end

    else
      # если where_found_user_id - более ранний по времени создания
      # значит его профилями в where_found_user_id (из match_profiles_arr)- заменяем более поздние, т.е. - в who_found_user_id (из opposite_profiles_arr).
      @msg = "who_found_user_id > where_found_user_id" ## DEBUGG_TO_VIEW

      ######### перезапись profile_id's & update User
      ## (уходят):   opposite_profiles_arr - противоположные, найденным в поиске
      ## (остаются): match_profiles_arr - найден в поиске
      # Первым параметром идут те профили, которые остаются
      Profile.merge(match_profiles_arr, opposite_profiles_arr)

      for arr_ind in 0 .. opposite_profiles_arr.length-1 # ищем этот profile_id для его замены
        # меняем profile_id из match_profiles_arr на profile_id из opposite_profiles_arr
        one_profile = opposite_profiles_arr[arr_ind] # profile_id для замены
        logger.info one_profile

        # Получение массивов для Замены профилей в Tree
        one_arr1 = get_rewrite_profiles_ids(Tree, "profile_id", who_found_user_id.to_i, one_profile.to_i, match_profiles_arr[arr_ind].to_i)
        rewrite_tree_arr1 << one_arr1 if !one_arr1.blank?
        one_arr2 = get_rewrite_profiles_ids(Tree, "is_profile_id", who_found_user_id.to_i, one_profile.to_i, match_profiles_arr[arr_ind].to_i)
        rewrite_tree_arr2 << one_arr2 if !one_arr2.blank?

        # Получение массивов для Замены профилей в ProfileKey
        one_arr1 = get_rewrite_profiles_ids(ProfileKey, "profile_id", who_found_user_id.to_i, one_profile.to_i, match_profiles_arr[arr_ind].to_i)
        rewrite_profilekey_arr1 << one_arr1 if !one_arr1.blank?
        one_arr2 = get_rewrite_profiles_ids(ProfileKey, "is_profile_id", who_found_user_id.to_i, one_profile.to_i, match_profiles_arr[arr_ind].to_i)
        rewrite_profilekey_arr2 << one_arr2 if !one_arr2.blank?
      end

    end

    save_rewrite_profiles_ids(Tree, rewrite_tree_arr1 + rewrite_tree_arr2)
    @save_in_tree = @saved_profiles_arr # DEBUGG_TO_VIEW
    save_rewrite_profiles_ids(ProfileKey, rewrite_profilekey_arr1 + rewrite_profilekey_arr2)
    @save_in_profilekey = @saved_profiles_arr # DEBUGG_TO_VIEW

  end


  # Главный стартовый метод дла перезаписи профилей в таблицах
  # Вход:
  # current_user_id = params[:current_user_id] = who_found_user_id - Автор дерева, который ищет
  # user_id = params[:user_id_to_connect] = where_found_user_id - Автор дерева, в котором найдено# DEBUGG_TO_VIEW#
  # matched_profiles_in_tree = ... params[:matched_profiles] = Из поиска: @final_reduced_profiles_hash
  # matched_relations_in_tree = ... params[:matched_relations] = Из поиска:  @final_reduced_relations_hash
  # Выход:
  # 1. перезапись profile_id в таблице Profile.
  # 2. update в таблице User
  # 3. перезапись profile_id в полях "profile_id" и "is_profile_id"
  # в таблицах Tree & ProfileKey.

  def connection_of_trees

    current_user_id = params[:current_user_id] # DEBUGG_TO_VIEW#
    user_id = params[:user_id_to_connect] # DEBUGG_TO_VIEW#
    matched_profiles_in_tree = params[:matched_profiles].values_at(user_id)[0].values.flatten
    matched_relations_in_tree = params[:matched_relations].values_at(user_id)[0].values.flatten

    @matched_profiles_hash = params[:matched_profiles] # DEBUGG_TO_VIEW @final_reduced_profiles_hash
    @matched_relations_hash = params[:matched_relations] # DEBUGG_TO_VIEW @final_reduced_relations_hash
    @current_user_id = current_user_id # DEBUGG_TO_VIEW
    @user_id = user_id # DEBUGG_TO_VIEW
    @matched_profiles_in_tree = matched_profiles_in_tree # DEBUGG_TO_VIEW
    @matched_relations_in_tree = matched_relations_in_tree # DEBUGG_TO_VIEW
    @first_tree = tree_arr(current_user_id) # DEBUGG_TO_VIEW
    @second_tree = tree_arr(user_id) # DEBUGG_TO_VIEW
    @connected_users_arr = current_user.get_connected_users # DEBUGG_TO_VIEW

    if !@connected_users_arr.include?(user_id.to_i) # check_connection: IF NOT CONNECTED
      logger.info "DEBUG IN connection_of_trees: NOT CONNECTED - #{@connected_users_arr.include?(user_id).inspect}" # == false
      connect_trees(params[:current_user_id], params[:user_id_to_connect], matched_profiles_in_tree, matched_relations_in_tree)
      connect_users(current_user_id.to_i, user_id.to_i)
    else
      logger.info "DEBUG IN connection_of_trees: USERS ALREADY CONNECTED! Current_user=#{current_user_id.inspect}, user_id=#{user_id.inspect}."
    end

  end



end

# DEBUGG_TO_VIEW
# 38 in 39
#  IN connection_of_trees: who_found_user_id = @current_user_id: "38"
#  IN connection_of_trees: where_found_user_id = @user_id: "39"
#
#  @matched_profiles_arr: ["275", "273", "274", "272", "277", "276"]
#  @opposite_profiles_arr: [265, 266, 267, 268, 269, 270]
#  @save_in_tree: [[273, "pr", 265], [268, "pr", 268], [269, "pr", 268], [270, "pr", 268], [271, "pr", 268], [272, "pr", 268], [274, "pr", 270], [271, "is_pr", 265], [269, "is_pr", 266], [270, "is_pr", 267], [268, "is_pr", 268], [273, "is_pr", 269], [272, "is_pr", 270]]
#  @save_in_profilekey: [[969, "pr", 265], [970, "pr", 265], [971, "pr", 265], [973, "pr", 265], [963, "pr", 266], [964, "pr", 266], [965, "pr", 266], [966, "pr", 267], [967, "pr", 267], [968, "pr", 267], [959, "pr", 268], [960, "pr", 268], [961, "pr", 268], [962, "pr", 268], [974, "pr", 269], [972, "pr", 270], [975, "pr", 270], [961, "is_pr", 265], [965, "is_pr", 265], [968, "is_pr", 265], [974, "is_pr", 265], [959, "is_pr", 266], [966, "is_pr", 266], [969, "is_pr", 266], [960, "is_pr", 267], [964, "is_pr", 267], [970, "is_pr", 267], [963, "is_pr", 268], [967, "is_pr", 268], [971, "is_pr", 268], [972, "is_pr", 268], [973, "is_pr", 269], [962, "is_pr", 270], [976, "is_pr", 270]]

  #User Ok
  #38;265;FALSE
  #39;268;FALSE

  #Connected_tree Ok
  #22;38;39;FALSE - id

  #Profiles НЕ Ok
  #  242;35
  #  243;0
  #  244;0
  #  245;0
  #  246;0
  #  247;0
  #  248;0
  #  249;0
  #  250;0
  #  265;38
  #  266;0
  #  267;0
  #  268;0  !!! 39  нужно сюда поставить! чтобы грузить список welcome + перезаписать e-mail
  #  269;0
  #  270;0
  #  271;0
  #  278;0


  #Tree Ok
  #  id user pr rel    isp
  #  238;35;242;0;;343;242;343
  #  239;35;242;1;;343;243;419
  #  240;35;242;2;;343;244;449
  #  241;35;242;8;;343;245;214
  #  242;35;242;3;;343;246;370
  #  243;35;242;4;;343;247;354
  #  244;35;243;5;;419;248;40
  #  245;35;243;1;;419;249;196
  #  246;35;243;2;;419;250;173

  #  261;38;265;0;;419;265;419
  #  262;38;265;1;;419;266;196
  #  263;38;265;2;;419;267;173
  #  264;38;265;5;;419;268;40
  #  265;38;265;3;;419;269;343
  #  266;38;268;8;;40;270;48
  #  267;38;269;8;;343;271;214

  #  268;39;268;0;;40;268;40
  #  269;39;268;1;;40;266;196
  #  270;39;268;2;;40;267;173
  #  271;39;268;5;;40;265;419
  #  272;39;268;8;;40;270;48
  #  273;39;265;3;;419;269;343
  #  274;39;270;1;;48;278;110


  #ProfilesKey Ok

  # id user pr   rel isp
  #  958;38;271;214;7;269;343
  #
  #  959;39;268;40;1;266;196
  #  960;39;268;40;2;267;173
  #  961;39;268;40;5;265;419
  #  962;39;268;40;8;270;48
  #
  #  963;39;266;196;3;268;40
  #  964;39;266;196;8;267;173
  #  965;39;266;196;3;265;419
  #
  #  966;39;267;173;7;266;196
  #  967;39;267;173;3;268;40
  #  968;39;267;173;3;265;419
  #
  #  969;39;265;419;1;266;196
  #  970;39;265;419;2;267;173
  #  971;39;265;419;5;268;40
  #
  #  972;39;270;48;7;268;40
  #  973;39;265;419;3;269;343
  #  974;39;269;343;1;265;419
  #  975;39;270;48;1;278;110
  #  976;39;278;110;4;270;48
  #


  #1. ПОИСК В 35 НИКОЛАЙ от Семена 38
  #ВСЕ wide СОВПАДЕНИЯ РОДНЫХ : @final_reduced_profiles_hash: {35=>{265=>[243, 249, 250, 248, 242], 269=>[245], 268=>[243, 249, 250, 248]}}
  #ВСЕ wide НАЙДЕННЫЕ НОМЕРА ОТНОШЕНИй: @final_reduced_relations_hash: {35=>{265=>[0, 1, 2, 5, 3], 269=>[8], 268=>[5, 1, 2, 0]}}

  #2. ПОИСК В 35 НИКОЛАЙ от Андрея 39
  #  who_found_user_id = @current_user.id: 39
  #  where_found_user_id = @user_id: nil
  #  @connected_users_arr: [39, 38]
  #  @len_check_tree: 12
  #  @new_tree_arr: [[39, 268, 40, 8, 270, 48, 0, false], [39, 270, 48, 1, 278, 110, 1, false], [39, 268, 40, 5, 265, 419, 1, false], [39, 268, 40, 1, 266, 196, 1, false], [39, 268, 40, 2, 267, 173, 0, false], [39, 268, 40, 0, 268, 40, 1, false], [39, 265, 419, 3, 269, 343, 1, false], [38, 265, 419, 0, 265, 419, 1, false], [38, 265, 419, 1, 266, 196, 1, false], [38, 265, 419, 2, 267, 173, 0, false], [38, 265, 419, 5, 268, 40, 1, false], [38, 269, 343, 8, 271, 214, 0, false]]
  #  @new_tree_arr Length: 12
  #
  #  ВСЕ wide СОВПАДЕНИЯ РОДНЫХ : @final_reduced_profiles_hash: {35=>{268=>[243, 249, 250, 248], 265=>[242, 243, 249, 250, 248], 269=>[245]}}
  #  ВСЕ wide НАЙДЕННЫЕ НОМЕРА ОТНОШЕНИй: @final_reduced_relations_hash: {35=>{268=>[5, 1, 2, 0], 265=>[3, 0, 1, 2, 5], 269=>[8]}}


