class MainController < ApplicationController
 # include MainHelper  #

  before_filter :check_user

  def check_user
    redirect_to :root if !current_user
  end


 # Отображение дерева Юзера в табличной форме.
 # @note GET /
 # @param admin_page [Integer] опциональный номер страницы
 # @see News
 def get_user_tree(user_id)


      user_tree = Tree.where(:user_id => user_id)
      row_arr = []
      tree_arr = []

      user_tree.each do |tree_row|
        row_arr[0] = tree_row.user_id              # user_id ID От_Профиля
        row_arr[1] = tree_row.profile_id           # ID От_Профиля (From_Profile)
        row_arr[2] = tree_row.name_id              # name_id ID От_Профиля
        row_arr[3] = tree_row.relation_id          # ID Родства От_Профиля с К_Профилю (To_Profile)
        row_arr[4] = tree_row.is_profile_id        # ID К_Профиля
        row_arr[5] = tree_row.is_name_id           # name_id К_Профиля
        row_arr[6] = tree_row.is_sex_id            # sex К_Профиля
        row_arr[7] = tree_row.connected            # Объединено дерево К_Профиля с другим деревом

        tree_arr << row_arr
        row_arr = []

      end

      session[:tree_arr] = {:value => tree_arr, :updated_at => Time.current}
      @tree_arr = tree_arr    # DEBUGG TO VIEW


 end


# Поиск совпадений по дереву Юзера
# Основной метод
# @note GET /
# @param admin_page [Integer] опциональный номер страницы
# @see News
 def main_page
   @circle = current_user.profile.circle(current_user.id)

    if current_user
# Для отладки add_profile - исключаем этот метод
     get_user_tree(current_user.id) # Получение массива дерева текущего Юзера из Tree

     ## @bk_arr = circle_as_array(current_user.id)
     # @bk_arr = current_user.profile.circle_as_array(current_user.id)
     # target_profile_id = 155
     # @circle = Profile.find(target_profile_id).circle_as_array(current_user.id)
     #@circle_hash = current_user.profile.circle_as_hash(current_user.id)#
     #@circle_hash_mothers = current_user.profile.mothers_hash(current_user.id)#

      beg_search_time = Time.now   # Начало отсечки времени поиска

      search_profiles_tree_match    # Основной поиск по дереву Автора среди деревьев в ProfileKeys.

      end_search_time = Time.now   # Конец отсечки времени поиска
      @elapsed_search_time = (end_search_time - beg_search_time).round(5)
    end

 end

  # Поиск совпадений для одного из профилей БК current_user
  # Берем параметр: profile_id из массива  = profiles_tree_arr[tree_index][6].
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # На выходе: @all_match_arr по данному виду родства
 def get_relation_match(from_profile_searching, profile_id_searched, relation_id_searched)

   found_trees_hash = Hash.new     #{ 0 => []}
   found_profiles_hash = Hash.new  #
   found_relations_hash = Hash.new  #
   all_relation_match_arr = []     #

   wide_found_profiles_hash = Hash.new  #
   wide_found_relations_hash = Hash.new  #


   all_profile_rows = ProfileKey.where(:user_id => current_user.id).where(:profile_id => profile_id_searched).select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id)
   # поиск массива записей ближнего круга для каждого профиля в дереве Юзера
   @from_profile_searching = from_profile_searching  # DEBUGG_TO_VIEW
   @profile_searched = profile_id_searched   # DEBUGG_TO_VIEW
   @relation_searched = relation_id_searched   # DEBUGG TO VIEW
   @all_profile_rows = all_profile_rows   # DEBUGG_TO_VIEW

   if !all_profile_rows.blank?
     @all_profile_rows_len = all_profile_rows.length if !all_profile_rows.blank? #_DEBUGG_TO_VIEW
     # размер ближнего круга профиля в дереве current_user.id
     all_profile_rows.each do |relation_row|
        relation_match_arr = ProfileKey.where.not(user_id: current_user.id).where(:name_id => relation_row.name_id).where(:relation_id => relation_row.relation_id).where(:is_name_id => relation_row.is_name_id).select(:user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
        if !relation_match_arr.blank?
          row_arr = []
          relation_match_arr.each do |tree_row|
            row_arr[0] = tree_row.user_id              # ID Автора
            row_arr[1] = tree_row.profile_id           # ID От_Профиля
            row_arr[2] = tree_row.name_id              # ID Имени От_Профиля
            row_arr[3] = tree_row.relation_id          # ID Родства От_Профиля с другим К_Профиля
            row_arr[4] = tree_row.is_profile_id        # ID другого К_Профиля
            row_arr[5] = tree_row.is_name_id           # ID Имени К_Профиля

            all_relation_match_arr << row_arr
            row_arr = []

            fill_hash(found_trees_hash, tree_row.user_id) # наполнение хэша найденными user_id = trees и частотой их обнаружения
            found_profiles_hash.merge!({tree_row.user_id  => [tree_row.profile_id]}) # наполнение хэша найденными profile_id
            found_relations_hash.merge!({tree_row.user_id  => [relation_id_searched]}) # наполнение хэша найденными relation_id

            wide_found_profiles_hash.merge!({tree_row.user_id  => {from_profile_searching => [tree_row.profile_id]} } ) # наполнение хэша найденными profile_id
            wide_found_relations_hash.merge!({tree_row.user_id  => {from_profile_searching => [relation_id_searched]} } ) # наполнение хэша найденными relation_id

            #@test_hash_profiles = { 23 => {51 => [51,52,53,54], 54 => [58,59]}, 22 => {31 => [31,32,33,34], 34 =>[38,39] } }



          end
          @relation_match_arr = relation_match_arr   # DEBUGG TO VIEW
        else
          @relation_match_arr = ["relation_match_arr"]   # DEBUGG TO VIEW
        end
     end
     @relation_id_searched_arr << relation_id_searched  #_DEBUGG_TO_VIEW

     ##### НАСТРОЙКИ результатов поиска

     # Исключение тех user_id, по которым не все запросы дали результат внутри Ближнего круга
     # Остаются те user_id, в которых найдены совпавшие профили.
     # На выходе ХЭШ: {user_id  => кол-во успешных поисков } - должно быть равно (не меньше) длине массива
     # всех видов отношений в блжнем круге для разыскиваемого профиля.
     if relation_id_searched != 0 # Для всех профилей, кот-е не явл. current_user
       # Исключение из результатов поиска
#       if all_profile_rows.length > 3

       #found_trees_hash.delete_if {|key, value|  value < all_profile_rows.length - 1 } #
       found_trees_hash.delete_if {|key, value|  value < all_profile_rows.length } #
       # all_profile_rows.length = размер ближнего круга профиля в дереве current_user.id
       #else
       #  # Если маленький БК
       #  found_trees_hash.delete_if {|key, value|  value <= 2  }  # 1 .. 3 = НАСТРОЙКА!!
       #end

     else
       if all_profile_rows.length >= 3
         found_trees_hash.delete_if {|key, value|  value <= 2 } #all_profile_rows.length  }  # 1 .. 3 = НАСТРОЙКА!!
         # Исключение из результатов поиска групп с малым кол-вом совпадений в других деревьях or value < all_profile_rows.length
       else
         # Если маленький БК
         found_trees_hash.delete_if {|key, value|  value <= 1  }  # 1 .. 2 = НАСТРОЙКА!!
       end
     end

   end


   ##### КОРРЕКТИРОВКА результатов поиска
   found_profiles_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
   # На выходе ХЭШ: {user_id  => profile_id} - найденные деревья с найденным профилем в них.
   @test_found_profiles_hash = found_profiles_hash

   found_relations_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
   # На выходе ХЭШ: {user_id  => relation_id} - найденные деревья с найденным relation_id.

   wide_found_profiles_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
   # На выходе ХЭШ: {user_id  => profile_id} - найденные деревья с найденным профилем в них.
   @test_wide_found_profiles_hash = found_profiles_hash

   wide_found_relations_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей

   ##### ИТОГОВЫЕ результаты поиска
   #@all_match_trees_arr << found_trees_hash if !found_trees_hash.blank? # Заполнение выходного массива хэшей
   @all_match_profiles_arr << found_profiles_hash if !found_profiles_hash.blank? # Заполнение выходного массива хэшей
   @all_match_relations_arr << found_relations_hash if !found_relations_hash.empty? # Заполнение выходного массива хэшей
   #####

   ##### ИТОГОВЫЕ РАСШИРЕННЫЕ результаты поиска
   @all_wide_match_profiles_arr << wide_found_profiles_hash if !found_profiles_hash.blank? # Заполнение выходного массива хэшей
   @all_wide_match_relations_arr << wide_found_relations_hash if !found_relations_hash.empty? # Заполнение выходного массива хэшей

   @found_profiles_hash = found_profiles_hash # DEBUGG TO VIEW
   @found_relations_hash = found_relations_hash # DEBUGG TO VIEW
   @found_trees_hash = found_trees_hash # DEBUGG TO VIEW
   @all_profile_rows = all_profile_rows   # DEBUGG TO VIEW
   @all_relation_match_arr = all_relation_match_arr   ## DEBUGG TO VIEW

   @wide_found_profiles_hash = wide_found_profiles_hash # DEBUGG TO VIEW
   @wide_found_relations_hash = wide_found_relations_hash # DEBUGG TO VIEW

 end

# Основной поиск по дереву Автора - Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_profiles_tree_match

    tree_arr = session[:tree_arr][:value] if !session[:tree_arr].blank?

    # true/false - признак ближнего круга автора дерева   # ??? м.б. не нужно

    @tree_arr = tree_arr    # DEBUGG TO VIEW
    @tree_arr_len = tree_arr.length  # DEBUGG TO VIEW
    @tree_to_display = []
    @tree_row = []

    # НОВАЯ СТРУКТУРА РЕЗУЛЬТАТОВ ПОИСКА
    # - ТЕПЕРЬ С ВЛОЖЕННЫМИ РЕЗУЛЬТАТАМИ ПРИ ДОБАВЛЕННЫХ ПРОФИЛЯХ
    # @all_wide_match_profiles_arr:
    #@test_arr_hash_profiles = [{22=>{153=>[141]}, 23=>{153=>[151]}},
    #                       {23=>{153=>[146]}},
    #                       {22=>{153=>[140]}, 23=>{153=>[149]}},
    #                       {22=>{153=>[138]}, 23=>{153=>[150]}},
    #                       {22=>{153=>[142]}, 23=>{153=>[152]}},
    #                       {21=>{154=>[133]}, 23=>{154=>[148]}}]

# @all_wide_match_arr_sorted
#    @test_hash_arr_profiles =
#    {23=>[[153, [151]],[], [154, [148]],[155, [188]],[167, [19966]],[154, [166]],[167, [22166]],[154, [167]], [153, [146]], [153, [149]], [153, [150]], [153, [152]]],
#     22=>[[153, [141]],[], [153, [140]], [155, [111]], [155, [111]], [153, [138]], [153, [142]]],
#     21=>{154=>[133]}}


# @complete_hash:
#    @new_test_hash_profiles = {23=>{153=>[151, 146, 149, 150, 152], # have to be
#                                    154=>[148]},
#
#                               22=>{153=>[141, 140, 138, 142]},
#                               21=>{154=>[133]}}


#    @tree_arr.each do |item|
#      @tree_row[0] = item[3] # relation
#   #   profile_name = Name.find(item[5]).name#.mb_chars.capitalize # name
#      @tree_row[1] = Name.find(item[5]).name.mb_chars.capitalize
#      @tree_row[2] = item[4]
#      @tree_row[3] = current_user.id
##      @tree_row = link_to "Добавить родственника", add_new_profile_path,  onclick: "alert('Добавить нового родственника к relation_id: #{item[3]}, profile_id: #{item[4]}, в дереве user_id: #{current_user.id}')"
#
#      @tree_to_display << @tree_row
#      @tree_row = []
#    end

    ##### Будущие результаты поиска
    @all_match_trees_arr = []     # Массив совпадений деревьев
    @all_match_profiles_arr = []  # Массив совпадений профилей
    @all_match_relations_arr = []  # Массив совпадений отношений
    #####
    @all_wide_match_profiles_arr = []     # Широкий Массив совпадений профилей
    @all_wide_match_relations_arr = []     # Широкий Массив совпадений отношений

    @relation_id_searched_arr = []     #_DEBUGG_TO_VIEW Ok

    if !tree_arr.blank?
      for tree_index in 0 .. tree_arr.length-1

#if User.find_by_profile_id(tree_arr[tree_index][1]).id == tree_arr[tree_index][0]
#  @search_way = "In BK"
#else
#  @search_way = "Outside BK"
#end

        from_profile_searching = tree_arr[tree_index][1] # От какого профиля осущ-ся Поиск
        profile_id_searched = tree_arr[tree_index][4] # Поиск по ID К_Профиля
        relation_id_searched = tree_arr[tree_index][3] # relation_id К_Профиля
        get_relation_match(from_profile_searching, profile_id_searched, relation_id_searched)       # На выходе: @all_match_arr по данному дереву
      end
    end

    if !@all_match_profiles_arr.blank?

      #### PROFILES
      all_match_hash = join_arr_of_hashes(@all_match_profiles_arr) if !@all_match_profiles_arr.blank?  # Если найдены совпадения - в @all_match_arr
      #@all_match_hash = all_match_hash  #_DEBUGG_TO_VIEW

      @all_match_arr_sorted = Hash[all_match_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      ##### НАСТРОЙКИ результатов поиска:

      # КОРРЕКТИРОВАТЬ ВМЕСТЕ С @all_match_relations_sorted !!!!
      #@all_match_arr_sorted.delete_if {|key, value| value.size == 1 }  #
      # Исключение тех рез-тов поиска, где найден всего один профиль
      @user_ids_arr = @all_match_arr_sorted.keys  # TO VIEW
      profile_ids_arr = @all_match_arr_sorted.values.flatten # TO VIEW
      @amount_of_profiles = profile_ids_arr.size if !profile_ids_arr.blank? # TO VIEW

      #### RELATIONS
      all_match_relations_hash = join_arr_of_hashes(@all_match_relations_arr) if !@all_match_relations_arr.blank?  # Если найдены совпадения - в @all_match_arr
      @all_match_relations_sorted = Hash[all_match_relations_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      ##### НАСТРОЙКИ результатов поиска
      #@all_match_relations_sorted.delete_if {|key, value| value .size == 1 }  #
      # Исключение тех рез-тов поиска (отношения), где найден всего один профиль

      @relation_ids_arr = @all_match_relations_sorted.values.flatten # TO VIEW
           @all_match_relations_hash = all_match_relations_hash # TO VIEW
      count_users_found(profile_ids_arr) # TO VIEW
    end

    #### расширенные РЕЗУЛЬТАТЫ ПОИСКА:
    if !@all_wide_match_profiles_arr.blank?
      #### PROFILES
      all_wide_match_hash = join_arr_of_hashes(@all_wide_match_profiles_arr) if !@all_wide_match_profiles_arr.blank?  # Если найдены совпадения - в @all_match_arr
      @all_wide_match_hash = all_wide_match_hash  #_DEBUGG_TO_VIEW
      @all_wide_match_arr_sorted = Hash[all_wide_match_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      @complete_hash = make_complete_hash(@all_wide_match_arr_sorted)  #_DEBUGG_TO_VIEW

      # @final_reduced_profiles_hash = итоговый Хаш массивов найденных профилей
      @final_reduced_profiles_hash = reduce_hash(make_complete_hash(@all_wide_match_arr_sorted))  # TO VIEW

      # @wide_user_ids_arr = итоговый массив найденных деревьев
      @wide_user_ids_arr = @final_reduced_profiles_hash.keys.flatten  # TO VIEW

      # @wide_profile_ids_arr = итоговый массив хашей найденных профилей
      @wide_profile_ids_arr = @final_reduced_profiles_hash.values.flatten # TO VIEW

      # @wide_amount_of_profiles = Подсчет количества найденных Профилей в массиве Хэшей
      @wide_amount_of_profiles = count_profiles_in_hash(@wide_profile_ids_arr)

      #### RELATIONS
      all_wide_match_relations_hash = join_arr_of_hashes(@all_wide_match_relations_arr) if !@all_wide_match_relations_arr.blank?  # Если найдены совпадения - в @all_match_arr
      @all_wide_match_relations_sorted = Hash[all_wide_match_relations_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

      #@complete_relations_hash = make_complete_hash(@all_wide_match_relations_sorted)

      @final_reduced_relations_hash = reduce_hash(make_complete_hash(@all_wide_match_relations_sorted))  # TO VIEW

      #@relation_ids_arr = @all_match_relations_sorted.values.flatten # TO VIEW
      #@all_match_relations_hash = all_match_relations_hash # TO VIEW
      #count_users_found(profile_ids_arr) # TO VIEW

    end

  end



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

  # Подтверждение совпадения родственника в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def match_approval

    @session_id = request.session_options[:id]    # ?

    if user_signed_in?

      @new_approved_qty = 3
      @total_approved_qty = @@approved_match_qty + @new_approved_qty
      @rest_to_approve = @@match_qty - @total_approved_qty

      @triplex_arr = []
      make_one_triplex_arr(current_user.id,@triplex_arr,nil,1,2)   # @triplex_arr - ready!

      # Поиск братьев/сестер по триплекс-массиву
      # У братьев/сестер - те же отец и мать.
      # [profile_id, sex_id, name_id, relation_id]
      # @triplex_arr: [[22, 0, 506, nil], [23, 1, 45, 1], [24, 0, 453, 2]]
      search_bros_sist(@triplex_arr)  # найдены общие отцы с потенциальными братьями/сестрами

    end

  end

  # Отображение меню действий для родственника в дереве Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def relative_menu

    @menu_choice = "No choice yet - in Relative_menu"

  end







end
