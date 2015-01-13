class MainController < ApplicationController
 # include MainHelper  #

  before_filter :check_user

  include SearchHelper

   def check_user
     redirect_to :root if !current_user
   end

  def main_page

  end

# ГЛАВНЫЙ СТАРТОВЫЙ МЕТОД ПОИСКА совпадений по дереву Юзера
 def gmain_page

    if current_user

      logger.info " "
      logger.info "== IN main_controller#main_page "
      logger.info " "

      # Нужно To view
      @circle = current_user.profile.circle(current_user.get_connected_users) # Нужно To view
      @author = current_user.profile  # Нужно To view

      @author_id = current_user.id # DEBUGG_TO_VIEW

      connected_author_arr = current_user.get_connected_users # Состав объединенного дерева в виде массива id
      author_tree_arr = Tree.get_connected_tree(connected_author_arr) # Массив объединенного дерева из Tree # DEBUGG_TO_VIEW
      @author_tree_arr = author_tree_arr # DEBUGG_TO_VIEW
      @tree_is_profiles = author_tree_arr.map {|p| p.is_profile_id }.uniq # DEBUGG_TO_VIEW

      ##### КОЭФФИЦИЕНТ ДОСТОВЕРНОСТИ ##########
      #@certain_koeff = params[:certain_koeff] || 4 # (for 0-8 relations)
      #@certain_koeff = @certain_koeff.to_i
      ###############
      # Взять значение из Settings
      @certain_koeff = get_certain_koeff #3 from appl.cntrler
      logger.info "== in connection_of_trees:  @certain_koeff = #{@certain_koeff}"

      # PLACE for DEBUGG_TO_VIEW
      ########### TEST ########################################
      # NB !! Вставить проверку и действия ПРИСУТСТВИЯ КАЖДОГО FOUND ПРОФИЛЯ В ЕГО РОДНОМ ДЕРЕВЕ

      # СБОР ВСЕХ НАЙДЕННЫХ ПРОФИЛЕЙ ПО ДЕРЕВЬЯМ
      ################ TEST #######################################
      # ПРОВЕРКА ПРИСУТСТВИЯ КАЖДОГО ПРОФИЛЯ В ЕГО РОДНОМ ДЕРЕВЕ
      def check_profiles_tree_uniqness(trees_profiles_hash)
        logger.info "**  in check_profiles_tree_uniqness: trees_profiles_hash = #{trees_profiles_hash} "
        check_results_hash = {}
        new_uniq_profiles_hash = {}
        trees_profiles_hash.each_with_index do |(tree_id, profiles_arr), index|
          all_tree_profiles = Tree.where(user_id: tree_id).pluck(:is_profile_id)
          check_arr = profiles_arr & all_tree_profiles
          logger.info "** profiles_arr = #{profiles_arr}, all_tree_profiles = #{all_tree_profiles}, check_arr = #{check_arr} "
          # проверка на совпадение массивов
          # если массивы совпали, значит все профили - из дерева
          # тогда рез.хэш - пустой= {}
          # если не равны , то надо найти разность массивов, т.е. .
          # те профили, кот-е отсутствуют в соотв-м дереве
          # эту разность заносим в рез-й хэш
          logger.info "** check_arr != profiles_arr = #{check_arr != profiles_arr} "
          if check_arr != profiles_arr #
            if check_arr.size > profiles_arr.size
              rez = check_arr - profiles_arr
            else
              rez = profiles_arr - check_arr
            end
            logger.info "** rez = #{rez} "
            check_results_hash.merge!( tree_id => rez )
          end

        end
        return check_results_hash, new_uniq_profiles_hash
      end

      #uniq_profiles_pairs =
      #{89=>{14=>103, 15=>103},
      # 91=>{14=>108, 15=>2108},
      # 92=>{14=>107, 15=>107},
      # 90=>{14=>1106, 15=>106},
      # 88=>{14=>109, 15=>109, 16=>3134}}

      #trees_profiles_hash = collect_trees_profiles(uniq_profiles_pairs)
      #logger.info "** after collect_trees_profiles begin: trees_profiles_hash = #{trees_profiles_hash} "
      #
      #check_results_hash, new_uniq_profiles_hash = check_profiles_tree_uniqness(trees_profiles_hash)
      #logger.info "** After check_uniqness: new_uniq_profiles_hash = #{new_uniq_profiles_hash}, check_results_hash = #{check_results_hash}"
      ############### TEST ########################################

      #

      ################################
      ##### Основной поиск от дерева Автора (вместе с соединенными)
      ##### среди других деревьев в ProfileKeys.
      beg_search_time = Time.now   # Начало отсечки времени поиска

      #####  Запуск НОВОГО поиска С @certainty_koeff - последняя версия
      search_results = current_user.start_search(@certain_koeff)  ##

      end_search_time = Time.now   # Конец отсечки времени поиска
      @elapsed_search_time = (end_search_time - beg_search_time).round(5) # Длительность поиска - для инфы
      ################################

      ######## Сбор рез-тов поиска:
      @connected_author_arr = search_results[:connected_author_arr]
      @qty_of_tree_profiles = search_results[:qty_of_tree_profiles] # To view

      @profiles_relations_arr = search_results[:profiles_relations_arr]
      @profiles_found_arr = search_results[:profiles_found_arr]
      @uniq_profiles_pairs = search_results[:uniq_profiles_pairs]
      @profiles_with_match_hash = search_results[:profiles_with_match_hash]

      ############# РЕЗУЛЬТАТЫ ПОИСКА для отображения на Главной ##########################################
      @by_profiles = search_results[:by_profiles]
      @by_trees = search_results[:by_trees]

      @duplicates_one_to_many = search_results[:duplicates_one_to_many]
      @duplicates_many_to_one = search_results[:duplicates_many_to_one]
      ######################################################


      # Для отладки # DEBUGG_TO_VIEW
      logger.info " "
      logger.info "=== BEFORE connection_of_trees ==="
      @search_res = {} # DEBUGG_TO_VIEW - чтобы отключить старые рез-ты-пути на вьюхе
      logger.info "search_results.by_profiles = #{search_results[:by_profiles]}"
      logger.info "search_results.by_trees = #{search_results[:by_trees]}"

    end


 end  # End of main_page method

  #   ТЕСТ НАЙДЕННЫХ ПРОФИЛЕЙ - РАСПРЕДЕЛЕНИЕ ПО МОЩНОСТИ СОВПАДЕНИЙ:

  # НОВЫЕ МЕТОДЫ СОРТИРОВКИ ПРОФИЛЕЙ ПО МОЩНОСТИ ПЕРЕСЕЧЕНИЯ
  # 1.ПОЛУЧЕНИЯ КРУГА ПО ПРОФИЛЮ
  # 2.ПРЕОБРАЗОВАНИЕ КРУГА В ХЭШ (см.выше)
  # 3.СРАВНЕНИЕ ХЭШЕЙ - ПЕРЕСЕЧЕНИЕ И ОПРЕДЛЕНИЕ МОЩНОСТИ СОВПАДЕНИЯ
  # 4 ФОРМИРОВАНИЕ 2-Х СПРАВОЧНЫХ ХЭШЕЙ - ПО МОЩНОСТИ
  # СОРТИРОВКА ПАР ПРОФИЛЕЙ ПО МОЩНОСТИ ИХ ПЕРЕСЕЧЕНИЯ
  # .
  #logger.info "METHODS - TO COMPARE CIRCLES IN HASHES"
  #profile_circle_1_hash = {
  #    'f1' => 58, 'f2' => 100, 'm1' => 59, 's1' => 63, 's2' => 64, 'b1' => 60, 'b2' => 61, 'b3' => 66, 'w1' => 62 }
  #
  #profile_circle_2_hash = {
  #    'f1' => 58, 'f2' => 100, 'm1' => 59, 'b1' => 60, 'b2' => 61, 'w1' => 62 }

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

  #profiles_to_rewrite = [57, 58, 59, 60, 61, 62, 80, 81]
  #profiles_to_destroy = [78, 72, 75, 77, 76, 79, 73, 74]

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




end
