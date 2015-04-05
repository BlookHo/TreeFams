class ConnectUsersTreesController < ApplicationController
  include SearchHelper
  include ConnectionRequestsHelper


  layout 'application.new'

  # todo: refactor
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

    connection_message = "Нельзя объединить ваши деревья, т.к. есть информация, что они уже объединены!"
    # Проверка: может быть дерево автора уже было соединено с выбранным юзером?
    if check_connection_permit(who_connect_users_arr.include?(user_id.to_i), connection_message) # check IF NOT CONNECTED
      logger.info "=== IN check_connection_switch: уже объединены"
      return
    end

    with_whom_connect_users_arr = User.find(user_id).get_connected_users  #
    @with_whom_connect_users_arr = with_whom_connect_users_arr # DEBUGG_TO_VIEW

    beg_search_time = Time.now   # Начало отсечки времени поиска

    ##### Запуск стартового ДОСТОВЕРНОГО поиска с certain_koeff_for_connect из Weafam_Settings
    search_results = current_user.start_search(get_certain_koeff)
    # get_certain_koeff=4 - значение из Settings from appl.cntrler
    ##############################################################################

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
    # Чтобы протестировать check_connection_permit: в модуле search.rb, после запуска метода
    # search_profiles_from_tree - раскомментить одну или обе строки с # for DEBUGG ONLY!!!
    connection_message = "Нельзя объединить ваши деревья, т.к. в результатах поиска есть дубликаты!"
    if check_connection_permit(!duplicates_one_to_many.empty? || !duplicates_many_to_one.empty?, connection_message)
      logger.info "=== IN check_connection_switch: дубликаты"
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

    end_search_time = Time.now   # Конец отсечки времени поиска
    @elapsed_search_time = (end_search_time - beg_search_time).round(5) # Длительность поиска - для инфы

    connection_data = {
        who_connect_arr:          who_connect_users_arr, #
        with_whom_connect_arr:    with_whom_connect_users_arr, #
        profiles_to_rewrite:  profiles_to_rewrite, #
        profiles_to_destroy:  profiles_to_destroy, #
        current_user_id:      current_user_id, #
        user_id:              user_id ,#
        connection_id:        @connection_id #
    }
    logger.info "Connection - GO ON! connection_data = #{connection_data}"

    # connection_data = {:who_connect=>[1, 2], :with_whom_connect=>[3],
    #                    :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18],
    #                    :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26]
    # , :current_user_id=>2, :user_id=>3, :connection_id=>3}
    ######## Контроль корректности массивов перед объединением
    check_connection_result = current_user.check_connection_arrs(connection_data)
    ##############################################################################

    stop_by_arrs = check_connection_result[:stop_by_arrs]
    connection_message = check_connection_result[:diag_connection_message]
    # Чтобы протестировать check_connection_permit: в модуле connection_trees.rb, в конце метода
    # check_duplications - раскомментить одну строку с complete_dubles_hash = {11=>[25, 26]} # for DEBUGG ONLY!!!
    if check_connection_permit(stop_by_arrs, connection_message)
      logger.info "=== IN check_connection_switch: дублирования в массивах"
      return
    end

    unless @stop_connection || stop_by_arrs # for stop_connection & view

      ##### Центральный метод соединения деревьев = перезапись и удаление профилей в таблицах
      current_user.connection_in_tables(connection_data)
      ##################################################################
      flash[:notice] = " #{connection_message} Ваши деревья успешно объединены!"
      logger.info "Connection - GO ON! array(s) - CORRECT!,
                   @stop_connection = #{@stop_connection},\n connection_message = #{connection_message}"

      current_user.unlock_tree! # unlock tree
    end

  end

  # @note: Контроль возможности продолжения объединения деревьев
  #   На вьюхе проверяем: отображать ли процесс объединения. @stop_connection
  # @note: Проверка 1: может быть дерево автора уже было соединено с выбранным юзером?
  #   Проверка 2: на наличие дубликатов из поиска:
  #   Если есть дубликаты из Поиска, то устанавливаем stop_by_search_dublicates = true
  #   Проверка 3: Контроль корректности массивов перед объединением
  def check_connection_permit(switch, connection_message)
    if switch
      flash[:alert] = " #{connection_message} "
      logger.info " #{connection_message} "
      current_user.unlock_tree! # unlock tree
      @stop_connection = true   # for stop_connection & view
      redirect_to home_path
    end
  end



end
