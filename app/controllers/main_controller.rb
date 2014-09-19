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
      @certainty_koeff = 3 # (for 0-8 relations)
      ###############


      # DEBUGG_TO_VIEW

      #start_hash =
      #{72=>{9=>58, 10=>68}, # o #CK = 1
      # 73=>{9=>80, 10=>84}, # o
      # 74=>{9=>81, 10=>85}, # o
      # 75=>{9=>59, 10=>65}, # o
      # 76=>{9=>61, 10=>69}, # o
      # 77=>{9=>60, 10=>70}, # o
      # 78=>{9=>57, 10=>71}, # o
      # 79=>{9=>62, 10=>86}} # o
      #
      #
      #res_hash = collect_trees_profiles(start_hash)
      #logger.info "** collect_trees_profiles begin: res_hash = #{res_hash} "




      def get_new_hash(concern_hash)
      a = 0
      logger.info "** get_new_hash begin: concern_hash = #{concern_hash} "
      new_concern_hash = {}
      new_keys = []
      new_values = []
      concern_hash.each do |el|

        if a == 1 && !@repeat

          new_hash = {4 => 10, 5 => 20}  # New pairs  ЕСТЬ НОВЫЕ пары совпадающих профилей
          logger.info "** IN if == 1: new_hash = #{new_hash}"
          new_concern_hash.merge!(new_hash)
          new_keys << new_hash.keys
          new_keys = new_keys.flatten(1)
          new_values << new_hash.values
          new_values = new_values.flatten(1)
          logger.info "** IN if == 1: new_concern_hash = #{new_concern_hash}, new_keys = #{new_keys}, new_values = #{new_values} "
        end

        if a == 2 && !@repeat
          new_hash = {8 => 50, 9 => 60} # New pairs
          new_concern_hash.merge!(new_hash)
          new_keys << new_hash.keys
          new_values << new_hash.values
          new_keys = new_keys.flatten(1)
          new_values = new_values.flatten(1)
          logger.info "** IN if == 2: new_concern_hash = #{new_concern_hash}, new_keys = #{new_keys}, new_values = #{new_values} "
        end

        if a == 3 && @repeat
          new_hash = {} # No New pairs - НЕТ НОВОЙ пары совпадающих профилей
          # НЕТ пересечения 2-х БК.
          logger.info "** IN if == 3: new_hash = #{new_hash}"
          if !new_hash.empty?
            new_concern_hash.merge!(new_hash)
            new_keys << new_hash.keys
            new_values << new_hash.values
          end
        else
          logger.info "** IN NOT if == 3: @repeat = #{@repeat}"
        end

        a += 1
        logger.info "** IN Test: a = #{a}"
      end
      logger.info "** End of Test: new_concern_hash = #{new_concern_hash}, new_keys = #{new_keys}, new_values = #{new_values} "

  return new_concern_hash, new_keys, new_values
end

      # COMPLETE HARD SEARCH STRUCTURE

      concern_hash = {1 => 5, 2 => 15, 3 => 25, 6 => 30, 7 => 35}

      # переставить начиная отсюда в метод hard_complete_search
      final_concern_hash = concern_hash
      final_keys_arr = concern_hash.keys
      final_vals_arr = concern_hash.values
      @repeat = false

      until concern_hash.empty?
        logger.info "** IN UNTIL top: concern_hash = #{concern_hash}"
        new_hash, new_keys, new_values = get_new_hash(concern_hash)
        @repeat = true
        concern_hash = new_hash
        if !new_hash.empty?
          final_concern_hash.merge!(new_hash)
          final_keys_arr << new_keys
          final_vals_arr << new_values
          final_keys_arr = final_keys_arr.flatten(1)
          final_vals_arr = final_vals_arr.flatten(1)

        end
        logger.info "** IN UNTIL : concern_hash = #{concern_hash}, new_keys = #{new_keys}, new_values = #{new_values} "
        logger.info " "

      end

      logger.info "** After COMPLETE HARD SEARCH: final_concern_hash = #{final_concern_hash} "
      logger.info "**  final_keys_arr = #{final_keys_arr} "
      logger.info "**  final_vals_arr = #{final_vals_arr} "
      logger.info " "

      # по сюда - переставить

      # END OF COMPLETE HARD SEARCH STRUCTURE


      # NEW METHOD "HARD COMPLETE SEARCH"- TO DO
      # Input: start tree No, tree No to connect
      # @max_power_profiles_pairs_hash
      # Output:
      # Определение массивов профилей для перезаписи: profiles_to_rewrite, profiles_to_destroy
      # profiles_to_rewrite, profiles_to_destroy =  get_rewrite_profiles_by_bk(search_results) ##
      #
      # start_tree = от какого дерева объедин.
      # connected_user = с каким деревом объед-ся
      # /
      # Input: 1. @max_power_profiles_pairs_hash


      def hard_complete_search(start_tree, connected_user, max_power_profiles_pairs_hash )
        logger.info "** IN hard_complete_search *** "
        profiles_to_rewrite = []
        profiles_to_destroy = []

        profile_searched = 78
        profile_found = 57

        start_tree = 11
        connected_user = 9

       {72=>{9=>58, 10=>68},
        75=>{9=>59, 10=>65},
        76=>{9=>61, 10=>69},
        77=>{9=>60, 10=>70},
        78=>{9=>57, 10=>71}}

        init_searched_profiles_arr = []
        init_found_profiles_arr = []
        init_connection_hash = {}
        max_power_profiles_pairs_hash.each do |searched_profile, trees_hash|
          init_searched_profiles_arr << searched_profile
          trees_hash.each do |tree_key, found_profile|
            # ЗДЕСЬ !! ЕСЛИ connected_user = ОБЪЕДИНЕННЫМ ДЕРЕВОМ ?
            if tree_key == connected_user #connected_user.each

              init_found_profiles_arr << found_profile
              init_connection_hash.merge!( searched_profile => found_profile )
            end
          end
        end
        logger.info " init_searched_profiles_arr = #{init_searched_profiles_arr}, init_found_profiles_arr = #{init_found_profiles_arr}"
        logger.info " init_concerned_hash = #{init_connection_hash}"


        # сюда переставить из метода выше
        connection_hash = init_connection_hash

        profile_searched_user_id = Profile.find(profile_searched).tree_id
        searched_profile_circle = get_one_profile_BK(profile_searched, profile_searched_user_id)
        logger.info "=== БЛИЖНИЙ КРУГ ИСКОМОГО ПРОФИЛЯ = #{profile_searched} "
        show_in_logger(searched_profile_circle, "= ряд " )  # DEBUGG_TO_LOGG
        search_bk_arr, search_bk_profiles_arr = make_arr_hash_BK(searched_profile_circle)

        profile_found_user_id = Profile.find(profile_found).tree_id
        found_profile_circle = get_one_profile_BK(profile_found, profile_found_user_id)
        logger.info "=== БЛИЖНИЙ КРУГ НАЙДЕННОГО ПРОФИЛЯ = #{profile_found} "
        show_in_logger(found_profile_circle, "= ряд " )  # DEBUGG_TO_LOGG
        found_bk_arr, found_bk_profiles_arr = make_arr_hash_BK(found_profile_circle)

        logger.info " Compare_two_BK: ИСКОМОГО ПРОФИЛЯ = #{profile_searched} и НАЙДЕННОГО ПРОФИЛЯ = #{profile_found}:"
        compare_rezult, common_bk_arr, delta = compare_two_BK(found_bk_arr, search_bk_arr)
        logger.info " compare_rezult = #{compare_rezult}"
        logger.info " ПЕРЕСЕЧЕНИЕ двух БК: common_bk_arr = #{common_bk_arr}"
        logger.info " РАЗНОСТЬ двух БК: delta = #{delta}"

        if !common_bk_arr.blank? # Если rez_bk_arr != [] - есть какое-то ПЕРЕСЕЧЕНИЕ при сравнении 2-х БК

          new_field_arr_searched, new_field_arr_found, new_connection_hash = get_fields_arrays_from_bk(search_bk_profiles_arr, found_bk_profiles_arr )
          new_field_arr_searched = new_field_arr_searched.flatten(1)
          new_field_arr_found = new_field_arr_found.flatten(1)
          logger.info "=ВАРИАНТ Extraxt is_profile_id из пересечения 2-х БК если оно есть"
          logger.info " new_field_arr_searched = #{new_field_arr_searched}, new_field_arr_found = #{new_field_arr_found} "
          logger.info " new_connection_hash = #{new_connection_hash} "
          logger.info " "
        else
          new_connection_hash = {}
        end
        @new_connection_hash = new_connection_hash  # DEBUGG_TO_VIEW

        if !new_connection_hash.empty?
          add_to_hash(connection_hash, new_connection_hash)
          logger.info "@@@@@ connection_hash = #{connection_hash} "
        end

        logger.info "connection_hash = #{connection_hash} "
        logger.info " "
        profiles_to_rewrite = connection_hash.keys
        profiles_to_destroy = connection_hash.values

        return profiles_to_rewrite, profiles_to_destroy

      end



      start_tree = 11
      connected_user = 9
      max_power_profiles_pairs_hash =

          {72=>{9=>58, 10=>68},
           75=>{9=>59, 10=>65},
           76=>{9=>61, 10=>69},
           77=>{9=>60, 10=>70},
           78=>{9=>57, 10=>71}}

      profiles_to_rewrite, profiles_to_destroy = hard_complete_search(start_tree, connected_user, max_power_profiles_pairs_hash )

      logger.info "ALL profiles_to_rewrite = #{profiles_to_rewrite} "
      logger.info "ALL profiles_to_destroy = #{profiles_to_destroy} "
      logger.info " "
      logger.info " "
      logger.info " "



      # Для SEARCH_HARD!
      # Метод определения массивов перезаписи профилей при объединении деревьев
      # На входе: рез-тат жесткого поиска совпавших профилей - при совпадении их БК
      # Далее начинаем цикл по профилям, кот-е участвуют в БК совпавших профилей при жестком поиске
      # Поэтапное наполнение массивов перезаписи
      #
      def get_rewrite_profiles_by_bk(search_results) # используется только вместе с start_hard_search

        ######## Сбор рез-тов поиска, необходимых для объединения:
        # !!!! ЗДЕСЬ - ВАЖЕН ПОРЯДОК ПРИСВАИВАНИЯ !!! - КАК ВПОЛУЧЕНИИ search_results!/
        @final_hard_profiles_to_connect_hash = search_results[:final_hard_profiles_to_connect_hash]
        @final_pos_profiles_arr = search_results[:final_pos_profiles_arr]
        @final_profiles_searched_arr = search_results[:final_profiles_searched_arr]
        @final_profiles_found_arr = search_results[:final_profiles_found_arr]
        @final_search_profiles_step_arr = search_results[:final_search_profiles_step_arr]
        @final_found_profiles_step_arr = search_results[:final_found_profiles_step_arr]

        logger.info ""
        logger.info "** IN connection_of_trees ******** "
        logger.info "@final_hard_profiles_to_connect_hash = #{@final_hard_profiles_to_connect_hash}"
        # Текущий Хэш профилей для объдинения
        # Получен из search_hard
        # Далее - его наращивание новыми парами профилей для объединения.
        #who_connect_users_arr = current_user.get_connected_users
        #with_whom_connect_users_arr = User.find(user_id).get_connected_users  #
        #logger.info "who_connect_users_arr = #{who_connect_users_arr}, with_whom_connect_users_arr = #{with_whom_connect_users_arr}"
        current_profiles_connect_hash = {}

        logger.info "################ TO DO!!! IN HARD SEARCH ##################"
        #@final_search_profiles_step_arr = [[17, 19], [16, 20, 18]] # from hard_search
        #@final_found_profiles_step_arr = [[27, 30], [28, 29, 24]] # from hard_search
        logger.info "@final_search_profiles_step_arr = #{@final_search_profiles_step_arr}"
        logger.info "@final_found_profiles_step_arr = #{@final_found_profiles_step_arr}"

        ######## Дальнейшее Определение массивов профилей для перезаписи ПО ДАННЫМ ИЗ Hard_Search
        ##############################################################################
        logger.info "##### NEW METHOD - TO DETERMINE REWRITE & DESTROY PROFILES BEFORE TREES CONNECTION"
        for arr_ind in 1 .. @final_search_profiles_step_arr.size - 1
          one_search_arr = @final_search_profiles_step_arr[arr_ind]
          one_found_arr = @final_found_profiles_step_arr[arr_ind]
          logger.info "one_search_arr = #{one_search_arr}, one_found_arr = #{one_found_arr}"
          #new_connection_hash = {}

          one_search_arr.each_with_index do |profile_searched, index|
            logger.info "one_search_arr=profile_searched = #{profile_searched}, index = #{index}"
            profile_found = one_found_arr[index]
            logger.info "one_found_arr=profile_found = #{profile_found}, index = #{index}"

            profile_searched_user_id = Profile.find(profile_searched).tree_id
            searched_profile_circle = get_one_profile_BK(profile_searched, profile_searched_user_id)
            logger.info "=== БЛИЖНИЙ КРУГ ИСКОМОГО ПРОФИЛЯ = #{profile_searched} "
            show_in_logger(searched_profile_circle, "= ряд " )  # DEBUGG_TO_LOGG
            search_bk_arr, search_bk_profiles_arr = make_arr_hash_BK(searched_profile_circle)

            profile_found_user_id = Profile.find(profile_found).tree_id
            found_profile_circle = get_one_profile_BK(profile_found, profile_found_user_id)
            logger.info "=== БЛИЖНИЙ КРУГ НАЙДЕННОГО ПРОФИЛЯ = #{profile_found} "
            show_in_logger(found_profile_circle, "= ряд " )  # DEBUGG_TO_LOGG
            found_bk_arr, found_bk_profiles_arr = make_arr_hash_BK(found_profile_circle)

            logger.info " Compare_two_BK: ИСКОМОГО ПРОФИЛЯ = #{profile_searched} и НАЙДЕННОГО ПРОФИЛЯ = #{profile_found}:"
            compare_rezult, rez_bk_arr = compare_two_BK(found_bk_arr, search_bk_arr)
            logger.info " compare_rezult = #{compare_rezult}"
            logger.info " ПЕРЕСЕЧЕНИЕ двух БК: rez_bk_arr = #{rez_bk_arr}"

            if !rez_bk_arr.blank? # Если rez_bk_arr != [] - есть какое-то ПЕРЕСЕЧЕНИЕ при сравнении 2-х БК

              new_field_arr_searched, new_field_arr_found, new_connection_hash = get_fields_arrays_from_bk(search_bk_profiles_arr, found_bk_profiles_arr )
              new_field_arr_searched = new_field_arr_searched.flatten(1)
              new_field_arr_found = new_field_arr_found.flatten(1)
              logger.info "=ВАРИАНТ Получение is_profile_id из пересечения 2-х БК, если оно есть"
              logger.info " new_field_arr_searched = #{new_field_arr_searched}, new_field_arr_found = #{new_field_arr_found} "
              logger.info " new_connection_hash = #{new_connection_hash} "
              logger.info " "
            else
              new_connection_hash = {}
            end

            @new_connection_hash = new_connection_hash  # DEBUGG_TO_VIEW
            diff_hash = current_profiles_connect_hash.diff(new_connection_hash) ###
            # ## DEPRECATION WARNING: Hash#diff is no longer used inside of Rails, and is being deprecated with no replacement.

            logger.info " current_profiles_connect_hash = #{current_profiles_connect_hash} "
            logger.info " new_connection_hash = #{new_connection_hash} "
            logger.info " diff_hash = #{diff_hash} "
            logger.info " "

            current_profiles_connect_hash = current_profiles_connect_hash.merge!(diff_hash)
            logger.info "current_profiles_connect_hash = #{current_profiles_connect_hash} "
            logger.info " "

          end
          current_profiles_connect_hash = current_profiles_connect_hash.merge!(current_profiles_connect_hash)

        end

        logger.info "@final_hard_profiles_to_connect_hash = #{@final_hard_profiles_to_connect_hash}"
        logger.info "ALL current_profiles_connect_hash = #{current_profiles_connect_hash} "
        logger.info " "

        profiles_to_rewrite = current_profiles_connect_hash.keys
        profiles_to_destroy = current_profiles_connect_hash.values

        logger.info "@final_profiles_searched_arr = #{@final_profiles_searched_arr}, @final_profiles_found_arr = #{@final_profiles_found_arr}"
        logger.info "ALL profiles_to_rewrite = #{profiles_to_rewrite} "
        logger.info "ALL profiles_to_destroy = #{profiles_to_destroy} "

        return profiles_to_rewrite, profiles_to_destroy

      end ## END OF NEW METHOD определения массивов для перезаписи






      # NEW METHOD "TRANSFORM RESULTS TO PATHS"- TO DO
      # Преобразование рез-тов поиска в @final_reduced_profiles_hash и @final_reduced_relations_hash,
      # Input: 1. @max_power_profiles_pairs_hash

      [{72=>{9=>58, 10=>68}},
       {75=>{9=>59, 10=>65}},
       {76=>{9=>61, 10=>69}},
       {77=>{9=>60, 10=>70}},
       {78=>{9=>57, 10=>71}} ]

      #@new_profiles_relations_arr: - for 11
      [{72=>{73=>1, 74=>2, 76=>3, 77=>3, 78=>3, 75=>8}},
       {73=>{72=>3, 74=>8}},
       {74=>{72=>3, 73=>7}},
       {75=>{76=>3, 77=>3, 78=>3, 72=>7}},
       {76=>{72=>1, 75=>2, 77=>5, 78=>5}},
       {77=>{72=>1, 75=>2, 76=>5, 78=>5}},
       {78=>{72=>1, 75=>2, 76=>5, 77=>5, 79=>8}},
       {79=>{78=>7}}]

      # New method


      # Output: @final_reduced_profiles_hash

      {9=>{72=>[58, 61, 60, 57, 59],
           75=>[59, 61, 60, 57, 58],
           76=>[61, 58, 59, 60, 57],
           77=>[60, 58, 59, 61, 57],
           78=>[57, 58, 59, 61, 60]},

       10=>{72=>[68, 69, 70, 71, 65],
            75=>[65, 69, 70, 71, 68],
            76=>[69, 68, 65, 70, 71],
            77=>[70, 68, 65, 69, 71],
            78=>[71, 68, 65, 69, 70]}
      }

      # Output:@final_reduced_relations_hash

      {9=>{72=>[0, 3, 3, 3, 8],
           75=>[0, 3, 3, 3, 7],
           76=>[0, 1, 2, 5, 5],
           77=>[0, 1, 2, 5, 5],
           78=>[0, 1, 2, 5, 5]},

       10=>{72=>[0, 3, 3, 3, 8],
            75=>[0, 3, 3, 3, 7],
            76=>[0, 1, 2, 5, 5],
            77=>[0, 1, 2, 5, 5],
            78=>[0, 1, 2, 5, 5]}
      }




      @profiles_found_arr =
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


      # 5 to 6
      [{34=>{6=>{45=>[3, 8]}}},
       {38=>{6=>{41=>[3, 7]}}},
       {40=>{6=>{46=>[1, 2]}}}]

      {34=>{6=>45},
       38=>{6=>41},
       40=>{6=>46}}



      # ИЗЪЯТИЕ ПРОФИЛЕЙ С МАЛОЙ МОЩНОСТЬЮ НАЙДЕННЫХ ОТНОШЕНИЙ
      def reduce_profile_relations(profile_relations_hash, certainty_koeff)      ###################
        reduced_profile_relations_hash = profile_relations_hash.select {|k,v| v.size >= certainty_koeff }
        logger.info " reduced_profile_relations_hash = #{reduced_profile_relations_hash} "
        ###############
        return reduced_profile_relations_hash
      end

      # ПРЕВРАЩЕНИЕ ХЭША ПРОФИЛЕЙ С НАЙДЕННЫМИ ОТНОШЕНИЯМИ В ХЭШ ПРОФИЛЕЙ С МОЩНОСТЯМИ ОТНОШЕНИЙ
      def make_profiles_power_hash(reduced_profile_relations_hash)
        profiles_powers_hash = {}
        reduced_profile_relations_hash.each { |k, v_arr | profiles_powers_hash.merge!( k => v_arr.size) }
        logger.info " profiles_powers_hash = #{profiles_powers_hash} "
        return profiles_powers_hash
      end

      # ПРЕВРАЩЕНИЕ ХЭША ПРОФИЛЕЙ С МОЩНОСТЯМИ ОТНОШЕНИЙ В ХЭШ ПРОФИЛЯ(ЕЙ) С МАКСИМАЛЬНОЙ(МИ) МОЩНОСТЬЮ
      def get_max_power_profiles_hash(profiles_powers_hash)
        max_power = profiles_powers_hash.values.max
        max_profiles_powers_hash = profiles_powers_hash.select { |k, v| v == max_power}
        logger.info " max profiles_powers_hash = #{max_profiles_powers_hash} "
        return max_profiles_powers_hash, max_power
      end


    # ПОЛУЧЕНИЕ ПАР СООТВЕТСТВИЙ ПРОФИЛЕЙ С МАКС. МОЩНОСТЬЮ МНОЖЕСТВ СОВПАДЕНИЙ ОТНОШЕНИЙ
    # Вход
    # Выход
    # .
    def get_certain_profiles_pairs(profiles_found_arr, certainty_koeff)
      max_power_profiles_pairs_hash = {}
      duplicated_profiles_pairs_hash = {}
      profiles_found_arr.each do |hash_in_arr|
        #logger.info " hash_in_arr = #{hash_in_arr} "
        hash_in_arr.each do |searched_profile, profile_trees_relations|
          #logger.info " searched_profile = #{searched_profile} "
          max_power_pairs_hash = {}
          duplicated_pairs_hash = {}
          profile_trees_relations.each do |key_tree, profile_relations_hash|
            tree_selected = key_tree
            #logger.info " tree_selected = #{tree_selected} "
            #profile_relations_hash = {58=>[1, 2, 3, 3, 3, 8], 59=>[1, 2, 3, 3, 3,9 ], 60=>[1, 2, 3, 3], 57=>[2, 3, 3]}
            logger.info " profile_relations_hash = #{profile_relations_hash} "
            reduced_profile_relations_hash = reduce_profile_relations(profile_relations_hash, certainty_koeff)
            if !reduced_profile_relations_hash.empty?
              profiles_powers_hash = make_profiles_power_hash(reduced_profile_relations_hash)
              max_profiles_powers_hash, max_power = get_max_power_profiles_hash(profiles_powers_hash)
              ##################

              if max_profiles_powers_hash.size == 1 # один профиль с максимальной мощностью
                # НАРАЩИВАНИЕ ХЭША ДОСТОВЕРНЫХ ПАР ПРОФИЛЕЙ certain_max_power_pairs_hash
                profile_selected = max_profiles_powers_hash.key(max_power)

                max_power_pairs_hash.merge!(key_tree => profile_selected )
                #logger.info " SAVE key_tree = #{key_tree}, max_power_pairs_hash = #{max_power_pairs_hash}  "
              else # больше одного профиля с максимальной мощностью
                # НАРАЩИВАНИЕ ХЭША ПРОФИЛЕЙ-ДУПЛИКАТОВ duplicated_pairs_hash
                # ЕСЛИ НАЙДЕНО БОЛЬШЕ 1 ПАРЫ ПРОФИЛЕЙ С ОДИНАК. МАКС. МОЩНОСТЬЮ
                # Т.Е. ДУПЛИКАТ ТИПА 1 К 2
                # ЗАНОСИМ В ХЭШ ДУПЛИКАТОВ.
                duplicated_pairs_hash.merge!(key_tree => max_profiles_powers_hash )
                #logger.info " SKIP , PUT in DUPLICATES_HASH,  duplicated_profiles_pairs_hash = #{duplicated_profiles_pairs_hash} "
              end

            end

          end
          max_power_profiles_pairs_hash.merge!(searched_profile => max_power_pairs_hash ) if !max_power_pairs_hash.empty?
          duplicated_profiles_pairs_hash.merge!(searched_profile => duplicated_pairs_hash ) if !duplicated_pairs_hash.empty?

        end

      end
      return max_power_profiles_pairs_hash, duplicated_profiles_pairs_hash

    end # End of method


      ################################
      ######## Основной поиск от дерева Автора (вместе с соединенными)
      ######## среди других деревьев в ProfileKeys.
      beg_search_time = Time.now   # Начало отсечки времени поиска

      ##############################################################################
      ##### ВЫБОР ВИДА ПОИСКА: start_hard_search (жесткий - по совпадению БК),
      # или start_search_first (1-й версии - самый первый),
      # или start_search (мягкий - 2-я версия, с определением right_profile по макс. кол-ву совпадений),
      ##############################################################################

      #####  Запуск НОВОГО поиска С @certainty_koeff
      search_results = current_user.start_search  ##

      #####  Запуск ЖЕСТКОГО поиска
      #search_results = current_user.start_hard_search  ##

      #####  Запуск поиска 1-й версии - самый первый
      #search_results = current_user.start_search_first  #####  Запуск поиска 1-й версии

      #####  Запуск МЯГКОГО поиска - 2-я версия
      #search_results = current_user.start_search_soft  ## Запуск поиска с right_profile

      end_search_time = Time.now   # Конец отсечки времени поиска
      @elapsed_search_time = (end_search_time - beg_search_time).round(5) # Длительность поиска - для инфы
      ######## Сбор рез-тов поиска:
      @final_reduced_profiles_hash = search_results[:final_reduced_profiles_hash]
      @final_reduced_relations_hash = search_results[:final_reduced_relations_hash]
      @wide_user_ids_arr = search_results[:wide_user_ids_arr]
      @qty_of_tree_profiles = search_results[:qty_of_tree_profiles] # To view
      @connected_author_arr = search_results[:connected_author_arr]

      @new_profiles_found_arr = search_results[:new_profiles_found_arr]

      # @new_profiles_found_arr = searched unconcerned results for searched tree (11) - for analyzis
      [{72=>{9=>{58=>[1, 2, 3, 3, 3, 8], 57=>[2, 3, 3]}, 10=>{68=>[1, 2, 3, 3, 3, 8], 71=>[2, 3]}}},
       {73=>{9=>{80=>[3, 8]}, 10=>{84=>[3, 8], 70=>[8]}}},
       {74=>{9=>{59=>[3], 81=>[3, 7]}, 10=>{65=>[3], 85=>[3, 7], 83=>[7]}}},
       {75=>{9=>{59=>[3, 3, 3, 7], 81=>[3]}, 10=>{65=>[3, 3, 3, 7], 85=>[3]}}},
       {76=>{9=>{61=>[1, 2, 5, 5]}, 10=>{69=>[1, 2, 5, 5]}}},
       {77=>{9=>{60=>[1, 2, 5, 5], 64=>[1, 5]}, 10=>{70=>[1, 2, 5, 5], 87=>[1]}}},
       {78=>{9=>{57=>[1, 2, 5, 5, 8], 63=>[1, 5], 58=>[2]}, 10=>{71=>[1, 2, 5, 5, 8], 68=>[2]}}},
       {79=>{9=>{62=>[7]}, 10=>{86=>[7]}}}]

      @new_profiles_relations_arr = search_results[:new_profiles_relations_arr]

      # searched tree structure (11) - for what?
      [{72=>{73=>1, 74=>2, 76=>3, 77=>3, 78=>3, 75=>8}},
       {73=>{72=>3, 74=>8}},
       {74=>{72=>3, 73=>7}},
       {75=>{76=>3, 77=>3, 78=>3, 72=>7}},
       {76=>{72=>1, 75=>2, 77=>5, 78=>5}},
       {77=>{72=>1, 75=>2, 76=>5, 78=>5}},
       {78=>{72=>1, 75=>2, 76=>5, 77=>5, 79=>8}},
       {79=>{78=>7}}]

      #######################################################
      ######## Запуск метода выбора пар профилей с максимальной мощностью множеств совпадений отношений
      # по результатам поиска из всего полученного множества результатов @new_profiles_found_arr.
      max_power_profiles_pairs_hash, duplicated_profiles_pairs_hash = get_certain_profiles_pairs(@new_profiles_found_arr, @certainty_koeff)

    #  max_power_profiles_pairs_hash = # test w/dubbles
      {72=>{9=>58, 10=>68},
       73=>{9=>80, 10=>84},
       74=>{9=>81, 10=>85},
       75=>{9=>57, 10=>65},   # 75=>{9=>59, 10=>65},
       76=>{9=>61, 10=>69},
       77=>{9=>60, 10=>71}, #    77=>{9=>60, 10=>70},
       78=>{9=>57, 10=>71}}

      @max_power_profiles_pairs_hash = max_power_profiles_pairs_hash #
      @duplicated_profiles_pairs_hash = duplicated_profiles_pairs_hash #

      #######################################################
      # ПРОВЕРКА ХЭША ПАР ПРОФИЛЕЙ С МАКС. МОЩНОСТЬЮ НА НАЛИЧИЕ ДУБЛИКАТОВ
      # ТИПА 2 К 1
      # Не должно остаться в хэше пар - пар для одного дерева с одним профилем
      uniq_profiles_pairs_hash, double_profiles_pairs_hash = duplicates_out(max_power_profiles_pairs_hash)  # Ok
      # Exclude empty hashes
      uniq_profiles_pairs_hash.delete_if { |k,v|  v == {} }
      logger.info "** After dups_out: uniq_profiles_pairs_hash = #{uniq_profiles_pairs_hash}, double_profiles_pairs_hash = #{double_profiles_pairs_hash}"

      #######################################################
      # СБОР ВСЕХ НАЙДЕННЫХ ПРОФИЛЕЙ ПО ДЕРЕВЬЯМ
      res_hash = collect_trees_profiles(start_hash)
      logger.info "** collect_trees_profiles begin: res_hash = #{res_hash} "
      #######################################################
      # ПРОВЕРКА ПРИСУТСТВИЯ КАЖДОГО ПРОФИЛЯ В ЕГО РОДНОМ ДЕРЕВЕ
      def check_profiles_tree_uniqness(trees_profiles_hash)
        check_results_hash = {}
        new_uniq_profiles_hash = {}
        trees_profiles_hash.each_with_index do |(k, v), index|

        end
        return check_results_hash, new_uniq_profiles_hash
      end
      check_results_hash, new_uniq_profiles_hash = check_profiles_tree_uniqness(uniq_profiles_pairs_hash)
      logger.info "** After check_uniqness: new_uniq_profiles_hash = #{new_uniq_profiles_hash}, check_results_hash = #{check_results_hash}"
      # After method Get all found profiles for trees


      ######## сформирован итоговый Хэш uniq_profiles_pairs_hash достоверных пар результатов поиска
      ######## для отображения их на Главной
      # (аналог старых недостоверных @final_reduced_profiles_hash  и  @final_reduced_relations_hash)
      # для дальнейшего формирования путей ?
      # А также Хэш дубликатов double_profiles_pairs_hash, в случае их выявления

     # uniq_profiles_pairs_hash =
      {72=>{9=>58, 10=>68}, # test - adter exclude dubbles
       73=>{9=>80, 10=>84},
       74=>{9=>81, 10=>85},
       75=>{10=>65},
       76=>{9=>61, 10=>69},
       77=>{9=>60},
       78=>{}}

      {78=>{9=>57, 10=>71}, 75=>{9=>57}, 77=>{10=>71}}  # test - dubbles


      {72=>{9=>58, 10=>68},
       73=>{9=>80, 10=>84},
       74=>{9=>81, 10=>85, 12=>93},
       75=>{10=>65},
       76=>{9=>61, 10=>69},
       77=>{9=>60},
       79=>{12=>101}}



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


      @uniq_profiles_pairs_hash = uniq_profiles_pairs_hash #
      @double_profiles_pairs_hash = double_profiles_pairs_hash #

      duplicated_profiles_pairs_hash.merge!(double_profiles_pairs_hash) if !double_profiles_pairs_hash.empty?
      logger.info "** Final DUPPS: duplicated_profiles_pairs_hash = #{duplicated_profiles_pairs_hash}"


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

       # check_pairs_uniqness(@max_power_profiles_pairs_hash).
      # вход: @max_power_profiles_pairs_hash



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
