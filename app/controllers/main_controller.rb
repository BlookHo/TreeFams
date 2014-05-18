class MainController < ApplicationController
 # include MainHelper  #


 # Отображение дерева Юзера в табличной форме.
 # @note GET /
 # @param admin_page [Integer] опциональный номер страницы
 # @see News
  def get_user_tree

    if user_signed_in?
      user_profiles_tree = ProfileKey.where(:user_id => current_user.id).where(:profile_id => User.find(current_user.id).profile_id).select(:id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)

      row_arr = []
      profiles_tree_arr = []

      user_profiles_tree.each do |tree_row|
        row_arr[0] = tree_row.id              # ID в Дереве
        row_arr[1] = tree_row.profile_id      # ID Профиля
        row_arr[2] = tree_row.name_id      # ID Имя Профиля
        row_arr[3] = Name.find(tree_row.name_id).name   # Имя Профиля
        row_arr[4] = Profile.find(tree_row.profile_id).sex_id         # Пол Профиля
        row_arr[5] = tree_row.relation_id         # ID Родства Профиля с Автором
        row_arr[6] = tree_row.is_profile_id      # ID Профиля Родственника
        row_arr[7] = tree_row.is_name_id      # ID Имя Профиля
        row_arr[8] = Name.find(tree_row.is_name_id).name   # Имя Родственника
 #       row_arr[9] = tree_row.connected           # Объединено

        profiles_tree_arr << row_arr
        row_arr = []
      end

      session[:profiles_tree_arr] = {:value => profiles_tree_arr, :updated_at => Time.current}

    end

  end


# Отображение дерева Юзера в табличной форме.
# @note GET /
# @param admin_page [Integer] опциональный номер страницы
# @see News
  def main_page

    get_user_tree # Получение массива дерева текущего Юзера

    if user_signed_in?

      #user_tree = Tree.where(:user_id => current_user.id).select(:id, :profile_id, :relation_id, :connected)
      #
      #row_arr = []
      #tree_arr = []
      #
      #user_tree.each do |tree_row|
      #  row_arr[0] = tree_row.id              # ID в Дереве
      #  row_arr[1] = tree_row.profile_id      # ID Профиля
      #  row_arr[2] = Profile.find(tree_row.profile_id).name_id      # ID Имени Профиля
      #  row_arr[3] = Name.find(Profile.find(tree_row.profile_id).name_id).name   # Имя Профиля
      #  row_arr[4] = Profile.find(tree_row.profile_id).sex_id         # Пол Профиля
      #  row_arr[5] = tree_row.relation_id         # ID Родства Профиля с Автором
      #  row_arr[6] = tree_row.connected           # Объединено
      #
      #  tree_arr << row_arr
      #  row_arr = []
      #
      #end
      #
      #session[:tree_arr] = {:value => tree_arr, :updated_at => Time.current}
      #@tree_arr = tree_arr    # DEBUGG TO VIEW

      beg_search_time = Time.now   # Начало отсечки времени поиска

      search_profiles_tree_match    # Основной поиск по дереву Автора - Юзера
                                    # среди деревьев в таблице ProfileKeys.

      end_search_time = Time.now   # Конец отсечки времени поиска
      @elapsed_search_time = (end_search_time - beg_search_time).round(5)

    end

  end


  # Поиск совпадений для одного из профилей БК current_user
  # Берем параметр: profile_id из массива profiles_tree_arr[tree_index][6].
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  # На выходе: @all_match_arr по данному виду родства
 def get_relation_match(profile_id_searched)

   found_trees_hash = Hash.new  #
   found_profiles_hash = Hash.new  #
   all_relation_match_arr = []  #
   all_relation_rows = ProfileKey.where(:user_id => current_user.id).where(:profile_id => profile_id_searched).select(:user_id, :name_id, :relation_id, :is_name_id, :profile_id) #.pluck(:relation_id)#.where(:is_name_id => profiles_tree_arr[tree_index][8]).select(:id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
   if !all_relation_rows.blank?
     @all_relation_rows_len = all_relation_rows.length if !all_relation_rows.blank? ##
     all_relation_rows.each do |father_row|
        relation_match_arr = ProfileKey.where.not(user_id: current_user.id).where(:name_id => father_row.name_id).where(:relation_id => father_row.relation_id).where(:is_name_id => father_row.is_name_id).select(:user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id)
        row_arr = []
        relation_match_arr.each do |tree_row|
          row_arr[0] = tree_row.user_id              # ID в Дереве
          row_arr[1] = tree_row.profile_id      # ID Профиля
          row_arr[2] = tree_row.name_id      # ID Имени Профиля
          row_arr[3] = tree_row.relation_id   # ID Родства Профиля
          row_arr[4] = tree_row.is_profile_id         # ID Родства Профиля с Автором
          row_arr[5] = tree_row.is_name_id           # Объединено

          all_relation_match_arr << row_arr
          row_arr = []

          fill_hash(found_trees_hash, tree_row.user_id) # наполнение хэша найденными user_id = trees и частотой их обнаружения
          found_profiles_hash.merge!({tree_row.user_id  => tree_row.profile_id}) #

        end
        @relation_match_arr = relation_match_arr   # DEBUGG TO VIEW

     end

     # select exclude hash Class

     found_trees_hash.delete_if {|key, value| value < all_relation_rows.length } # Исключение из результатов поиска
     # тех user_id, по которым не все запросы дали результат внутри Ближнего круга
     # Остаются те user_id, в которых найдены совпавшие профили.
     # На выходе ХЭШ: {user_id  => кол-во успешных поисков } - должно быть равно длине массива
     # всех видов отношений в блжнем круге для разыскиваемого профиля.
    found_profiles_hash.delete_if {|key, value| !found_trees_hash.keys.include?(key)} # Убираем из хэша профилей
     # те user_id, которые удалены из хэша деревьев
     # На выходе ХЭШ: {user_id  => profile_id} - найденные деревья с найденным профилем в них.

   end
   @all_match_arr << found_profiles_hash if !found_profiles_hash.blank? # Заполнение выходного массива хэшей


   @found_profiles_hash = found_profiles_hash # DEBUGG TO VIEW
   @found_trees_hash = found_trees_hash # DEBUGG TO VIEW
   @all_relation_rows = all_relation_rows   # DEBUGG TO VIEW
   @all_relation_match_arr = all_relation_match_arr   ## DEBUGG TO VIEW

 end

# Основной поиск по дереву Автора - Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def search_profiles_tree_match

    profiles_tree_arr = session[:profiles_tree_arr][:value] if !session[:profiles_tree_arr].blank?
    @profiles_tree_arr = profiles_tree_arr    # DEBUGG TO VIEW
    @profiles_tree_arr_len = profiles_tree_arr.length  # DEBUGG TO VIEW

    @all_match_arr = []   # Массив совпадений всех родных с Автором
    if !profiles_tree_arr.blank?

      for tree_index in 0 .. profiles_tree_arr.length-1
        relation = profiles_tree_arr[tree_index][5]  # Выбор очередности поиска в зависимости от relation
        @relation = relation  # DEBUGG TO VIEW
        @name = profiles_tree_arr[tree_index][7]
        case relation # Определение вида поиска по значению relation внутри БК current_user

          when 1    # "father"
            @search_profiles_relation = "father"   # DEBUGG TO VIEW
            get_relation_match(profiles_tree_arr[tree_index][6])  # На выходе: @all_match_arr по данному виду родства

          when 2    # "mother"
            @search_profiles_relation = "mother"   # DEBUGG TO VIEW
            get_relation_match(profiles_tree_arr[tree_index][6])

          when 3   # "son"
            @search_profiles_relation = "son"   # DEBUGG TO VIEW
            get_relation_match(profiles_tree_arr[tree_index][6])

          when 4   # "daughter"
            @search_profiles_relation = "daughter"   # DEBUGG TO VIEW
            get_relation_match(profiles_tree_arr[tree_index][6])

          when 5  # "brother"
            @search_profiles_relation = "brother"   # DEBUGG TO VIEW
            get_relation_match(profiles_tree_arr[tree_index][6])

          when 6   # "sister"
            @search_profiles_relation = "sister"   # DEBUGG TO VIEW
            get_relation_match(profiles_tree_arr[tree_index][6])

          when 7   # "husband"
            @search_profiles_relation = "husband"   # DEBUGG TO VIEW
            get_relation_match(profiles_tree_arr[tree_index][6])

          when 8   # "wife"
            @search_profiles_relation = "wife"   # DEBUGG TO VIEW
            get_relation_match(profiles_tree_arr[tree_index][6])

          else
            @search_profiles_relation = "ERROR: no relation in tree profile"
            # TODO: call error_processing

        end

      end

    end

#    @all_match_arr = @all_match_arr  # Вычисляется поэтапно в каждом get_relation_match

    @all_match_hash = Hash.new   # Вычисляется в join_arr_of_hashes
    join_arr_of_hashes(@all_match_arr) if !@all_match_arr.blank?
    @user_ids_arr = @all_match_hash.keys
    @profile_ids_arr = @all_match_hash.values.flatten
    @amount_of_profiles = @profile_ids_arr.size if !@profile_ids_arr.blank?

    count_users_found(@profile_ids_arr)

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
    @all_match_hash = final_merged_hash
  end

  # Подсчет количества найденных Юзеров среди найденных Профилей
  # @note GET
  # На входе: массив профилей all_profiles_arr: profile_id
  # На выходе: @count Кол-во Юзеров
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def count_users_found(all_profiles_arr)
    @count = 0
    @users_id_arr = []
    for ind in 0 .. all_profiles_arr.length - 1
      user_found_id = User.find_by_profile_id(all_profiles_arr[ind])
      if !user_found_id.blank?
        @count += 1
        @users_id_arr << user_found_id.id  # user_id среди найденных профилей
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

    @sel_names = session[:sel_names][:value]
    @menu_choice = "No choice yet - in new_profile"

    @add_to_profile = params[:add_to_profile] #
    if !@add_to_profile.blank?
      #@profile_sex = check_sex_by_name(@profile_name) # display sex by name = извлечение пола из введенного имени
    end

    @profile_name = params[:profile_name_select] #
    if !@profile_name.blank?
      @profile_sex = check_sex_by_name(@profile_name) # display sex by name = извлечение пола из введенного имени
    end

    @profile_relation = params[:relation_number] #
    if !@profile_relation.blank?
      #@profile_sex = check_sex_by_name(@profile_name) # display sex by name = извлечение пола из введенного имени
    end

    #new_profile = Profile.new
    #new_profile.user_id = current_user.id  # user_id - берем после регистрации
    #new_profile.email = current_user.email # user regged email
    #new_profile.name_id = Name.find_by_name(profiles_array[arr_i][1]).id  # name_id
    #if @profile_sex # sex_id
    #  new_profile.sex_id = 1    # sex_id - MALE
    #else
    #  new_profile.sex_id = 0    # sex_id - FEMALE
    #end
    #new_profile.save
    #
    #@new_profile_id = new_profile.id             # profile_id


  end




end
