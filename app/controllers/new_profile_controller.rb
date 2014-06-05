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
  def make_tree_row


# Дополнение в Tree

@tree_arr =
    [[4, 22, 506, 0, 22, 506, 0, false]]

#[4, 22, 506, 1, 23, 45, 1, false],

# при этом, при вводе нового профиля: Денису добавляем Жену Викторию
# в табл. Tree записываем old_profile_id  has  relation_id  is  new_profile_id.
# т.е.  () Муж Денис имеет жену Викторию- это и записываем в profiles_tree_arr.


  end

  # Добавление новых рядов по профилю в таблицу ProfileKey
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def make_profilekeys_rows

    # Дополнение в ProfileKey

    @profiles_tree_arr =
        [[ 22, 506, "Татьяна", 0, 1, 23, 45, "Борис", true],
         [ 22, 506, "Татьяна", 0, 2, 24, 453, "Мария", true],
         [ 22, 506, "Татьяна", 0, 5, 25, 97, "Денис", true],
         [ 22, 506, "Татьяна", 0, 6, 26, 453, "Мария", true]]
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


  end

  # Добавление нового профиля для любого профиля дерева
  # Запись во все таблицы
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_new_profile

    get_profile_params

    make_new_profile

    make_tree_row

    make_profilekeys_rows

  end

end