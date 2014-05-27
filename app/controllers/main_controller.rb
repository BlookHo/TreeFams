class MainController < ApplicationController
 # include MainHelper  #


 # Отображение дерева Юзера в табличной форме.
 # @note GET /
 # @param admin_page [Integer] опциональный номер страницы
 # @see News
 def get_user_tree

#@profiles_tree_arr:
#[[22, 506, "Татьяна", 0, 1, 23, 45, "Борис"],
# [22, 506, "Татьяна", 0, 2, 24, 453, "Мария"],
# [22, 506, "Татьяна", 0, 5, 25, 97, "Денис"],
# [22, 506, "Татьяна", 0, 6, 26, 453, "Мария"]]
#tree_arr =
#    [[4, 22, 506, 0, 22, 506, 0, false]]

     #[4, 22, 506, 1, 23, 45, 1, false],
     #[4, 22, 506, 2, 24, 453, 0, false],
     #[4, 22, 506, 5, 25, 97, 1, false],
     #[4, 22, 506, 6, 26, 453, 0, false]]

     ##  [[4, 22, 506, 0, 22, 506, 0, false]]
#    [[2, 7, 97, 0, 7, 97, 1, false]]
      #  [[3, 15, 45, 0, 15, 45, 1, false]]
     #   [4, 22, 506, 1, 23, 45, 1, false],
#    [[7, 40, 45, 0, 40, 45, 1, false]]
    #   [4, 22, 506, 2, 24, 453, 0, false],
   #[[11, 69, 265, 0, 69, 265, 1, false], # Сергей
   # [11, 69, 265, 1, 70, 123, 1, false]] # Иван
        #   [4, 22, 506, 5, 25, 97, 1, false],
#   [4, 22, 506, 6, 26, 453, 0, false],
#   [4, 25, 97, 8, 84, 371, 0, false]]


  if user_signed_in?

      user_tree = Tree.where(:user_id => current_user.id)#.select(:id, :profile_id, :relation_id, :connected)
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


 end


# Поиск совпадений по дереву Юзера
# Основной метод
# @note GET /
# @param admin_page [Integer] опциональный номер страницы
# @see News
 def main_page

    if user_signed_in?
      get_user_tree # Получение массива дерева текущего Юзера из Tree

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
 def get_relation_match(profile_id_searched, relation_id_searched)

   found_trees_hash = Hash.new     #{ 0 => []}
   found_profiles_hash = Hash.new  #
   all_relation_match_arr = []     #

   all_profile_rows = ProfileKey.where(:user_id => current_user.id).where(:profile_id => profile_id_searched).select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id)
   # поиск массива записей ближнего круга для Юзера

   @profile_searched = profile_id_searched   # DEBUGG TO VIEW
   @relation_searched = relation_id_searched   # DEBUGG TO VIEW
   if !all_profile_rows.blank?
     @all_profile_rows_len = all_profile_rows.length if !all_profile_rows.blank? # DEBUGG TO VIEW
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
          end
          @relation_match_arr = relation_match_arr   # DEBUGG TO VIEW
        end
     end

     if relation_id_searched != 0 # Для всех профилей, кот-е не явл. current_user
       found_trees_hash.delete_if {|key, value|  value < all_profile_rows.length }  # Исключение из результатов поиска
     else
       found_trees_hash.delete_if {|key, value|  value <= 2 }  # 2 = НАСТРОЙКА!!
       # Исключение из результатов поиска групп с малым кол-вом совпадений - ТОЛЬКО для current_user!
     end
     # Исключение тех user_id, по которым не все запросы дали результат внутри Ближнего круга
     # Остаются те user_id, в которых найдены совпавшие профили.
     # На выходе ХЭШ: {user_id  => кол-во успешных поисков } - должно быть равно (не меньше) длине массива
     # всех видов отношений в блжнем круге для разыскиваемого профиля.
     found_profiles_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
     # те user_id, которые удалены из хэша деревьев
     # На выходе ХЭШ: {user_id  => profile_id} - найденные деревья с найденным профилем в них.
   end

   ##### результаты поиска
   @all_match_trees_arr << found_trees_hash if !found_trees_hash.blank? # Заполнение выходного массива хэшей
   @all_match_profiles_arr << found_profiles_hash if !found_profiles_hash.blank? # Заполнение выходного массива хэшей
   #####

   @found_profiles_hash = found_profiles_hash # DEBUGG TO VIEW
   @found_trees_hash = found_trees_hash # DEBUGG TO VIEW
   @all_profile_rows = all_profile_rows   # DEBUGG TO VIEW
   @all_relation_match_arr = all_relation_match_arr   ## DEBUGG TO VIEW

 end

# Основной поиск по дереву Автора - Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_profiles_tree_match

    tree_arr = session[:tree_arr][:value] if !session[:tree_arr].blank?

    #profiles_tree_arr =
    #    [[ 22, 506, "Татьяна", 0, 1, 23, 45, "Борис", true],
    #     [ 22, 506, "Татьяна", 0, 2, 24, 453, "Мария", true],
    #     [ 22, 506, "Татьяна", 0, 5, 25, 97, "Денис", true],
    #     [ 22, 506, "Татьяна", 0, 6, 26, 453, "Мария", true]
         #   Это - тест для поиска вне БК
         # к Денису - добавляем новый профиль: Жену Виктория
#         [80, 25, 97, "Денис", 1, 8, 84, 371, "Виктория", false],
         # к Денису - добавляем новый профиль: Дочь Анна
#        [81, 25, 97, "Денис", 1, 4, 85, 352, "Анна", false]
                                         # к Денису - меняем новый профиль: Дочь Елена
                                 #       ,[81, 25, 97, "Денис", 1, 4, 85, 395, "Елена", false]

#        ]

    # при этом, при вводе нового профиля: Денису добавляем Жену Викторию
    # в табл. Tree записываем old_profile_id  has  relation_id  is  new_profile_id.
    # т.е.  () Муж Денис имеет жену Викторию- это и записываем в profiles_tree_arr.

    # true/false - признак ближнего круга автора дерева   # ??? м.б. не нужно

    @tree_arr = tree_arr    # DEBUGG TO VIEW
    @tree_arr_len = tree_arr.length  # DEBUGG TO VIEW

    ##### Будущие результаты поиска
    @all_match_trees_arr = []     # Массив совпадений деревьев
    @all_match_profiles_arr = []  # Массив совпадений профилей
    #####

    if !tree_arr.blank?
      for tree_index in 0 .. tree_arr.length-1
        profile_id_searched = tree_arr[tree_index][4] # Поиск по ID К_Профиля
        relation_id_searched = tree_arr[tree_index][3] # relation_id К_Профиля
        get_relation_match(profile_id_searched, relation_id_searched)       # На выходе: @all_match_arr по данному дереву
      end
    end

    all_match_hash = join_arr_of_hashes(@all_match_profiles_arr) if !@all_match_profiles_arr.blank?  # Если найдены совпадения - в @all_match_arr

    @all_match_arr_sorted = Hash[all_match_hash.sort_by { |k, v| v.size }.reverse] #  Ok Sorting of input hash by values.size arrays Descend

    @user_ids_arr = @all_match_arr_sorted.keys  # TO VIEW
    @profile_ids_arr = @all_match_arr_sorted.values.flatten # TO VIEW
    @amount_of_profiles = @profile_ids_arr.size if !@profile_ids_arr.blank? # TO VIEW

    count_users_found(@profile_ids_arr) # TO VIEW

  end

  # Слияние массива Хэшей без потери значений { (key = user_id) => (value = profile_id) }
  # Получение упорядоченного Хэша: {user_id  -> [ profile_id, profile_id, profile_id ...]}
  # @note GET
  # На входе: массив хэшей: [{user_id -> profile_id, ... , user_id -> profile_id}, ..., {user_id -> profile_id, ... , user_id -> profile_id} ]
  # На выходе: @all_match_hash Итоговый упорядоченный ХЭШ
  # @param admin_page [Integer]
  def join_arr_of_hashes(all_match_hash_arr)
    final_merged_hash = all_match_hash_arr[0]  # 1-st hash
    for h_ind in 1 .. all_match_hash_arr.length - 1
      next_hash = all_match_hash_arr[h_ind]
      merged_hash = final_merged_hash.merge(next_hash){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
      final_merged_hash = merged_hash
    end
    #@all_match_hash = final_merged_hash  # DEBUGG TO VIEW
    return final_merged_hash
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

  # Добавление нового профиля для любого профиля дерева
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_new_profile

    form_select_arrays  # Формирование массивов значений для форм ввода типа select.
    session[:sel_names] = {:value => @sel_names, :updated_at => Time.current}

    @sel_names = session[:sel_names][:value]
    @menu_choice = "No choice yet - in new_profile"

    @add_to_profile = params[:add_to_profile] #
    if !@add_to_profile.blank?
      #@profile_sex = check_sex_by_name(@profile_name) # display sex by name = извлечение пола из введенного имени
    end

    @new_profile_name = params[:profile_name_select] #
    if !@new_profile_name.blank?
      @new_profile_sex = check_sex_by_name(@new_profile_name) # display sex by name = извлечение пола из введенного имени
    end

    @new_profile_relation = params[:relation_number] #
    if !@new_profile_relation.blank?
      #@profile_sex = check_sex_by_name(@profile_name) # display sex by name = извлечение пола из введенного имени
    end

    # Новый profile_id


#    new_profile = Profile.new
#    new_profile.user_id = current_user.id  # user_id - берем после регистрации
#    new_profile.email = current_user.email # user regged email
#    new_profile.name_id = Name.find_by_name(profiles_array[arr_i][1]).id  # name_id
#    if @profile_sex # sex_id
#      new_profile.sex_id = 1    # sex_id - MALE
#    else
#      new_profile.sex_id = 0    # sex_id - FEMALE
#    end
#    new_profile.save
#
#    @new_profile_id = new_profile.id             # profile_id
#



     # Дополнение в ProfileKey

     #profiles_tree_arr =
     #    [[ 22, 506, "Татьяна", 0, 1, 23, 45, "Борис", true],
     #     [ 22, 506, "Татьяна", 0, 2, 24, 453, "Мария", true],
     #     [ 22, 506, "Татьяна", 0, 5, 25, 97, "Денис", true],
     #     [ 22, 506, "Татьяна", 0, 6, 26, 453, "Мария", true]
     #   Это - тест для поиска вне БК
     # к Денису - добавляем новый профиль: Жену Виктория
     #         [80, 25, 97, "Денис", 1, 8, 84, 371, "Виктория", false],
     # к Денису - добавляем новый профиль: Дочь Анна
     #        [81, 25, 97, "Денис", 1, 4, 85, 352, "Анна", false]
     # к Денису - меняем новый профиль: Дочь Елена
     #       ,[81, 25, 97, "Денис", 1, 4, 85, 395, "Елена", false]

     #        ]


#
#    new_ProfileKeys_arr = []
#    add_profile_name_id = Profile
#
#    # add new_ProfileKeys rows
#    new_ProfileKeys_arr << [@add_to_profile, new_profile.name_id, @profile_relation, @new_profile_id, 4]
#    new_ProfileKeys_arr << [@profile_relation, new_profile.name_id, @add_to_profile, @new_profile_id, 4]
#    @new_ProfileKeys_arr = new_ProfileKeys_arr # DEBUGG TO VIEW
#
#    # Нужны правила формирования обратных relations, в завис-ти от прямого relation, пола и т.д.
#
#    new_profile_key_row = ProfileKey.new
#    new_profile_key_row.user_id = current_user.id                           # user_id
#    new_profile_key_row.profile_id = @new_profile_id                                # profile_id
#
#    name_id = Name.find_by_name(@add_to_profile).id         # name_id
#    new_profile_key_row.name_id = name_id                                    # name_id
#
##    is_profile_id = profile_id_hash.key([profile_keys_arr[row_ind][2], profile_keys_arr[row_ind][3]])
#    new_profile_key_row.is_profile_id = @profile_relation                        # is_profile_id
#
#    is_name_id = Name.find_by_name(@profile_name).id             # is_name_id
#    new_profile_key_row.is_name_id = is_name_id                              # is_name_id
#
#    new_profile_key_row.save



# Дополнение в Tree

#tree_arr =
#    [[4, 22, 506, 0, 22, 506, 0, false]]

#[4, 22, 506, 1, 23, 45, 1, false],

# при этом, при вводе нового профиля: Денису добавляем Жену Викторию
# в табл. Tree записываем old_profile_id  has  relation_id  is  new_profile_id.
# т.е.  () Муж Денис имеет жену Викторию- это и записываем в profiles_tree_arr.



  end




end
