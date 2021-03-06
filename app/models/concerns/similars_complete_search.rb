module SimilarsCompleteSearch
  extend ActiveSupport::Concern
  # in User model

  #############################################################
  # Иванищев А.В. 2014 - 2015
  # @note: Методы полного поиска - перед объединением Похожих
  #############################################################


  # Input: start tree No, tree No to connect
  # сбор полного хэша достоверных пар профилей для объединения
  # Output:
  # Определение массивов профилей для перезаписи: profiles_to_rewrite, profiles_to_destroy
  # start_tree = от какого дерева объедин.
  # connected_user = с каким деревом объед-ся
  # Input: init_connection_hash
  def prev_similars_complete_search(first_profile_connecting, second_profile_connecting)

    init_connection_hash = { first_profile_connecting => second_profile_connecting}
    logger.info "** IN similars_complete_search *** "
    logger.info " init_connection_hash = #{init_connection_hash}"
    final_profiles_to_rewrite = []
    final_profiles_to_destroy = []
    final_connection_hash = {}

    unless init_connection_hash.empty?

      final_connection_hash = init_connection_hash
        logger.info "** IN unless top: init_connection_hash = #{init_connection_hash}"

      # начало сбора полного хэша достоверных пар профилей для объединения
    until init_connection_hash.empty?
        # logger.info "** IN UNTIL top: init_connection_hash = #{init_connection_hash}"

        # get new_hash for connection
        add_connection_hash = {}
        init_connection_hash.each do |profile_searched, profile_found|

          new_connection_hash = {}
          # Получение Кругов для первой пары профилей -
          # для последующего сравнения и анализа
          search_bk_arr, search_bk_profiles_arr, search_is_profiles_arr = have_profile_circle(profile_searched)
          found_bk_arr, found_bk_profiles_arr, found_is_profiles_arr = have_profile_circle(profile_found)
          logger.info " search_is_profiles_arr = #{search_is_profiles_arr}"
          logger.info " found_is_profiles_arr = #{found_is_profiles_arr} "

          logger.info " "
          # Очистка полученных кругов от исходных профилей (init) - для искл-я зацикливания
          search_is_profiles_arr = search_is_profiles_arr - [profile_found] - [profile_searched]
          found_is_profiles_arr = found_is_profiles_arr - [profile_found] - [profile_searched]

          logger.info " After clean profiles_arrs"
          logger.info " search_is_profiles_arr = #{search_is_profiles_arr}"
          logger.info " found_is_profiles_arr = #{found_is_profiles_arr} "

          ## todo: Проверка Кругов на дубликаты
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
          logger.info " search_bk_arr = #{search_bk_arr}, found_bk_arr = #{found_bk_arr} "
          compare_rezult, common_circle_arr, delta = compare_two_circles(found_bk_arr, search_bk_arr)
          logger.info " After compare circles: compare_rezult = #{compare_rezult}"
          logger.info " ПЕРЕСЕЧЕНИЕ двух Кругов: common_circle_arr = #{common_circle_arr}"

          # Анализ результата сравнения двух Кругов
          unless common_circle_arr.blank? # Если есть какое-то ПЕРЕСЕЧЕНИЕ при сравнении 2-х Кругов
            # new_connection_hash = get_fields_arr_from_circles(search_is_profiles_arr, found_is_profiles_arr )
            logger.info "search_bk_profiles_arr = #{search_bk_profiles_arr} "
            logger.info "found_bk_profiles_arr = #{found_bk_profiles_arr}     "
            new_connection_hash = get_fields_arr_from_circles(search_bk_profiles_arr, found_bk_profiles_arr )
            logger.info " Если есть какое-то ПЕРЕСЕЧЕНИЕ при сравнении 2-х Кругов: new_connection_hash = #{new_connection_hash} "
          else
            # todo: Вставить проверку: Если Круги равны, И: НЕТ ДУБЛИКАТОВ В КАЖДОМ ИЗ КРУГОВ,
            # то формируем новый хэш из их профилей, КОТ-Е ТОЖЕ РАВНЫ
            search_is_profiles_arr.each_with_index do | is_profile, index |
              new_connection_hash.merge!(is_profile => found_is_profiles_arr[index])
            end
          end
          logger.info " После сравнения Кругов: new_connection_hash = #{new_connection_hash} "

          # сокращение нового хэша если его эл-ты уже есть в финальном хэше
          # todo: Вставить проверку: Если нет такой комбинации: k == profiles_s && v == profile_f
          # а есть: k == profiles_s && v != profile_f (?) возможно ли это? Что возвратит delete_if?.
          # и действия
          final_connection_hash.each do |profiles_s, profile_f|
            new_connection_hash.delete_if { |k,v|  k == profiles_s && v == profile_f }
            # new_connection_hash.delete_if { |k,v|  k == profiles_f && v == profile_s }

          end

          # todo: delete if a: b and b: a

          # final_connection_hash.each do |profiles_s, profile_f|
          #   # new_connection_hash.delete_if { |k,v|  k == profiles_s && v == profile_f }
          #   new_connection_hash.delete_if { |k,v|  k == profile_f && v == profiles_s }
          #
          # end

          logger.info " После сокращение нового хэша: new_connection_hash = #{new_connection_hash} "

          # накапливание нового доп.хаша по всему циклу
          add_connection_hash.merge!(new_connection_hash) if !new_connection_hash.empty?
          logger.info " add_connection_hash = #{add_connection_hash} "

        end

        # Наращивание финального хэша пар профилей для объединения, если есть чем наращивать
        unless add_connection_hash.empty?
          SearchWork.add_to_hash(final_connection_hash, add_connection_hash)
          logger.info "@@@@@ final_connection_hash = #{final_connection_hash} "
        end
        # Подготовка к следующему циклу
        init_connection_hash = add_connection_hash
    end

      # logger.info "final_connection_hash = #{final_connection_hash} "
      # logger.info " "
      final_profiles_to_rewrite = final_connection_hash.keys
      final_profiles_to_destroy = final_connection_hash.values
    end

    return final_profiles_to_rewrite, final_profiles_to_destroy, final_connection_hash  # for RSpec & TO_VIEW

  end






  # @note: NEW METHOD "SIMILARS SEARCH COMPLETE "
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
  def similars_complete_search(first_profile_connect, second_profile_connect)

    init_connection_hash = { first_profile_connect => second_profile_connect}
    logger.info "** IN similars_complete_search *** "
    logger.info " init_connection_hash = #{init_connection_hash}"
    # final_profiles_to_rewrite = []
    # final_profiles_to_destroy = []
    final_connection_hash = {}

    unless init_connection_hash.empty?
      final_connection_hash = init_connection_modify(init_connection_hash)#, CERTAIN_KOEFF)
      puts "final_connection_hash = #{final_connection_hash} "

    end
    final_profiles_to_rewrite = final_connection_hash.keys
    final_profiles_to_destroy = final_connection_hash.values
    return final_profiles_to_rewrite, final_profiles_to_destroy, final_connection_hash  # for RSpec & TO_VIEW

  end



end # End of SimilarsCompleteSearch module

