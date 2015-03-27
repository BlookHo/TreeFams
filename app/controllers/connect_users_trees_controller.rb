class ConnectUsersTreesController < ApplicationController
  include SearchHelper
  include ConnectionRequestsHelper


  layout 'application.new'

  # Заполнение таблицы Connected_Trees - записью о том, что деревья с current_user_id и user_id - соединились
  # def connect_users(current_user_id, user_id)
  #
  #   if current_user_id != user_id
  #     new_users_connection = ConnectedUser.new
  #     new_users_connection.user_id = current_user_id
  #     new_users_connection.with_user_id = user_id
  #     new_users_connection.save
  #   else
  #     logger.info "ERROR: SimilarsConnection of Users - INVALID! Current_user=#{current_user_id.inspect} EQUALS TO user_id=#{user_id.inspect}"
  #   end
  #
  # end

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





  # Метод дла перезаписи профилей в таблицах
  # who_found_user_id - Автор дерева, который ищет
  # where_found_user_id - Автор дерева, в котором найдено
  ## (остаются): profiles_to_rewrite -
  ## (уходят): profiles_to_destroy -
  # who_connect_ids_arr - массив id, входящих в объед-ное дерево автора (того, кто соединяется)
  # with_who_conn_ids_ar - массив id, входящих в объед-ное дерево того, с кем соединяется автор
  #
  def connect_trees_prev(profiles_to_rewrite, profiles_to_destroy, who_connect_ids_arr, with_who_conn_ids_ar)

    logger.info "DEBUG IN CONNECT_TREES: profiles_to_rewrite = #{profiles_to_rewrite}; profiles_to_destroy = #{profiles_to_destroy} "

    rewrite_tree_arr1 = []
    rewrite_tree_arr2 = []
    rewrite_profilekey_arr1 = []
    rewrite_profilekey_arr2 = []

    #########  перезапись profile_id's & update User
    ## (остаются): profiles_to_rewrite - противоположные, найденным в поиске
    ## (уходят): profiles_to_destroy - найден в поиске
    # Первым параметром идут те профили, которые остаются
    Profile.merge(connection_data)

    for arr_ind in 0 .. profiles_to_destroy.length-1 # ищем этот profile_id для его замены
      # меняем profile_id в match_profiles_arr на profile_id из opposite_profiles_arr
      one_profile = profiles_to_destroy[arr_ind] # profile_id для замены
      logger.info one_profile

      with_who_conn_ids_ar.each do |one_user_in_tree|
        # Получение массивов для Замены профилей в Tree
        one_arr1 = get_rewrite_profiles_ids(Tree, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_tree_arr1 << one_arr1 if !one_arr1.blank?
        @rewrite_tree_arr1 = rewrite_tree_arr1 # DEBUGG_TO_VIEW
        one_arr2 = get_rewrite_profiles_ids(Tree, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_tree_arr2 << one_arr2 if !one_arr2.blank?
        @rewrite_tree_arr2 = rewrite_tree_arr2 # DEBUGG_TO_VIEW

        # Получение массивов для Замены профилей в ProfileKey
        one_arr1 = get_rewrite_profiles_ids(ProfileKey, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_profilekey_arr1 << one_arr1 if !one_arr1.blank?
        @rewrite_profilekey_arr1 = rewrite_profilekey_arr1 # DEBUGG_TO_VIEW
        one_arr2 = get_rewrite_profiles_ids(ProfileKey, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_profilekey_arr2 << one_arr2 if !one_arr2.blank?
        @rewrite_profilekey_arr2 = rewrite_profilekey_arr2 # DEBUGG_TO_VIEW
      end

      who_connect_ids_arr.each do |one_user_in_tree|
        # Получение массивов для Замены профилей в Tree
        one_arr1 = get_rewrite_profiles_ids(Tree, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_tree_arr1 << one_arr1 if !one_arr1.blank?
        @rewrite_tree_arr1 = rewrite_tree_arr1 # DEBUGG_TO_VIEW
        one_arr2 = get_rewrite_profiles_ids(Tree, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_tree_arr2 << one_arr2 if !one_arr2.blank?
        @rewrite_tree_arr2 = rewrite_tree_arr2 # DEBUGG_TO_VIEW

        # Получение массивов для Замены профилей в ProfileKey
        one_arr1 = get_rewrite_profiles_ids(ProfileKey, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_profilekey_arr1 << one_arr1 if !one_arr1.blank?
        @rewrite_profilekey_arr1 = rewrite_profilekey_arr1 # DEBUGG_TO_VIEW
        one_arr2 = get_rewrite_profiles_ids(ProfileKey, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
        rewrite_profilekey_arr2 << one_arr2 if !one_arr2.blank?
        @rewrite_profilekey_arr2 = rewrite_profilekey_arr2 # DEBUGG_TO_VIEW
      end

    end

    save_rewrite_profiles_ids(Tree, rewrite_tree_arr1 + rewrite_tree_arr2)
    @save_in_tree = @saved_profiles_arr # DEBUGG_TO_VIEW
    @save_in_tree_LEN = @saved_profiles_arr.length if !@save_in_tree.blank? # DEBUGG_TO_VIEW
    save_rewrite_profiles_ids(ProfileKey, rewrite_profilekey_arr1 + rewrite_profilekey_arr2)
    @save_in_profilekey = @saved_profiles_arr # DEBUGG_TO_VIEW
    @save_in_profilekey_LEN = @saved_profiles_arr.length if !@save_in_profilekey.blank? # DEBUGG_TO_VIEW

  end


  # Центральный метод соединения деревьев = перезапись профилей в таблицах
  # Заполнение таблицы Connected_Trees - записью о том, что деревья с current_user_id и user_id - соединились
  def connection_in_tables(connection_data) #, current_user_id, user_id, connection_id)
    # def connection_in_tables(connection_data, current_user_id, user_id, connection_id)

    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]
    who_connect         = connection_data[:who_connect]
    with_whom_connect   = connection_data[:with_whom_connect]
    current_user_id     = connection_data[:current_user_id]
    user_id             = connection_data[:user_id]
    connection_id       = connection_data[:connection_id]

    # [1 2] c [3]
    # @profiles_to_rewrite: [14, 21, 19, 11, 20, 12, 13, 18]
    # @profiles_to_destroy: [22, 29, 27, 25, 28, 23, 24, 26]
    # init_connection_hash = {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26}
    ###################################################################
    ######## Собственно Центральный метод соединения деревьев = перезапись профилей в таблицах
    # connect_trees(profiles_to_rewrite, profiles_to_destroy, who_connect, with_whom_connect)
#    connect_trees(connection_data) #profiles_to_rewrite, profiles_to_destroy, who_connect, with_whom_connect)
    ####################################################################
    ######## Заполнение таблицы Connected_Trees - записью о том, что деревья с current_user_id и user_id - соединились
    #                          connect_users(current_user_id.to_i, user_id.to_i) # OLD!!

#    ConnectedUser.set_users_connection(connection_data) #, current_user_id, user_id, connection_id)
    #### это и есть лог объединения - с массивами профилей!!!!

    ##################################################################
    ######## Перезапись profile_id при объединении деревьев
    #              UpdatesFeed.connect_update_profiles(profiles_to_rewrite, profiles_to_destroy)
    ##################################################################

    ######## Перезапись profile_data при объединении деревьев
    #    ProfileData.connect!(profiles_to_rewrite, profiles_to_destroy)
    ##################################################################

  end




  # @note: Перезапись профилей в таблицах
  # @param connection_data
  def connect_trees(connection_data) #profiles_to_rewrite, profiles_to_destroy, who_connect_ids_arr, with_who_conn_ids_ar)

    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]
    who_connect         = connection_data[:who_connect]
    with_whom_connect   = connection_data[:with_whom_connect]
    current_user_id     = connection_data[:current_user_id]
    user_id             = connection_data[:user_id]
    connection_id       = connection_data[:connection_id]

    logger.info "IN connect_trees: profiles_to_rewrite = #{profiles_to_rewrite}; profiles_to_destroy = #{profiles_to_destroy} "

    #####################################################
    # Profile.merge(profiles_to_rewrite, profiles_to_destroy)
    #####################################################

    # log_connection_tree       = update_table(connection_data, Tree)
    # log_connection_profilekey = update_table(connection_data, ProfileKey)

    #####################################################
    update_table(connection_data, Tree)
    update_table(connection_data, ProfileKey)
    #####################################################

  end

  # перезапись значений в полях одной таблицы
  # лог не формируем как в похожих, т.к он уже сформирован в табл.Connected_User
  def update_table(connection_data, table )
    # log_connection = []

    # ТЕСТ
    # name_of_table = table.table_name
    # logger.info "*** In module SimilarsConnection update_table: name_of_table = #{name_of_table.inspect} "
    # model = name_of_table.classify.constantize
    # logger.info "*** In module SimilarsConnection update_table: model = #{model.inspect} "
    # logger.info "*** In module SimilarsConnection update_table: table = #{table.inspect} "

    connection_data[:table_name] = table.table_name # DEBUGG_TO
    logger.info "IN connect_trees update_table: connection_data[:table_name] = #{connection_data[:table_name]}" # DEBUGG_TO

    ['profile_id', 'is_profile_id'].each do |table_field|
      table_update_data = { table: table, table_field: table_field}
      # log_connection = update_field(connection_data, table_update_data , log_connection)
      update_field(connection_data, table_update_data)
    end
    # log_connection
  end


  # Делаем общий массив юзеров, для update_field
  # /
  def users_connecting_scope(who_connect, with_whom_connect)
    all_users_to_connect = who_connect + with_whom_connect
    logger.info "IN connect_trees users_connecting_scope: all_users_to_connect = #{all_users_to_connect}"
    all_users_to_connect
  end

  # перезапись значений в одном поле одной таблицы
  # profiles_to_destroy[arr_ind] - один profile_id для замены
  # profiles_to_rewrite[arr_ind] - один profile_id, которым меняем
  def update_field(connection_data, table_update_data)

    who_connect         = connection_data[:who_connect]
    with_whom_connect   = connection_data[:with_whom_connect]
    # table_name          = connection_data[:table_name]
    # current_user_id     = connection_data[:current_user_id]
    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]
    # connected_users_arr = connection_data[:connected_users_arr]
    # connection_id       = connection_data[:connection_id]

    table       = table_update_data[:table]
    table_field = table_update_data[:table_field]

    all_users_to_connect = users_connecting_scope(who_connect, with_whom_connect)

    for arr_ind in 0 .. profiles_to_destroy.length-1 # ищем этот profile_id для его замены
      rows_to_update = table.where(:user_id => all_users_to_connect)
                            .where(" #{table_field} = #{profiles_to_destroy[arr_ind]} " )
      unless rows_to_update.blank?
        rows_to_update.each do |rewrite_row|

          # todo:Раскоммитить 1 строкy ниже  - для полной перезаписи логов и отладки
        #  rewrite_row.update_attributes(:"#{table_field}" => profiles_to_rewrite[arr_ind], :updated_at => Time.now)

          logger.info "IN connect_trees update_field: rewrite_row.id = #{rewrite_row.id}, #{rewrite_row.profile_id},
                          #{rewrite_row.is_profile_id} "
          logger.info "IN connect_trees update_field: rewrite_row.id = #{rewrite_row.id}, #{profiles_to_rewrite[arr_ind]} "

          # one_connection_data = { connected_at: connection_id,              # int
          #                         current_user_id: current_user_id,        # int
          #                         table_name: table_name,                  # string
          #                         table_row: rewrite_row.id,            # int
          #                         field: table_field,                 # string
          #                         written: profiles_to_rewrite[arr_ind],        # int
          #                         overwritten: profiles_to_destroy[arr_ind] }        # int
          #
          # log_connection << SimilarsLog.new(one_connection_data)

        end

      end

    end
    # log_connection

  end


  # Получение стартового Хэша для объединения профилей на основе:
  # uniq_profiles_pairs - хэша уникальных достоверных пар профилей,
  # полученных в рез-те отработки start_search
  # connected_user - дерева(деревьев), с котороыми собираемся объединяться
  # На выходе - init_connection_hash - Хэш достоверных пар профилей,
  # с которых начинается процесс жесткого определения полного набора соответствий между всеми профилями
  # объединяемых деревьев.
  # def init_connection_data(with_whom_connect_users_arr, uniq_profiles_pairs)
  #   logger.info "with_whom_connect_users_arr = #{with_whom_connect_users_arr}, uniq_profiles_pairs = #{uniq_profiles_pairs}"
  #   init_connection_hash = {} # hash to work with
  #   uniq_profiles_pairs.each do |searched_profile, trees_hash|
  #     #logger.info " searched_profile = #{searched_profile}, trees_hash = #{trees_hash}"
  #     trees_hash.each do |tree_key, found_profile|
  #       #logger.info " tree_key = #{tree_key}, found_profile = #{found_profile}"
  #       # выбор результатов для дерева из with_whom_connect_users_arr
  #       # перезапись в хэше под key = searched_profile
  #       if with_whom_connect_users_arr.include?(tree_key) #
  #         init_connection_hash.merge!( searched_profile => found_profile )
  #         #logger.info " init_connection_hash = #{init_connection_hash}"
  #       end
  #     end
  #   end
  #   return init_connection_hash
  # end


  # NEW METHOD "HARD COMPLETE SEARCH"- TO DO
  # Input: start tree No, tree No to connect
  # сбор полного хэша достоверных пар профилей для объединения
  # Output:
  # Определение массивов профилей для перезаписи: profiles_to_rewrite, profiles_to_destroy
  # start_tree = от какого дерева объедин.
  # connected_user = с каким деревом объед-ся
  # Input: init_connection_hash
  # def complete_search(complete_search_data)
  # # def complete_search(init_connection_hash)
  #     with_whom_connect_users_arr = complete_search_data[:with_whom_connect]
  #     uniq_profiles_pairs         = complete_search_data[:uniq_profiles_pairs]
  #
  #   init_connection_hash = init_connection_data(with_whom_connect_users_arr, uniq_profiles_pairs)
  #   logger.info "IN complete_search init_connection_hash = #{init_connection_hash}"
  #   # init_connection_hash = {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26} (pid:6800)
  #
  #
  #   logger.info "** IN complete_search *** "
  #   #logger.info " init_connection_hash = #{init_connection_hash}"
  #   final_profiles_to_rewrite = []
  #   final_profiles_to_destroy = []
  #   if !init_connection_hash.empty?
  #
  #     final_connection_hash = init_connection_hash
  #
  #     # начало сбора полного хэша достоверных пар профилей для объединения
  #     until init_connection_hash.empty?
  #       logger.info "** IN UNTIL top: init_connection_hash = #{init_connection_hash}"
  #
  #       # get new_hash for connection
  #       add_connection_hash = {}
  #       init_connection_hash.each do |profile_searched, profile_found|
  #
  #         new_connection_hash = {}
  #         # Получение Кругов для первой пары профилей -
  #         # для последующего сравнения и анализа
  #         search_bk_arr, search_bk_profiles_arr, search_is_profiles_arr = have_profile_circle(profile_searched)
  #         found_bk_arr, found_bk_profiles_arr, found_is_profiles_arr = have_profile_circle(profile_found)
  #         logger.info " "
  #         logger.info " search_is_profiles_arr = #{search_is_profiles_arr}, found_is_profiles_arr = #{found_is_profiles_arr} "
  #
  #         ## Проверка Кругов на дубликаты
  #         #search_diplicates_hash = find_circle_duplicates(search_bk_profiles_arr)
  #         #found_diplicates_hash = find_circle_duplicates(found_bk_profiles_arr)
  #         ## Действия в случае выявления дубликатов в Круге
  #         #if !search_diplicates_hash.empty?
  #         #
  #         #end
  #         #if !found_diplicates_hash.empty?
  #         #
  #         #end
  #
  #         # Сравнение двух Кругов пары профилей Если: НЕТ ДУБЛИКАТОВ В КАЖДОМ ИЗ КРУГОВ,
  #         logger.info " compare_two_circles: ИСКОМОГО ПРОФИЛЯ = #{profile_searched} и НАЙДЕННОГО ПРОФИЛЯ = #{profile_found}:"
  #         compare_rezult, common_circle_arr, delta = compare_two_circles(found_bk_arr, search_bk_arr)
  #         logger.info " compare_rezult = #{compare_rezult}"
  #         logger.info " ПЕРЕСЕЧЕНИЕ двух Кругов: common_circle_arr = #{common_circle_arr}"
  #         logger.info " РАЗНОСТЬ двух Кругов: delta = #{delta}"
  #
  #         # Анализ результата сравнения двух Кругов
  #         if !common_circle_arr.blank? # Если есть какое-то ПЕРЕСЕЧЕНИЕ при сравнении 2-х Кругов
  #           new_connection_hash = get_fields_arr_from_circles(search_bk_profiles_arr, found_bk_profiles_arr )
  #         else
  #           # @@@@@ NB !! Вставить проверку: Если Круги равны, И: НЕТ ДУБЛИКАТОВ В КАЖДОМ ИЗ КРУГОВ,
  #           # то формируем новый хэш из их профилей, КОТ-Е ТОЖЕ РАВНЫ
  #           search_is_profiles_arr.each_with_index do | is_profile, index |
  #             new_connection_hash.merge!(is_profile => found_is_profiles_arr[index])
  #           end
  #         end
  #         logger.info " После сравнения Кругов: new_connection_hash = #{new_connection_hash} "
  #
  #         # сокращение нового хэша если его эл-ты уже есть в финальном хэше
  #         # NB !! Вставить проверку: Если нет такой комбинации: k == profiles_s && v == profile_f
  #         # а есть: k == profiles_s && v != profile_f (?) возможно ли это? Что возвратит delete_if?.
  #         # и действия
  #         final_connection_hash.each do |profiles_s, profile_f|
  #           new_connection_hash.delete_if { |k,v|  k == profiles_s && v == profile_f }
  #         end
  #
  #         # накапливание нового доп.хаша по всему циклу
  #         logger.info " after delete_if in new_connection_hash = #{new_connection_hash} "
  #         add_connection_hash.merge!(new_connection_hash) if !new_connection_hash.empty?
  #         logger.info " add_connection_hash = #{add_connection_hash} "
  #
  #       end
  #
  #       # Наращивание финального хэша пар профилей для объединения, если есть чем наращивать
  #       if !add_connection_hash.empty?
  #         add_to_hash(final_connection_hash, add_connection_hash)
  #         logger.info "@@@@@ final_connection_hash = #{final_connection_hash} "
  #       end
  #
  #       # Подготовка к следующему циклу
  #       init_connection_hash = add_connection_hash
  #
  #     end
  #
  #     logger.info "final_connection_hash = #{final_connection_hash} "
  #     logger.info " "
  #     final_profiles_to_rewrite = final_connection_hash.keys
  #     final_profiles_to_destroy = final_connection_hash.values
  #
  #   end
  #
  #   return final_profiles_to_rewrite, final_profiles_to_destroy
  #
  # end



  ######## Главный стартовый метод дла перезаписи профилей в таблицах
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

    # Не заблокировано ли дерево пользователя
    if current_user.tree_is_locked?
      flash[:alert] = "Объединения в данный момент не возможно. Повторите попытку позже."
      return redirect_to :back
    else
      current_user.lock!
    end

    current_user_id = current_user.id #
    user_id = params[:user_id_to_connect].to_i # From view

    profile_current_user = current_user.profile_id #
    profile_user_id = User.find(user_id).profile_id  #
    logger.info "== in connection_of_trees 1 :  profile_current_user = #{profile_current_user}, profile_user_id = #{profile_user_id} "


    @current_user_id = current_user_id # DEBUGG_TO_VIEW
    @user_id = user_id # DEBUGG_TO_VIEW
    @certain_koeff_for_connect = params[:certain_koeff] # From view
    @certain_koeff_for_connect = @certain_koeff_for_connect.to_i

    # Взять значение из Settings
    @certain_koeff_for_connect = get_certain_koeff #3 4  from appl.cntrler
    logger.info "== in connection_of_trees:  @certain_koeff_for_connect = #{@certain_koeff_for_connect}"


    connected_user = User.find(user_id) # For lock check


    @connection_request =  ConnectionRequest.where(connection_id: params[:connection_id]).first
    @from_user = User.find(@connection_request.user_id)
    @to_user = User.find(@connection_request.with_user_id)

    @connection_id = params[:connection_id].to_i # From view Link - where pressed button Yes

    logger.info " "
    logger.info "=== IN connection_of_trees ==="
    logger.info "current_user_id = #{current_user_id}, user_id = #{user_id}, connected_user = #{connected_user} "
    logger.info "current_user.tree_is_locked? = #{current_user.tree_is_locked?}, connected_user.tree_is_locked? = #{connected_user.tree_is_locked?} "
    logger.info "@connection_id = #{@connection_id}"


      who_connect_users_arr = current_user.get_connected_users
      @who_connect_users_arr = who_connect_users_arr # DEBUGG_TO_VIEW
      # Проверка: может быть дерево автора уже было соединено с выбранным юзером?
      if !who_connect_users_arr.include?(user_id.to_i) # check_connection: IF NOT CONNECTED
        logger.info "DEBUG IN connection_of_trees: NOT CONNECTED - #{who_connect_users_arr.include?(user_id).inspect}" # == false
        with_whom_connect_users_arr = User.find(user_id).get_connected_users  #
        @with_whom_connect_users_arr = with_whom_connect_users_arr # DEBUGG_TO_VIEW

        beg_search_time = Time.now   # Начало отсечки времени поиска

        ##############################################################################
        ##### Запуск ДОСТОВЕРНОГО поиска С @@certain_koeff_for_connect
        logger.info ""
        logger.info "BEFORE start_search  "
        logger.info " @certain_koeff_for_connect = #{@certain_koeff_for_connect}"

        # Задание на поиск от Дерева Юзера: tree_is_profiles =
        # [9, 15, 14, 21, 8, 19, 11, 7, 2, 20, 16, 10, 17, 12, 3, 13, 124, 18]

        search_results = current_user.start_search(@certain_koeff_for_connect)
        ##############################################################################
        logger.info " $$$$$$$$$$$$$$  After connect_users_tr_contrl: CONNECT search_results = #{search_results.inspect}"
        #  After start_search index: results =
        # {:connected_author_arr=>[1, 2], :qty_of_tree_profiles=>18,
        # :profiles_relations_arr=>[
        # {9=>{3=>4, 10=>8, 2=>18, 17=>112}},
        # {15=>{17=>1, 11=>2, 124=>4, 16=>5, 2=>91, 12=>92, 3=>101, 13=>102, 14=>202}},
        # {14=>{12=>1, 13=>2, 11=>6, 18=>91, 20=>92, 19=>101, 21=>102, 15=>212, 16=>212}},
        # {21=>{13=>4, 20=>7, 12=>18, 11=>122, 14=>122}},
        # {8=>{2=>3, 7=>7, 3=>17, 17=>111}},
        # {19=>{12=>3, 18=>7, 13=>17, 11=>121, 14=>121}},
        # {11=>{12=>1, 13=>2, 15=>3, 16=>3, 14=>6, 17=>7, 2=>13, 3=>14, 18=>91, 20=>92, 19=>101, 21=>102, 124=>121}},
        # {7=>{2=>3, 8=>8, 3=>17, 17=>111}},
        # {2=>{7=>1, 8=>2, 17=>3, 3=>8, 9=>15, 10=>16, 11=>17, 15=>111, 16=>111}},
        # {20=>{13=>4, 21=>8, 12=>18, 11=>122, 14=>122}},
        # {16=>{17=>1, 11=>2, 15=>5, 2=>91, 12=>92, 3=>101, 13=>102, 14=>202, 124=>221}},
        # {10=>{3=>4, 9=>7, 2=>18, 17=>112}},
        # {17=>{2=>1, 3=>2, 15=>3, 16=>3, 11=>8, 12=>15, 13=>16, 7=>91, 9=>92, 8=>101, 10=>102, 124=>121}},
        # {12=>{18=>1, 19=>2, 11=>4, 14=>4, 13=>8, 20=>15, 21=>16, 17=>18, 15=>112, 16=>112}},
        # {3=>{9=>1, 10=>2, 17=>3, 2=>7, 7=>13, 8=>14, 11=>17, 15=>111, 16=>111}},
        # {13=>{20=>1, 21=>2, 11=>4, 14=>4, 12=>7, 18=>13, 19=>14, 17=>18, 15=>112, 16=>112}},
        # {124=>{15=>1, 17=>91, 11=>101, 16=>191}},
        # {18=>{12=>3, 19=>8, 13=>17, 11=>121, 14=>121}}],
        # :profiles_found_arr=>[
        # {9=>{}},
        # {15=>{9=>{85=>[1, 2, 4, 5, 91, 101]}, 10=>{100=>[1, 2, 4]}, 11=>{128=>[1, 2, 5, 91, 92, 101, 102]}}},
        # {14=>{3=>{22=>[1, 2, 6, 91, 92, 101, 102]}}},
        # {21=>{3=>{29=>[4, 7, 18, 122, 122]}}},
        # {8=>{}},
        # {19=>{3=>{27=>[3, 7, 17, 121, 121]}}},
        # {11=>{3=>{25=>[1, 2, 6, 91, 92, 101, 102]}, 11=>{127=>[1, 2, 3, 3, 7, 13, 14]}, 9=>{87=>[3, 3, 7, 13, 14, 121]}, 10=>{171=>[3, 7, 121]}}},
        # {7=>{}},
        # {2=>{9=>{172=>[3, 8, 17, 111, 111]}, 11=>{139=>[3, 8, 17, 111, 111]}}},
        # {20=>{3=>{28=>[4, 8, 18, 122, 122]}}},
        # {16=>{9=>{88=>[1, 2, 5, 91, 101, 221]}, 11=>{125=>[1, 2, 5, 91, 92, 101, 102]}}},
        # {10=>{}},
        # {17=>{9=>{86=>[1, 2, 3, 3, 8, 121]}, 11=>{126=>[1, 2, 3, 3, 8, 15, 16]}, 10=>{170=>[3, 8, 121]}}},
        # {12=>{3=>{23=>[1, 2, 4, 4, 8, 15, 16]}, 11=>{155=>[4, 8, 18, 112, 112]}}},
        # {3=>{9=>{173=>[3, 7, 17, 111, 111]}, 11=>{154=>[3, 7, 17, 111, 111]}}},
        # {13=>{3=>{24=>[1, 2, 4, 4, 7, 13, 14]}, 11=>{156=>[4, 7, 18, 112, 112]}}},
        # {124=>{9=>{91=>[1, 91, 101, 191]}, 10=>{99=>[1, 91, 101]}}},
        # {18=>{3=>{26=>[3, 8, 17, 121, 121]}}}],
        # :uniq_profiles_pairs=>{
        # 15=>{9=>85, 11=>128},
        # 14=>{3=>22},
        # 21=>{3=>29},
        # 19=>{3=>27},
        # 11=>{3=>25, 11=>127, 9=>87},
        # 2=>{9=>172, 11=>139},
        # 20=>{3=>28}, 16=>{9=>88, 11=>125},
        # 17=>{9=>86, 11=>126},
        # 12=>{3=>23, 11=>155},
        # 3=>{9=>173, 11=>154},
        # 13=>{3=>24, 11=>156},
        # 124=>{9=>91},
        # 18=>{3=>26}},
        # :profiles_with_match_hash=>{
        # 24=>7, 23=>7, 126=>7, 125=>7, 127=>7, 25=>7, 22=>7, 128=>7,
        # 86=>6, 88=>6, 87=>6, 85=>6,
        # 26=>5, 156=>5, 154=>5, 173=>5, 155=>5, 28=>5, 139=>5, 172=>5, 27=>5, 29=>5,
        # 91=>4},
        # :by_profiles=>[
        # {:search_profile_id=>13, :found_tree_id=>3, :found_profile_id=>24, :count=>7},
        # {:search_profile_id=>12, :found_tree_id=>3, :found_profile_id=>23, :count=>7},
        # {:search_profile_id=>17, :found_tree_id=>11, :found_profile_id=>126, :count=>7},
        # {:search_profile_id=>16, :found_tree_id=>11, :found_profile_id=>125, :count=>7},
        # {:search_profile_id=>11, :found_tree_id=>11, :found_profile_id=>127, :count=>7},
        # {:search_profile_id=>11, :found_tree_id=>3, :found_profile_id=>25, :count=>7},
        # {:search_profile_id=>14, :found_tree_id=>3, :found_profile_id=>22, :count=>7},
        # {:search_profile_id=>15, :found_tree_id=>11, :found_profile_id=>128, :count=>7},
        # {:search_profile_id=>17, :found_tree_id=>9, :found_profile_id=>86, :count=>6},
        # {:search_profile_id=>16, :found_tree_id=>9, :found_profile_id=>88, :count=>6},
        # {:search_profile_id=>11, :found_tree_id=>9, :found_profile_id=>87, :count=>6},
        # {:search_profile_id=>15, :found_tree_id=>9, :found_profile_id=>85, :count=>6},
        # {:search_profile_id=>18, :found_tree_id=>3, :found_profile_id=>26, :count=>5},
        # {:search_profile_id=>13, :found_tree_id=>11, :found_profile_id=>156, :count=>5},
        # {:search_profile_id=>3, :found_tree_id=>11, :found_profile_id=>154, :count=>5},
        # {:search_profile_id=>3, :found_tree_id=>9, :found_profile_id=>173, :count=>5},
        # {:search_profile_id=>12, :found_tree_id=>11, :found_profile_id=>155, :count=>5},
        # {:search_profile_id=>20, :found_tree_id=>3, :found_profile_id=>28, :count=>5},
        # {:search_profile_id=>2, :found_tree_id=>11, :found_profile_id=>139, :count=>5},
        # {:search_profile_id=>2, :found_tree_id=>9, :found_profile_id=>172, :count=>5},
        # {:search_profile_id=>19, :found_tree_id=>3, :found_profile_id=>27, :count=>5},
        # {:search_profile_id=>21, :found_tree_id=>3, :found_profile_id=>29, :count=>5},
        # {:search_profile_id=>124, :found_tree_id=>9, :found_profile_id=>91, :count=>4}]
        # :by_trees=>[
        # {:found_tree_id=>9, :found_profile_ids=>[85, 87, 172, 88, 86, 173, 91]},
        # {:found_tree_id=>11, :found_profile_ids=>[128, 127, 139, 125, 126, 155, 154, 156]},
        # {:found_tree_id=>3, :found_profile_ids=>[22, 29, 27, 25, 28, 23, 24, 26]}],
        # :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}


        ######## Сбор рез-тов поиска:
        uniq_profiles_pairs = search_results[:uniq_profiles_pairs]
        @uniq_profiles_pairs = uniq_profiles_pairs # DEBUGG_TO_VIEW

        duplicates_one_to_many = search_results[:duplicates_one_to_many]
        duplicates_many_to_one = search_results[:duplicates_many_to_one]
        @duplicates_one_to_many = duplicates_one_to_many # DEBUGG_TO_VIEW
        @duplicates_many_to_one = duplicates_many_to_one # DEBUGG_TO_VIEW

        ######## Контроль на наличие дубликатов из поиска:
        # Если есть дубликаты из Поиска, то устанавливаем stop_by_search_dublicates = true
        # На вьюхе проверяем: продолжать ли объединение.
        stop_by_search_dublicates = false
        stop_by_search_dublicates = true if !duplicates_one_to_many.empty? || !duplicates_many_to_one.empty?
        @stop_by_search_dublicates = stop_by_search_dublicates # DEBUGG_TO_VIEW
        logger.info "ERROR - STOP connection! ЕСТЬ дублирования в поиске. stop_by_search_dublicates =
                     #{stop_by_search_dublicates}" if !duplicates_one_to_many.empty? || !duplicates_many_to_one.empty?
        if stop_by_search_dublicates == false # если не было дубликатов
           #  uniq_profiles_pairs = {135=>{12=>94}, 129=>{12=>110, 13=>110, 14=>104}}
          #  uniq_profiles_pairs = { 129=>{12=>110, 13=>110, 14=>104}}
          @stop_connection = false  # for view
          flash[:notice] = "Ваши деревья успешно объединены!"
          @uniq_profiles_pairs = uniq_profiles_pairs # DEBUGG_TO_VIEW

          logger.info " After start_search in SEARCH.rb"
          logger.info " stop_by_search_dublicates = #{stop_by_search_dublicates}, @stop_connection = #{@stop_connection}"
          logger.info "BEFORE COMPLETE_SEARCH uniq_profiles_pairs = #{uniq_profiles_pairs} "


          ##############################################################################
          ##### запуск ПОЛНОГО (жесткого) метода поиска от дерева Автора
          ##### на основе исходного массива ДОСТОВЕРНЫХ ПАР ПРОФИЛЕЙ - uniq_profiles_pairs -> init_connection_hash
          ##### ПОЛНОЕ Определение массивов профилей для перезаписи: profiles_to_rewrite, profiles_to_destroy
          complete_search_data = { with_whom_connect: with_whom_connect_users_arr,
                                   uniq_profiles_pairs: uniq_profiles_pairs }

          # profiles_to_rewrite, profiles_to_destroy = current_user.complete_search(complete_search_data)
          final_connection_hash = current_user.complete_search(complete_search_data)
          ##############################################################################
          profiles_to_rewrite = final_connection_hash.keys
          profiles_to_destroy = final_connection_hash.values

          @profiles_to_rewrite = profiles_to_rewrite # DEBUGG_TO_VIEW
          @profiles_to_destroy = profiles_to_destroy # DEBUGG_TO_VIEW
          logger.info "Array(s) FOR connection:"
          logger.info "ALL profiles_to_rewrite = #{profiles_to_rewrite} "
          logger.info "ALL profiles_to_destroy = #{profiles_to_destroy} "
          logger.info "AFTER COMPLETE_SEARCH @duplicates_one_to_many = #{@duplicates_one_to_many} "
          logger.info "AFTER COMPLETE_SEARCH @duplicates_many_to_one = #{@duplicates_many_to_one} "

          #profiles_to_destroy = [14, 21, 19, 11, 20, 12, 13, 18]
          #profiles_to_rewrite = [22, 29, 27, 25, 28, 23, 24, 26]
          # @duplicates_one_to_many = {}
          # @duplicates_many_to_one = {}.

          end_search_time = Time.now   # Конец отсечки времени поиска
          @elapsed_search_time = (end_search_time - beg_search_time).round(5) # Длительность поиска - для инфы

          connection_data = {
              who_connect:          who_connect_users_arr, #
              with_whom_connect:    with_whom_connect_users_arr, #
              profiles_to_rewrite:  profiles_to_rewrite, #
              profiles_to_destroy:  profiles_to_destroy, #
              current_user_id:      current_user_id, #
              user_id:              user_id ,#
              connection_id:        @connection_id #
          }
          logger.info "Connection - GO ON! connection_data = #{connection_data}"

          # [1 2] c [3]

          # In check_connection_arrs:  connection_data =

           # connection_data = {:who_connect=>[1, 2], :with_whom_connect=>[3],
           #                    :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18],
           #                    :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26]
           # , :current_user_id=>2, :user_id=>3, :connection_id=>3}

           ######## Контроль корректности массивов перед объединением
          stop_by_arrs = false
          stop_by_arrs, connection_message = check_connection_arrs(connection_data)
          if stop_by_arrs == false
            @stop_connection = false  # for view
            flash[:notice] = "Ваши деревья успешно объединены!"
            logger.info "Connection - GO ON! array(s) - CORRECT! stop_by_arrs = #{stop_by_arrs}, @stop_connection = #{@stop_connection}"
            connection_message = "Деревья объединяются..."

            ##################################################################
            ##### Центральный метод соединения деревьев = перезапись и удаление профилей в таблицах
            # connection_in_tables(connection_data, current_user_id, user_id, @connection_id)
            connection_in_tables(connection_data) #, current_user_id, user_id, @connection_id)
            ##################################################################
            # ##### Update connection requests - to yes connect
            #  yes_to_request(@connection_id)
            # ##################################################################
            # # Make DONE all connected requests
            # # - update all requests - with users, connected with current_user
            #  after_conn_update_requests  # From Helper
            # ##############################################
            #
            # ##########  UPDATES FEEDS - № 2  ############## В обоих направлениях: Кто с Кем и Обратно
            # logger.info "== in connection_of_trees UPDATES :  profile_current_user = #{profile_current_user}, profile_user_id = #{profile_user_id} "
            # UpdatesFeed.create(user_id: current_user_id, update_id: 2, agent_user_id: user_id, agent_profile_id: profile_user_id, read: false)
            # UpdatesFeed.create(user_id: user_id, update_id: 2, agent_user_id: current_user_id, agent_profile_id: profile_current_user, read: false)
            # ###############################################


          else
            @stop_connection = true  # for view
            flash[:alert] = "В данный момент нельзя объединить ваши деревья!"
            logger.info "ERROR - STOP connection! SimilarsConnection array(s) - INCORRECT! stop_by_arrs = #{stop_by_arrs}, "
          end

        else
          @stop_connection = true  # for view
          flash[:alert] = "В данный момент нельзя объединить ваши деревья!"
          logger.info "ERROR - STOP connection! ЕСТЬ дублирования в поиске. @duplicates_one_to_many = #{@duplicates_one_to_many}; @duplicates_many_to_one = #{@duplicates_many_to_one}."
        end

      else
        @stop_connection = true  # for view
        flash[:alert] = "В данный момент нельзя объединить ваши деревья!"
        logger.info "WARNING: DEBUG IN connection_of_trees: USERS ALREADY CONNECTED! Current_user_arr =#{who_connect_users_arr.inspect}, user_id_arr=#{with_whom_connect_users_arr.inspect}."
      end
      @stop_by_arrs = stop_by_arrs # DEBUGG_TO_VIEW
      @connection_message = connection_message # DEBUGG_TO_VIEW


      # unlock tree
      current_user.unlock_tree!


  end

  # update request data - to yes to connect
  # Ответ ДА на запрос на объединение
  # Действия: сохраняем инфу - кто дал добро (= 1) какому объединению
  # Перед этим - запуск собственно процесса объединения
  def yes_to_request(connection_id)
    requests_to_update = ConnectionRequest.where(:connection_id => connection_id, :done => false ).order('created_at').reverse_order
    if !requests_to_update.blank?
      requests_to_update.each do |request_row|
        request_row.done = true
        request_row.confirm = 1 if request_row.with_user_id == current_user.id
        request_row.save
      end
      logger.info "In update_requests: Done"
    else
      logger.info "WARNING: NO update_requests WAS DONE!"
      redirect_to show_user_requests_path # To: Просмотр Ваших оставшихся запросов'
      # flash - no connection requests data in table
    end
  end


  ######## Контроль корректности массивов перед объединением
  def check_connection_arrs(connection_data )
    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]

    stop_by_arrs = false
    logger.info "== In check_connection_arrs:  connection_data = #{connection_data}"
    ######## Контроль корректности массивов перед объединением
    if !profiles_to_rewrite.blank? && !profiles_to_destroy.blank?
      logger.info "Ok to connect. Array(s) - Dont blank."

      # Проверка на наличие общих (совпадающих) эл-тов у массивов перезаписи
      commons = check_commons(profiles_to_rewrite, profiles_to_destroy)
      logger.info "== In check_uniqness:  commons = #{commons}"
      if commons.blank?  # Нет пересечения commons=[]- общих профилей - Ок

        if profiles_to_rewrite.size == profiles_to_destroy.size
          logger.info "Ok to connect. Connection array(s) - Equal. Size = #{profiles_to_rewrite.size}."

          # Проверка найденных массивов перезаписи перед объединением - на повторы
          complete_dubles_hash = check_duplications(profiles_to_rewrite, profiles_to_destroy)

          if complete_dubles_hash.empty? # Если НЕТ дублирования в массивах
            connection_message = "Ok to connect. НЕТ Дублирований in Connection array(s) "
            logger.info "Ok to connect. НЕТ Дублирований in Connection array(s).  complete_dubles_hash = #{complete_dubles_hash};  connection_message = #{connection_message};"
          else
            connection_message = "ERROR: Объединение остановлено! ЕСТЬ дублирования в массивах:"
            logger.info "ERROR: STOP connection! ЕСТЬ дублирования в массивах: complete_dubles_hash = #{complete_dubles_hash};  connection_message = #{connection_message};"
            stop_by_arrs = true #
          end

        else
          connection_message = "ERROR: Объединение остановлено! Array(s) - NOT Equal!"
          logger.info "ERROR: STOP connection! Array(s) - NOT Equal!  To_rewrite arr.size = #{profiles_to_rewrite.size}; To_destroy arr.size = #{profiles_to_destroy.size}.  connection_message = #{connection_message};"
          stop_by_arrs = true
        end

      else
        connection_message = "Объединение остановлено. В массивах объединения - есть общие профили!"
        logger.info "ERROR: В массивах объединения - есть общие профили! connection_message = #{connection_message};."
        stop_by_arrs = true

      end

    else
      connection_message = "Объединение остановлено, т.к. недостаточно отношений между профилями. (Массивы объединения - пустые)"
      logger.info "ERROR: Connection array(s) - blank! connection_message = #{connection_message};."
      stop_by_arrs = true
    end

    @complete_dubles_hash = complete_dubles_hash  # DEBUGG_TO_VIEW
    logger.info "== After in check_connection_arrs:  stop_by_arrs = #{stop_by_arrs}, connection_message = #{connection_message} "

    return stop_by_arrs, connection_message
  end


  # ИСПОЛЬЗУЕТСЯ В МЕТОДЕ ОБЪЕДИНЕНИЯ ДЕРЕВЬЕВ - connection_of_trees
  # Проверка найденных массивов перезаписи при объединении - на повторы
  # .
  def check_duplications(profiles_to_rewrite, profiles_to_destroy)

    # Извлечение из массива - повторяющиеся эл-ты в виде массива
    def repeated(array)
      counts = Hash.new(0)
      array.each{|val|counts[val]+=1}
      counts.reject{|val,count|count==1}.keys
    end

    repeated_destroy = repeated(profiles_to_destroy)
    indexs_hash_destroy = {}
    if !repeated_destroy.blank?
      for i in 0 .. repeated_destroy.length-1
        arr_of_dubles = []
        profiles_to_destroy.each_with_index do |arr_el, index|
          if arr_el == repeated_destroy[i]
            arr_of_dubles << profiles_to_rewrite[index]
          end
        end
        indexs_hash_destroy.merge!(repeated_destroy[i] => arr_of_dubles)
      end
    end

    repeated_rewrite = repeated(profiles_to_rewrite)
    indexs_hash_rewrite = {}
    if !repeated_rewrite.blank?
      for i in 0 .. repeated_rewrite.length-1
        arr_of_dubles = []
        profiles_to_rewrite.each_with_index do |arr_el, index|
          if arr_el == repeated_rewrite[i]
            arr_of_dubles << profiles_to_destroy[index]
          end
        end
        indexs_hash_rewrite.merge!(repeated_rewrite[i] => arr_of_dubles)
      end
    end

    complete_dubles_hash = {}
    complete_dubles_hash = complete_dubles_hash.merge!(indexs_hash_destroy) if !indexs_hash_destroy.blank?
    complete_dubles_hash = complete_dubles_hash.merge!(indexs_hash_rewrite) if !indexs_hash_rewrite.blank?

    @complete_dubles_hash = complete_dubles_hash # DEBUGG_TO_VIEW

    return complete_dubles_hash

  end


  # Проверка на наличие общих (совпадающих) эл-тов у массивов перезаписи
  # Что - не должно быть!.
  def check_commons(array1, array2)
    logger.info "== In check_uniqness:  array1 = #{array1}"
    logger.info "== In check_uniqness:  array2 = #{array2}"
    commons = array1 & array2

    return commons
  end



end
