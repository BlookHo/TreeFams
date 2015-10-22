module SearchComplete
  extend ActiveSupport::Concern

  #############################################################
  # Иванищев А.В. 2014 -2015
  # Метод Полного поиска
  #############################################################
  # Осуществляет поиск совпадений в деревьях, расчет результатов и сохранение в БД
  # @note: Here is the storage of SearchComplete class methods
  #   to evaluate data to be stored
  #   as proper search results and update search data
  #############################################################


  # @note: METHOD " SEARCH COMPLETE "
  #   сбор полных достоверных пар профилей для объединения
  #   Определение массивов профилей для перезаписи: profiles_to_rewrite, profiles_to_destroy
  # @param:
  #   with_whom_connect_users_arr = [3]
  #   uniq_profiles_pairs =
  #   {15=>{9=>85, 11=>128}, 14=>{3=>22}, 21=>{3=>29},
  #   19=>{3=>27}, 11=>{3=>25, 11=>127, 9=>87}, 2=>{9=>172, 11=>139},
  #   20=>{3=>28}, 16=>{9=>88, 11=>125}, 17=>{9=>86, 11=>126},
  #   12=>{3=>23, 11=>155}, 3=>{9=>173, 11=>154}, 13=>{3=>24, 11=>156},
  #   124=>{9=>91}, 18=>{3=>26}}
  # Output:
  #  final_connection_hash = {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26} (pid:4353)
  #   ( profiles_to_rewrite = [14, 21, 19, 11, 20, 12, 13, 18]
  #   profiles_to_destroy = [22, 29, 27, 25, 28, 23, 24, 26] )
  def complete_search(complete_search_data)
    logger.info "** IN complete_search Module *** "
    with_whom_connect_users_arr = complete_search_data[:with_whom_connect]
    uniq_profiles_pairs         = complete_search_data[:uniq_profiles_pairs]

    init_connection_hash = init_connection_data(with_whom_connect_users_arr, uniq_profiles_pairs)
    logger.info "IN complete_search init_connection_hash = #{init_connection_hash}"
    # init_connection_hash = {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26}

    final_connection_hash = {}
    if !init_connection_hash.empty?

      final_connection_hash = init_connection_hash

      # начало сбора полного хэша достоверных пар профилей для объединения
      until init_connection_hash.empty?
        logger.info "** IN UNTIL top: init_connection_hash = #{init_connection_hash}"

        # get new_hash for connection
        add_connection_hash = {}
        init_connection_hash.each do |profile_searched, profile_found|

          new_connection_hash = {}

          # Получение Кругов для пары профилей - для последующего сравнения и анализа
          logger.info "=== КРУГИ ПРОФИЛЕЙ: profile_searched = #{profile_searched}, profile_found = #{profile_found}"
          circles_arrs_data = SearchCircles.find_circles_arrs(profile_searched, profile_found)
          search_bk_arr          = circles_arrs_data[:search_bk_arr]
          search_bk_profiles_arr = circles_arrs_data[:search_bk_profiles_arr]
          search_is_profiles_arr = circles_arrs_data[:search_is_profiles_arr]
          found_bk_arr           = circles_arrs_data[:found_bk_arr]
          found_bk_profiles_arr  = circles_arrs_data[:found_bk_profiles_arr]
          found_is_profiles_arr  = circles_arrs_data[:found_is_profiles_arr]
          logger.info " search_is_profiles_arr = #{search_is_profiles_arr}, found_is_profiles_arr = #{found_is_profiles_arr} "

          ## Проверка Кругов на дубликаты
          # search_diplicates_hash = find_circle_duplicates(search_bk_profiles_arr)
          #found_diplicates_hash = find_circle_duplicates(found_bk_profiles_arr)
          ## Действия в случае выявления дубликатов в Круге
          #if !search_diplicates_hash.empty?
          #
          #end
          #if !found_diplicates_hash.empty?
          #
          #end

          compare_circles_data = {
              profile_searched: profile_searched,
              profile_found: profile_found,
              found_bk_arr: found_bk_arr,
              search_bk_arr: search_bk_arr,
              found_bk_profiles_arr: found_bk_profiles_arr,
              search_bk_profiles_arr: search_bk_profiles_arr,
              found_is_profiles_arr: found_is_profiles_arr,
              search_is_profiles_arr: search_is_profiles_arr,
              new_connection_hash: new_connection_hash
          }
          new_connection_hash = SearchCircles.proceed_compare_circles(compare_circles_data)

          logger.info " После сравнения Кругов: new_connection_hash = #{new_connection_hash} "


          # сокращение нового хэша если его эл-ты уже есть в финальном хэше
          # NB !! Вставить проверку: Если нет такой комбинации: k == profiles_s && v == profile_f
          # а есть: k == profiles_s && v != profile_f (?) возможно ли это? Что возвратит delete_if?.
          # и действия
          final_connection_hash.each do |profiles_s, profile_f|
            new_connection_hash.delete_if { |k,v|  k == profiles_s && v == profile_f }
          end

          # накапливание нового доп.хаша по всему циклу
          # logger.info " after delete_if in new_connection_hash = #{new_connection_hash} "
          # add_connection_hash.merge!(new_connection_hash) unless new_connection_hash.empty?
          add_connection_hash.merge!(new_connection_hash) unless new_connection_hash.blank?
          # check if new_connection_hash != nil?
          logger.info " add_connection_hash = #{add_connection_hash} "
        end

        add_to_hash_data = { add_connection_hash: add_connection_hash, final_connection_hash: final_connection_hash }
        final_connection_hash = SearchWork.collect_final_connection(add_to_hash_data)
        logger.info "@@@@@ final_connection_hash = #{final_connection_hash} "

        # Подготовка к следующему циклу
        init_connection_hash = add_connection_hash
      end

      logger.info "final_connection_hash = #{final_connection_hash} "
      # final_connection_hash = {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26} (pid:4353)
    end

    final_connection_hash
  end


  # @note: Получение стартового Хэша для объединения профилей на основе:
  # uniq_profiles_pairs - хэша уникальных достоверных пар профилей,
  # полученных в рез-те отработки start_search
  # with_whom_connect_users - array дерева(деревьев), с котороыми собираемся объединяться
  # На выходе - init_connection_hash - Хэш достоверных пар профилей,
  # с которых начинается процесс жесткого определения полного набора соответствий между всеми профилями
  # объединяемых деревьев.
  def init_connection_data(with_whom_connect_users, uniq_profiles_pairs)
    logger.info "with_whom_connect_users_arr = #{with_whom_connect_users}, uniq_profiles_pairs = #{uniq_profiles_pairs}"
    init_connection_hash = {} # hash to work with
    uniq_profiles_pairs.each do |searched_profile, trees_hash|
    init_hash_data = {
      trees_hash:              trees_hash,
      init_connection_hash:    init_connection_hash,
      searched_profile:        searched_profile,
      with_whom_connect_users: with_whom_connect_users
    }

    init_connection_hash = collect_init_hash(init_hash_data)

    end
    init_connection_hash
  end

  # @note: выбор результатов для дерева из with_whom_connect_users_arr
  # перезапись в хэше под key = searched_profile
  def collect_init_hash(init_hash_data)

    trees_hash              = init_hash_data[:trees_hash]
    init_connection_hash    = init_hash_data[:init_connection_hash]
    searched_profile        = init_hash_data[:searched_profile]
    with_whom_connect_users = init_hash_data[:with_whom_connect_users]

    trees_hash.each do |tree_key, found_profile|
      init_connection_hash.merge!( searched_profile => found_profile ) if with_whom_connect_users.include?(tree_key)
    end
    init_connection_hash
  end



end # End of search_complete module

