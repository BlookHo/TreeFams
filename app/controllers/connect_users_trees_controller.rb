class ConnectUsersTreesController < ApplicationController
  include SearchHelper
  include ConnectionRequestsHelper


  def connect_users(current_user_id, user_id)

    if current_user_id != user_id
      new_users_connection = ConnectedUser.new
      new_users_connection.user_id = current_user_id
      new_users_connection.with_user_id = user_id
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

  # Метод дла перезаписи профилей в таблицах
  # who_found_user_id - Автор дерева, который ищет
  # where_found_user_id - Автор дерева, в котором найдено
  ## (остаются): profiles_to_rewrite -
  ## (уходят): profiles_to_destroy -
  # who_connect_ids_arr - массив id, входящих в объед-ное дерево автора (того, кто соединяется)
  # with_who_conn_ids_ar - массив id, входящих в объед-ное дерево того, с кем соединяется автор
  #
  def connect_trees(profiles_to_rewrite, profiles_to_destroy, who_connect_ids_arr, with_who_conn_ids_ar)

    logger.info "DEBUG IN CONNECT_TREES: profiles_to_rewrite = #{profiles_to_rewrite}; profiles_to_destroy = #{profiles_to_destroy} "

    rewrite_tree_arr1 = []
    rewrite_tree_arr2 = []
    rewrite_profilekey_arr1 = []
    rewrite_profilekey_arr2 = []

    #########  перезапись profile_id's & update User
    ## (остаются): profiles_to_rewrite - противоположные, найденным в поиске
    ## (уходят): profiles_to_destroy - найден в поиске
    # Первым параметром идут те профили, которые остаются
    Profile.merge(profiles_to_rewrite, profiles_to_destroy)

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



  # Получение стартового Хэша для объединения профилей на основе:
  # uniq_profiles_pairs - хэша уникальных достоверных пар профилей,
  # полученных в рез-те отработки start_search
  # connected_user - дерева(деревьев), с котороыми собираемся объединяться
  # На выходе - init_connection_hash - Хэш достоверных пар профилей,
  # с которых начинается процесс жесткого определения полного набора соответствий между всеми профилями
  # объединяемых деревьев.
  def make_init_connection_hash(with_whom_connect_users_arr, uniq_profiles_pairs)
    logger.info "with_whom_connect_users_arr = #{with_whom_connect_users_arr}, uniq_profiles_pairs = #{uniq_profiles_pairs}"
    init_connection_hash = {} # hash to work with
    uniq_profiles_pairs.each do |searched_profile, trees_hash|
      #logger.info " searched_profile = #{searched_profile}, trees_hash = #{trees_hash}"
      trees_hash.each do |tree_key, found_profile|
        #logger.info " tree_key = #{tree_key}, found_profile = #{found_profile}"
        # выбор результатов для дерева из with_whom_connect_users_arr
        # перезапись в хэше под key = searched_profile
        if with_whom_connect_users_arr.include?(tree_key) #
          init_connection_hash.merge!( searched_profile => found_profile )
          #logger.info " init_connection_hash = #{init_connection_hash}"
        end
      end
    end
    return init_connection_hash
  end


  # NEW METHOD "HARD COMPLETE SEARCH"- TO DO
  # Input: start tree No, tree No to connect
  # сбор полного хэша достоверных пар профилей для объединения
  # Output:
  # Определение массивов профилей для перезаписи: profiles_to_rewrite, profiles_to_destroy
  # start_tree = от какого дерева объедин.
  # connected_user = с каким деревом объед-ся
  # Input: init_connection_hash
  def hard_complete_search(init_connection_hash)
    logger.info "** IN hard_complete_search *** "
    #logger.info " init_connection_hash = #{init_connection_hash}"
    final_profiles_to_rewrite = []
    final_profiles_to_destroy = []
    if !init_connection_hash.empty?

      final_connection_hash = init_connection_hash

      # начало сбора полного хэша достоверных пар профилей для объединения
      until init_connection_hash.empty?
        logger.info "** IN UNTIL top: init_connection_hash = #{init_connection_hash}"

        # get new_hash for connection
        add_connection_hash = {}
        init_connection_hash.each do |profile_searched, profile_found|

          new_connection_hash = {}
          # Получение Кругов для первой пары профилей -
          # для последующего сравнения и анализа
          search_bk_arr, search_bk_profiles_arr, search_is_profiles_arr = have_profile_circle(profile_searched)
          found_bk_arr, found_bk_profiles_arr, found_is_profiles_arr = have_profile_circle(profile_found)
          logger.info " "
          logger.info " search_is_profiles_arr = #{search_is_profiles_arr}, found_is_profiles_arr = #{found_is_profiles_arr} "

          ## Проверка Кругов на дубликаты
          #search_diplicates_hash = find_circle_duplicates(search_bk_profiles_arr)
          #found_diplicates_hash = find_circle_duplicates(found_bk_profiles_arr)
          ## Действия в случае выявления дубликатов в Круге
          #if !search_diplicates_hash.empty?
          #
          #end
          #if !found_diplicates_hash.empty?
          #
          #end

          # Сравнение двух Кругов пары профилей Если: НЕТ ДУБЛИКАТОВ В КАЖДОМ ИЗ КРУГОВ,
          logger.info " compare_two_circles: ИСКОМОГО ПРОФИЛЯ = #{profile_searched} и НАЙДЕННОГО ПРОФИЛЯ = #{profile_found}:"
          compare_rezult, common_circle_arr, delta = compare_two_circles(found_bk_arr, search_bk_arr)
          logger.info " compare_rezult = #{compare_rezult}"
          logger.info " ПЕРЕСЕЧЕНИЕ двух Кругов: common_circle_arr = #{common_circle_arr}"
          logger.info " РАЗНОСТЬ двух Кругов: delta = #{delta}"

          # Анализ результата сравнения двух Кругов
          if !common_circle_arr.blank? # Если есть какое-то ПЕРЕСЕЧЕНИЕ при сравнении 2-х Кругов
            new_connection_hash = get_fields_arr_from_circles(search_bk_profiles_arr, found_bk_profiles_arr )
          else
            # @@@@@ NB !! Вставить проверку: Если Круги равны, И: НЕТ ДУБЛИКАТОВ В КАЖДОМ ИЗ КРУГОВ,
            # то формируем новый хэш из их профилей, КОТ-Е ТОЖЕ РАВНЫ
            search_is_profiles_arr.each_with_index do | is_profile, index |
              new_connection_hash.merge!(is_profile => found_is_profiles_arr[index])
            end
          end
          logger.info " После сравнения Кругов: new_connection_hash = #{new_connection_hash} "

          # сокращение нового хэша если его эл-ты уже есть в финальном хэше
          # NB !! Вставить проверку: Если нет такой комбинации: k == profiles_s && v == profile_f
          # а есть: k == profiles_s && v != profile_f (?) возможно ли это? Что возвратит delete_if?.
          # и действия
          final_connection_hash.each do |profiles_s, profile_f|
            new_connection_hash.delete_if { |k,v|  k == profiles_s && v == profile_f }
          end

          # накапливание нового доп.хаша по всему циклу
          logger.info " after delete_if in new_connection_hash = #{new_connection_hash} "
          add_connection_hash.merge!(new_connection_hash) if !new_connection_hash.empty?
          logger.info " add_connection_hash = #{add_connection_hash} "

        end

        # Наращивание финального хэша пар профилей для объединения, если есть чем наращивать
        if !add_connection_hash.empty?
          add_to_hash(final_connection_hash, add_connection_hash)
          logger.info "@@@@@ final_connection_hash = #{final_connection_hash} "
        end

        # Подготовка к следующему циклу
        init_connection_hash = add_connection_hash

      end

      logger.info "final_connection_hash = #{final_connection_hash} "
      logger.info " "
      final_profiles_to_rewrite = final_connection_hash.keys
      final_profiles_to_destroy = final_connection_hash.values

    end

    return final_profiles_to_rewrite, final_profiles_to_destroy

  end


  ## Need to create table
  #def get_settings(field_name)
  #  settings = WeafamSetting.first   # Берем из Таблицы настроек значение требуемого кол-ва совпадений отношений
  #  # для признания двух профилей эквивалентными.
  #  @parameter_value = settings.field_name   # To take from Bl_settings == 650 !
  #end

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

    current_user_id = current_user.id #
    user_id = params[:user_id_to_connect] # From view
    @current_user_id = current_user_id # DEBUGG_TO_VIEW
    @user_id = user_id # DEBUGG_TO_VIEW
    @certain_koeff_for_connect = params[:certain_koeff] # From view
    @certain_koeff_for_connect = @certain_koeff_for_connect.to_i
    # Взять значение из Settings
    @certain_koeff_for_connect = 4
    connected_user = User.find(user_id) # For lock check

    @connection_id = params[:connection_id].to_i # From view Link - where pressed button Yes

    logger.info " "
    logger.info "=== IN connection_of_trees ==="
    logger.info "current_user_id = #{current_user_id}, user_id = #{user_id}, connected_user = #{connected_user} "
    logger.info "current_user.tree_is_locked? = #{current_user.tree_is_locked?}, connected_user.tree_is_locked? = #{connected_user.tree_is_locked?} "
    logger.info "@connection_id = #{@connection_id}"

    ######## Check users lock status and connect if all ok
    #if current_user.tree_is_locked? or connected_user.tree_is_locked?
    #  logger.info "Connection locked"
    #  redirect_to :back, :alert => "Дерево находится в процессе реорганизации, повторите попытку позже"
    #else
    #  logger.info "Connection UNLOCK => GO ON! "
    #  logger.info "current_user = #{current_user},  connected_user = #{connected_user} "
    #
    #  current_user.lock!
    #  connected_user.lock!

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

        search_results = current_user.start_search(@certain_koeff_for_connect)
        ##############################################################################

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
        logger.info "ERROR - STOP connection! ЕСТЬ дублирования в поиске. stop_by_search_dublicates = #{stop_by_search_dublicates}" if !duplicates_one_to_many.empty? || !duplicates_many_to_one.empty?
        if stop_by_search_dublicates == false # если не было дубликатов
           #  uniq_profiles_pairs = {135=>{12=>94}, 129=>{12=>110, 13=>110, 14=>104}}
          #  uniq_profiles_pairs = { 129=>{12=>110, 13=>110, 14=>104}}
          @stop_connection = false  # for view
          @uniq_profiles_pairs = uniq_profiles_pairs # DEBUGG_TO_VIEW

          logger.info " After start_search in SEARCH.rb"
          logger.info " stop_by_search_dublicates = #{stop_by_search_dublicates}, @stop_connection = #{@stop_connection}"
          logger.info "BEFORE HARD_COMPLETE_SEARCH uniq_profiles_pairs = #{uniq_profiles_pairs} "

          init_connection_hash = make_init_connection_hash(with_whom_connect_users_arr, uniq_profiles_pairs)
          logger.info " init_connection_hash = #{init_connection_hash}"

          ##############################################################################
          ##### запуск ПОЛНОГО (жесткого) метода поиска от дерева Автора
          ##### на основе исходного массива ДОСТОВЕРНЫХ ПАР ПРОФИЛЕЙ - uniq_profiles_pairs -> init_connection_hash
          ##### ПОЛНОЕ Определение массивов профилей для перезаписи: profiles_to_rewrite, profiles_to_destroy
          #profiles_to_rewrite, profiles_to_destroy = []
          profiles_to_rewrite, profiles_to_destroy = hard_complete_search(init_connection_hash)
          ##############################################################################

          @profiles_to_rewrite = profiles_to_rewrite # DEBUGG_TO_VIEW
          @profiles_to_destroy = profiles_to_destroy # DEBUGG_TO_VIEW
          logger.info "Array(s) FOR connection:"
          logger.info "ALL profiles_to_rewrite = #{profiles_to_rewrite} "
          logger.info "ALL profiles_to_destroy = #{profiles_to_destroy} "
          logger.info "AFTER HARD_COMPLETE_SEARCH @duplicates_one_to_many = #{@duplicates_one_to_many} "
          logger.info "AFTER HARD_COMPLETE_SEARCH @duplicates_many_to_one = #{@duplicates_many_to_one} "

          #profiles_to_rewrite = [88, 89, 90, 94, 93, 16, 16]
          #profiles_to_destroy = [134, 136, 137, 135, 128, 16, 19]

          end_search_time = Time.now   # Конец отсечки времени поиска
          @elapsed_search_time = (end_search_time - beg_search_time).round(5) # Длительность поиска - для инфы

          connection_data = {
              who_connect: who_connect_users_arr, #
              with_whom_connect: with_whom_connect_users_arr, #
              profiles_to_rewrite: profiles_to_rewrite, #
              profiles_to_destroy: profiles_to_destroy #
          }

          ######## Контроль корректности массивов перед объединением
          stop_by_arrs = false
          stop_by_arrs, connection_message = check_connection_arrs(connection_data)
          if stop_by_arrs == false
            @stop_connection = false  # for view
            logger.info "Connection - GO ON! Connection array(s) - CORRECT! stop_by_arrs = #{stop_by_arrs}, @stop_connection = #{@stop_connection}"
            connection_message = "Деревья объединяются..."

            ##################################################################
            ##### Центральный метод соединения деревьев = перезапись и удаление профилей в таблицах
            connection_in_tables(connection_data, current_user_id, user_id)
            ##################################################################
            ##### Update connection requests - to yes connect
             yes_to_request(@connection_id)
            ##################################################################
            # Make DONE all connected requests
            # - update all requests - with users, connected with current_user
             after_conn_update_requests  # From Helper
            ##############################################

          else
            logger.info "ERROR - STOP connection! Connection array(s) - INCORRECT! stop_by_arrs = #{stop_by_arrs}, "
          end

        else
          logger.info "ERROR - STOP connection! ЕСТЬ дублирования в поиске. @duplicates_one_to_many = #{@duplicates_one_to_many}; @duplicates_many_to_one = #{@duplicates_many_to_one}."
        end

      else
        logger.info "WARNING: DEBUG IN connection_of_trees: USERS ALREADY CONNECTED! Current_user_arr =#{who_connect_users_arr.inspect}, user_id_arr=#{with_whom_connect_users_arr.inspect}."
      end
      @stop_by_arrs = stop_by_arrs # DEBUGG_TO_VIEW
      @connection_message = connection_message # DEBUGG_TO_VIEW

 #   redirect_to yes_connect_path(yes_user_id: current_user.id, connection_id: connection_id) and return

    ######## Afrer all unlock unlock user tree
    #  current_user.unlock_tree!
    #  connected_user.unlock_tree!
    #
    #end

    #redirect_to home_path # ?


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

  # Центральный метод соединения деревьев = перезапись профилей в таблицах
  # Заполнение таблицы Connected_Trees - записью о том, что деревья с current_user_id и user_id - соединились
  def connection_in_tables(connection_data, current_user_id, user_id)

    profiles_to_rewrite = connection_data[:profiles_to_rewrite]
    profiles_to_destroy = connection_data[:profiles_to_destroy]
    who_connect         = connection_data[:who_connect]
    with_whom_connect   = connection_data[:with_whom_connect]

    ###################################################################
    ######## Собственно Центральный метод соединения деревьев = перезапись профилей в таблицах
                            connect_trees(profiles_to_rewrite, profiles_to_destroy, who_connect, with_whom_connect)
    ####################################################################
    ######## Заполнение таблицы Connected_Trees - записью о том, что деревья с current_user_id и user_id - соединились
                            connect_users(current_user_id.to_i, user_id.to_i)
    ##################################################################

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
            connection_message = "ERROR: STOP connection! ЕСТЬ дублирования в массивах:"
            logger.info "ERROR: STOP connection! ЕСТЬ дублирования в массивах: complete_dubles_hash = #{complete_dubles_hash};  connection_message = #{connection_message};"
            stop_by_arrs = true #
          end

        else
          connection_message = "ERROR: STOP connection! Array(s) - NOT Equal!"
          logger.info "ERROR: STOP connection! Array(s) - NOT Equal!  To_rewrite arr.size = #{profiles_to_rewrite.size}; To_destroy arr.size = #{profiles_to_destroy.size}.  connection_message = #{connection_message};"
          stop_by_arrs = true
        end

      else
        connection_message = "ERROR - STOP connection! В массивах объединения - есть общие профили!"
        logger.info "ERROR: В массивах объединения - есть общие профили! connection_message = #{connection_message};."
        stop_by_arrs = true

      end

    else
      connection_message = "ERROR - STOP connection! Connection array(s) - blank!"
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
