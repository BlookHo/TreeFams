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

  # For 92: => {:final_reduced_profiles_hash=>
  # {89=>{749=>[724, 745, 746, 748, 747, 715, 725]},
  # 87=>{749=>[724, 745, 746, 748, 747]},
  # 90=>{749=>[724, 745, 746, 748, 747]},
  # 86=>{749=>[724, 745, 746, 748, 747]},
  # 88=>{749=>[724, 745, 746, 748, 747]},
  # 85=>{749=>[724, 745, 746, 748, 747]}},
  # :final_reduced_relations_hash=>
  # {89=>{749=>[0, 1, 2, 5, 5, 8, 3]},
  # 87=>{749=>[0, 1, 2, 5, 5]},
  # 90=>{749=>[0, 1, 2, 5, 5]},
  # 86=>{749=>[0, 1, 2, 5, 5]},
  # 88=>{749=>[0, 1, 2, 5, 5]},
  # 85=>{749=>[0, 1, 2, 5, 5]}},
  # :wide_user_ids_arr=>[89, 87, 90, 86, 88, 85], :connected_author_arr=>[92], :qty_of_tree_profiles=>7}

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


      ################################
      ######## Основной поиск от дерева Автора (вместе с соединенными)
      ######## среди других деревьев в ProfileKeys.
      beg_search_time = Time.now   # Начало отсечки времени поиска
      #search_profiles_tree_match(@connected_users_arr, @new_tree_arr)    # Старый вариант запуска поиска
      search_results = current_user.start_search  #####  Запуск поиска
      end_search_time = Time.now   # Конец отсечки времени поиска
      @elapsed_search_time = (end_search_time - beg_search_time).round(5) # Длительность поиска - для инфы
      ######## Сбор рез-тов поиска:
      @final_reduced_profiles_hash = search_results[:final_reduced_profiles_hash]
      @final_reduced_relations_hash = search_results[:final_reduced_relations_hash]
      @wide_user_ids_arr = search_results[:wide_user_ids_arr]
      @qty_of_tree_profiles = search_results[:qty_of_tree_profiles] # To view
      @connected_author_arr = search_results[:connected_author_arr]


      # Для отладки # DEBUGG_TO_VIEW
      @author_id = current_user.id # DEBUGG_TO_VIEW
      @author_connected_tree_arr = get_connected_users_tree(@connected_author_arr) # DEBUGG_TO_VIEW
      @len_author_tree = @author_connected_tree_arr.length  if !@author_connected_tree_arr.blank?  # DEBUGG_TO_VIEW


      ################################
      ######## Запуск метода формирования путей
      ######## отображения рез-тов на Главной
      make_search_results_paths(@final_reduced_profiles_hash) #
      #make_search_results_paths({}) # # DEBUGG_TO_VIEW

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


#  # Поиск совпадений для одного из профилей БК current_user
#  # Берем параметр: profile_id из массива  = profiles_tree_arr[tree_index][6].
#  # @note GET /
#  # @param admin_page [Integer] опциональный номер страницы
#  # @see News
#  # На выходе: @all_match_arr по данному виду родства
# def get_relation_match(connected_users, from_profile_searching, profile_id_searched, relation_id_searched)
#
#   found_trees_hash = Hash.new     #{ 0 => []}
#   all_relation_match_arr = []     #
#
#   wide_found_profiles_hash = Hash.new  #
#   wide_found_relations_hash = Hash.new  #
#
#   #all_profile_rows = ProfileKey.where(:user_id => current_user.id).where(:profile_id => profile_id_searched).select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id)
#   all_profile_rows = ProfileKey.where(:user_id => connected_users).where(:profile_id => profile_id_searched).select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id)
#   # поиск массива записей ближнего круга для каждого профиля в дереве Юзера
#   @from_profile_searching = from_profile_searching  # DEBUGG_TO_VIEW
#   @profile_searched = profile_id_searched   # DEBUGG_TO_VIEW
#   @relation_searched = relation_id_searched   # DEBUGG TO VIEW
#   @all_profile_rows = all_profile_rows   # DEBUGG_TO_VIEW
#
#   if !all_profile_rows.blank?
#     @all_profile_rows_len = all_profile_rows.length if !all_profile_rows.blank? #_DEBUGG_TO_VIEW
#     # размер ближнего круга профиля в дереве current_user.id
#     all_profile_rows.each do |relation_row|
##       relation_match_arr = ProfileKey.where.not(user_id: current_user.id).where(:name_id => relation_row.name_id).where(:relation_id => relation_row.relation_id).where(:is_name_id => relation_row.is_name_id).select(:id, :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
#        relation_match_arr = ProfileKey.where.not(user_id: connected_users).where(:name_id => relation_row.name_id, :relation_id => relation_row.relation_id, :is_name_id => relation_row.is_name_id).select(:id, :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
#        if !relation_match_arr.blank?
#          row_arr = []
#          relation_match_arr.each do |tree_row|
#            row_arr[0] = tree_row.user_id              # ID Автора
#            row_arr[1] = tree_row.profile_id           # ID От_Профиля
#            row_arr[2] = tree_row.name_id              # ID Имени От_Профиля
#            row_arr[3] = tree_row.relation_id          # ID Родства От_Профиля с другим К_Профиля
#            row_arr[4] = tree_row.is_profile_id        # ID другого К_Профиля
#            row_arr[5] = tree_row.is_name_id           # ID Имени К_Профиля
#
#            all_relation_match_arr << row_arr
#            row_arr = []
#
#            fill_hash(found_trees_hash, tree_row.user_id) # наполнение хэша найденными user_id = trees и частотой их обнаружения
#
#            wide_found_profiles_hash.merge!({tree_row.user_id  => {from_profile_searching => [tree_row.profile_id]} } ) # наполнение хэша найденными profile_id
#            wide_found_relations_hash.merge!({tree_row.user_id  => {from_profile_searching => [relation_id_searched]} } ) # наполнение хэша найденными relation_id
#
#          end
#          @relation_match_arr = relation_match_arr   # DEBUGG TO VIEW
#        else
#         # @relation_match_arr = ["relation_match_arr"]   # DEBUGG TO VIEW
#     #     @relation_match_arr = relation_match_arr   # DEBUGG TO VIEW
#        end
#     end
#     @relation_id_searched_arr << relation_id_searched  #_DEBUGG_TO_VIEW
#
#     ##### НАСТРОЙКИ результатов поиска
#
#     # Исключение тех user_id, по которым не все запросы дали результат внутри Ближнего круга
#     # Остаются те user_id, в которых найдены совпавшие профили.
#     # На выходе ХЭШ: {user_id  => кол-во успешных поисков } - должно быть равно (не меньше) длине массива
#     # всех видов отношений в блжнем круге для разыскиваемого профиля.
#     if relation_id_searched != 0 # Для всех профилей, кот-е не явл. current_user
#       # Исключение из результатов поиска
#       #if all_profile_rows.length > 3
#
# #      found_trees_hash.delete_if {|key, value|  value < all_profile_rows.length - 1 } #
#       #found_trees_hash.delete_if {|key, value|  value < all_profile_rows.length } #
#       # all_profile_rows.length = размер ближнего круга профиля в дереве current_user.id
#       #else
#       #  # Если маленький БК
#       #  found_trees_hash.delete_if {|key, value|  value <= 2  }  # 1 .. 3 = НАСТРОЙКА!!
#       #end
#
#     else
#       #if all_profile_rows.length <= 3
#       #  found_trees_hash.delete_if {|key, value|  value <= 0 } #all_profile_rows.length  }  # 1 .. 3 = НАСТРОЙКА!!
#       #  # Исключение из результатов поиска групп с малым кол-вом совпадений в других деревьях or value < all_profile_rows.length
#       #else
#       #  # Если маленький БК
#       #  found_trees_hash.delete_if {|key, value|  value <= 0  }  # 1 .. 2 = НАСТРОЙКА!!
#       #end
#     end
#
#   end
#
#
#   ##### КОРРЕКТИРОВКА результатов поиска
#
#   wide_found_profiles_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
#   # На выходе ХЭШ: {user_id  => profile_id} - найденные деревья с найденным профилем в них.
#   @wide_found_profiles_hash = wide_found_profiles_hash
#
#   wide_found_relations_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
#
#   ##### ИТОГОВЫЕ РАСШИРЕННЫЕ результаты поиска
#   @all_wide_match_profiles_arr << wide_found_profiles_hash if !wide_found_profiles_hash.blank? # Заполнение выходного массива хэшей
#   @all_wide_match_relations_arr << wide_found_relations_hash if !wide_found_relations_hash.empty? # Заполнение выходного массива хэшей
#
#   #@found_profiles_hash = found_profiles_hash # DEBUGG TO VIEW
#   #@found_relations_hash = found_relations_hash # DEBUGG TO VIEW
#   @found_trees_hash = found_trees_hash # DEBUGG TO VIEW
#   @all_profile_rows = all_profile_rows   # DEBUGG TO VIEW
#   @all_relation_match_arr = all_relation_match_arr   ## DEBUGG TO VIEW
#
#   @wide_found_profiles_hash = wide_found_profiles_hash # DEBUGG TO VIEW
#   @wide_found_relations_hash = wide_found_relations_hash # DEBUGG TO VIEW
#
# end
#
# Основной поиск по дереву Автора - Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  #def search_profiles_tree_match(connected_users_arr, tree_arr)
  #
  #  @tree_arr_len = tree_arr.length  # DEBUGG TO VIEW
  #  @tree_to_display = []
  #  @tree_row = []
  #
  #  ##### Будущие результаты поиска
  #  @all_match_trees_arr = []     # Массив совпадений деревьев
  #  @all_match_profiles_arr = []  # Массив совпадений профилей
  #  @all_match_relations_arr = []  # Массив совпадений отношений
  #  #####
  #  @all_wide_match_profiles_arr = []     # Широкий Массив совпадений профилей
  #  @all_wide_match_relations_arr = []     # Широкий Массив совпадений отношений
  #
  #  @relation_id_searched_arr = []     #_DEBUGG_TO_VIEW Ok
  #
  #  if !tree_arr.blank?
  #    for tree_index in 0 .. tree_arr.length-1
  #  #    32, 212, 419, 1, 213, 196, 1, false]
  #  #         1        3   4
  #      from_profile_searching = tree_arr[tree_index][1] # От какого профиля осущ-ся Поиск
  #      relation_id_searched = tree_arr[tree_index][3] # relation_id К_Профиля
  #      profile_id_searched = tree_arr[tree_index][4] # Поиск по ID К_Профиля
  #      get_relation_match(connected_users_arr, from_profile_searching, profile_id_searched, relation_id_searched)       # На выходе: @all_match_arr по данному дереву
  #    end
  #  end
  #
  #  #### расширенные РЕЗУЛЬТАТЫ ПОИСКА:
  #  if !@all_wide_match_profiles_arr.blank?
  #    #### PROFILES
  #    all_wide_match_hash = join_arr_of_hashes(@all_wide_match_profiles_arr) if !@all_wide_match_profiles_arr.blank?  # Если найдены совпадения - в @all_match_arr
  #    @all_wide_match_hash = all_wide_match_hash  #_DEBUGG_TO_VIEW
  #    @all_wide_match_arr_sorted = Hash[all_wide_match_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend
  #
  #    @complete_hash = make_complete_hash(@all_wide_match_arr_sorted)  #_DEBUGG_TO_VIEW
  #
  #    # @final_reduced_profiles_hash = итоговый Хаш массивов найденных профилей
  #    # Здесь - исключаем из результатов - те, в кот-х найдено всего одно совпадение
  #    # см. метод reduce_hash
  #    # То же - симметрично повторяется для relations
  #    @final_reduced_profiles_hash = reduce_hash(make_complete_hash(@all_wide_match_arr_sorted))  # TO VIEW
  #
  #    # @wide_user_ids_arr = итоговый массив найденных деревьев
  #    @wide_user_ids_arr = @final_reduced_profiles_hash.keys.flatten  # TO VIEW
  #
  #    # @wide_profile_ids_arr = итоговый массив хашей найденных профилей
  #    @wide_profile_ids_arr = @final_reduced_profiles_hash.values.flatten # TO VIEW
  #
  #    # @wide_amount_of_profiles = Подсчет количества найденных Профилей в массиве Хэшей
  #    @wide_amount_of_profiles = count_profiles_in_hash(@wide_profile_ids_arr)
  #
  #    #### RELATIONS
  #    all_wide_match_relations_hash = join_arr_of_hashes(@all_wide_match_relations_arr) if !@all_wide_match_relations_arr.blank?  # Если найдены совпадения - в @all_match_arr
  #    @all_wide_match_relations_sorted = Hash[all_wide_match_relations_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend
  #
  #    #@complete_relations_hash = make_complete_hash(@all_wide_match_relations_sorted)
  #
  #    @final_reduced_relations_hash = reduce_hash(make_complete_hash(@all_wide_match_relations_sorted))  # TO VIEW
  #
  #    #@relation_ids_arr = @all_match_relations_sorted.values.flatten # TO VIEW
  #    #@all_match_relations_hash = all_match_relations_hash # TO VIEW
  #    #count_users_found(profile_ids_arr) # TO VIEW
  #
  #  else
  #    @final_reduced_profiles_hash = []
  #    @final_reduced_relations_hash = []
  #    @wide_user_ids_arr = []
  #  end
  #
  #end
  #


  ## Формирование полного щирокого Хаша
  # @note GET
  # На входе:
  # На выходе: @ Итоговый  ХЭШ
  #def make_complete_hash(input_hash)
  #  complete_hash = Hash.new     #
  #  if !input_hash.blank?
  #    input_hash.each do |k, v|
  #      if v.size == 1
  #        complete_hash.merge!({k => v}) # наполнение хэша найденными profile_id
  #      else
  #        rez_hash = Hash.new     #
  #        v.each do |one_arr|
  #          if !one_arr.blank?
  #            merged_hash = rez_hash.merge({one_arr[0] => one_arr[1]}){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
  #            rez_hash = merged_hash
  #          end
  #        end
  #        complete_hash.merge!(k => rez_hash) # искомый хэш
  #        # с найденнымии profile_id, распределенными по связанным с ними profile_id
  #      end
  #    end
  #  end
  #  return complete_hash
  #end
  #
  #
  ## НАСТРОЙКА СОКРАЩЕНИЯ РЕ-В ПОИСКА: УДАЛЕНИЕ КОРОТКИХ СОВПАДЕНИЙ
  ## ЦИФРА В УСЛОВИИ if - ЭТО РАЗМЕР СОВПАДЕНИЙ В ДЕРЕВЕ ПРИ ПОИСКЕ.
  ## # Исключение тех рез-тов поиска, где найден всего один профиль
  ## @note GET
  ## На входе:
  ## На выходе: @ Итоговый  ХЭШ
  #def reduce_hash(input_hash)
  #  reduced_hash = Hash.new
  #  input_hash.each do |k, v|
  #    if v.values.flatten.size > 1  # НАСТРОЙКА УДАЛЕНИЯ МАЛЫХ СОВПАДЕНИЙ
  #      reduced_hash.merge!({k => v}) #
  #    end
  #  end
  #  return reduced_hash
  #end
  #
  ## Слияние массива Хэшей без потери значений { (key = user_id) => (value = profile_id) }
  ## Получение упорядоченного Хэша: {user_id  -> [ profile_id, profile_id, profile_id ...]}
  ## @note GET
  ## На входе: массив хэшей: [{user_id -> profile_id, ... , user_id -> profile_id}, ..., {user_id -> profile_id, ... , user_id -> profile_id} ]
  ## На выходе: @all_match_hash Итоговый упорядоченный ХЭШ
  ## @param admin_page [Integer]
  #def join_arr_of_hashes(all_match_hash_arr)
  #  final_merged_hash = Hash.new
  #  for h_ind in 0 .. all_match_hash_arr.length - 1
  #    next_hash = all_match_hash_arr[h_ind]
  #    merged_hash = final_merged_hash.merge(next_hash){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
  #    final_merged_hash = merged_hash
  #  end
  #  #@all_match_hash = final_merged_hash  # DEBUGG TO VIEW
  #  return final_merged_hash
  #end
  #
  ## Преобразование Хэша хэшей в Хэш массивов вместо хэшей
  ## На входе: Из: { user_id => { profile_id => [profile_id, profile_id ,..]}, user_id => { profile_id => [profile_id, profile_id ,..]}
  ## На выходе в Хэш, где значения - массивы:
  ## { user_id => [ profile_id, [profile_id, profile_id ,..]], user_id => [profile_id, [profile_id, profile_id ,..]]
  ## @note GET
  ## final_hash_arr = Итоговый ХЭШ
  #def hash_hash_to_hash_arr(input_hash_hash)
  #  final_hash_arr = Hash.new
  #  ind = 0
  #  input_hash_hash.values.each do |one_hash|
  #    new_hash_merging = final_hash_arr.merge({input_hash_hash.keys[ind] => one_hash.to_a.flatten(1)} )
  #    final_hash_arr = new_hash_merging
  #    ind += 1
  #  end
  #  return final_hash_arr
  #end
  #
  #
  ## Подсчет количества найденных Профилей в массиве Хэшей
  ## На входе: массив Хэшей профилей input_arr_hash
  ## На выходе: amount_found Кол-во
  #def count_profiles_in_hash(input_arr_hash)
  #  amount_found = 0
  #  input_arr_hash.each do |k|
  #    amount_found = amount_found + k.values.flatten.size
  #  end
  #  return amount_found
  #end
  #
  ## Подсчет количества найденных Юзеров среди найденных Профилей
  ## @note GET
  ## На входе: массив профилей all_profiles_arr: profile_id
  ## На выходе: @count Кол-во Юзеров
  ## @param admin_page [Integer] опциональный номер страницы
  ## @see News
  #def count_users_found(all_profiles_arr)
  #  @count = 0
  #  @users_ids_arr = []
  #  for ind in 0 .. all_profiles_arr.length - 1
  #    user_found_id = User.find_by_profile_id(all_profiles_arr[ind])
  #    if !user_found_id.blank?
  #      @count += 1
  #      @users_ids_arr << user_found_id.id  # user_id среди найденных профилей
  #    end
  #  end
  #end
  #



end
