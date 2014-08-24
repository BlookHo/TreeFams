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

#    author_tree_arr = # DEBUGG_TO_VIEW
    #    [
    #    [159, 1365, 373, 0, 1365, 373, 1, false],
    #    #[159, 1365, 373, 1, 1366, 377, 1, false],
    #    #[159, 1365, 373, 2, 1367, 36, 0, false],
    #    #[159, 1365, 373, 5, 1368, 141, 1, false],
    #    #[159, 1365, 373, 5, 1369, 194, 1, false],
    #    #[159, 1365, 373, 8, 1370, 441, 0, false],
    #    [159, 1365, 373, 3, 1371, 141, 1, false],
    #    [159, 1365, 373, 3, 1372, 194, 1, false]
    #    ]

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

    search_profiles_tree_match(connected_author_arr, author_tree_arr) # Основной поиск по дереву Автора среди деревьев в ProfileKeys.

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
      logger.debug "#{string_to_add} - запись № #{row_no.inspect}: #{row.attributes.inspect} " # DEBUGG_TO_LOGG
      #logger.debug "=== === ::: запись № #{row_no.inspect} = relation_match_arr.each: #{row.attributes.inspect} " # DEBUGG_TO_LOGG
    end  # DEBUGG_TO_LOGG
  end

  # Поиск совпадений для одного из профилей БК current_user
  # Берем параметр: profile_id из массива  = profiles_tree_arr[i][6].
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # На выходе: @all_match_arr по данному виду родства
 def get_relation_match(connected_users, from_profile_searching, profile_id_searched, relation_id_searched)

   found_trees_hash = Hash.new     #{ 0 => []}
   all_relation_match_arr = []     #

   wide_found_profiles_hash = Hash.new  #
   wide_found_relations_hash = Hash.new  #
   logger.info " == IN get_relation_match == "

   all_profile_rows = ProfileKey.where(:user_id => connected_users).where(:profile_id => profile_id_searched).select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id, :is_profile_id, :id)
   # поиск массива записей ближнего круга для каждого профиля в дереве Юзера
   logger.info "Все записи об искомом профиле = #{profile_id_searched.inspect} в (объединенном) дереве зарег-го Юзера"
   show_in_logger(all_profile_rows, "all_profile_rows" )  # DEBUGG_TO_LOGG
   qty_of_results = 0 # Начало подсчета результатов поиска (сумма успешных поисков в противоположном дереве)

  #@search_exclude_users = [85,86,87,88,89,90,91,92] # временный массив исключения косых юзеров из поиска DEBUGG_TO_VIEW
   @search_exclude_users = [] # временный массив исключения косых юзеров из поиска DEBUGG_TO_LOGG
# убрать потом !!!
   all_profile_rows_No = 1
   if !all_profile_rows.blank?
     @all_profile_rows_len = all_profile_rows.length if !all_profile_rows.blank? #DEBUGG_TO_LOGG
     # размер ближнего круга профиля в дереве current_user.id
     logger.info "= кол-во всех записей об искомом профиле @all_profile_rows_len = #{@all_profile_rows_len}"
     logger.info "= Начало циклов ПОИСКА по всем записям об искомом профиле в других (остальных) деревьях сайта:::"
     row_arr = []   # DEBUGG_TO_LOGG
     res_hash = Hash.new

     all_profile_rows.each do |relation_row|
       logger.info "=== Собственно, ПОИСК по записи № #{all_profile_rows_No} об искомом профиле = #{profile_id_searched.inspect} :::"
       logger.info "==== ::: запись in each.all_profile_rows: #{relation_row.attributes.inspect}"

       relation_match_arr = ProfileKey.where.not(user_id: @search_exclude_users).where.not(user_id: connected_users).where(:name_id => relation_row.name_id, :relation_id => relation_row.relation_id, :is_name_id => relation_row.is_name_id).select(:id, :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
       if !relation_match_arr.blank?
         logger.info "=== === ::: Есть результат! ::: Найдено #{relation_match_arr.size} записей в деревьях сайта (см. ниже) ::: === === "
         show_in_logger(relation_match_arr, "=== === ::: show relation_match_arr.each:" )  # DEBUGG_TO_LOGG

         logger.info "=== === === ::: Цикл по найденным записям в деревьях сайта::: === === "
         relation_match_arr_row_no = 1  # DEBUGG_TO_LOGG
         relation_match_arr.each do |tree_row|
           logger.debug "=== === === === ::: Запись рез-тов поиска по записи № #{relation_match_arr_row_no} для relation_match_arr: #{tree_row.attributes.inspect} " # DEBUGG_TO_LOGG
           row_arr << tree_row.profile_id
           qty_of_results += 1
           relation_match_arr_row_no += 1  # подсчет кол-ва рядов в relation_match_arr, которые входят в результат по очереди

           fill_hash(res_hash, tree_row.profile_id) # наполнение хэша найденными profile_id и частотой их обнаружения
            # Формирование ХЭШа с результатами: Сколько раз какой профиль был найден.

           logger.info "=== === === === ::: нашли триплекс: name_id = #{tree_row.name_id}, relation_id = #{tree_row.relation_id}, is_name_id = #{tree_row.is_name_id}   (is_profile_id = #{tree_row.is_profile_id}) "
           logger.info "=== === === === ::: Для искомого профиля #{profile_id_searched.inspect} - найден профиль: #{tree_row.profile_id}, накопленный массив найденных профилей: #{row_arr}, кол-во результатов qty_of_results = #{qty_of_results}  "
           logger.info "=== === === === ::: накопленный массив найденных профилей: #{row_arr}, кол-во результатов qty_of_results = #{qty_of_results}  "
           fill_hash(found_trees_hash, tree_row.user_id) # наполнение хэша найденными user_id = trees и частотой их обнаружения
           logger.info "=== === === === ::: found_trees_hash = #{found_trees_hash} "

           logger.info "=== === === ::: Определение ТЕКУЩЕГО правильного profile_id из найденных для записи в окончательный рез-тат - в found_trees_hash"
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
           logger.info "=== === === === ::: правильный profile_id : right_profile_key = #{right_profile_key}"
           # в принципе здесь ВМЕСТО ЭТОГО ВОЗМОЖНО ПОТРЕБУЕТСЯ более ТОЧНЫЙ анализ по определению правильного ПРОФИЛЯ - рез-та поиска
           # НУЖНО БУДЕТ АНАЛИЗИРОВАТЬ НАЛИЧИЕ ДРУГИХ СВЯЗЕЙ КАЖДОГО ИЗ НАЙДЕННЫХ ПРОФИЛЕЙ
           #
           # В ПРИНЦИПЕ, ЧАСТОТА ИХ (ПРОФИЛЕЙ) ОБНАРУЖЕНИЯ, КОТ. ЗАПИСАНА В ХЭШЕ res_hash - ЭТО И ЕСТЬ ПОДТВЕРЖДЕНИЕ ТОГО, ЧТО
           # В ПОИСКЕ СРАБОТАЛИ СООТВ-Е КОЛ-ВО ИМЕЮЩИХСЯ СВЯЗЕЙ (см.res_hash).
           # ПРОБЛЕМА МОЖЕТ БЫТЬ ЕСЛИ ЧАСТОТА ОБНАРУЖЕНИЯ РАЗНЫХ ПРОФИЛЕЙ БУДЕТ ОДИНАКОВА
           # ТОГДА НАДО ВЫЯСНЯТЬ СИТУАЦИЮ МЕЖДУ ЭТИМИ РАВНОНАЙДЕННЫМИ ПРОФИЛЯМИ
           # НО ЭТО - СЛЕДУЮЩАЯ ЗАДАЧА.


           #wide_found_profiles_hash.merge!({tree_row.user_id  => {from_profile_searching => [tree_row.profile_id]} } ) # наполнение хэша найденными profile_id   # предыдущий вариант
           wide_found_profiles_hash.merge!({tree_row.user_id  => {from_profile_searching => [right_profile_key]} } ) # наполнение хэша найденными profile_id
           wide_found_relations_hash.merge!({tree_row.user_id  => {from_profile_searching => [relation_id_searched]} } ) # наполнение хэша найденными relation_id
           logger.info "=== === === === ::: В цикле : qty_of_results = #{qty_of_results}, found_trees_hash = #{found_trees_hash}, wide_found_profiles_hash = #{wide_found_profiles_hash}, wide_found_relations_hash = #{wide_found_relations_hash}"

         end
         # Показ результатов
         logger.info "=== === === ::: После ПОИСКА по записи № #{all_profile_rows_No} и записи рез-тов поиска: "
         logger.info "=== === === ::: итоговый ХЭШ рез-тов: res_hash = #{res_hash}, qty_of_results = #{qty_of_results} "
        else
          logger.info "==== ::: НЕТ результата! В деревьях сайта ничего не найдено ::: === === "
        end

        # Здесь: анализ накопленного массива найденных row_arr

       all_profile_rows_No += 1 # Подсчет номера по порядку очередной записи об искомом профиле

     end

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
   logger.info " ******* Настройка рез-тов поиска в get_relation_match: found_trees_hash = #{found_trees_hash} "


   ##### КОРРЕКТИРОВКА результатов поиска на основе настройки результатов поиска - см.выше
   wide_found_profiles_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
   # На выходе ХЭШ: {user_id  => profile_id} - найденные деревья с найденным профилем в них.
   @wide_found_profiles_hash = wide_found_profiles_hash

   wide_found_relations_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
   logger.info " ******* После настройки рез-тов поиска: wide_found_profiles_hash = #{wide_found_profiles_hash}, wide_found_relations_hash = #{wide_found_relations_hash}"

   ##### ИТОГОВЫЕ РАСШИРЕННЫЕ результаты поиска
   @all_wide_match_profiles_arr << wide_found_profiles_hash if !wide_found_profiles_hash.blank? # Заполнение выходного массива хэшей
   @all_wide_match_relations_arr << wide_found_relations_hash if !wide_found_relations_hash.empty? # Заполнение выходного массива хэшей
   logger.info " ******* РЕЗУЛЬТАТ ПОИСКА В get_relation_match: @all_wide_match_profiles_arr = #{@all_wide_match_profiles_arr}"

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
  def search_profiles_tree_match(connected_users_arr, tree_arr)

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

    @relation_id_searched_arr = []     #_DEBUGG_TO_VIEW Ok

    logger.info "======================= Запуск цикла поиска по всему массиву заданий ========================= "
    if !tree_arr.blank?
      for i in 0 .. tree_arr.length-1
    #    32, 212, 419, 1, 213, 196, 1, false]
    #         1        3   4
        from_profile_searching = tree_arr[i][1] # От какого профиля осущ-ся Поиск
        relation_id_searched = tree_arr[i][3] # relation_id К_Профиля
        profile_id_searched = tree_arr[i][4] # Поиск по ID К_Профиля
        logger.info "*** #{i+1}-я итерация ПОИСКА *** Ищем по этому элементу из дерева Юзера: tree_arr[i] = #{tree_arr[i]}"
        logger.info "Параметры поиска: Из какого дерева (объед-х деревьев): #{connected_users_arr}, От какого профиля: #{from_profile_searching},  Ищем этот профиль: #{profile_id_searched}, Ищем это отношение (relation_id) = #{relation_id_searched} "
        get_relation_match(connected_users_arr, from_profile_searching, profile_id_searched, relation_id_searched)       # На выходе: @all_match_arr по данному дереву
      end
    end


    logger.info "======================= After get_relation_match ========================= "

    #### расширенные РЕЗУЛЬТАТЫ ПОИСКА:
    if !@all_wide_match_profiles_arr.blank?
      #### PROFILES
      all_wide_match_hash = join_arr_of_hashes(@all_wide_match_profiles_arr) if !@all_wide_match_profiles_arr.blank?  # Если найдены совпадения - в @all_match_arr
      #@all_wide_match_hash = all_wide_match_hash  #_DEBUGG_TO_VIEW
      @all_wide_match_arr_sorted = Hash[all_wide_match_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      #@complete_hash = make_complete_hash(@all_wide_match_arr_sorted)  #_DEBUGG_TO_VIEW

      logger.info " In search_profiles_tree_match: @all_wide_match_arr_sorted = #{@all_wide_match_arr_sorted} "
      # @final_reduced_profiles_hash = итоговый Хаш массивов найденных профилей
      # Здесь - исключаем из результатов - те, в кот-х найдено всего одно совпадение
      # см. метод reduce_hash
      # То же - симметрично повторяется для relations
      @final_reduced_profiles_hash = reduce_hash(make_complete_hash(@all_wide_match_arr_sorted))  # TO VIEW
      logger.info " In search_profiles_tree_match: @final_reduced_profiles_hash = #{@final_reduced_profiles_hash} "

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
      logger.info " In search_profiles_tree_match: @final_reduced_relations_hash = #{@final_reduced_relations_hash} "

      #@relation_ids_arr = @all_match_relations_sorted.values.flatten # TO VIEW
      #@all_match_relations_hash = all_match_relations_hash # TO VIEW
      #count_users_found(profile_ids_arr) # TO VIEW

    else
      @final_reduced_profiles_hash = []
      @final_reduced_relations_hash = []
      @wide_user_ids_arr = []
    end

  end

  #[[155, 1325, 103, 0, 1325, 103, 0, false],
  # [155, 1325, 103, 1, 1326, 40, 1, false],
  # [155, 1325, 103, 2, 1327, 449, 0, false],
  # [155, 1325, 103, 5, 1328, 26, 1, false],
  # [155, 1325, 103, 7, 1329, 151, 1, false],
  # [155, 1325, 103, 4, 1330, 172, 0, false],
  # [155, 1325, 103, 4, 1331, 147, 0, false]]
  #
  #
  #;143;1220;8;;;151;1225;103;0
  #;143;1236;2;;;40;1268;421;0
  #;143;1221;1;;;73;1258;318;1
  #;143;1221;2;;;73;1257;174;0
  #;143;1225;1;;;103;1236;40;1
  #;143;1225;2;;;103;1237;449;0
  #;143;1225;5;;;103;1238;26;1
  #;143;1238;8;;;26;1239;258;0
  #;143;1228;5;;;318;1240;122;1
  #;143;1228;5;;;318;1241;37;1
  #;143;1220;1;;;151;1221;73;1
  #;143;1220;2;;;151;1222;516;0
  #;143;1220;6;;;151;1223;331;0
  #;143;1220;6;;;151;1224;214;0
  #;143;1220;0;;;151;1220;151;1
  #;143;1220;4;;;151;1226;172;0
  #;143;1220;4;;;151;1227;147;0
  #;143;1224;7;;;214;1228;318;1
  #;143;1236;5;;;40;1269;196;1
  #


  #143  -- > In search_profiles_tree_match: @final_reduced_profiles_hash =
  #    {155=>{1220=>[1329, 1325, 1330, 1331],
 #              {1220=>[0, 8, 4, 4],

  #           1225=>[1326, 1327, 1328, 1329, 1330, 1331],
  #           1225=>[1, 2, 5, 7, 4, 4],

  #           1224=>[1329],
  #           1224=>[5],
  #           1223=>[1329],
  #           1223=>[5],

  #           1236=>[1326, 1327, 1328, 1325],
  #           1236=>[0, 8, 3, 4],

  #           1222=>[1329],
  #           1222=>[3],

  #           1268=>[1326],
  #           1268=>[3],

  #           1237=>[1326, 1327, 1328, 1325],
  #           1237=>[7, 0, 3, 4],

  #           1317=>[1327],
  #           1317=>[6],

  #           1318=>[1327]},
  #           1318=>[6]},
  #
  #     161=>{1220=>[1329, 1325],
  #           1224=>[1329],
  #           1223=>[1329],
  #           1236=>[1325],
  #           1225=>[1329],
  #           1222=>[1329], 1237=>[1325]}}
  #In search_profiles_tree_match: @final_reduced_relations_hash =
  #    {155=>{1220=>[0, 8, 4, 4],
  #           1225=>[1, 2, 5, 7, 4, 4],
  #           1224=>[5],
  #           1223=>[5],
  #           1236=>[0, 8, 3, 4],
  #           1222=>[3],
  #           1268=>[3],
  #           1237=>[7, 0, 3, 4],
  #           1317=>[6],
  #           1318=>[6]},
  #
  #     161=>{1220=>[0, 8],
  #           1224=>[5],
  #           1223=>[5],
  #           1236=>[4],
  #           1225=>[7],
  #           1222=>[3],
  #           1237=>[4]}}
  #
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
      if v.values.flatten.size > 1  # НАСТРОЙКА УДАЛЕНИЯ МАЛЫХ СОВПАДЕНИЙ
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
