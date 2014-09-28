class MainController < ApplicationController
 # include MainHelper  #

  before_filter :check_user

  include SearchHelper

  def check_user
    redirect_to :root if !current_user
  end


# ГЛАВНЫЙ СТАРТОВЫЙ МЕТОД ПОИСКА совпадений по дереву Юзера
 def main_page

    if current_user

      # Нужно To view
      @circle = current_user.profile.circle(current_user.get_connected_users) # Нужно To view
      @author = current_user.profile  # Нужно To view

      connected_author_arr = current_user.get_connected_users # Состав объединенного дерева в виде массива id
      author_tree_arr = get_connected_tree(connected_author_arr) # Массив объединенного дерева из Tree
  #    qty_of_tree_profiles = author_tree_arr.map {|p| p[4] }.uniq.size # Кол-во профилей в объед-ном дереве - для отображения на Главной
      @author_tree_arr = author_tree_arr # DEBUGG_TO_VIEW

      ##### КОЭФФИЦИЕНТ ДОСТОВЕРНОСТИ ##########
      @certain_koeff = params[:certain_koeff] || 4 # (for 0-8 relations)
      @certain_koeff = @certain_koeff.to_i
      ###############
      #logger.info "@certain_koeff = #{@certain_koeff}"

      # PLACE for DEBUGG_TO_VIEW

      #


  # ДАЛЕЕ: ИСПОЛЬЗУЕТСЯ В NEW METHOD "HARD COMPLETE SEARCH"
  # NB !! ЕСЛИ connected_user = ОБЪЕДИНЕННЫМ ДЕРЕВОМ ?
  # Вставить проверку и действия
  # .
  # Получение стартового Хэша для объединения профилей на основе:
  # uniq_profiles_hash - хэша уникальных достоверных пар профилей,
  # полученных в рез-те отработки start_search
  # connected_user - дерева(деревьев), с котороыми собираемся объединяться
  # На выходе - init_connection_hash - Хэш достоверных пар профилей,
  # с которых начинается процесс жесткого определения полного набора соответствий между всеми профилями
  # объединяемых деревьев.
  def make_init_connection_hash(connected_user, uniq_profiles_hash)
    logger.info " uniq_profiles_hash = #{uniq_profiles_hash}"
    init_searched_profiles_arr = []
    init_found_profiles_arr = []
    init_connection_hash = {} # hash to work with
    uniq_profiles_hash.each do |searched_profile, trees_hash|
      init_searched_profiles_arr << searched_profile
      trees_hash.each do |tree_key, found_profile|
        # ЗДЕСЬ !! ЕСЛИ connected_user = ОБЪЕДИНЕННЫМ ДЕРЕВОМ ?
        if tree_key == connected_user #connected_user.each
          init_found_profiles_arr << found_profile
          init_connection_hash.merge!( searched_profile => found_profile )
        end
      end
    end
    #logger.info " init_searched_profiles_arr = #{init_searched_profiles_arr}, init_found_profiles_arr = #{init_found_profiles_arr}"
    return init_connection_hash
  end


  # NEW METHOD "HARD COMPLETE SEARCH"
  # Input: start tree No, tree No to connect
  # сбор полного хэша достоверных пар профилей для объединения
  # @max_power_profiles_pairs_hash
  # Output:
  # Определение массивов профилей для перезаписи: profiles_to_rewrite, profiles_to_destroy
  # profiles_to_rewrite, profiles_to_destroy =  get_rewrite_profiles_by_bk(search_results) ##
  #
  # start_tree = от какого дерева объедин.
  # connected_user = с каким деревом объед-ся
  #
  # Input: 1. @max_power_profiles_pairs_hash
  def hard_complete_search(with_whom_connect_users_arr, uniq_profiles_hash )
    logger.info "** IN hard_complete_search *** "
    final_profiles_to_rewrite = []
    final_profiles_to_destroy = []
    if !uniq_profiles_hash.empty?

      init_connection_hash = make_init_connection_hash(with_whom_connect_users_arr, uniq_profiles_hash)
      logger.info " init_connection_hash = #{init_connection_hash}"

      final_connection_hash = init_connection_hash
      #final_profiles_to_rewrite = init_connection_hash.keys
      #final_profiles_to_destroy = init_connection_hash.values
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

          # Проверка Кругов на дубликаты
          search_diplicates_hash = find_circle_duplicates(search_bk_profiles_arr)
          found_diplicates_hash = find_circle_duplicates(found_bk_profiles_arr)
          # Действия в случае выявления дубликатов в Круге
          if !search_diplicates_hash.empty?

          end
          if !found_diplicates_hash.empty?

          end
          # NB !! Вставить проверку: Сравнение двух Кругов пары профилей Если: НЕТ ДУБЛИКАТОВ В КАЖДОМ ИЗ КРУГОВ,
          logger.info " compare_two_circles: ИСКОМОГО ПРОФИЛЯ = #{profile_searched} и НАЙДЕННОГО ПРОФИЛЯ = #{profile_found}:"
          compare_rezult, common_bk_arr, delta = compare_two_circles(found_bk_arr, search_bk_arr)
          logger.info " compare_rezult = #{compare_rezult}"
          logger.info " ПЕРЕСЕЧЕНИЕ двух Кругов: common_bk_arr = #{common_bk_arr}"
          logger.info " РАЗНОСТЬ двух Кругов: delta = #{delta}"

          # Анализ результата сравнения двух Кругов
          if !common_bk_arr.blank? # Если есть какое-то ПЕРЕСЕЧЕНИЕ при сравнении 2-х Кругов

            new_field_arr_searched, new_field_arr_found, new_connection_hash = get_fields_arrays_from_bk(search_bk_profiles_arr, found_bk_profiles_arr )
            new_field_arr_searched = new_field_arr_searched.flatten(1)
            new_field_arr_found = new_field_arr_found.flatten(1)
            logger.info "=ВАРИАНТ Extraxt is_profile_id из пересечения 2-х Кругов если оно есть"
            logger.info " new_field_arr_searched = #{new_field_arr_searched}, new_field_arr_found = #{new_field_arr_found} "
            logger.info " "
          else
            # NB !! Вставить проверку: Если Круги равны, И: НЕТ ДУБЛИКАТОВ В КАЖДОМ ИЗ КРУГОВ,
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
          logger.info " after reduce new_connection_hash = #{new_connection_hash} "
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


      #start_tree = 11
      #connected_user = 9
      #uniq_profiles_pairs_hash =
      #    {72=>{9=>58, 10=>68},
      #     75=>{9=>59, 10=>65},
      #     76=>{9=>61, 10=>69},
      #     77=>{9=>60, 10=>70},
      #     78=>{9=>57, 10=>71}}
      #profiles_to_rewrite = [72, 75, 76, 77, 78, 73, 74, 79]
      #profiles_to_destroy = [58, 59, 61, 60, 57, 80, 81, 62]

      start_tree = 9
      with_whom_connect_users_arr = 11
      @with_whom_connect_users_arr = with_whom_connect_users_arr
      # ck = 2
      {58=>{10=>68, 11=>72},
       59=>{10=>65, 11=>75},
       60=>{10=>70},
       61=>{10=>69, 11=>76},
       62=>{10=>86},
       80=>{10=>84, 11=>73},
       81=>{10=>85, 11=>74}}
      #One_to_Many_hash:
      {64=>{10=>{70=>2, 87=>2}}}
      #Many_to_One_hash:
      {63=>{10=>71, 11=>78},
       64=>{11=>77},
       57=>{10=>71, 11=>78},
       60=>{11=>77}}
      # ALL profiles_to_rewrite = [58, 59, 61, 80, 81, 57, 60, 62]
      # ALL profiles_to_destroy = [72, 75, 76, 73, 74, 78, 77, 79]

      # ck = 3
      {57=>{10=>71, 11=>78},
       58=>{10=>68, 11=>72},
       59=>{10=>65, 11=>75},
       60=>{10=>70, 11=>77},
       61=>{10=>69, 11=>76}}
      #ALL profiles_to_rewrite = [57, 58, 59, 60, 61, 62, 80, 81]
      #ALL profiles_to_destroy = [78, 72, 75, 77, 76, 79, 73, 74]

      ##################################
      # ck = 4
      uniq_profiles_pairs_hash =
      {57=>{10=>71, 11=>78},
       58=>{10=>68, 11=>72},
       59=>{10=>65, 11=>75},
       60=>{10=>70, 11=>77},
       61=>{10=>69, 11=>76}}

      [57, 58, 59, 60, 61, 62, 80, 81]
      [78, 72, 75, 77, 76, 79, 73, 74]

      #ALL profiles_to_rewrite = [57, 58, 59, 60, 61, 62, 80, 81]
      #ALL profiles_to_destroy = [78, 72, 75, 77, 76, 79, 73, 74]
      #####################################

      # ck = 5
      {57=>{10=>71, 11=>78},
       58=>{10=>68, 11=>72},
       59=>{10=>65}}
      #ALL profiles_to_rewrite = [57, 58, 59, 60, 61, 62, 80, 81]
      #ALL profiles_to_destroy = [78, 72, 75, 77, 76, 79, 73, 74]

      # ck = 6
      {57=>{10=>71},
       58=>{10=>68, 11=>72}}
      #ALL profiles_to_rewrite = [58, 80, 81, 57, 60, 61, 59, 62]
      #ALL profiles_to_destroy = [72, 73, 74, 78, 77, 76, 75, 79]

      # ck = 7
      {}

      #start_tree = 9
      #connected_user = 10
      #uniq_profiles_pairs_hash =
      #    {57=>{10=>71, 11=>78},
      #     58=>{11=>72, 10=>68},
      #     59=>{10=>65, 11=>75},
      #     60=>{10=>70, 11=>77},
      #     61=>{10=>69, 11=>76}}
      #profiles_to_rewrite = [57, 58, 59, 60, 61, 64, 62, 80, 81, 82]
      #profiles_to_destroy = [71, 68, 65, 70, 69, 87, 86, 84, 85, 66]

      #start_tree = 10
      #connected_user = 11
      #uniq_profiles_pairs_hash =
      #{65=>{9=>59, 11=>75},
      # 68=>{11=>72, 9=>58},
      # 69=>{9=>61, 11=>76},
      # 70=>{9=>60, 11=>77},
      # 71=>{9=>57, 11=>78}}
      #profiles_to_rewrite = [65, 68, 69, 70, 71, 84, 85, 86]
      #profiles_to_destroy = [75, 72, 76, 77, 78, 73, 74, 79]

  ### @@@@@@@@@@@@@@@@@@@@@@
  #    profiles_to_rewrite, profiles_to_destroy = hard_complete_search(with_whom_connect_users_arr, uniq_profiles_pairs_hash )
  #    logger.info "ALL profiles_to_rewrite = #{profiles_to_rewrite} "
  #    logger.info "ALL profiles_to_destroy = #{profiles_to_destroy} "
  #    logger.info " "
  #    @profiles_to_rewrite = profiles_to_rewrite # DEBUGG_TO_VIEW
  #    @profiles_to_destroy = profiles_to_destroy # DEBUGG_TO_VIEW
      logger.info " "
      logger.info " "




      #   ТЕСТ НАЙДЕННЫХ ПРОФИЛЕЙ - РАСПРЕДЕЛЕНИЕ ПО МОЩНОСТИ СОВПАДЕНИЙ:

      # НОВЫЕ МЕТОДЫ СОРТИРОВКИ ПРОФИЛЕЙ ПО МОЩНОСТИ ПЕРЕСЕЧЕНИЯ
      # 1.ПОЛУЧЕНИЯ КРУГА ПО ПРОФИЛЮ
      # 2.ПРЕОБРАЗОВАНИЕ КРУГА В ХЭШ (см.выше)
      # 3.СРАВНЕНИЕ ХЭШЕЙ - ПЕРЕСЕЧЕНИЕ И ОПРЕДЛЕНИЕ МОЩНОСТИ СОВПАДЕНИЯ
      # 4 ФОРМИРОВАНИЕ 2-Х СПРАВОЧНЫХ ХЭШЕЙ - ПО МОЩНОСТИ
      # СОРТИРОВКА ПАР ПРОФИЛЕЙ ПО МОЩНОСТИ ИХ ПЕРЕСЕЧЕНИЯ
      # .
      logger.info " COMPARE HASHES"

      profile_circle_1_hash = {
          'f1' => 58, 'f2' => 100, 'm1' => 59, 's1' => 63, 's2' => 64, 'b1' => 60, 'b2' => 61, 'b3' => 66, 'w1' => 62 }

      profile_circle_2_hash = {
          'f1' => 58, 'f2' => 100, 'm1' => 59, 'b1' => 60, 'b2' => 61, 'w1' => 62 }

      # ИСП. В НОВЫХ МЕТОДАХ СОРТИРОВКИ ПРОФИЛЕЙ ПО МОЩНОСТИ ПЕРЕСЕЧЕНИЯ
      def get_row_data(one_row_hash)
        if !one_row_hash.empty?
          relation_val = one_row_hash.values_at('relation_id')[0]
          is_profile_val = one_row_hash.values_at('is_profile_id')[0]
        end
        return relation_val, is_profile_val
      end

      # ИСП. В НОВЫХ МЕТОДАХ СОРТИРОВКИ ПРОФИЛЕЙ ПО МОЩНОСТИ ПЕРЕСЕЧЕНИЯ
      def get_name_letter(relation_val)
        name_letter = ""
        case relation_val
          when 1
            name_letter = "f"
          when 2
            name_letter = "m"
          when 3  # son
            name_letter = "s"
          when 4
            name_letter = "d"
          when 5
            name_letter = "b"
          when 6  # sIster
            name_letter = "i"
          when 7
            name_letter = "h"
          when 8
            name_letter = "w"
          else
            logger.info "ERROR: No relation_id in Circle "
        end
        return name_letter
      end


      # ИСП. В НОВЫХ МЕТОДАХ СОРТИРОВКИ ПРОФИЛЕЙ ПО МОЩНОСТИ ПЕРЕСЕЧЕНИЯ
      # Получаем кол-во для нового имени отношения в хэш круга
      def name_next_qty(circle_keys_arr, name)
        name_qty = 0
        circle_keys_arr.each do |one_name_key|
          name_qty += 1 if one_name_key.first == name
        end
        name_qty += 1
        return name_qty
      end

      # ИСП. В НОВЫХ МЕТОДАХ СОРТИРОВКИ ПРОФИЛЕЙ ПО МОЩНОСТИ ПЕРЕСЕЧЕНИЯ
      # Получаем новое  имя отношения в хэш круга
      def get_new_elem_name(circle_keys_arr, name)
        name_qty = name_next_qty(circle_keys_arr, name)
        new_name = name.concat(name_qty.to_s)
        return new_name
      end

      # ИСП. В НОВЫХ МЕТОДАХ СОРТИРОВКИ ПРОФИЛЕЙ ПО МОЩНОСТИ ПЕРЕСЕЧЕНИЯ
      # input: circle_arr
      # На выходе: profile_circle_hash = {'f1' => 58, 'f2' => 100, 'm1' => 59, 'b1' => 60, 'b2' => 61, 'w1' => 62 }
      def convert_circle_to_hash(circle_arr)
        profile_circle_hash = {}
        circle_arr.each do |one_row_hash|
          circle_keys_arr = profile_circle_hash.keys
          relation_val, is_profile_val = get_row_data(one_row_hash)
          name_letter = get_name_letter(relation_val)
          # Получаем новое по порядку имя отношения в новый элемент хэша круга
          new_name = get_new_elem_name(circle_keys_arr, name_letter)
          # Наращиваем круг в виде хэша
          profile_circle_hash.merge!( new_name => is_profile_val )
        end
         return profile_circle_hash
      end

      # ИСП. В НОВЫХ МЕТОДАХ СОРТИРОВКИ ПРОФИЛЕЙ ПО МОЩНОСТИ ПЕРЕСЕЧЕНИЯ
      def rewrite_profiles_in_circle(profile_circle_hash, profiles_to_rewrite, profiles_to_destroy)
        new_found_profile_circle_hash = {}
        profile_circle_hash.each do | key, profile_val|
          index = profiles_to_destroy.index(profile_val)
          if !index.blank?
            rewrited_profile_val = profiles_to_rewrite[index]
            new_found_profile_circle_hash.merge!( key => rewrited_profile_val )
          else
            new_found_profile_circle_hash.merge!( key => 0)
            # если нет такого профиля в противоположном массиве, то
            # заполняем профиль=0
          end
        end
        return new_found_profile_circle_hash
      end


      # ИСП. В НОВЫХ МЕТОДАХ СОРТИРОВКИ ПРОФИЛЕЙ ПО МОЩНОСТИ ПЕРЕСЕЧЕНИЯ
      def check_rewrite_power(profiles_to_rewrite, profiles_to_destroy)

      high_power_results_hash = {}
      low_power_results_hash = {}

      profiles_to_rewrite.each_with_index do |one_profile_rewr, index|
        one_profile_destr = profiles_to_destroy[index]

        # Получение Кругов для первой пары профилей -
        # для последующего сравнения и анализа
        search_bk_arr, search_bk_profiles_arr, search_is_profiles_arr, search_relations_arr = have_profile_circle(one_profile_rewr)
        found_bk_arr, found_bk_profiles_arr, found_is_profiles_arr, found_relations_arr = have_profile_circle(one_profile_destr)

        search_profile_circle_hash = convert_circle_to_hash(search_bk_profiles_arr)
        found_profile_circle_hash = convert_circle_to_hash(found_bk_profiles_arr)

        # перезапись профилей на основе массивов перезаписи
        found_profile_circle_hash = rewrite_profiles_in_circle(found_profile_circle_hash, profiles_to_rewrite, profiles_to_destroy)
        #logger.info "rewrited found_profile_circle_hash = #{found_profile_circle_hash}"

        # определение пересечения (общей части) двух Кругов в виде хэшей
        common_hash = search_profile_circle_hash & found_profile_circle_hash
        # определение мощности пересечения
        common_hash_power = 0
        common_hash_power = common_hash.size if !common_hash.empty?
        # занесение пар профилей в различные хэши по мощности
        common_hash_power >= @certain_koeff.to_i ?
            high_power_results_hash.merge!(one_profile_rewr => one_profile_destr) :
            low_power_results_hash.merge!(one_profile_rewr => one_profile_destr)

      end

      return high_power_results_hash, low_power_results_hash

    end

      profiles_to_rewrite = [57, 58, 59, 60, 61, 62, 80, 81]
      profiles_to_destroy = [78, 72, 75, 77, 76, 79, 73, 74]

       ### @@@@@@@@@@@@@@@@@@@@@@
      #high_power_results_hash, low_power_results_hash =
      #  check_rewrite_power(profiles_to_rewrite, profiles_to_destroy)
      #logger.info " high_power_results_hash = #{high_power_results_hash}"
      #logger.info " low_power_results_hash = #{low_power_results_hash}"
      #@high_power_results_hash = high_power_results_hash
      #@low_power_results_hash = low_power_results_hash

      #high_power_results_hash = {57=>78, 58=>72, 59=>75, 60=>77, 61=>76}
      #low_power_results_hash = {62=>79, 80=>73, 81=>74}

      # КОНЕЦ   ТЕСТ НАЙДЕННЫХ ПРОФИЛЕЙ - РАСПРЕДЕЛЕНИЕ ПО МОЩНОСТИ СОВПАДЕНИЙ:
      # НОВЫХ МЕТОДОВ СОРТИРОВКИ ПРОФИЛЕЙ ПО МОЩНОСТИ ПЕРЕСЕЧЕНИЯ


# from 11 to 9,10
#          {72=>{9=>58, 10=>68},
#           75=>{9=>59, 10=>65},
#           76=>{9=>61, 10=>69},
#           77=>{9=>60, 10=>70},
#           78=>{9=>57, 10=>71}}


# from 10 to 11,9

      # from 10 to 11,9
      #{65=>{9=>59, 11=>75},
      # 68=>{11=>72, 9=>58},
      # 69=>{9=>61, 11=>76},
      # 70=>{9=>60, 11=>77},
      # 71=>{9=>57, 11=>78}}

# from 9 to 11,10

      {57=>{10=>71, 11=>78},
       58=>{11=>72, 10=>68},
       59=>{10=>65, 11=>75},
       60=>{10=>70, 11=>77},
       61=>{10=>69, 11=>76}}


      ################################
      ##### Основной поиск от дерева Автора (вместе с соединенными)
      ##### среди других деревьев в ProfileKeys.
      beg_search_time = Time.now   # Начало отсечки времени поиска

      #####  Запуск НОВОГО поиска С @certainty_koeff - последняя версия
      search_results = current_user.start_search(@certain_koeff)  ##

      #####  Запуск ЖЕСТКОГО поиска
      #search_results = current_user.start_hard_search  ##

      #####  Запуск поиска 1-й версии - самый первый
      #search_results = current_user.start_search_first  #####  Запуск поиска 1-й версии

      #####  Запуск МЯГКОГО поиска - 2-я версия
      #search_results = current_user.start_search_soft  ## Запуск поиска с right_profile

      end_search_time = Time.now   # Конец отсечки времени поиска
      @elapsed_search_time = (end_search_time - beg_search_time).round(5) # Длительность поиска - для инфы

      ######## Сбор рез-тов поиска:
      @connected_author_arr = search_results[:connected_author_arr]
      @qty_of_tree_profiles = search_results[:qty_of_tree_profiles] # To view
      ############################# NEW METHOD ############
      @profiles_relations_arr = search_results[:profiles_relations_arr]
      @new_profiles_found_arr = search_results[:new_profiles_found_arr]
      @uniq_profiles_pairs_hash = search_results[:uniq_profiles_pairs_hash]
      @profiles_with_match_hash = search_results[:profiles_with_match_hash]

      ############# РЕЗУЛЬТАТЫ ПОИСКА для отображения на Главной ##########################################
      @by_profiles = search_results[:by_profiles]
      @by_trees = search_results[:by_trees]

      @duplicates_One_to_Many_hash = search_results[:duplicates_One_to_Many_hash]
      @duplicates_Many_to_One_hash = search_results[:duplicates_Many_to_One_hash]
      ######################################################


      # Для отладки # DEBUGG_TO_VIEW
      @author_id = current_user.id # DEBUGG_TO_VIEW
      @author_connected_tree_arr = get_connected_users_tree(@connected_author_arr) # DEBUGG_TO_VIEW
      @len_author_tree = @author_connected_tree_arr.length  if !@author_connected_tree_arr.blank?  # DEBUGG_TO_VIEW


      logger.info " "
      logger.info "=== BEFORE connection_of_trees ==="
     # connected_user = User.find(user_id) # For lock check
      logger.info "current_user = #{current_user}"
#,  connected_user = #{connected_user} "
      @search_res = {}
      logger.info "@search_res = #{@search_res}"
      logger.info "search_results = #{search_results}"

    end



 end




end
