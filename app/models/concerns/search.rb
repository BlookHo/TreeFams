module Search
  extend ActiveSupport::Concern
  include SearchHelper
#  require "awesome_print"

  def start_search
    # @circle = current_user.profile.circle(current_user.id)  # DEBUGG_TO_VIEW
    #@circle = self.profile.circle(self.get_connected_users)  # DEBUGG_TO_VIEW
    #@author = self.profile # DEBUGG_TO_VIEW
    #@current_user_id = self.id # DEBUGG_TO_VIEW

    connected_author_arr = self.get_connected_users # Состав объединенного дерева в виде массива id
    author_tree_arr = get_connected_tree(connected_author_arr) # Массив объединенного дерева из Tree
    qty_of_tree_profiles = author_tree_arr.map {|p| p[4] }.uniq.size # Кол-во профилей в объед-ном дереве - для отображения на Главной

  #  author_tree_arr = # DEBUGG_TO_VIEW
    #[
     #[3, 16, 123, 0, 16, 123, 1, false],
     #[3, 16, 123, 1, 17, 123, 1, false],
     #[3, 16, 123, 2, 18, 98, 0, false],
     #[3, 16, 123, 5, 19, 130, 1, false],
     #[3, 16, 123, 5, 20, 125, 1, false],
     #[3, 16, 123, 8, 21, 84, 0, false],
     #[3, 16, 123, 3, 22, 123, 1, false],
     #[3, 16, 123, 3, 23, 125, 1, false]
   # ]
    #[
    #    [160, 1373, 36, 0, 1373, 36, 0, false],
    ##    #[160, 1373, 36, 1, 1374, 419, 1, false],
    ##    #[160, 1373, 36, 2, 1375, 233, 0, false],
    ##    #[160, 1373, 36, 7, 1376, 377, 1, false],
    #    [160, 1373, 36, 3, 1377, 373, 1, false],
    #    [160, 1373, 36, 3, 1378, 141, 1, false],
    #    [160, 1373, 36, 3, 1379, 194, 1, false]
    #]

    #@author_tree_arr = author_tree_arr # DEBUGG_TO_VIEW
    logger.info "======================= RUN start_search ========================= "
    logger.info "Общее задание на поиск от зарег-го Юзера - весь массив заданий (author_tree_arr)"
    logger.info "#{author_tree_arr}"

    search_profiles_from_tree(connected_author_arr, author_tree_arr) # Основной поиск по дереву Автора среди деревьев в ProfileKeys.

    results = {
      final_reduced_profiles_hash: @final_reduced_profiles_hash,
      final_reduced_relations_hash: @final_reduced_relations_hash,
      wide_user_ids_arr: @wide_user_ids_arr,
      connected_author_arr: connected_author_arr,
      qty_of_tree_profiles: qty_of_tree_profiles
    }

    return results
  end

  # Служебный метод для отладки - для LOGGER
  # Показывает массив в logger
  def show_in_logger(arr_to_log, string_to_add)
    row_no = 0  # DEBUGG_TO_LOGG
    arr_to_log.each do |row| # DEBUGG_TO_LOGG
      row_no += 1
      logger.debug "#{string_to_add} № #{row_no.inspect}: #{row.attributes.inspect} " # DEBUGG_TO_LOGG
      #logger.debug "=== === ::: запись № #{row_no.inspect} = relation_match_arr.each: #{row.attributes.inspect} " # DEBUGG_TO_LOGG
    end  # DEBUGG_TO_LOGG
    logger.info " "
  end

  # На выходе ближний круг для профиля в дереве user_id
  # по записям в ProfileKey
  def profile_near_circle(user_ids, profile_id)
    Tree.where(user_id: user_ids).where("profile_id = #{profile_id} or is_profile_id = #{profile_id}").order('relation_id').includes(:name)
  end

  # Сохранение результатов поиска в рабочих Хэшах
  #
  def collect_search_results(found_user_id, found_profile_id)

    logger.info "=== === Накопление результатов по деревьям (в методе *collect_search_results*) "

    # ВАЖНО: формируется массив найденных профилей для одной группы relation_match_arr
    current_profiles_arr << tree_row.profile_id  # Если в нем не окажется профиля из предыдущих, то такой профиль удаляется как результат
    logger.info "=== === 1. Текущий массив найденных профилей: #{current_profiles_arr}"
    fill_hash(res_hash, tree_row.profile_id) # наполнение хэша найденными profile_id и частотой их обнаружения = 1
    # Формирование ХЭШа с результатами: Сколько раз какой профиль был найден.
    logger.info "=== === 2. Hash найденных профилей: #{res_hash} "
    trees_res_hash.merge!({tree_row.user_id  => res_hash } ) # наполнение хэша накопленные Hash найденных профилей: #{res_hash}
    logger.info "=== === 3. Trees Hash найденных профилей: #{trees_res_hash} "   #
    # Его структура: {tree_id => {profile_id => частота появления profile_id в рез-тах поиска}}/

    ## ??? ВАЖНЫЙ УЧАСТОК: ОПРЕДЕЛЕНИЕ ПРАВИЛЬНОГО ПРОФИЛЯ В КАЧЕСТВЕ СООТВЕТСТВИЯ ИСКОМОМУ
    #trees_res_hash.each_pair {|key,val_hash|  key == tree_row.user_id; qty_arr = val_hash.values
    #max_qty = qty_arr.sort.last
    #@right_profile = val_hash.key(max_qty)
    #logger.info "=== === 4. ВАЖНО: Из Trees Hash : @right_profile = #{@right_profile}"
    #} #
    #
    #fill_hash(found_trees_hash, tree_row.user_id) # наполнение хэша найденными user_id = trees и частотой их обнаружения
    #logger.info "=== === 5. found_trees_hash = #{found_trees_hash} "
    #
    #wide_found_profiles_arr << {from_profile_searching => [@right_profile]} # DEBUGG_TO_LOGG
    #wide_found_relations_arr << {from_profile_searching => [relation_id_searched]} # DEBUGG_TO_LOGG
    #
    #wide_found_profiles_hash.merge!({tree_row.user_id  => {from_profile_searching => [@right_profile]} } ) # наполнение хэша найденными profile_id
    #wide_found_relations_hash.merge!({tree_row.user_id  => {from_profile_searching => [relation_id_searched]} } ) # наполнение хэша найденными relation_id
    #logger.info "=== === 6. wide_found_profiles_hash = #{wide_found_profiles_hash}, wide_found_relations_hash = #{wide_found_relations_hash}"
    #logger.info "=== === 7. wide_found_profiles_arr = #{wide_found_profiles_arr}, wide_found_relations_arr = #{wide_found_relations_arr}"
    #logger.info "=== === 8. общее кол-во сохранений профилей = #{qty_of_results} из relation_match_arr"
    #logger.info " "
      # end of collect_search_results(tree_row, from_profile_searching, relation_id_searched)


  end



  # ЖЕСТКИЙ Поиск совпадений для одного из профилей БК current_user
  # Берем параметр: profile_id из массива  = profiles_tree_arr[i][6].
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # На выходе: @all_match_arr по данному виду родства
 def hard_search_match(connected_users, from_profile_searching, profile_id_searched, relation_id_searched)

   found_trees_hash = Hash.new     #{ 0 => []}
   wide_found_profiles_arr = Array.new  #
   wide_found_relations_arr = Array.new  #

   hard_search_profiles_hash = Hash.new  #
   hard_search_relations_hash = Hash.new  #

   wide_found_profiles_hash = Hash.new  #
   wide_found_relations_hash = Hash.new  #
   logger.info " "
   logger.info "-------- СТАРТ hard_search_match для одной итерации ---------"
   logger.info " "

   all_profile_rows = ProfileKey.where(:user_id => connected_users).where(:profile_id => profile_id_searched).select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id, :id)

   # поиск массива записей ближнего круга для каждого профиля в дереве Юзера
   logger.info "Ближний круг - Все записи об ИСКОМОМ ПРОФИЛЕ = #{profile_id_searched.inspect} в ИСХОДНОМ (объединенном) дереве зарег-го Юзера"
   show_in_logger(all_profile_rows, "all_profile_rows - запись" )  # DEBUGG_TO_LOGG
   #qty_of_results = 0 # Начало подсчета результатов поиска (сумма успешных поисков в противоположном дереве)

  #@search_exclude_users = [85,86,87,88,89,90,91,92] # временный массив исключения косых юзеров из поиска DEBUGG_TO_VIEW
   @search_exclude_users = [] # временный массив исключения косых юзеров из поиска DEBUGG_TO_LOGG
# убрать потом !!!

   all_profile_rows_No = 1 # текущий номер записи из all_profile_rows - для Logger
   if !all_profile_rows.blank?
     @all_profile_rows_len = all_profile_rows.length if !all_profile_rows.blank? #DEBUGG_TO_LOGG
     # размер ближнего круга профиля в дереве current_user.id
     logger.info "кол-во всех записей об ИСКОМОМ ПРОФИЛЕ @all_profile_rows_len = #{@all_profile_rows_len}"
     profiles_included_arr = []  # # Полный массив найденных профилей для одной записи из all_profile_rows
     res_hash = Hash.new  # Hash найденных профилей = {profile_id => qty}
     trees_res_hash = Hash.new  # Hash найденных профилей = {tree => {profile_id => qty}} для одной записи из all_profile_rows

     first_rez_collect = true  # Признак того, что в 1-й раз собираем рез-ты поиска по all_profile_rows, не считая когда
     # ищем relation_id_searched == 0 (не Автора).

     #to_check_match = 0 # Счетчик кол-ва успешных поисков по 1 записи из all_profile_rows для искомого профиля
     all_profile_rows.each do |relation_row|
       logger.info " "
       logger.info "=== ПОИСК ПРОФИЛЯ < #{profile_id_searched.inspect} > по записи о нем № #{all_profile_rows_No}: #{relation_row.attributes.inspect}"
       logger.info "=== ИЩЕМ: Имя = #{relation_row.name_id.inspect} --- Отношение = #{relation_row.relation_id} --- К Имени = #{relation_row.is_name_id}  "

       relation_match_arr = ProfileKey.where.not(user_id: @search_exclude_users).where.not(user_id: connected_users).where(:name_id => relation_row.name_id, :relation_id => relation_row.relation_id, :is_name_id => relation_row.is_name_id).select(:id, :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
       if !relation_match_arr.blank?  # Значит, есть совпадения(е)  в пространстве поиска ProfileKey для 1 записи из all_profile_rows.
         show_in_logger(relation_match_arr, "=== РЕЗУЛЬТАТ ПОИСКА" )  # DEBUGG_TO_LOGG

         if relation_id_searched != 0 # Ищем не Автора
           #########################################################
           logger.info "** ищем ОТНОШЕНИЕ не Автора - relation_id = #{relation_id_searched}"
           #########################################################

           if first_rez_collect # Признак того, что в 1-й раз собираем рез-ты поиска по all_profile_rows
             # заносим все найденные рез-ты в 1-й раз в
             #########################################################
             logger.info "!!! В 1-й раз сохранение рез-тов поиска !!! first_rez_collect = #{first_rez_collect}"
             #########################################################
             qty_of_results = 1  # Счетчик кол-ва циклов по найденным результатам DEBUGG_TO_LOGG
             current_profiles_arr = []   # Текущий массив найденных профилей
             relation_match_arr.each do |tree_row|  # Цикл по найденным результатам
               logger.info " "
               logger.info "=== 1-й В ДЕРЕВЕ #{tree_row.user_id} ДЛЯ ИСКОМОГО ПРОФИЛЯ #{profile_id_searched.inspect} - НАЙДЕН НЕКИЙ ПРОФИЛЬ #{tree_row.profile_id} "
               logger.info "=== 1-й === Накопление ПЕРВЫХ результатов по деревьям - collect_search_results"

               # collect_search_results(tree_row, from_profile_searching, relation_id_searched)
               @right_profile = find_right_profile(tree_row)
               logger.info "=== CHECK : right_prof = #{@right_profile}"

               current_profiles_arr << tree_row.profile_id  # Если в нем не окажется профиля из предыдущих, то такой профиль удаляется как результат
               logger.info "=== 1-й === 2. Текущий массив найденных профилей: current_profiles_arr = #{current_profiles_arr}"

               #fill_hash(res_hash, tree_row.profile_id) # наполнение хэша найденными profile_id и частотой их обнаружения = 1
               ## Формирование ХЭШа с результатами: Сколько раз какой профиль был найден.
               #logger.info "=== 1-й === 3. Hash найденных профилей: #{res_hash} "
               #trees_res_hash.merge!({tree_row.user_id  => res_hash } ) # наполнение хэша накопленные Hash найденных профилей: #{res_hash}
               #logger.info "=== 1-й === 4. Trees Hash найденных профилей: #{trees_res_hash} "   #
               ## Его структура: {tree_id => {profile_id => частота появления profile_id в рез-тах поиска}}/
               #
               ## ??? ВАЖНЫЙ УЧАСТОК: ОПРЕДЕЛЕНИЕ ПРАВИЛЬНОГО ПРОФИЛЯ В КАЧЕСТВЕ СООТВЕТСТВИЯ ИСКОМОМУ
               #trees_res_hash.each_pair {|key,val_hash|  key == tree_row.user_id; qty_arr = val_hash.values
               #max_qty = qty_arr.sort.last
               #@right_profile = val_hash.key(max_qty)
               #} #

               logger.info "=== автор 4. ВАЖНО: Из Trees Hash : @right_profile = #{@right_profile}"

               hard_search_profiles_hash.merge!({tree_row.user_id  => {from_profile_searching => [@right_profile]} } ) # наполнение хэша найденными profile_id
               hard_search_relations_hash.merge!({tree_row.user_id  => {from_profile_searching => [relation_id_searched]} } ) # наполнение хэша найденными relation_id
               logger.info "=== 1-й === 1a. hard_search_profiles_hash = #{hard_search_profiles_hash}"
               logger.info "=== 1-й === 1b. hard_search_relations_hash = #{hard_search_relations_hash}"

               qty_of_results += 1  # подсчет кол-ва рядов в relation_match_arr, которые входят в результат по очереди

             end
             #########################################################
             # сбор общего массива найденных профилей по всем зацепленным деревьям
              #    trees_res_hash =  {4=>{27=>1, 28=>2, 29=>3,},5=>{27=>4},6=>{27=>5},7=>{27=>6} }  # DEBUG_TO_LOGGER
             #logger.info " "
             #profiles_included_arr = []
             #trees_res_hash.each_pair {|key, val_hash|
             #  one_arr_profiles = val_hash.keys
             #  profiles_included_arr << one_arr_profiles
             #  logger.info "=== 1-й === 5. сбор массива profiles_included_arr Из Trees Hash : one_arr_profiles = #{one_arr_profiles}"
             #}
             profiles_included_arr = current_profiles_arr #
             profiles_included_arr = profiles_included_arr.flatten.uniq # выравнивание массива и удал-е дубликатов
             logger.info "=== 1-й === 6. массив найденных профилей profiles_included_arr для 1-й записи: profiles_included_arr = #{profiles_included_arr}"
             first_rez_collect = false  # Установка Признака того, что это - уже не первый по порядку поиск (не Автора)
             #@all_found_profiles_arr << profiles_included_arr
             #logger.info "=== 1-й === 7. Текущий итоговый массив найденных профилей для всех деревьев, обнаруженных в поиске: @all_found_profiles_arr = #{@all_found_profiles_arr}"
             #########################################################

           else # Далее - "!!! УЖЕ НЕ в 1-й раз cохранение рез-тов поиска !!!

             #########################################################
             logger.info "!!! УЖЕ НЕ в 1-й раз cохранение рез-тов поиска !!! first_rez_collect = #{first_rez_collect}"
             #########################################################
             qty_of_results = 1  # Счетчик кол-ва циклов по найденным результатам DEBUGG_TO_LOGG
             current_profiles_arr = []   # Текущий массив найденных профилей для одной записи из relation_match_arr
             relation_match_arr.each do |tree_row|  # Цикл по найденным результатам
               logger.info " "
               logger.info "=== ПОИСК ПО РЕЗУЛЬТАТУ № #{qty_of_results}"
               logger.info "=== В ДЕРЕВЕ #{tree_row.user_id} ДЛЯ ИСКОМОГО ПРОФИЛЯ #{profile_id_searched.inspect} - НАЙДЕН НЕКИЙ ПРОФИЛЬ #{tree_row.profile_id} "

               #########################################################
               if profiles_included_arr.include?(tree_row.profile_id)
                 logger.info "=== ПОВТОРНО НАЙДЕН ПРОФИЛЬ из ранее найденных - Накопление результатов"
                 #########################################################

                 logger.info "=== === Накопление результатов по деревьям (в методе *collect_search_results*) "

                 # collect_search_results(tree_row, from_profile_searching, relation_id_searched)
                 current_profiles_arr << tree_row.profile_id  # Если в нем не окажется профиля из предыдущих, то такой профиль удаляется как результат
                 logger.info "=== 1-й === 2. Текущий массив найденных профилей: current_profiles_arr = #{current_profiles_arr}"

                 #@right_profile = find_right_profile(tree_row)
                 #logger.info "=== CHECK : right_prof = #{@right_profile}"

                 fill_hash(res_hash, tree_row.profile_id) # наполнение хэша найденными profile_id и частотой их обнаружения = 1
                 # Формирование ХЭШа с результатами: Сколько раз какой профиль был найден.
                 logger.info "=== 1-й === 3. Hash найденных профилей: #{res_hash} "
                 trees_res_hash.merge!({tree_row.user_id  => res_hash } ) # наполнение хэша накопленные Hash найденных профилей: #{res_hash}
                 logger.info "=== 1-й === 4. Trees Hash найденных профилей: #{trees_res_hash} "   #
                 # Его структура: {tree_id => {profile_id => частота появления profile_id в рез-тах поиска}}/

                 # ВАЖНЫЙ УЧАСТОК: ОПРЕДЕЛЕНИЕ ПРАВИЛЬНОГО ПРОФИЛЯ В КАЧЕСТВЕ СООТВЕТСТВИЯ ИСКОМОМУ
                 trees_res_hash.each_pair {|key,val_hash|  key == tree_row.user_id; qty_arr = val_hash.values
                 max_qty = qty_arr.sort.last
                 @right_profile = val_hash.key(max_qty)
                 } #
                 logger.info "=== автор 4. ВАЖНО: Из Trees Hash : @right_profile = #{@right_profile}"

                 hard_search_profiles_hash.merge!({tree_row.user_id  => {from_profile_searching => [@right_profile]} } ) # наполнение хэша найденными profile_id
                 hard_search_relations_hash.merge!({tree_row.user_id  => {from_profile_searching => [relation_id_searched]} } ) # наполнение хэша найденными relation_id
                 logger.info "=== 1-й === 1a. hard_search_profiles_hash = #{hard_search_profiles_hash}"
                 logger.info "=== 1-й === 1b. hard_search_relations_hash = #{hard_search_relations_hash}"
                 # end of collect_search_results(tree_row, from_profile_searching, relation_id_searched)

               else
                 #########################################################
                 logger.debug "=== НАЙДЕННЫЙ ПРОФИЛЬ - НОВЫЙ, ПОЭТОМУ НЕ СОХРАНЯЕМ ЕГО В РЕЗ-ТАХ поиска - в массиве #{current_profiles_arr} (по результату № #{qty_of_results}) "
                 #########################################################
               end
               #profiles_included_arr << current_profiles_arr
               #logger.info "=== === массив найденных профилей: profiles_included_arr = #{profiles_included_arr}"
               #@all_found_profiles_arr << profiles_included_arr
               qty_of_results += 1  # подсчет кол-ва рядов в relation_match_arr, которые входят в результат по очереди

             end

             #########################################################
             ## ВАЖНАЯ ОПЕРАЦИЯ: КОРРЕКТИРОВКА ПОЛНОГО МАССИВА НАЙДЕННЫХ ПРОФИЛЕЙ profiles_included_arr
             # В ЗАВИС-ТИ ОТ СОДЕРЖАНИЯ МАССИВА ТЕКУЩИХ НАЙДЕННЫХ ПРОФИЛЕЙ current_profiles_arr:
             # НАХОДИМ ПЕРЕСЕЧЕНИЕ ЭТИХ ДВУХ МАССИВОВ
             # В ИТОГОВОМ ПОЛНОМ МАССИВЕ ОСТАЮТСЯ ТОЛЬКО ТЕ ПРОФИЛИ, КОТОРЫЕ БЫЛИ НАЙДЕНЫ
             # С ПЕРВОГО ДО ТЕКУЩЕГО ПОИСКА
             # (В ИТОГЕ - ДО ПОСЛЕДНЕЙ ЗАПИСИ)
             # в принципе, содержание итогового массива profiles_included_arr - с каждым результатом поиска уменьшается
             # из него исключаются те профили, кот-е не были найдены хотя бы
             # в одном поиске
             # #######################################################
             #########################################################
             logger.info "=== === КОРРЕКТИРОВКА ПОЛНОГО МАССИВА НАЙДЕННЫХ ПРОФИЛЕЙ profiles_included_arr"
             logger.info "=== === Текущий массив найденных профилей: current_profiles_arr = #{current_profiles_arr}"
             if !current_profiles_arr.blank?
               profiles_included_arr = profiles_included_arr & current_profiles_arr  # определение оставшихся профилей в рез-те поиска
             else
               profiles_included_arr = []
             end
             logger.info "=== === Полученный массив найденных профилей: profiles_included_arr = #{profiles_included_arr}"
             #########################################################

           end  # ОСНОВНОЙ ЦИКЛ ПОИСКА завершение поиска НЕ Автора и НЕ в 1-й раз

           #########################################################
           logger.debug ""
           logger.debug "=== Результаты поиска для записи № #{all_profile_rows_No}: #{relation_row.attributes.inspect} ==="
           logger.info "=== Trees Hash найденных профилей: #{trees_res_hash} "   #
           #logger.info "=== Новый Накопленный Полный массив найденных профилей: profiles_included_arr = #{profiles_included_arr}"
           #logger.info "=== Текущий итоговый массив найденных профилей для всех деревьев, обнаруженных в поиске: @all_found_profiles_arr = #{@all_found_profiles_arr}"
           #########################################################

         else # Ищем Автора
           #########################################################
           logger.info "** ищем ОТНОШЕНИЕ Автора - relation_id = #{relation_id_searched}"
            # Здесь - особый порядок поиска
            # заносим все найденные рез-ты в 1-й раз в
            #########################################################
           qty_of_results = 1  # Счетчик кол-ва циклов по найденным результатам DEBUGG_TO_LOGG
           current_profiles_arr = []   # Текущий массив найденных профилей DEBUGG_TO_LOGG
           relation_match_arr.each do |tree_row|  # Цикл по найденным результатам
             logger.info " "
             logger.info "=== В ДЕРЕВЕ #{tree_row.user_id} ДЛЯ ИСКОМОГО ПРОФИЛЯ #{profile_id_searched.inspect} - НАЙДЕН НЕКИЙ ПРОФИЛЬ #{tree_row.profile_id} "
             logger.info "=== === Накопление ПЕРВЫХ результатов по деревьям - collect_search_results"

             # collect_search_results(tree_row, from_profile_searching, relation_id_searched)
             # ВАЖНО: формируется массив найденных профилей для одной группы relation_match_arr
             #current_profiles_arr << tree_row.profile_id  # Если в нем не окажется профиля из предыдущих, то такой профиль удаляется как результат
             #logger.info "=== автор 1a. Текущий массив найденных профилей: #{current_profiles_arr}"

             fill_hash(res_hash, tree_row.profile_id) # наполнение хэша найденными profile_id и частотой их обнаружения = 1
             # Формирование ХЭШа с результатами: Сколько раз какой профиль был найден.
             logger.info "=== автор 2. Hash найденных профилей: #{res_hash} "
             trees_res_hash.merge!({tree_row.user_id  => res_hash } ) # наполнение хэша накопленные Hash найденных профилей: #{res_hash}
             logger.info "=== автор 3. Trees Hash найденных профилей: #{trees_res_hash} "   #
             # Его структура: {tree_id => {profile_id => частота появления profile_id в рез-тах поиска}}/

             # ??? ВАЖНЫЙ УЧАСТОК: ОПРЕДЕЛЕНИЕ ПРАВИЛЬНОГО ПРОФИЛЯ В КАЧЕСТВЕ СООТВЕТСТВИЯ ИСКОМОМУ
             trees_res_hash.each_pair {|key,val_hash|  key == tree_row.user_id; qty_arr = val_hash.values
             max_qty = qty_arr.sort.last
             @right_profile = val_hash.key(max_qty)
             logger.info "=== автор 4. ВАЖНО: Из Trees Hash : @right_profile = #{@right_profile}"
             } #

             hard_search_profiles_hash.merge!({tree_row.user_id  => {from_profile_searching => [@right_profile]} } ) # наполнение хэша найденными profile_id
             hard_search_relations_hash.merge!({tree_row.user_id  => {from_profile_searching => [relation_id_searched]} } ) # наполнение хэша найденными relation_id
             logger.info "=== автор 5a. hard_search_profiles_hash = #{hard_search_profiles_hash}"
             logger.info "=== автор 5b. hard_search_relations_hash = #{hard_search_relations_hash}"

             profiles_included_arr = [@right_profile] #
             logger.info "=== автор 6. массив найденных профилей: #{profiles_included_arr}"

             qty_of_results += 1  # подсчет кол-ва рядов в relation_match_arr, которые входят в результат по очереди

           end

           ########## Завершение поиска Автора ###############################################

         end

       else
         #########################################################
          logger.info "=== НЕТ результата!"
          logger.info "=== В деревьях сайта ничего не найдено для записи № #{all_profile_rows_No}: #{relation_row.attributes.inspect} === "
          logger.debug "=== ИСКЛЮЧЕНИЕ ВСЕХ ПРОФИЛЕЙ ИЗ trees_res_hash"
          profiles_included_arr = [] #
          logger.info "=== массив найденных профилей: #{profiles_included_arr}"
          trees_res_hash = {} # НЕТ результата!
          logger.info "=== Trees Hash НЕнайденных профилей: #{trees_res_hash} "   #
          #########################################################

       end

       all_profile_rows_No += 1 # Подсчет номера по порядку очередной записи об искомом профиле

     end
     @all_found_profiles_arr << profiles_included_arr
     logger.info "=== === Текущий итоговый массив найденных профилей для всех деревьев, обнаруженных в поиске: @all_found_profiles_arr = #{@all_found_profiles_arr}"


     #logger.info ""
     #logger.info "ПОСЛЕ РЯДОВ all_profile_rows ДЛЯ ОДНОЙ ИТЕРАЦИИ ПОИСКА tree_arr"
     #logger.info " *** текущий РЕЗУЛЬТАТ ПОИСКА: @hard_search_result_profiles = #{@hard_search_result_profiles}"
     #logger.info " *** текущий РЕЗУЛЬТАТ ПОИСКА: @hard_search_result_relations = #{@hard_search_result_relations}"


   end

   ################## ЗДЕСЬ АНАЛИЗ ПОЛУЧЕННЫХ СОВПАДЕНИЙ по всем деревьям/
   logger.info "ПОСЛЕ ВСЕХ рядов all_profile_rows"
   #logger.info "FINALFINAL === === После ряда № = #{all_profile_rows_No}  all_profile_rows:"
   logger.info "FINAL === ===  hard_search_profiles_hash = #{hard_search_profiles_hash}"
   logger.info "FINAL === ===  hard_search_relations_hash = #{hard_search_relations_hash}"
   #logger.info "FINAL === ===  Полный массив найденных профилей: profiles_included_arr = #{profiles_included_arr}"
   #logger.info "FINAL === ===  Trees Hash найденных профилей: #{trees_res_hash} "   #
   logger.info "FINAL === Итоговый массив найденных профилей для всех деревьев, обнаруженных в поиске: @all_found_profiles_arr = #{@all_found_profiles_arr}"

   ##### КОРРЕКТИРОВКА результатов поиска на основе результатов поиска - содержания Хэша trees_res_hash
   hard_search_profiles_hash.delete_if {|key, value| !trees_res_hash.keys.include?(key)} # Убираем из хэша профилей
#   hard_search_profiles_hash.delete_if {|key, value| !all_found_profiles_arr.include?(key)} # Убираем из хэша профилей
   # На выходе ХЭШ: {user_id  => profile_id} - найденные деревья с найденным профилем в них.
   @hard_search_profiles_hash = hard_search_profiles_hash
   hard_search_relations_hash.delete_if {|key, value| !trees_res_hash.keys.include?(key)} # Убираем из хэша профилей
   logger.info " *** после настройки рез-тов поиска: hard_search_profiles_hash = #{hard_search_profiles_hash}, hard_search_relations_hash = #{hard_search_relations_hash}"

   ##### ИТОГОВЫЕ РАСШИРЕННЫЕ результаты поиска

   @hard_search_result_profiles << hard_search_profiles_hash if !hard_search_profiles_hash.blank? # Заполнение выходного массива хэшей
   @hard_search_result_relations << hard_search_relations_hash if !hard_search_relations_hash.empty? # Заполнение выходного массива хэшей
   logger.info " *** РЕЗУЛЬТАТ ПОИСКА ПОСЛЕ ОЧЕРЕДНОЙ ОДНОЙ ИТЕРАЦИИ - ЗАПУСКА HARD_SEARCH по tree_arr"
   logger.info " *** @hard_search_result_profiles = #{@hard_search_result_profiles}"
   logger.info " *** @hard_search_result_relations = #{@hard_search_result_relations}"

   @new_all_found_profiles_arr = @all_found_profiles_arr.flatten.uniq
   logger.info " *** @new_all_found_profiles_arr = #{@new_all_found_profiles_arr}"

 #  @hard_search_result_profiles = [{4=>{16=>[28]}}, {4=>{16=>[27]}}, {4=>{16=>[24]}}, {4=>{16=>[30]}}, {4=>{16=>[29]}}, {4=>{16=>[35]}}]
 #  *** @new_search_profiles_arr =  [{4=>{16=>[28]}}, {4=>{16=>[27]}}, {4=>{16=>[24]}}, {4=>{16=>[30]}}, {4=>{16=>[29]}}]

  @all_wide_match_profiles_arr, @all_wide_match_relations_arr =  main_exclude_search_hashes(@hard_search_result_profiles, @hard_search_result_relations, @new_all_found_profiles_arr)

   #
   #@new_search_profiles_arr = []
   #@new_search_relations_arr = []
   #@hard_search_result_profiles.each_with_index do |k, index| #,val_hash|
   #  one_elem_value_hash = k.values[0].values.flatten[0]
   #  if @new_all_found_profiles_arr.include?(one_elem_value_hash)
   #    @new_search_profiles_arr << k
   #    @new_search_relations_arr << @hard_search_result_relations[index]
   #  end
   #  logger.info " *** k = #{k}, one_elem_value_hash = #{one_elem_value_hash}"
   #
   #
   #end
   #logger.info " *** @new_search_profiles_arr = #{@new_search_profiles_arr}"
   #logger.info " *** @@new_search_relations_arr = #{@new_search_relations_arr}"
   #


   #@all_wide_match_profiles_arr = @new_search_profiles_arr
   #@all_wide_match_relations_arr = @new_search_relations_arr

 end


  # ВАЖНО! Исключение из Хэша результатов тех элементов,
  # которые отсутствуют в массиве отобранных профилей по-жесткому
  def main_exclude_search_hashes(input_profiles_hash, input_relations_hash, profiles_array)
   new_search_profiles_arr = []
   new_search_relations_arr = []
   input_profiles_hash.each_with_index do |k, index| #,val_hash|
     one_elem_value_hash = k.values[0].values.flatten[0]
     if profiles_array.include?(one_elem_value_hash)
       new_search_profiles_arr << k
       new_search_relations_arr << input_relations_hash[index]
     end
     logger.info " *** k = #{k}, one_elem_value_hash = #{one_elem_value_hash}"
   end

   logger.info " *** new_search_profiles_arr = #{new_search_profiles_arr}"
   logger.info " *** new_search_relations_arr = #{new_search_relations_arr}"

   return new_search_profiles_arr, new_search_relations_arr
 end





def find_right_profile(tree_row)

  res_hash = Hash.new  # Hash найденных профилей = {profile_id => qty}
  trees_res_hash = Hash.new  # Hash найденных профилей = {tree => {profile_id => qty}} для одной записи из all_profile_rows

  fill_hash(res_hash, tree_row.profile_id) # наполнение хэша найденными profile_id и частотой их обнаружения = 1
  # Формирование ХЭШа с результатами: Сколько раз какой профиль был найден.
  logger.info "=== автор 2. Hash найденных профилей: #{res_hash} "
  trees_res_hash.merge!({tree_row.user_id  => res_hash } ) # наполнение хэша накопленные Hash найденных профилей: #{res_hash}
  logger.info "=== автор 3. Trees Hash найденных профилей: #{trees_res_hash} "   #
  # Его структура: {tree_id => {profile_id => частота появления profile_id в рез-тах поиска}}/

  # ??? ВАЖНЫЙ УЧАСТОК: ОПРЕДЕЛЕНИЕ ПРАВИЛЬНОГО ПРОФИЛЯ В КАЧЕСТВЕ СООТВЕТСТВИЯ ИСКОМОМУ
  trees_res_hash.each_pair {|key,val_hash|  key == tree_row.user_id; qty_arr = val_hash.values
  max_qty = qty_arr.sort.last
  right_profile = val_hash.key(max_qty)
  logger.info "=== автор 4. ВАЖНО: Из Trees Hash : @right_profile = #{right_profile}"
  @right_profil = right_profile
  } #

  return @right_profil

end


  # Поиск совпадений для одного из профилей БК current_user
  # Берем параметр: profile_id из массива  = profiles_tree_arr[i][6].
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # На выходе: @all_match_arr по данному виду родства
  def soft_search_match(connected_users, from_profile_searching, profile_id_searched, relation_id_searched)

    found_trees_hash = Hash.new     #{ 0 => []}
    all_relation_match_arr = []     #

       wide_found_profiles_arr = Array.new  #
       wide_found_relations_arr = Array.new  #

    wide_found_profiles_hash = Hash.new  #
    wide_found_relations_hash = Hash.new  #
       logger.info " "
       logger.info "     IN get_relation_match "
       logger.info " "

    all_profile_rows = ProfileKey.where(:user_id => connected_users).where(:profile_id => profile_id_searched).select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id, :id)
    # поиск массива записей ближнего круга для каждого профиля в дереве Юзера
       logger.info "Все записи об ИСКОМОМ ПРОФИЛЕ = #{profile_id_searched.inspect} в (объединенном) дереве зарег-го Юзера"
       show_in_logger(all_profile_rows, "all_profile_rows - запись" )  # DEBUGG_TO_LOGG
    qty_of_results = 0 # Начало подсчета результатов поиска (сумма успешных поисков в противоположном дереве)

    #@search_exclude_users = [85,86,87,88,89,90,91,92] # временный массив исключения косых юзеров из поиска DEBUGG_TO_VIEW
    @search_exclude_users = [] # временный массив исключения косых юзеров из поиска DEBUGG_TO_LOGG
    # убрать потом !!!

    all_profile_rows_No = 1
    if !all_profile_rows.blank?
      @all_profile_rows_len = all_profile_rows.length if !all_profile_rows.blank? #DEBUGG_TO_LOGG
      # размер ближнего круга профиля в дереве current_user.id
           logger.info "кол-во всех записей об ИСКОМОМ ПРОФИЛЕ @all_profile_rows_len = #{@all_profile_rows_len}"
      row_arr = []   # DEBUGG_TO_LOGG
      res_hash = Hash.new

      all_profile_rows.each do |relation_row|
               logger.info " "
               logger.info "=== ПОИСК по записи № #{all_profile_rows_No}: #{relation_row.attributes.inspect}"

        relation_match_arr = ProfileKey.where.not(user_id: @search_exclude_users).where.not(user_id: connected_users).where(:name_id => relation_row.name_id, :relation_id => relation_row.relation_id, :is_name_id => relation_row.is_name_id).select(:id, :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
        if !relation_match_arr.blank?
                   logger.info "=== Есть результаты! найдено #{relation_match_arr.size} результатов в деревьях сайта (см. ниже список записей) "
                   show_in_logger(relation_match_arr, "=== результат" )  # DEBUGG_TO_LOGG
                   logger.info "=== Цикл по найденным результатам ==="
          relation_match_arr_row_no = 1  # DEBUGG_TO_LOGG

          relation_match_arr.each do |tree_row|
                     logger.info "=== === в результате #{relation_match_arr_row_no} НАЙДЕН ТРИПЛЕКС : name_id = #{tree_row.name_id}, relation_id = #{tree_row.relation_id}, is_name_id = #{tree_row.is_name_id}   (profile_id = #{tree_row.profile_id}, is_profile_id = #{tree_row.is_profile_id}) "
                     logger.debug "=== === === СОХРАНЕНИЕ РЕЗ-ТОВ поиска по результату № #{relation_match_arr_row_no} "
                     row_arr << tree_row.profile_id  # DEBUGG_TO_LOGG
                     qty_of_results += 1   # DEBUGG_TO_LOGG

          fill_hash(res_hash, tree_row.profile_id) # наполнение хэша найденными profile_id и частотой их обнаружения
                                                             # Формирование ХЭШа с результатами: Сколько раз какой профиль был найден.
                     logger.info "=== === === накопленные: Hash найденных профилей: #{res_hash}, общее кол-во сохранений результатов = #{qty_of_results}  "
                     logger.info "=== === === !!! ДЛЯ ИСКОМОГО ПРОФИЛЯ #{profile_id_searched.inspect} - НАЙДЕН ПРОФИЛЬ #{tree_row.profile_id} !!! "
                     logger.info "=== === === накопленные: массив найденных профилей: #{row_arr} "# ", кол-во результатов = #{relation_match_arr_row_no}  "

          # В СИТУАЦИИ КОГДА ПОЯВЛЯЕТСЯ МНОЖЕСТВО ВАРИАНТОВ ПРОФИЛЕЙ tree_row.profile_id В КАЧ-ВЕ РЕЗ-ТА ПОИСКА
          # ЗДЕСЬ - АНАЛИЗ И ВЫБОР ПРАВИЛЬНОГО ПРОФИЛЯ ДЛЯ ЗАПИСИ В ХЭШ wide_found_profiles_hash РЕЗУЛЬТАТОВ
          #
          # В НАСТОЯЩИЙ МОМЕНТ - ПРАВИЛЬНЫЙ ПРОФИЛЬ ТОТ,
          # ЧТО БЫЛ НАЙДЕН МАКСИМАЛЬНОЕ ЧИСЛО РАЗ ПО СРАВНЕНИЮ С ДРУГИМИ
          # ЕСЛИ ЭТОГО НЕ ДЕЛАТЬ, ТО В РЕЗ-ТИР-Й ХЭШ wide_found_profiles_hash ЗАПИШЕТСЯ ПОСЛЕДНИЙ ИЗ НАЙДЕННЫХ ПРОФИЛЕЙ,
          # НЕСМОТРЯ НА ТО, ЧТО ОН МОЖЕТ БЫЛ НАЙДЕН ВСЕГО 1 РАЗ. КОГДА ДРУГИЕ ПРОФИЛИ - БОЛЬШЕЕ ЧИСЛО РАЗ.
          # (ТАК РАБОТАЕТ merge)
          # .
          # СЕЙЧАС СДЕЛАНО ТАК:
          # ПРОИСХОДИТ СОРТИРОВКА НАКОПЛЕННОГО ХЭША res_hash ПО ЗНАЧЕНИЮ ВСТРЕЧАЕМОСТИ ПРОФИЛЯ
          # и извлечение последнего, т.к. м.б. несколько с макс-м значением (?) - ПРЕДПОЛОЖЕНИЕ
          #
          right_profile_key = res_hash.sort{|a,b| a[1] <=> b[1]}.last[0]  # KEY последний в отсортированном Хэше по value
                     logger.info "=== === === === === определен ТЕКУЩИЙ правильный profile_id : right_profile_key = #{right_profile_key} для записи в окончательный рез-тат - в wide_found_profiles_hash"
          # в принципе здесь ВМЕСТО ЭТОГО ВОЗМОЖНО ПОТРЕБУЕТСЯ более ТОЧНЫЙ анализ по определению правильного ПРОФИЛЯ - рез-та поиска
          # НУЖНО БУДЕТ АНАЛИЗИРОВАТЬ НАЛИЧИЕ ДРУГИХ СВЯЗЕЙ КАЖДОГО ИЗ НАЙДЕННЫХ ПРОФИЛЕЙ
          #
          # В ПРИНЦИПЕ, ЧАСТОТА ИХ (ПРОФИЛЕЙ) ОБНАРУЖЕНИЯ, КОТ. ЗАПИСАНА В ХЭШЕ res_hash - ЭТО И ЕСТЬ ПОДТВЕРЖДЕНИЕ ТОГО, ЧТО
          # В ПОИСКЕ СРАБОТАЛИ СООТВ-Е КОЛ-ВО ИМЕЮЩИХСЯ СВЯЗЕЙ (см.res_hash).
          # ПРОБЛЕМА МОЖЕТ БЫТЬ ЕСЛИ ЧАСТОТА ОБНАРУЖЕНИЯ РАЗНЫХ ПРОФИЛЕЙ БУДЕТ ОДИНАКОВА
          # ТОГДА НАДО ВЫЯСНЯТЬ СИТУАЦИЮ МЕЖДУ ЭТИМИ РАВНОНАЙДЕННЫМИ ПРОФИЛЯМИ
                     # НО ЭТО - СЛЕДУЮЩАЯ ЗАДАЧА
                     #
                     # .

                     fill_hash(found_trees_hash, tree_row.user_id) # наполнение хэша найденными user_id = trees и частотой их обнаружения
                     #logger.info "=== === === found_trees_hash = #{found_trees_hash} "

                     wide_found_profiles_arr << {from_profile_searching => [right_profile_key]} # DEBUGG_TO_LOGG
                     wide_found_relations_arr << {from_profile_searching => [relation_id_searched]} # DEBUGG_TO_LOGG

          wide_found_profiles_hash.merge!({tree_row.user_id  => {from_profile_searching => [right_profile_key]} } ) # наполнение хэша найденными profile_id
          wide_found_relations_hash.merge!({tree_row.user_id  => {from_profile_searching => [relation_id_searched]} } ) # наполнение хэша найденными relation_id
                     logger.info "=== === обработан результат № #{relation_match_arr_row_no} из relation_match_arr"
                     logger.info "=== === промежуточный итог обработки: накопленное кол-во успешных поисков для итерации qty_of_results = #{qty_of_results}, found_trees_hash = #{found_trees_hash},"
                     logger.info "=== === wide_found_profiles_hash = #{wide_found_profiles_hash}, wide_found_relations_hash = #{wide_found_relations_hash}"
                     logger.info "=== === wide_found_profiles_arr = #{wide_found_profiles_arr}, wide_found_relations_arr = #{wide_found_relations_arr}"
                     relation_match_arr_row_no += 1  # подсчет кол-ва рядов в relation_match_arr, которые входят в результат по очереди

                     # КРОМЕ ТОГО, ДЛЯ ЧИСТОТЫ: НУЖНО УМЕНЬШАТЬ в found_trees_hash КОЛ-ВО РАЗ, КОГДА В ДАННОМ ДЕРЕВЕ tree_row.user_id
                     # НАЙДЕН РЕЗУЛЬТАТ, НА ВЕЛИЧИНУ РЕЗ-ТОВ, КОТОРЫЕ ОТКИНУТЫ КАК НЕВЕРНЫЕ ПРИ ОПРЕДЕЛЕНИИ ТЕКУЩЕГО ПРАВИЛЬНОГО ПРОФИЛЯ
                     # Т.Е. НУЖНО ВЫДЕЛИТЬ КОЛ-ВО РАЗ ПОЯВЛЕНИЯ ПРАВИЛЬНОГО ПРОФИЛЯ В ХЭШЕ РЕЗ-ТОВ res_hash =  {4=>4, 7=>1},
                     # ЭТО ЗДЕСЬ РАВНО 4 И ЗАНЕСТИ ЭТО ЗНАЧЕНИЕ в found_trees_hash, ЧТОБЫ ВМЕСТО {1=>5} СТАЛО
                     # found_trees_hash = {1=>4}. Т.К. ИМЕННО 4 РАЗА БЫЛ НАЙДЕН ПРАВИЛЬНЫЙ ПРОФИЛЬ В ДЕРЕВЕ 1
                     # А 1 РАЗ - БЫЛ НАЙДЕН НЕПРАВИЛЬНЫЙ
                     # ЭТО СДЕЛАНО НИЖЕ! /

                     logger.info "=== === Корректировка found_trees_hash в завис-ти от res_hash :"
                     new_val = res_hash.values_at(right_profile_key)[0]
                     # найти дерево, в котором сидит правильный профиль - для случая объединенных
                     tree_id = Profile.find(right_profile_key).tree_id
                     found_trees_hash.merge!(tree_id  => new_val)
                     # наполнение хэша найденными profile_id
                     logger.info "!!!!!  === === new found_trees_hash = #{found_trees_hash} (tree_id = #{tree_id} === === #{new_val})"




        end

        # Показ результатов
                 logger.info " "
                 logger.info "=== После ПОИСКА по записи № #{all_profile_rows_No} и записи рез-тов: ХЭШ рез-тов: res_hash = #{res_hash}, qty_of_results = #{qty_of_results} "




               else
                  logger.info "=== НЕТ результата! В деревьях сайта ничего не найдено! === "
      end

      # Здесь: анализ накопленного массива найденных row_arr

      all_profile_rows_No += 1 # Подсчет номера по порядку очередной записи об искомом профиле

    end



      #if to_check_match >= @all_profile_rows_len
      #  logger.info " "
      #  logger.info "РЕЗУЛЬТАТ найден ::: для искомого профиля #{profile_id_searched.inspect} найден @right_profile_key = #{@right_profile_key}, @tree_id = #{@tree_id} "
      #  logger.info "РЕЗУЛЬТАТ::: to_check_match = #{to_check_match.inspect}, qty_of_results = #{qty_of_results.inspect}, @all_profile_rows_len = #{@all_profile_rows_len}"
      #  logger.info " "
      #else
      #  logger.info " "
      #  logger.info "РЕЗУЛЬТАТ НЕ найден ::: для искомого профиля #{profile_id_searched.inspect} НЕ найден @right_profile_key = #{@right_profile_key}, @tree_id = #{@tree_id} "
      #  logger.info "РЕЗУЛЬТАТ::: to_check_match = #{to_check_match.inspect}, qty_of_results = #{qty_of_results.inspect}, @all_profile_rows_len = #{@all_profile_rows_len}"
      #  logger.info " "
      #end



      ##### НАСТРОЙКИ результатов поиска - ТРЕБУЕТСЯ НОВОЕ ОСОЗНАНИЕ!
    # Исключение тех user_id, по которым не все запросы дали результат внутри Ближнего круга
    # Остаются те user_id, в которых найдены совпавшие профили.
    # На выходе ХЭШ: {user_id  => кол-во успешных поисков } - должно быть равно (не меньше) длине массива
    # всех видов отношений в блжнем круге для разыскиваемого профиля.
    if relation_id_searched != 0 # Для всех профилей, кот-е не явл. current_user
      # Исключение из результатов поиска
      if all_profile_rows.length > 3

        found_trees_hash.delete_if {|key, value|  value <= 2 } #  all_profile_rows.length - 1 } #
        #found_trees_hash.delete_if {|key, value|  value < all_profile_rows.length } #
        # all_profile_rows.length = размер ближнего круга профиля в дереве current_user.id
      else
        #  # Если маленький БК
        found_trees_hash.delete_if {|key, value|  value <= 1  }  # 1 .. 3 = НАСТРОЙКА!!
      end

    else
      if all_profile_rows.length > 3 #<= 3
        found_trees_hash.delete_if {|key, value|  value <= 2 } #all_profile_rows.length  }  # 1 .. 3 = НАСТРОЙКА!!
        #  # Исключение из результатов поиска групп с малым кол-вом совпадений в других деревьях or value < all_profile_rows.length
      else
        #  # Если маленький БК
        found_trees_hash.delete_if {|key, value|  value <= 1  }  # 1 .. 2 = НАСТРОЙКА!!
      end
    end

  end
     logger.info " *** настройка рез-тов поиска в get_relation_match: found_trees_hash = #{found_trees_hash} "


  ##### КОРРЕКТИРОВКА результатов поиска на основе настройки результатов поиска - см.выше
  wide_found_profiles_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
  # На выходе ХЭШ: {user_id  => profile_id} - найденные деревья с найденным профилем в них.
  @wide_found_profiles_hash = wide_found_profiles_hash

  wide_found_relations_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
     logger.info " *** после настройки рез-тов поиска: wide_found_profiles_hash = #{wide_found_profiles_hash}, wide_found_relations_hash = #{wide_found_relations_hash}"

  ##### ИТОГОВЫЕ РАСШИРЕННЫЕ результаты поиска
  @all_wide_match_profiles_arr << wide_found_profiles_hash if !wide_found_profiles_hash.blank? # Заполнение выходного массива хэшей
  @all_wide_match_relations_arr << wide_found_relations_hash if !wide_found_relations_hash.empty? # Заполнение выходного массива хэшей
     logger.info " *** РЕЗУЛЬТАТ ПОИСКА из get_relation_match: @all_wide_match_profiles_arr = #{@all_wide_match_profiles_arr}"

  #@found_profiles_hash = found_profiles_hash # DEBUGG TO VIEW
  #@found_relations_hash = found_relations_hash # DEBUGG TO VIEW
  #@found_trees_hash = found_trees_hash # DEBUGG TO VIEW
  #@all_profile_rows = all_profile_rows   # DEBUGG TO VIEW
  #@all_relation_match_arr = all_relation_match_arr   ## DEBUGG TO VIEW
  #@wide_found_profiles_hash = wide_found_profiles_hash # DEBUGG TO VIEW
  #@wide_found_relations_hash = wide_found_relations_hash # DEBUGG TO VIEW

end

# Основной поиск по дереву Автора - Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_profiles_from_tree(connected_users_arr, tree_arr)

    @tree_arr_len = tree_arr.length  # DEBUGG TO VIEW
    @tree_to_display = []
    @tree_row = []

    ##### Будущие результаты поиска
    @all_match_trees_arr = []     # Массив совпадений деревьев
    @all_match_profiles_arr = []  # Массив совпадений профилей
    @all_match_relations_arr = []  # Массив совпадений отношений
    #####
    @all_wide_match_profiles_arr = []     # Широкий Массив совпадений профилей
    @all_wide_match_relations_arr = []     # Широкий Массив совпадений отношений

    @hard_search_result_profiles = []     #
    @hard_search_result_relations = []     #
    @all_found_profiles_arr = []  # Итоговый массив найденных профилей

    @relation_id_searched_arr = []     #_DEBUGG_TO_VIEW Ok

    logger.info "======================= Запуск цикла поиска по всему массиву заданий ========================= "
    if !tree_arr.blank?
      for i in 0 .. tree_arr.length-1
    #    32, 212, 419, 1, 213, 196, 1, false]
    #         1        3   4
        from_profile_searching = tree_arr[i][1] # От какого профиля осущ-ся Поиск
        name_id_searched = tree_arr[i][2] # relation_id К_Профиля
        relation_id_searched = tree_arr[i][3] # relation_id К_Профиля
        profile_id_searched = tree_arr[i][4] # Поиск по ID К_Профиля
        is_name_id_searched = tree_arr[i][5] # relation_id К_Профиля
        logger.info " "
        logger.info " "
        logger.info "***** ПОИСК: #{i+1}-я ИТЕРАЦИЯ in search_profiles_from_tree*** Ищем по этому элементу из дерева Юзера: tree_arr[i] = #{tree_arr[i]}"
        logger.info "***** из дерева (объед-х деревьев): #{connected_users_arr}; От профиля: #{from_profile_searching};  Ищем профиль: #{profile_id_searched};"
        logger.info "***** от имени (name_id): #{name_id_searched}; ищем отношение (relation_id) = #{relation_id_searched}, Ищем имя (is_name_id) = #{is_name_id_searched}  "
        hard_search_match(connected_users_arr, from_profile_searching, profile_id_searched, relation_id_searched)       # На выходе: @all_match_arr по данному дереву
  #      soft_search_match(connected_users_arr, from_profile_searching, profile_id_searched, relation_id_searched)       # На выходе: @all_match_arr по данному дереву
      end
    end


    logger.info "=========== После всего цикла по tree_arr - результат поиска: @all_wide_match_profiles_arr = #{@all_wide_match_profiles_arr}"

    #### расширенные РЕЗУЛЬТАТЫ ПОИСКА:
    if !@all_wide_match_profiles_arr.blank?
      #### PROFILES
      all_wide_match_hash = join_arr_of_hashes(@all_wide_match_profiles_arr) if !@all_wide_match_profiles_arr.blank?  # Если найдены совпадения - в @all_match_arr
      #@all_wide_match_hash = all_wide_match_hash  #_DEBUGG_TO_VIEW
      @all_wide_match_arr_sorted = Hash[all_wide_match_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      #@complete_hash = make_complete_hash(@all_wide_match_arr_sorted)  #_DEBUGG_TO_VIEW

      logger.info "********** Формирование итогового результата **************"
      logger.info "********** @all_wide_match_arr_sorted = #{@all_wide_match_arr_sorted} "
      # @final_reduced_profiles_hash = итоговый Хаш массивов найденных профилей
      # Здесь - исключаем из результатов - те, в кот-х найдено всего одно совпадение
      # см. метод reduce_hash
      # То же - симметрично повторяется для relations
      @final_reduced_profiles_hash = reduce_hash(make_complete_hash(@all_wide_match_arr_sorted))  # TO VIEW
      logger.info "********** @final_reduced_profiles_hash = #{@final_reduced_profiles_hash} "

      # @wide_user_ids_arr = итоговый массив найденных деревьев
      @wide_user_ids_arr = @final_reduced_profiles_hash.keys.flatten  #

      # @wide_profile_ids_arr = итоговый массив хашей найденных профилей
      @wide_profile_ids_arr = @final_reduced_profiles_hash.values.flatten #

      # @wide_amount_of_profiles = Подсчет количества найденных Профилей в массиве Хэшей
      @wide_amount_of_profiles = count_profiles_in_hash(@wide_profile_ids_arr)

      #### RELATIONS
      all_wide_match_relations_hash = join_arr_of_hashes(@all_wide_match_relations_arr) if !@all_wide_match_relations_arr.blank?  # Если найдены совпадения - в @all_match_arr
      @all_wide_match_relations_sorted = Hash[all_wide_match_relations_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      #@complete_relations_hash = make_complete_hash(@all_wide_match_relations_sorted)

      @final_reduced_relations_hash = reduce_hash(make_complete_hash(@all_wide_match_relations_sorted))  # TO VIEW
      logger.info "********** @final_reduced_relations_hash = #{@final_reduced_relations_hash} "

      #@relation_ids_arr = @all_match_relations_sorted.values.flatten # TO VIEW
      #@all_match_relations_hash = all_match_relations_hash # TO VIEW
      #count_users_found(profile_ids_arr) # TO VIEW

    else
      @final_reduced_profiles_hash = []
      @final_reduced_relations_hash = []
      @wide_user_ids_arr = []
    end

  end

  #logger.info " "
  #logger.info "Контроль: === === @right_profile_key = #{@right_profile_key}, @tree_id = #{@tree_id} "
  #found_profile_circle_rows = profile_near_circle(@tree_id, @right_profile_key)  #
  #logger.info "Ближний круг НАЙДЕННОГО ПРАВИЛЬНОГО ПРОФИЛЯ = #{@right_profile_key.inspect} в дереве #{@tree_id}"
  #show_in_logger(found_profile_circle_rows, "found_profile_circle_rows - запись" )  # DEBUGG_TO_LOGG

  # В СИТУАЦИИ КОГДА ПОЯВЛЯЕТСЯ МНОЖЕСТВО ВАРИАНТОВ ПРОФИЛЕЙ tree_row.profile_id В КАЧ-ВЕ РЕЗ-ТА ПОИСКА
  # ЗДЕСЬ - АНАЛИЗ И ВЫБОР ПРАВИЛЬНОГО ПРОФИЛЯ ДЛЯ ЗАПИСИ В ХЭШ wide_found_profiles_hash РЕЗУЛЬТАТОВ
  #
  # В НАСТОЯЩИЙ МОМЕНТ - ПРАВИЛЬНЫЙ ПРОФИЛЬ ТОТ,
  # ЧТО БЫЛ НАЙДЕН МАКСИМАЛЬНОЕ ЧИСЛО РАЗ ПО СРАВНЕНИЮ С ДРУГИМИ
  # ЕСЛИ ЭТОГО НЕ ДЕЛАТЬ, ТО В РЕЗ-ТИР-Й ХЭШ wide_found_profiles_hash ЗАПИШЕТСЯ ПОСЛЕДНИЙ ИЗ НАЙДЕННЫХ ПРОФИЛЕЙ,
  # НЕСМОТРЯ НА ТО, ЧТО ОН МОЖЕТ БЫЛ НАЙДЕН ВСЕГО 1 РАЗ. КОГДА ДРУГИЕ ПРОФИЛИ - БОЛЬШЕЕ ЧИСЛО РАЗ.
  # (ТАК РАБОТАЕТ merge)
  # .
  # СЕЙЧАС СДЕЛАНО ТАК:
  # ПРОИСХОДИТ СОРТИРОВКА НАКОПЛЕННОГО ХЭША res_hash ПО ЗНАЧЕНИЮ ВСТРЕЧАЕМОСТИ ПРОФИЛЯ
  # и извлечение последнего, т.к. м.б. несколько с макс-м значением (?) - ПРЕДПОЛОЖЕНИЕ
  #

  #right_profile_key = res_hash.sort{|a,b| a[1] <=> b[1]}.last[0]  # KEY последний в отсортированном Хэше по value
  #logger.info "=== === === === === определен ТЕКУЩИЙ правильный profile_id : right_profile_key = #{right_profile_key} для записи в окончательный рез-тат - в wide_found_profiles_hash"

  # в принципе здесь ВМЕСТО ЭТОГО ВОЗМОЖНО ПОТРЕБУЕТСЯ более ТОЧНЫЙ анализ по определению правильного ПРОФИЛЯ - рез-та поиска
  # НУЖНО БУДЕТ АНАЛИЗИРОВАТЬ НАЛИЧИЕ ДРУГИХ СВЯЗЕЙ КАЖДОГО ИЗ НАЙДЕННЫХ ПРОФИЛЕЙ
  #
  # В ПРИНЦИПЕ, ЧАСТОТА ИХ (ПРОФИЛЕЙ) ОБНАРУЖЕНИЯ, КОТ. ЗАПИСАНА В ХЭШЕ res_hash - ЭТО И ЕСТЬ ПОДТВЕРЖДЕНИЕ ТОГО, ЧТО
  # В ПОИСКЕ СРАБОТАЛИ СООТВ-Е КОЛ-ВО ИМЕЮЩИХСЯ СВЯЗЕЙ (см.res_hash).
  # ПРОБЛЕМА МОЖЕТ БЫТЬ ЕСЛИ ЧАСТОТА ОБНАРУЖЕНИЯ РАЗНЫХ ПРОФИЛЕЙ БУДЕТ ОДИНАКОВА
  # ТОГДА НАДО ВЫЯСНЯТЬ СИТУАЦИЮ МЕЖДУ ЭТИМИ РАВНОНАЙДЕННЫМИ ПРОФИЛЯМИ
  # НО ЭТО - СЛЕДУЮЩАЯ ЗАДАЧА
  #
  # КРОМЕ ТОГО, ДЛЯ ЧИСТОТЫ: НУЖНО УМЕНЬШАТЬ в found_trees_hash КОЛ-ВО РАЗ, КОГДА В ДАННОМ ДЕРЕВЕ tree_row.user_id
  # НАЙДЕН РЕЗУЛЬТАТ, НА ВЕЛИЧИНУ РЕЗ-ТОВ, КОТОРЫЕ ОТКИНУТЫ КАК НЕВЕРНЫЕ ПРИ ОПРЕДЕЛЕНИИ ТЕКУЩЕГО ПРАВИЛЬНОГО ПРОФИЛЯ
  # Т.Е. НУЖНО ВЫДЕЛИТЬ КОЛ-ВО РАЗ ПОЯВЛЕНИЯ ПРАВИЛЬНОГО ПРОФИЛЯ В ХЭШЕ РЕЗ-ТОВ res_hash =  {4=>4, 7=>1},
  # ЭТО ЗДЕСЬ РАВНО 4 И ЗАНЕСТИ ЭТО ЗНАЧЕНИЕ в found_trees_hash, ЧТОБЫ ВМЕСТО {1=>5} СТАЛО
  # found_trees_hash = {1=>4}. Т.К. ИМЕННО 4 РАЗА БЫЛ НАЙДЕН ПРАВИЛЬНЫЙ ПРОФИЛЬ В ДЕРЕВЕ 1
  # А 1 РАЗ - БЫЛ НАЙДЕН НЕПРАВИЛЬНЫЙ
  # ЭТО СДЕЛАНО НИЖЕ! /

  #logger.info "=== === Корректировка found_trees_hash в завис-ти от res_hash :"
  #new_val = res_hash.values_at(right_profile_key)[0]
  # найти дерево, в котором сидит правильный профиль - для случая объединенных
  #tree_id = Profile.find(right_profile_key).tree_id
  #@right_profile_key = right_profile_key
  #@tree_id = tree_id
  #found_trees_hash.merge!(tree_id  => new_val)
  # наполнение хэша найденными profile_id
  #logger.info "!!!!!  === === new found_trees_hash = #{found_trees_hash} (tree_id = #{tree_id} === === #{new_val})"

  #                 # ВАЖНЫЙ УЧАСТОК: ОПРЕДЕЛЕНИЕ ПРАВИЛЬНОГО ПРОФИЛЯ В КАЧЕСТВЕ СООТВЕТСТВИЯ ИСКОМОМУ
  #                 trees_res_hash.each_pair {|key,val_hash|  key == tree_row.user_id; qty_arr = val_hash.values
  #                 max_qty = qty_arr.sort.last
  #                 @right_profile = val_hash.key(max_qty)
  #                 logger.info "=== Trees Hash : @right_profile = #{@right_profile}"
  #                 } #
  #





  ## Формирование полного щирокого Хаша
  # @note GET
  # На входе:
  # На выходе: @ Итоговый  ХЭШ
  def make_complete_hash(input_hash)
    complete_hash = Hash.new     #
    if !input_hash.blank?
      input_hash.each do |k, v|
        if v.size == 1
          complete_hash.merge!({k => v}) # наполнение хэша найденными profile_id
        else
          rez_hash = Hash.new     #
          v.each do |one_arr|
            if !one_arr.blank?
              merged_hash = rez_hash.merge({one_arr[0] => one_arr[1]}){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
              rez_hash = merged_hash
            end
          end
          complete_hash.merge!(k => rez_hash) # искомый хэш
          # с найденнымии profile_id, распределенными по связанным с ними profile_id
        end
      end
    end
    return complete_hash
  end


  # НАСТРОЙКА СОКРАЩЕНИЯ РЕ-В ПОИСКА: УДАЛЕНИЕ КОРОТКИХ СОВПАДЕНИЙ
  # ЦИФРА В УСЛОВИИ if - ЭТО РАЗМЕР СОВПАДЕНИЙ В ДЕРЕВЕ ПРИ ПОИСКЕ.
  # # Исключение тех рез-тов поиска, где найден всего один профиль
  # @note GET
  # На входе:
  # На выходе: @ Итоговый  ХЭШ
  def reduce_hash(input_hash)
    reduced_hash = Hash.new
    input_hash.each do |k, v|
      if v.values.flatten.size > 0#1  # НАСТРОЙКА УДАЛЕНИЯ МАЛЫХ СОВПАДЕНИЙ
        # сохраняем в рез-тах те, в кот. найдено больше 1 профиля
        reduced_hash.merge!({k => v}) #
      end
    end
    return reduced_hash
  end

  # Слияние массива Хэшей без потери значений { (key = user_id) => (value = profile_id) }
  # Получение упорядоченного Хэша: {user_id  -> [ profile_id, profile_id, profile_id ...]}
  # @note GET
  # На входе: массив хэшей: [{user_id -> profile_id, ... , user_id -> profile_id}, ..., {user_id -> profile_id, ... , user_id -> profile_id} ]
  # На выходе: @all_match_hash Итоговый упорядоченный ХЭШ
  # @param admin_page [Integer]
  def join_arr_of_hashes(all_match_hash_arr)
    final_merged_hash = Hash.new
    for h_ind in 0 .. all_match_hash_arr.length - 1
      next_hash = all_match_hash_arr[h_ind]
      merged_hash = final_merged_hash.merge(next_hash){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
      final_merged_hash = merged_hash
    end
    #@all_match_hash = final_merged_hash  # DEBUGG TO VIEW
    return final_merged_hash
  end

  # Преобразование Хэша хэшей в Хэш массивов вместо хэшей
  # На входе: Из: { user_id => { profile_id => [profile_id, profile_id ,..]}, user_id => { profile_id => [profile_id, profile_id ,..]}
  # На выходе в Хэш, где значения - массивы:
  # { user_id => [ profile_id, [profile_id, profile_id ,..]], user_id => [profile_id, [profile_id, profile_id ,..]]
  # @note GET
  # final_hash_arr = Итоговый ХЭШ
  def hash_hash_to_hash_arr(input_hash_hash)
    final_hash_arr = Hash.new
    ind = 0
    input_hash_hash.values.each do |one_hash|
      new_hash_merging = final_hash_arr.merge({input_hash_hash.keys[ind] => one_hash.to_a.flatten(1)} )
      final_hash_arr = new_hash_merging
      ind += 1
    end
    return final_hash_arr
  end


  # Подсчет количества найденных Профилей в массиве Хэшей
  # На входе: массив Хэшей профилей input_arr_hash
  # На выходе: amount_found Кол-во
  def count_profiles_in_hash(input_arr_hash)
    amount_found = 0
    input_arr_hash.each do |k|
      amount_found = amount_found + k.values.flatten.size
    end
    return amount_found
  end

  # Подсчет количества найденных Юзеров среди найденных Профилей
  # @note GET
  # На входе: массив профилей all_profiles_arr: profile_id
  # На выходе: @count Кол-во Юзеров
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def count_users_found(all_profiles_arr)
    @count = 0
    @users_ids_arr = []
    for ind in 0 .. all_profiles_arr.length - 1
      user_found_id = User.find_by_profile_id(all_profiles_arr[ind])
      if !user_found_id.blank?
        @count += 1
        @users_ids_arr << user_found_id.id  # user_id среди найденных профилей
      end
    end
  end





end
