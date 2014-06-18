class NewProfileController < ApplicationController


  # Получение параметров нового профиля при его добавлении для любого профиля дерева
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_profile_params

    form_select_arrays  # Формирование массивов значений для форм ввода типа select.
    session[:sel_names] = {:value => @sel_names, :updated_at => Time.current}

    @sel_names = session[:sel_names][:value]
    @menu_choice = "No choice yet - in new_profile"


    @new_profile_name = params[:profile_name_select] #
    if !@new_profile_name.blank?
      @new_profile_sex = check_sex_by_name(@new_profile_name) # display sex by name = извлечение пола из введенного имени
    end

    @new_profile_relation = params[:relation_number] #
    if !@new_profile_relation.blank?
      #@profile_sex = check_sex_by_name(@profile_name) # display sex by name = извлечение пола из введенного имени
    end


  end

  # Добавление нового профиля в таблицу Profiles
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def make_new_profile


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
        @new_profile_id = Profile.last.id + 1            # profile_id
    #


  end

  # Добавление нового ряда к профилю в таблицу Tree
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def make_tree_row(profile_id, name_id, new_relation_id, new_profile_id, new_profile_name_id, new_profile_sex)


# Исходное состояние в Tree

 #
 #tree_arr = [[24, 153, 449, 0, 153, 449, 0, false],
 #             [24, 153, 449, 1, 154, 73, 1, false],
 #             [24, 153, 449, 2, 155, 293, 0, false],
 #             [24, 153, 449, 5, 156, 151, 1, false],
 #             [24, 153, 449, 6, 157, 293, 0, false]]
 #
 #session[:tree_arr] = {:value => tree_arr, :updated_at => Time.current}

 tree_arr = session[:tree_arr][:value] if !session[:tree_arr].blank?

 @tree_arr = tree_arr    # DEBUGG TO VIEW

 #Автор   Татьяна
 #Отец    Борис
 #Мать    Мария
 #Брат    Денис
 #Сестра  Мария


 # Дополнение в Tree

 @add_to_tree = []
 @add_to_tree = [current_user.id, profile_id, name_id, new_relation_id, new_profile_id, new_profile_name_id, new_profile_sex, false]

 tree_arr << @add_to_tree

 # @add_to_tree = [24, 154, 73, 2, 172, 354, 0, false]

#tree_arr = [[24, 153, 449, 0, 153, 449, 0, false],
#            [24, 153, 449, 1, 154, 73, 1, false],
#            [24, 153, 449, 2, 155, 293, 0, false],
#            [24, 153, 449, 5, 156, 151, 1, false],
#            [24, 153, 449, 6, 157, 293, 0, false],
#            [24, 154, 73, 2, 172, 354, 0, false]]      # Дополнение в Tree @add_to_tree

    #@one_profile_key_arr: [24, 172, 354, 3, 154, 73]
    #@profile_key_arr: [[24, 154, 73, 2, 172, 354], [24, 172, 354, 3, 154, 73]]

 session[:tree_arr] = {:value => tree_arr, :updated_at => Time.current}


  end


  # Добавление нового ряда в таблицу ProfileKey
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_new_ProfileKey_row(profile_id, name_id, new_relation_id, new_profile_id, new_profile_name_id)

    new_profile_key_row = ProfileKey.new
    new_profile_key_row.user_id = current_user.id                           # user_id
    new_profile_key_row.profile_id = profile_id                                # profile_id

    #new_profile_key_row.name_id = profiles_arr_w_ids[arr_i][2]             ### name_id
    #name_id = Name.find_by_name(profile_keys_arr[row_ind][0]).id                 # name_id
    new_profile_key_row.name_id = name_id                                    # name_id

    new_profile_key_row.relation_id = new_relation_id #profile_keys_arr[row_ind][1]               # relation_id

    #is_profile_id = profile_id_hash.key([profile_keys_arr[row_ind][2], profile_keys_arr[row_ind][3]])
    new_profile_key_row.is_profile_id = new_profile_id  #is_profile_id                        # is_profile_id

    #new_profile_key_row.name_id = profile_keys_arr[row_ind][0]               ### name_id
    #is_name_id = Name.find_by_name(profile_keys_arr[row_ind][2]).id             # is_name_id
    new_profile_key_row.is_name_id = new_profile_name_id  #is_name_id                              # is_name_id

    new_profile_key_row.save

    one_profile_key_arr = []
    one_profile_key_arr[0] = current_user.id
    one_profile_key_arr[1] = profile_id
    one_profile_key_arr[2] = name_id
    one_profile_key_arr[3] = new_relation_id
    one_profile_key_arr[4] = new_profile_id
    one_profile_key_arr[5] = new_profile_name_id

    @one_profile_key_arr = one_profile_key_arr

  end

  # Добавление новых рядов по профилю в таблицу ProfileKey
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def  make_profilekeys_rows(relation_id, profile_id, name_id, new_relation_id, new_profile_id, new_profile_name_id, new_profile_sex, sex_id)


    #def get_bk_circle(user_id, profile_id)
    #
    #  @bk_circle = ProfileKey.where(:user_id => current_user.id, :profile_id => profile_id )
    #
    #end

if relation_id != 0

  # add to out of BK circle
  # может быть, НАДО УСТАНАВЛИВАТЬ ПРИЗНАК - ВНЕ БК,
  # ЧТОБЫ ФОРМИРОВАТЬ ПРАВИЛЬНОЕ ОТОБРАЖЕНИЕ РЕЗ-ТОВ
  # И ФОРМИРОВАТЬ НАИМЕНОВАНИЕ НАЙДЕННОГО ОТНОШЕНИЯ РОДСТВА:
  # НАПРИМЕР, ВМЕСТО ВАША МАТЬ - МАТЬ ОТЦА

    @profile_key_arr = []
    case new_relation_id
      #when 1
      #  add_father_to_ProfileKeys(profiles_array.slice(0..index))
      when 2
        #   Это - тест для поиска вне БК

   # user.id; profile_id; name_id; new_relation_id; new_profile_id; new_profile_name_id

 #       add_mother_to_ProfileKeys(profiles_array.slice(0..index))

        add_new_ProfileKey_row(profile_id, name_id, new_relation_id, new_profile_id, new_profile_name_id)
      @profile_key_arr << @one_profile_key_arr

        @reverse_relation_id = Relation.where(:relation_id => new_relation_id, :origin_profile_sex_id => sex_id)[0].reverse_relation_id

        add_new_ProfileKey_row(new_profile_id, new_profile_name_id, @reverse_relation_id, profile_id, name_id)
      @profile_key_arr << @one_profile_key_arr

      #when 3
      #  add_son_to_ProfileKeys(profiles_array.slice(0..index))
      #when 4
      #  add_daugther_to_ProfileKeys(profiles_array.slice(0..index))
      #when 5
      #  add_brother_to_ProfileKeys(profiles_array.slice(0..index))
      #when 6
      #  add_sister_to_ProfileKeys(profiles_array.slice(0..index))
      #when 7
      #  add_husband_to_ProfileKeys(profiles_array.slice(0..index))
      #when 8
      #  add_wife_to_ProfileKeys(profiles_array.slice(0..index))
      else
        logger.info "======== ERRROR"
    end

else

  # add inside of BK circle


end




  # Дополнение в ProfileKey



  end

  # Добавление нового профиля для любого профиля дерева
  # Запись во все таблицы
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_new_profile

    # Выбираем на main_page при добавлении нового родственника
    @profile_id = params[:profile_id].to_i
    @relation_id = params[:relation_id].to_i
    @user_id = current_user.id
    profile_old = Profile.find(@profile_id)
    @name_id = profile_old.name_id
    @sex_id = profile_old.sex_id
    @new_profile_id = Profile.last.id + 1            # profile_id

    @new_profile_name_id = 354  # Ольга
    @new_profile_sex = 0  # female
    @new_relation_id = 2  # мать


    get_profile_params

    make_new_profile

    #@add_to_tree = [current_user.id, @profile_id, @name_id, @relation_id, @new_profile_id, @new_profile_name_id, @new_profile_sex, false]
    make_tree_row(@profile_id, @name_id, @new_relation_id, @new_profile_id, @new_profile_name_id, @new_profile_sex)

    make_profilekeys_rows(@relation_id, @profile_id, @name_id, @new_relation_id, @new_profile_id, @new_profile_name_id, @new_profile_sex, @sex_id)

  end

end
