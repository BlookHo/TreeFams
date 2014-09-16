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

# DEBUGG_TO_VIEW

      connected_author_arr = current_user.get_connected_users # Состав объединенного дерева в виде массива id
      author_tree_arr = get_connected_tree(connected_author_arr) # Массив объединенного дерева из Tree
  #    qty_of_tree_profiles = author_tree_arr.map {|p| p[4] }.uniq.size # Кол-во профилей в объед-ном дереве - для отображения на Главной

 #     author_tree_arr = # DEBUGG_TO_VIEW
      #    [

      #    ]

      #[

      #]

      @author_tree_arr = author_tree_arr # DEBUGG_TO_VIEW
# DEBUGG_TO_VIEW

     @profiles_found_arr =
# Исх.представление для метода select_certainty
      [{72=>{9=>{58=>[1, 2, 3, 3, 3, 8], 57=>[2, 3, 3]},
             10=>{68=>[1, 2, 3, 3, 3, 8], 71=>[2, 3]}}},# ]

       {73=>{9=>{80=>[3, 8]}, # exclude!
             10=>{84=>[3, 8], 70=>[8]}}},  # exclude!
       {74=>{9=>{59=>[3], 81=>[3, 7]},  # exclude!
             10=>{65=>[3], 85=>[3, 7], 83=>[7]}}},  # exclude!
       {75=>{9=>{59=>[3, 3, 3, 7], 81=>[3]},
             10=>{65=>[3, 3, 3, 7], 85=>[3]}}},
          #   10=>{65=>[3, 3, 3, 7], 85=>[3,3,3,3]}}}, # test for duplicated
       {76=>{9=>{61=>[1, 2, 5, 5]},
             10=>{69=>[1, 2, 5, 5]}}},
       {77=>{9=>{60=>[1, 2, 5, 5], 64=>[1, 5]},
             10=>{70=>[1, 2, 5, 5], 87=>[1]}}},
       {78=>{9=>{57=>[1, 2, 5, 5, 8], 63=>[1, 5], 58=>[2]},
             10=>{71=>[1, 2, 5, 5, 8], 68=>[2]}}},
       {79=>{9=>{62=>[7]},  # exclude!
             10=>{86=>[7]}}}]  # exclude!

      @certainty_koeff = 4 # (for 0-8 relations)

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


    # ПОЛУЧЕНИЕ ПАР ДОСТОВЕРНЫХ СООТВЕТСТВИЙ ПРОФИЛЕЙ
    def get_certain_profiles_pairs(profiles_found_arr, certainty_koeff)
      certain_profiles_pairs_hash = {}
      duplicated_profiles_pairs_hash = {}
      profiles_found_arr.each do |hash_in_arr|
        #logger.info " hash_in_arr = #{hash_in_arr} "
        hash_in_arr.each do |searched_profile, profile_trees_relations|
          #logger.info " searched_profile = #{searched_profile} "
          max_power_trees_profiles_hash = {}
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
                profile_selected = max_profiles_powers_hash.key(max_power)
                max_power_trees_profiles_hash.merge!(key_tree => profile_selected )
                logger.info " SAVE key_tree = #{key_tree}, max_power_trees_profiles_hash = #{max_power_trees_profiles_hash}  "
              else # больше одного профиля с максимальной мощностью
                duplicated_pairs_hash.merge!(key_tree => max_profiles_powers_hash )
                logger.info " SKIP , PUT in DUPLICATES_HASH,  duplicated_profiles_pairs_hash = #{duplicated_profiles_pairs_hash} "
              end

            end

          end
          certain_profiles_pairs_hash.merge!(searched_profile => max_power_trees_profiles_hash ) if !max_power_trees_profiles_hash.empty?
          duplicated_profiles_pairs_hash.merge!(searched_profile => duplicated_pairs_hash ) if !duplicated_pairs_hash.empty?
          #logger.info " certain_profiles_pairs_hash = #{certain_profiles_pairs_hash}  "

        end

      end
      return certain_profiles_pairs_hash, duplicated_profiles_pairs_hash
    end


      certain_profiles_pairs_hash, duplicated_profiles_pairs_hash = get_certain_profiles_pairs(@profiles_found_arr, @certainty_koeff)

      @certain_profiles_pairs_hash = certain_profiles_pairs_hash #
      @duplicated_profiles_pairs_hash = duplicated_profiles_pairs_hash #


      {72=>{9=>58, 10=>68},
       75=>{9=>59, 10=>65},
       76=>{9=>61, 10=>69},
       77=>{9=>60, 10=>70},
       78=>{9=>57, 10=>71}}



      #  @new_method_profiles_found_arr = #{11=> [12,13], 23 => [14,15], 10=>[3,4,5] }
    #{
    #    10 => { 59=>[1, 7, 3, 3, 3], 55=>[7, 3, 3, 3], 54=>[3], 51=>[3]} ,
    #    11 => { 68=>[8, 3, 3, 3, 1, 2], 62=>[8, 3, 3, 3, 1, 2], 67=>[3, 3, 2], 69=>[2]} ,
    #    12 => { 71=>[2, 1, 5, 5], 76=>[2, 1, 5, 5]}
    #}


      #tree = 11
      #tree_row_profile_id = 68
      #relation_row_relation_id = 10
      #@new_method_profiles_found_arr = fill_arrays_in_hash(@new_method_profiles_found_arr, tree, tree_row_profile_id, relation_row_relation_id)

      #user_ids = 11
      #profile_id = 72
      #@profiles_circle_hash, @relations_circle_hash = profile_circle_hash(user_ids, profile_id)

      ################################
      ######## Основной поиск от дерева Автора (вместе с соединенными)
      ######## среди других деревьев в ProfileKeys.
      beg_search_time = Time.now   # Начало отсечки времени поиска

      ##############################################################################
      ##### ВЫБОР ВИДА ПОИСКА: start_hard_search (жесткий - по совпадению БК),
      # или start_search_first (1-й версии - самый первый),
      # или start_search (мягкий - 2-я версия, с определением right_profile по макс. кол-ву совпадений),
      ##############################################################################

      #####  Запуск ЖЕСТКОГО поиска
      #search_results = current_user.start_hard_search  ##

      #####  Запуск поиска 1-й версии - самый первый
      #search_results = current_user.start_search_first  #####  Запуск поиска 1-й версии

      #####  Запуск МЯГКОГО поиска - 2-я версия
      search_results = current_user.start_search_soft  ## Запуск поиска с right_profile

      end_search_time = Time.now   # Конец отсечки времени поиска
      @elapsed_search_time = (end_search_time - beg_search_time).round(5) # Длительность поиска - для инфы
      ######## Сбор рез-тов поиска:
      @final_reduced_profiles_hash = search_results[:final_reduced_profiles_hash]
      @final_reduced_relations_hash = search_results[:final_reduced_relations_hash]
      @wide_user_ids_arr = search_results[:wide_user_ids_arr]
      @qty_of_tree_profiles = search_results[:qty_of_tree_profiles] # To view
      @connected_author_arr = search_results[:connected_author_arr]

      @new_profiles_found_arr = search_results[:new_profiles_found_arr]
      @new_profiles_relations_arr = search_results[:new_profiles_relations_arr]

      #######################################################
      ######## Запуск метода выбора достоверных результатов поиска из всего
      ######## полученного множества результатов @new_profiles_found_arr.
      ########
      #

      #######################################################
      ######## Запуск метода формирования итоговых массивов достоверных результатов поиска
      ######## для отображения их на Главной
      # (аналоги старых недостоверных @final_reduced_profiles_hash  и  @final_reduced_relations_hash)
      # для дальнейшего формирования путей


      ################################
      ######## Запуск метода формирования путей
      ######## отображения рез-тов на Главной

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
