class ConnectUsersTreesController < ApplicationController
  include SearchHelper
  include ConnectionRequestsHelper


  layout 'application.new'



  # Метод дла перезаписи профилей в таблицах
  # who_found_user_id - Автор дерева, который ищет
  # where_found_user_id - Автор дерева, в котором найдено
  ## (остаются): profiles_to_rewrite -
  ## (уходят): profiles_to_destroy -
  # who_connect_ids_arr - массив id, входящих в объед-ное дерево автора (того, кто соединяется)
  # with_who_conn_ids_ar - массив id, входящих в объед-ное дерево того, с кем соединяется автор
  #
  # def connect_trees_prev(profiles_to_rewrite, profiles_to_destroy, who_connect_ids_arr, with_who_conn_ids_ar)
  #
  #   logger.info "DEBUG IN CONNECT_TREES: profiles_to_rewrite = #{profiles_to_rewrite}; profiles_to_destroy = #{profiles_to_destroy} "
  #
  #   rewrite_tree_arr1 = []
  #   rewrite_tree_arr2 = []
  #   rewrite_profilekey_arr1 = []
  #   rewrite_profilekey_arr2 = []
  #
  #   #########  перезапись profile_id's & update User
  #   ## (остаются): profiles_to_rewrite - противоположные, найденным в поиске
  #   ## (уходят): profiles_to_destroy - найден в поиске
  #   # Первым параметром идут те профили, которые остаются
  #   Profile.merge(connection_data)
  #
  #   for arr_ind in 0 .. profiles_to_destroy.length-1 # ищем этот profile_id для его замены
  #     # меняем profile_id в match_profiles_arr на profile_id из opposite_profiles_arr
  #     one_profile = profiles_to_destroy[arr_ind] # profile_id для замены
  #     logger.info one_profile
  #
  #     with_who_conn_ids_ar.each do |one_user_in_tree|
  #       # Получение массивов для Замены профилей в Tree
  #       one_arr1 = get_rewrite_profiles_ids(Tree, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
  #       rewrite_tree_arr1 << one_arr1 if !one_arr1.blank?
  #       @rewrite_tree_arr1 = rewrite_tree_arr1 # DEBUGG_TO_VIEW
  #       one_arr2 = get_rewrite_profiles_ids(Tree, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
  #       rewrite_tree_arr2 << one_arr2 if !one_arr2.blank?
  #       @rewrite_tree_arr2 = rewrite_tree_arr2 # DEBUGG_TO_VIEW
  #
  #       # Получение массивов для Замены профилей в ProfileKey
  #       one_arr1 = get_rewrite_profiles_ids(ProfileKey, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
  #       rewrite_profilekey_arr1 << one_arr1 if !one_arr1.blank?
  #       @rewrite_profilekey_arr1 = rewrite_profilekey_arr1 # DEBUGG_TO_VIEW
  #       one_arr2 = get_rewrite_profiles_ids(ProfileKey, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
  #       rewrite_profilekey_arr2 << one_arr2 if !one_arr2.blank?
  #       @rewrite_profilekey_arr2 = rewrite_profilekey_arr2 # DEBUGG_TO_VIEW
  #     end
  #
  #     who_connect_ids_arr.each do |one_user_in_tree|
  #       # Получение массивов для Замены профилей в Tree
  #       one_arr1 = get_rewrite_profiles_ids(Tree, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
  #       rewrite_tree_arr1 << one_arr1 if !one_arr1.blank?
  #       @rewrite_tree_arr1 = rewrite_tree_arr1 # DEBUGG_TO_VIEW
  #       one_arr2 = get_rewrite_profiles_ids(Tree, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
  #       rewrite_tree_arr2 << one_arr2 if !one_arr2.blank?
  #       @rewrite_tree_arr2 = rewrite_tree_arr2 # DEBUGG_TO_VIEW
  #
  #       # Получение массивов для Замены профилей в ProfileKey
  #       one_arr1 = get_rewrite_profiles_ids(ProfileKey, "profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
  #       rewrite_profilekey_arr1 << one_arr1 if !one_arr1.blank?
  #       @rewrite_profilekey_arr1 = rewrite_profilekey_arr1 # DEBUGG_TO_VIEW
  #       one_arr2 = get_rewrite_profiles_ids(ProfileKey, "is_profile_id", one_user_in_tree, one_profile.to_i, profiles_to_rewrite[arr_ind].to_i)
  #       rewrite_profilekey_arr2 << one_arr2 if !one_arr2.blank?
  #       @rewrite_profilekey_arr2 = rewrite_profilekey_arr2 # DEBUGG_TO_VIEW
  #     end
  #
  #   end
  #
  #   save_rewrite_profiles_ids(Tree, rewrite_tree_arr1 + rewrite_tree_arr2)
  #   @save_in_tree = @saved_profiles_arr # DEBUGG_TO_VIEW
  #   @save_in_tree_LEN = @saved_profiles_arr.length if !@save_in_tree.blank? # DEBUGG_TO_VIEW
  #   save_rewrite_profiles_ids(ProfileKey, rewrite_profilekey_arr1 + rewrite_profilekey_arr2)
  #   @save_in_profilekey = @saved_profiles_arr # DEBUGG_TO_VIEW
  #   @save_in_profilekey_LEN = @saved_profiles_arr.length if !@save_in_profilekey.blank? # DEBUGG_TO_VIEW
  #
  # end



  # @note: Главный стартовый метод объединения деревьев
  # @param: Вход:
  #   current_user_id = params[:current_user_id] = who_found_user_id - Автор дерева, который ищет
  #   user_id = params[:user_id_to_connect] = where_found_user_id - Автор дерева, в котором найдено# DEBUGG_TO_VIEW#
  #   matched_profiles_in_tree = ... params[:matched_profiles] = Из поиска: @final_reduced_profiles_hash
  #   matched_relations_in_tree = ... params[:matched_relations] = Из поиска:  @final_reduced_relations_hash
  # Выход:
  # 1. перезапись profile_id в таблице Profile.
  # 2. update в таблице User
  # 3. перезапись profile_id в полях "profile_id" и "is_profile_id"
  # в таблицах Tree & ProfileKey.
  def connection_of_trees

    # Не заблокировано ли дерево пользователя
    if current_user.tree_is_locked?
      flash[:warning] = "Объединения в данный момент невозможно. Временная блокировка пользователя.
                       Можно повторить попытку позже."
      return redirect_to home_path #:back
    else
      current_user.lock!
    end

    current_user_id = current_user.id          #
    user_id = params[:user_id_to_connect].to_i # From view
    @current_user_id = current_user_id # DEBUGG_TO_VIEW
    @user_id = user_id # DEBUGG_TO_VIEW

    profile_current_user = current_user.profile_id   #
    profile_user_id = User.find(user_id).profile_id  #
    logger.info "== in connection_of_trees 1: profile_current_user = #{profile_current_user},
                 profile_user_id = #{profile_user_id} "

    @connection_request =  ConnectionRequest.where(connection_id: params[:connection_id]).first
    @from_user = User.find(@connection_request.user_id)
    @to_user = User.find(@connection_request.with_user_id)

    @connection_id = params[:connection_id].to_i # From view Link - where pressed button Yes

    logger.info "=== IN connection_of_trees ==="
    logger.info "current_user_id = #{current_user_id}, user_id = #{user_id} "
    logger.info "@connection_id = #{@connection_id}"

    who_connect_users_arr = current_user.get_connected_users
    @who_connect_users_arr = who_connect_users_arr

    # who_connect_users_arr = [1,2,3] # for DEBUGG ONLY!!!

    # Проверка: может быть дерево автора уже было соединено с выбранным юзером?
     if check_already_connected(who_connect_users_arr, user_id)
       return
     end

    with_whom_connect_users_arr = User.find(user_id).get_connected_users  #
    @with_whom_connect_users_arr = with_whom_connect_users_arr # DEBUGG_TO_VIEW

    beg_search_time = Time.now   # Начало отсечки времени поиска

    ##### Запуск стартового ДОСТОВЕРНОГО поиска с certain_koeff_for_connect из Weafam_Settings
    # search_results = current_user.start_search(certain_koeff_for_connect)
    search_results = current_user.start_search(get_certain_koeff) # get_certain_koeff=4 -  значение из Settings from appl.cntrler
    ##############################################################################
    logger.info " In connection_of_trees, After start_search: search_results = #{search_results.inspect}"
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
    duplicates_one_to_many = search_results[:duplicates_one_to_many]
    duplicates_many_to_one = search_results[:duplicates_many_to_one]
    @duplicates_one_to_many = duplicates_one_to_many  # DEBUGG_TO_VIEW
    @duplicates_many_to_one = duplicates_many_to_one  # DEBUGG_TO_VIEW

    logger.info "In connection_of_trees, After start_search: duplicates_one_to_many = #{duplicates_one_to_many},
                 duplicates_many_to_one = #{duplicates_many_to_one} "

    @stop_connection = false  # for view

    ######## Контроль на наличие дубликатов из поиска:
    # Если есть дубликаты из Поиска, то устанавливаем stop_by_search_dublicates = true
    # На вьюхе проверяем: продолжать ли объединение.
    if check_duplicates_exist(duplicates_one_to_many, duplicates_many_to_one)
      return
    end

    logger.info "BEFORE complete_search: uniq_profiles_pairs = #{uniq_profiles_pairs} "
    ##############################################################################
    ##### запуск ПОЛНОГО метода поиска от дерева Автора
    ##### на основе исходного массива ДОСТОВЕРНЫХ ПАР ПРОФИЛЕЙ - uniq_profiles_pairs -> init_connection_hash
    ##### ПОЛНОЕ Определение массивов профилей для перезаписи: profiles_to_rewrite, profiles_to_destroy
    complete_search_data = { with_whom_connect: with_whom_connect_users_arr,
                             uniq_profiles_pairs: uniq_profiles_pairs }
    final_connection_hash = current_user.complete_search(complete_search_data)
    ##############################################################################
    profiles_to_rewrite = final_connection_hash.keys
    profiles_to_destroy = final_connection_hash.values

    @profiles_to_rewrite = profiles_to_rewrite # DEBUGG_TO_VIEW
    @profiles_to_destroy = profiles_to_destroy # DEBUGG_TO_VIEW
    logger.info "AFTER complete_search:"
    logger.info "ALL profiles_to_rewrite = #{profiles_to_rewrite} "
    logger.info "ALL profiles_to_destroy = #{profiles_to_destroy} "

    #profiles_to_destroy = [14, 21, 19, 11, 20, 12, 13, 18]
    #profiles_to_rewrite = [22, 29, 27, 25, 28, 23, 24, 26]

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

    # In check_connection_arrs:  connection_data =
    # connection_data = {:who_connect=>[1, 2], :with_whom_connect=>[3],
    #                    :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18],
    #                    :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26]
    # , :current_user_id=>2, :user_id=>3, :connection_id=>3}
    ######## Контроль корректности массивов перед объединением
    check_connection_result = current_user.check_connection_arrs(connection_data)
    ##############################################################################

    @stop_by_arrs = check_connection_result[:stop_by_arrs]
    connection_message = check_connection_result[:diag_connection_message]
    logger.info "After Check Connection: check_connection_result = #{check_connection_result} "

    if check_stop_connection(check_connection_result[:stop_by_arrs], check_connection_result[:diag_connection_message] )
      return
    end

    unless @stop_connection || @stop_by_arrs # for stop_connection & view

      ##################################################################
      ##### Центральный метод соединения деревьев = перезапись и удаление профилей в таблицах
      current_user.connection_in_tables(connection_data)
      ##################################################################

      flash[:notice] = " #{connection_message} Ваши деревья успешно объединены!"
      logger.info "Connection - GO ON! array(s) - CORRECT!,
                   @stop_connection = #{@stop_connection},\n connection_message = #{connection_message}"
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

      # unlock tree
      current_user.unlock_tree!

    end


  end

  # @note: Проверка: может быть дерево автора уже было соединено с выбранным юзером?
  def check_already_connected(who_connect_users, user_id)
    if who_connect_users.include?(user_id.to_i) # check_connection: IF NOT CONNECTED
      flash[:alert] = "Нельзя объединить ваши деревья, т.к. есть информация, что они уже объединены!"
      logger.info "Нельзя объединить ваши деревья, т.к. есть информация, что они уже объединены!
           Current_user_arr = #{who_connect_users.inspect}, user_id = #{user_id.inspect}."

      current_user.unlock_tree!  # unlock tree
      @stop_connection = true  # for stop_connection & view

      redirect_to home_path
    end
  end

  # @note: Контроль на наличие дубликатов из поиска:
  # Если есть дубликаты из Поиска, то устанавливаем stop_by_search_dublicates = true
  # На вьюхе проверяем: продолжать ли объединение.
  def  check_duplicates_exist(duplicates_one_many, duplicates_many_one)
    if !duplicates_one_many.empty? || !duplicates_many_one.empty? #
      flash[:alert] = "Нельзя объединить ваши деревья, т.к. в результатах поиска есть дубликаты!"
      logger.info "Нельзя объединить ваши деревья, т.к. в результатах поиска есть дубликаты!
             duplicates_one_to_many = #{duplicates_one_many}; duplicates_many_to_one = #{duplicates_many_one}."

      current_user.unlock_tree! # unlock tree
      @stop_connection = true  # for stop_connection & view

      redirect_to home_path
    end
  end


  # @note: Контроль корректности массивов перед объединением
  def check_stop_connection(stop_connection, diag_connection_message)
    if stop_connection
      flash[:alert] = " #{diag_connection_message} " #  Нельзя объединить ваши деревья, т.к. данные для объединения - некорректны!"
      logger.info " #{diag_connection_message} " #   Нельзя объединить ваши деревья, т.к. данные для объединения - некорректны! "

      current_user.unlock_tree! # unlock tree
      @stop_connection = true  # for stop_connection & view

      redirect_to home_path
    end
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


end
