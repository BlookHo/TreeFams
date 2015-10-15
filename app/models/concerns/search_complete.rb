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


  # @note: NEW METHOD "HARD COMPLETE SEARCH"- TO DO
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
  #  profiles_to_rewrite = [14, 21, 19, 11, 20, 12, 13, 18]
  #  profiles_to_destroy = [22, 29, 27, 25, 28, 23, 24, 26]

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
          # add_connection_hash.merge!(new_connection_hash) unless new_connection_hash.empty?
          add_connection_hash.merge!(new_connection_hash) unless new_connection_hash.blank?
          # check if new_connection_hash != nil?
          logger.info " add_connection_hash = #{add_connection_hash} "
        end

        # Наращивание финального хэша пар профилей для объединения, если есть чем наращивать
        unless add_connection_hash.empty?
          HashWork.add_to_hash(final_connection_hash, add_connection_hash)
          logger.info "@@@@@ final_connection_hash = #{final_connection_hash} "
        end

        # Подготовка к следующему циклу
        init_connection_hash = add_connection_hash
      end

      logger.info "final_connection_hash = #{final_connection_hash} "
      logger.info " "
      # final_connection_hash = {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26} (pid:4353)
    end

    final_connection_hash
  end


  # Получение стартового Хэша для объединения профилей на основе:
  # uniq_profiles_pairs - хэша уникальных достоверных пар профилей,
  # полученных в рез-те отработки start_search
  # connected_user - дерева(деревьев), с котороыми собираемся объединяться
  # На выходе - init_connection_hash - Хэш достоверных пар профилей,
  # с которых начинается процесс жесткого определения полного набора соответствий между всеми профилями
  # объединяемых деревьев.
  def init_connection_data(with_whom_connect_users_arr, uniq_profiles_pairs)
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
    init_connection_hash
  end



end # End of search_complete module

