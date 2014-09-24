class MainController < ApplicationController
 # include MainHelper  #

  before_filter :check_user

  include SearchHelper



  def check_user
    redirect_to :root if !current_user
  end


 ############# МЕТОДЫ ФОРМИРОВАНИЯ ХЭША ПУТЕЙ ДЛЯ РЕЗ-ТОВ ПОИСКА

 # Делаем пути по результатам поиска - для отображения
 # @note GET /
  def make_search_results_paths(final_reduced_profiles_hash) #,final_reduced_relations_hash)


    @search_path_hash = Hash.new
    @new_search_path_hash = Hash.new  # NEW_PATH_W_START_PROFILE
    final_reduced_profiles_hash.each do |k_tree,v_tree|
      paths_arr = []
      new_paths_arr = []
      one_path_hash = Hash.new

      one_wide_hash = Hash.new  # NEW_PATH_W_START_PROFILE
      val_arr = []  # NEW_PATH_W_START_PROFILE

      #start_profile = User.find(k_tree).profile_id
      one_tree_hash = get_tree_hash(k_tree)
      @one_tree_hash = one_tree_hash # DEBUGG_TO_VIEW
      v_tree.each do |each_k,v_tree_hash|
        results_qty = v_tree_hash.size
        @v_tree_hash = v_tree_hash # DEBUGG_TO_VIEW
        v_tree_hash.each do |finish_profile|
          one_path_hash = make_path(one_tree_hash, finish_profile, results_qty)
          @one_path_hash = one_path_hash # DEBUGG_TO_VIEW
          paths_arr << one_path_hash

          val_arr = one_wide_hash.values_at(each_k).flatten.compact  # NEW_PATH_W_START_PROFILE
          #logger.info "DEBUG IN make_search_results_paths: before << #{@val_arr.inspect}"
          val_arr << one_path_hash   # NEW_PATH_W_START_PROFILE
          #logger.info "DEBUG IN make_search_results_paths: after << #{@val_arr.inspect}"
          one_wide_hash.merge!({each_k => val_arr})  # NEW_PATH_W_START_PROFILE
          @one_wide_hash = one_wide_hash # DEBUGG_TO_VIEW
          #new_paths_arr << one_wide_hash

        end
        #new_paths_arr << one_wide_hash
      end


      # Основной результат = @search_path_hash
      @search_path_hash.merge!({k_tree => paths_arr}) # наполнение хэша хэшами
      # Основной результат = @new_search_path_hash
      @new_search_path_hash.merge!({k_tree => one_wide_hash}) # # NEW_PATH_W_START_PROFILE  наполнение хэша хэшами  # NEW_PATH_W_START_PROFILE
    end
  end

  # Добавляем один хэш в один path рез-тов поиска
  #
  def add_one_hash_to_one_path(tree_hash, finish_profile, results_qty, end_profile)
    qty = 0
    start_elem_arr = tree_hash.values_at(end_profile)[0] #
    relation_to_next_profile = start_elem_arr[0]
    elem_next_profile = start_elem_arr[1]
    qty = results_qty if end_profile == finish_profile
    @one_path_hash.merge!(make_one_hash_in_path(end_profile, relation_to_next_profile, qty))
    return @one_path_hash, relation_to_next_profile, elem_next_profile
  end

  # Делаем один path рез-тов поиска - далее он включается в итоговый хэш
  #
  def make_path(tree_hash, finish_profile, results_qty)
    @one_path_hash = Hash.new
    end_profile = finish_profile
    @one_path_hash, relation_to_next_profile, elem_next_profile = add_one_hash_to_one_path(tree_hash, finish_profile, results_qty, end_profile)
    while relation_to_next_profile != 0 do
      @one_path_hash, new_elem_relation, new_next_profile = add_one_hash_to_one_path(tree_hash, finish_profile, results_qty, elem_next_profile)
      elem_next_profile = new_next_profile
      relation_to_next_profile = new_elem_relation
    end
    return Hash[@one_path_hash.to_a.reverse] #.reverse_order - чтобы шли от автора
  end

  # Получаем дерево в виде хэша для данного tree_user_id
  #
  def get_tree_hash(tree_user_id)
    return {} if tree_user_id.blank?
    tree_hash = Hash.new
    user_tree = Tree.where(:user_id => tree_user_id)  #
    if !user_tree.blank?
      user_tree.each do |tree_row|
        tree_hash.merge!({tree_row.is_profile_id => [tree_row.relation_id, tree_row.profile_id]})
      end
      return tree_hash
    end
  end

  # Делаем один хэш в один path рез-тов поиска
  #
  def make_one_hash_in_path(one_profile, one_relation, results_qty)
    one_hash_in_path = Hash.new
    one_hash_in_path.merge!({one_profile => {one_relation => results_qty}})
    return one_hash_in_path
  end

  #### КОНЕЦ МЕТОДОВ ФОРМИРОВАНИЯ ХЭША ПУТЕЙ ДЛЯ РЕЗ-ТОВ ПОИСКА





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
      ###############


      {72=>{9=>58, 10=>68}, #CK = 5
       78=>{9=>57, 10=>71}}

      {72=>{9=>58, 10=>68}, #CK = 4
       75=>{9=>59, 10=>65},
       76=>{9=>61, 10=>69},
       77=>{9=>60, 10=>70},
       78=>{9=>57, 10=>71}}

      {72=>{9=>58, 10=>68},  #CK = 2
       73=>{9=>80, 10=>84},
       74=>{9=>81, 10=>85},
       75=>{9=>59, 10=>65},
       76=>{9=>61, 10=>69},
       77=>{9=>60, 10=>70},
       78=>{9=>57, 10=>71}}

      {72=>{9=>58, 10=>68}, # o #CK = 1
       73=>{9=>80, 10=>84}, # o
       74=>{9=>81, 10=>85}, # o
       75=>{9=>59, 10=>65}, # o
       76=>{9=>61, 10=>69}, # o
       77=>{9=>60, 10=>70}, # o
       78=>{9=>57, 10=>71}, # o
       79=>{9=>62, 10=>86}} # o

      # DEBUGG_TO_VIEW




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


  # NEW METHOD "HARD COMPLETE SEARCH"- TO DO
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

      init_connection_hash = make_init_connection_hash(with_whom_connect_users_arr,uniq_profiles_hash)
      logger.info " init_connection_hash = #{init_connection_hash}"

      final_connection_hash = init_connection_hash
      final_profiles_to_rewrite = init_connection_hash.keys
      final_profiles_to_destroy = init_connection_hash.values
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
      # ck = 2
      uniq_profiles_pairs_hash =
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

      # ck = 4
      {57=>{10=>71, 11=>78},
       58=>{10=>68, 11=>72},
       59=>{10=>65, 11=>75},
       60=>{10=>70, 11=>77},
       61=>{10=>69, 11=>76}}
      [57, 58, 59, 60, 61, 62, 80, 81]
      [78, 72, 75, 77, 76, 79, 73, 74]
      #ALL profiles_to_rewrite = [57, 58, 59, 60, 61, 62, 80, 81]
      #ALL profiles_to_destroy = [78, 72, 75, 77, 76, 79, 73, 74]

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
      #ALL profiles_to_rewrite = []
      #ALL profiles_to_destroy = []



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


      profiles_to_rewrite, profiles_to_destroy = hard_complete_search(with_whom_connect_users_arr, uniq_profiles_pairs_hash )

      logger.info "ALL profiles_to_rewrite = #{profiles_to_rewrite} "
      logger.info "ALL profiles_to_destroy = #{profiles_to_destroy} "
      logger.info " "
      logger.info " "
      logger.info " "




# Исх.представление для метода select_certainty
# from 11 to 9,10
#      [{72=>{9=>{58=>[1, 2, 3, 3, 3, 8], 57=>[2, 3, 3]},
#             10=>{68=>[1, 2, 3, 3, 3, 8], 71=>[2, 3]}}},# ]
#
#       {73=>{9=>{80=>[3, 8]}, # exclude!
#             10=>{84=>[3, 8], 70=>[8]}}},  # exclude!
#       {74=>{9=>{59=>[3], 81=>[3, 7]},  # exclude!
#             10=>{65=>[3], 85=>[3, 7], 83=>[7]}}},  # exclude!
#       {75=>{9=>{59=>[3, 3, 3, 7], 81=>[3]},
#             10=>{65=>[3, 3, 3, 7], 85=>[3]}}},
#          #   10=>{65=>[3, 3, 3, 7], 85=>[3,3,3,3]}}}, # test for duplicated
#       {76=>{9=>{61=>[1, 2, 5, 5]},
#             10=>{69=>[1, 2, 5, 5]}}},
#       {77=>{9=>{60=>[1, 2, 5, 5], 64=>[1, 5]},
#             10=>{70=>[1, 2, 5, 5], 87=>[1]}}},
#       {78=>{9=>{57=>[1, 2, 5, 5, 8], 63=>[1, 5], 58=>[2]},
#             10=>{71=>[1, 2, 5, 5, 8], 68=>[2]}}},
#       {79=>{9=>{62=>[7]},  # exclude!
#             10=>{86=>[7]}}}]  # exclude!
# from 11 to 9,10
#          {72=>{9=>58, 10=>68},
#           75=>{9=>59, 10=>65},
#           76=>{9=>61, 10=>69},
#           77=>{9=>60, 10=>70},
#           78=>{9=>57, 10=>71}}


# from 10 to 11,9
#      [{65=>{9=>{59=>[1, 3, 3, 3, 7], 81=>[3]},
#             11=>{75=>[3, 3, 3, 7], 74=>[3]}}},
#       {66=>{9=>{82=>[4]}}},
#       {68=>{11=>{72=>[1, 2, 3, 3, 3, 8], 78=>[2]},
#             9=>{58=>[1, 2, 3, 3, 3, 8], 57=>[2, 3, 3]}}},
#       {69=>{9=>{61=>[1, 2, 5, 5]},
#             11=>{76=>[1, 2, 5, 5]}}},
#       {70=>{9=>{60=>[1, 2, 5, 5], 64=>[1, 5], 80=>[8]},
#             11=>{77=>[1, 2, 5, 5], 73=>[8]}}},
#       {71=>{9=>{57=>[1, 2, 3, 5, 5, 8], 63=>[1, 5], 58=>[2, 3]},
#             11=>{78=>[1, 2, 5, 5, 8], 72=>[2, 3]}}},
#       {83=>{11=>{74=>[7]}, 9=>{81=>[7]}}},
#       {84=>{11=>{73=>[3, 8]},
#             9=>{80=>[3, 8]}}},
#       {85=>{9=>{59=>[3], 81=>[3, 7]},
#             11=>{74=>[3, 7], 75=>[3]}}},
#       {86=>{9=>{62=>[3, 7]},
#             11=>{79=>[7]}}},
#       {87=>{9=>{60=>[1], 64=>[1, 2]},
#             11=>{77=>[1]}}}]

      # from 10 to 11,9
      #{65=>{9=>59, 11=>75},
      # 68=>{11=>72, 9=>58},
      # 69=>{9=>61, 11=>76},
      # 70=>{9=>60, 11=>77},
      # 71=>{9=>57, 11=>78}}

# from 9 to 11,10
      [{57=>{10=>{71=>[1, 2, 3, 5, 5, 8], 68=>[2, 3, 3]},
             11=>{78=>[1, 2, 5, 5, 8], 72=>[2, 3, 3]}}},
       {58=>{11=>{72=>[1, 2, 3, 3, 3, 8], 78=>[2]},
             10=>{68=>[1, 2, 3, 3, 3, 8], 71=>[2, 3]}}},
       {59=>{10=>{65=>[1, 3, 3, 3, 7], 85=>[3]},
             11=>{74=>[3], 75=>[3, 3, 3, 7]}}},
       {60=>{10=>{70=>[1, 2, 5, 5], 87=>[1]},
             11=>{77=>[1, 2, 5, 5]}}},
       {61=>{10=>{69=>[1, 2, 5, 5]}, 11=>{76=>[1, 2, 5, 5]}}},
       {62=>{10=>{86=>[3, 7]}, 11=>{79=>[7]}}},
       {63=>{10=>{71=>[1, 5]}, 11=>{78=>[1, 5]}}},
       {64=>{10=>{70=>[1, 5], 87=>[1, 2]}, 11=>{77=>[1, 5]}}},
       {80=>{11=>{73=>[3, 8]}, 10=>{84=>[3, 8], 70=>[8]}}},
       {81=>{10=>{65=>[3], 85=>[3, 7], 83=>[7]}, 11=>{74=>[3, 7], 75=>[3]}}},
       {82=>{10=>{66=>[4]}}}]

      {57=>{10=>71, 11=>78},
       58=>{11=>72, 10=>68},
       59=>{10=>65, 11=>75},
       60=>{10=>70, 11=>77},
       61=>{10=>69, 11=>76}}



      # 1 to 2
      [{1=>{2=>{11=>[3, 3, 8]}}},
       {4=>{2=>{7=>[3, 3, 7]}}},
       {5=>{2=>{12=>[1, 2, 5]}}},
       {6=>{2=>{13=>[1, 2, 5]}}}]

      {1=>{2=>11},
       4=>{2=>7},
       5=>{2=>12},
       6=>{2=>13}}


      # 2 to 1
      [{7=>{1=>{4=>[3, 3, 7]}}},
       {11=>{1=>{1=>[3, 3, 8]}}},
       {12=>{1=>{5=>[1, 2, 5]}}},
       {13=>{1=>{6=>[1, 2, 5]}}}]

      {7=>{1=>4},
       11=>{1=>1},
       12=>{1=>5},
       13=>{1=>6}}


      # 5 to 6 - для certain_koeff = 2
      [{34=>{6=>{45=>[3, 8]}}},
       {38=>{6=>{41=>[3, 7]}}},
       {40=>{6=>{46=>[1, 2]}}}]

      {34=>{6=>45},
       38=>{6=>41},
       40=>{6=>46}}




      ################################
      ######## Основной поиск от дерева Автора (вместе с соединенными)
      ######## среди других деревьев в ProfileKeys.
      beg_search_time = Time.now   # Начало отсечки времени поиска

      ##############################################################################
      ##### ВЫБОР ВИДА ПОИСКА:
      # start_search(@certain_koeff) - Запуск НОВОГО поиска С @certainty_koeff - последняя версия
      # start_hard_search (жесткий - по совпадению БК),
      # или start_search_first (1-й версии - самый первый),
      # или start_search (мягкий - 2-я версия, с определением right_profile по макс. кол-ву совпадений),
      ##############################################################################

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
      @new_profiles_relations_arr = search_results[:new_profiles_relations_arr]
      @new_profiles_found_arr = search_results[:new_profiles_found_arr]
      @uniq_profiles_pairs_hash = search_results[:uniq_profiles_pairs_hash]
      @profiles_with_match_hash = search_results[:profiles_with_match_hash]

      @duplicates_pairs_One_to_Many_hash = search_results[:duplicates_pairs_One_to_Many_hash]
      @duplicates_pairs_Many_to_One_hash = search_results[:duplicates_pairs_Many_to_One_hash]

      ######################################################

      # @new_profiles_found_arr = searched unconcerned results for searched tree (11) - for analyzis
      [{72=>{9=>{58=>[1, 2, 3, 3, 3, 8], 57=>[2, 3, 3]}, 10=>{68=>[1, 2, 3, 3, 3, 8], 71=>[2, 3]}}},
       {73=>{9=>{80=>[3, 8]}, 10=>{84=>[3, 8], 70=>[8]}}},
       {74=>{9=>{59=>[3], 81=>[3, 7]}, 10=>{65=>[3], 85=>[3, 7], 83=>[7]}}},
       {75=>{9=>{59=>[3, 3, 3, 7], 81=>[3]}, 10=>{65=>[3, 3, 3, 7], 85=>[3]}}},
       {76=>{9=>{61=>[1, 2, 5, 5]}, 10=>{69=>[1, 2, 5, 5]}}},
       {77=>{9=>{60=>[1, 2, 5, 5], 64=>[1, 5]}, 10=>{70=>[1, 2, 5, 5], 87=>[1]}}},
       {78=>{9=>{57=>[1, 2, 5, 5, 8], 63=>[1, 5], 58=>[2]}, 10=>{71=>[1, 2, 5, 5, 8], 68=>[2]}}},
       {79=>{9=>{62=>[7]}, 10=>{86=>[7]}}}]


      # searched tree structure (11) - for what?
      [{72=>{73=>1, 74=>2, 76=>3, 77=>3, 78=>3, 75=>8}},
       {73=>{72=>3, 74=>8}},
       {74=>{72=>3, 73=>7}},
       {75=>{76=>3, 77=>3, 78=>3, 72=>7}},
       {76=>{72=>1, 75=>2, 77=>5, 78=>5}},
       {77=>{72=>1, 75=>2, 76=>5, 78=>5}},
       {78=>{72=>1, 75=>2, 76=>5, 77=>5, 79=>8}},
       {79=>{78=>7}}]


    #  max_power_profiles_pairs_hash = # test w/dubbles
      {72=>{9=>58, 10=>68},
       73=>{9=>80, 10=>84},
       74=>{9=>81, 10=>85},
       75=>{9=>57, 10=>65},   # 75=>{9=>59, 10=>65},
       76=>{9=>61, 10=>69},
       77=>{9=>60, 10=>71}, #    77=>{9=>60, 10=>70},
       78=>{9=>57, 10=>71}}




      # 7 to 8 tree
      # @new_profiles_found_arr
      [{47=>{8=>{56=>[1, 2], 55=>[3, 8], 53=>[8]}}},  # !! duplicates! 1 to 2
       {48=>{8=>{55=>[3, 8], 53=>[8]}}},
       {49=>{8=>{52=>[3, 7], 54=>[7]}}},
       {50=>{8=>{52=>[3, 7], 54=>[7]}}},
       {51=>{8=>{56=>[1, 2]}}}]

      # @duplicated_profiles_pairs_hash
      {47=>{8=>{56=>2, 55=>2}}} # All duplicates!
      { 47=>{8=>[56, 55]} } # same All duplicates!

      # @max_power_profiles_pairs_hash
      {48=>{8=>55},
       49=>{8=>52}, # !! duplicates! 2 to 1
       50=>{8=>52}, # !! duplicates! 2 to 1
       51=>{8=>56}}



      ################################
      ######## Запуск метода формирования путей
      ######## отображения рез-тов на Главной
      #@final_reduced_profiles_hash =
      #{9=>{72=>[58, 61, 60, 57, 59],
      #     75=>[59, 61, 60, 57, 58],
      #     76=>[61, 58, 59, 60, 57],
      #     77=>[60, 58, 59, 61, 57],
      #     78=>[57, 58, 59, 61, 60]},
      #
      # 10=>{72=>[68, 69, 70, 71, 65],
      #      75=>[65, 69, 70, 71, 68],
      #      76=>[69, 68, 65, 70, 71],
      #      77=>[70, 68, 65, 69, 71],
      #      78=>[71, 68, 65, 69, 70]}
      #}
      #
      #@final_reduced_relations_hash =
      #{9=>{72=>[0, 3, 3, 3, 8],
      #     75=>[0, 3, 3, 3, 7],
      #     76=>[0, 1, 2, 5, 5],
      #     77=>[0, 1, 2, 5, 5],
      #     78=>[0, 1, 2, 5, 5]},
      #
      # 10=>{72=>[0, 3, 3, 3, 8],
      #      75=>[0, 3, 3, 3, 7],
      #      76=>[0, 1, 2, 5, 5],
      #      77=>[0, 1, 2, 5, 5],
      #      78=>[0, 1, 2, 5, 5]}
      #}

      #  make_search_results_paths(@final_reduced_profiles_hash) #
      @final_reduced_profiles_hash = {}
      @final_reduced_relations_hash = {}
      @wide_user_ids_arr =[]
      make_search_results_paths({})  # DEBUGG_TO_VIEW


      # Для отладки # DEBUGG_TO_VIEW
      @author_id = current_user.id # DEBUGG_TO_VIEW
      @author_connected_tree_arr = get_connected_users_tree(@connected_author_arr) # DEBUGG_TO_VIEW
      @len_author_tree = @author_connected_tree_arr.length  if !@author_connected_tree_arr.blank?  # DEBUGG_TO_VIEW



    end


    ################################
    ########## Методы формирования отображения рез-тов на Главной
    session[:search_results_relations] = nil
    session[:all_match_relations_sorted] = nil

    @search_results_relations = []
    @final_reduced_profiles_hash.each do |tree_id,  tree_value|
      tree_value.each do |matched_key, matched_value|
        matched_value.each_with_index do |profile_id, index|
          relation = @final_reduced_relations_hash[tree_id][matched_key][index]
          @search_results_relations << {profile_id => {matched_key => relation}}
        end
      end
    end

    session[:search_results_relations] = @search_results_relations
    session[:results_count_hash] =  @final_reduced_relations_hash

    # Ближние круги пользователей из результатов поиска
    @search_results = []
    result_users = User.where(id: @wide_user_ids_arr)
    sorted_result_users = @wide_user_ids_arr.collect {|id| result_users.detect {|u| u.id == id.to_i } }
    sorted_result_users.each do |user|
      @search_results << Hashie::Mash.new( {author: user, circle: user.profile.circle(user.id)} )
    end

    # Path search results
    @path_search_results = []
    @search_path_hash.each do |user_id, user_paths|
      user = User.find user_id
      @path_search_results << {user: user, paths: collect_path_profiles(user_paths)}
    end
    @path_search_results

    @search_results_data = collect_search_results_data(@new_search_path_hash)

 end


 def collect_search_results_data(data_hash)
   results = []
   data_hash.each do |user_id, result_data|
     user = User.find user_id
     result = {
               user_id: user.id,
               user_name: user.profile.name.to_name,
               user_sex_id: user.profile.sex_id,
               connected: user.get_connected_users.size > 1,
               results: collect_search_results_for_profiles(result_data)
              }
     results << Hashie::Mash.new(result)
   end
   results
 end


 def collect_search_results_for_profiles(data)
   results = []
   data.each do |profile_id, path_data|
     profile = Profile.find(profile_id)
     result = {
                profile_id: profile.id,
                profile_name: profile.name.to_name,
                results_count: path_data.size,
                results: collect_path_profiles(path_data)
              }
     results << result
   end
   results
 end


 def collect_path_profiles(user_paths)
   results = []
   user_paths.each do |paths|
     result = []
     prev_sex_id = nil
     paths.each do |profile_id, data|
       profile = Profile.find(profile_id)
       result << {profile: profile, data: data, relation: data.keys.first, prev_sex_id: prev_sex_id}
       prev_sex_id = profile.sex_id
     end
     results << result
   end
   return results
 end




end
