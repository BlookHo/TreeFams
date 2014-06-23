class NewProfileController < ApplicationController

  #ПЛАН РАБОТ

  #А) Нужно от Алексея:
  #1.переменные: кому добавляем и кого (в т.ч. sex_id)
  #2.метод создания нового профиля
  #3.массив БК профиля
  #4.заполненные хэши имен
  #
  #Б) потом - сохранение ряда в Tree - я
  #В) методы генерации рядов в ProfileKey - для каждой комбинации (кому-кого) - я
  #
  #Г) Итог: отображение присоединенного профиля на main_page - Алексей
  #в виде пометки у профиля Кому. При нажатии - показ ближнего круга его же, с выделением в БК добавленных профилей
  #При нажатии на добавленного - показ его БК, с возможностью удаления родни из его БК.
  #При этом должен работать метод пометки соответствующих рядов в ProfileKey как удаленных.
  #Для этого ввести новое поле в табл. PrjfileKey - relation_deleted
  #
  #Д) После решения вопроса с сохранением рядов в ProfileKey,
  # отладка поиска с получением расширеных Хэшей - я
  #Е) Одновременно - отображение рез-тов с учетом wide_arr results - Алексей
  #
  #Все. Премия.





  # Получение параметров нового профиля при его добавлении для любого профиля дерева
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def get_profile_params

    form_select_arrays  # Формирование массивов значений для форм ввода типа select.
    session[:sel_names] = {:value => @sel_names, :updated_at => Time.current}

    @sel_names = session[:sel_names][:value]
    @menu_choice = "No choice yet - in new_profile"

    # Выбираем на main_page при добавлении нового родственника
    @profile_id = params[:profile_id].to_i
    @relation_id = params[:relation_id].to_i

    @new_profile_name = params[:profile_name_select] # выбор нового имени
    if !@new_profile_name.blank?
      @new_profile_sex = check_sex_by_name(@new_profile_name) # display sex by name = извлечение пола из введенного имени
    end

    @new_profile_relation = params[:relation_number] # выбор нового relation
    if !@new_profile_relation.blank?
      #@profile_sex = check_sex_by_name(@profile_name) # display sex by name = извлечение пола из введенного имени
    end

    @user_id = current_user.id
    profile_old = Profile.find(@profile_id)
    @name_id = profile_old.name_id
    @sex_id = profile_old.sex_id


    @new_profile_id = Profile.last.id + 1000  # DEBUGG_TO_VIEW # profile_id
    @new_profile_name_id = 300             # DEBUGG_TO_VIEW # Ольга
    @new_profile_sex = 1                   # DEBUGG_TO_VIEW # female
    @new_relation_id = 3                   # DEBUGG_TO_VIEW # мать


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

  # Сохранение нового ряда для добавленного профиля в таблице Tree.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see
  def save_new_tree_row(add_row_to_tree)
      new_tree = Tree.new

      new_tree.user_id        = add_row_to_tree[0] #current_user.id                    # user_id ID От_Профиля (From_Profile)
      new_tree.profile_id     = add_row_to_tree[1] #current_user.profile_id         # profile_id От_Профиля
      new_tree.name_id        = add_row_to_tree[2] #Profile.find(current_user.profile_id).name_id       # name_id От_Профиля

      new_tree.relation_id    = add_row_to_tree[3] #profiles_arr_w_ids[arr_i][4]   # relation_id ID Родства От_Профиля с К_Профилю (To_Profile)

      new_tree.is_profile_id  = add_row_to_tree[4] #profiles_arr_w_ids[arr_i][0] # is_profile_id К_Профиля
      new_tree.is_name_id     = add_row_to_tree[5] #profiles_arr_w_ids[arr_i][2]    # is_name_id К_Профиля
      new_tree.is_sex_id      = add_row_to_tree[6] #profiles_arr_w_ids[arr_i][3]     # is_sex_id К_Профиля

      new_tree.connected      = add_row_to_tree[7] #false           # Пока не Объединено дерево К_Профиля с другим деревом

      new_tree.save
  end

  # Добавление нового ряда к профилю в таблицу Tree
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def make_tree_row(profile_id, sex_id, name_id, new_relation_id, new_profile_id, new_profile_name_id, new_profile_sex)

     tree_arr = session[:tree_arr][:value] if !session[:tree_arr].blank?
     @tree_arr = tree_arr    # DEBUGG TO VIEW

     # Дополнение в Tree
     @add_row_to_tree = []
     @add_row_to_tree = [current_user.id, profile_id, sex_id, name_id, new_relation_id, new_profile_id, new_profile_name_id, new_profile_sex, false]

    # save_new_tree_row(@add_row_to_tree)

     tree_arr << @add_row_to_tree

     # @add_to_tree = [24, 154, 73, 2, 172, 354, 0, false]

    #tree_arr = [[24, 153, 449, 0, 153, 449, 0, false],
    #            [24, 153, 449, 1, 154, 73, 1, false],
    #            [24, 153, 449, 2, 155, 293, 0, false],
    #            [24, 153, 449, 5, 156, 151, 1, false],
    #            [24, 153, 449, 6, 157, 293, 0, false],
    #            [24, 154, 73, 2, 172, 354, 0, false]]      # Дополнение в Tree @add_to_tree

  end

  # Добавление нового ряда в таблицу ProfileKey
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_new_ProfileKey_row(profile_id, name_id, new_relation_id, new_profile_id, new_profile_name_id)

    new_profile_key_row = ProfileKey.new
    new_profile_key_row.user_id = current_user.id              # user_id
    new_profile_key_row.profile_id = profile_id                # profile_id
    new_profile_key_row.name_id = name_id                      # name_id
    new_profile_key_row.relation_id = new_relation_id          # relation_id
    new_profile_key_row.is_profile_id = new_profile_id         # is_profile_id
    new_profile_key_row.is_name_id = new_profile_name_id       # is_name_id

#    new_profile_key_row.save

    one_profile_key_arr = []
    one_profile_key_arr[0] = current_user.id
    one_profile_key_arr[1] = profile_id
    one_profile_key_arr[2] = name_id
    one_profile_key_arr[3] = new_relation_id
    one_profile_key_arr[4] = new_profile_id
    one_profile_key_arr[5] = new_profile_name_id

    @one_profile_key_arr = one_profile_key_arr

  end

  # Добавление нового ряда в таблицу ProfileKey
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_two_main_ProfileKeys_rows(profile_id, sex_id, name_id, new_relation_id, new_profile_id, new_profile_name_id)

    @reverse_relation_id = Relation.where(:relation_id => new_relation_id, :origin_profile_sex_id => sex_id)[0].reverse_relation_id
    # Отношение_Обратное_Новому

    # Добавить ряд Профиль_К_Кому_Добавили - Новое_Отношение - Новый_профиль
    add_new_ProfileKey_row(profile_id, name_id, new_relation_id, new_profile_id, new_profile_name_id)
    @profile_key_arr_added << @one_profile_key_arr   # DEBUGG_TO_VIEW
    # Добавить ряд Новый_профиль - Отношение_Обратное_Новому - Профиль_К_Кому_Добавили
    add_new_ProfileKey_row(new_profile_id, new_profile_name_id, @reverse_relation_id, profile_id, name_id)
    @profile_key_arr_added << @one_profile_key_arr   # DEBUGG_TO_VIEW

  end

  # Добавление Комбинации рядов родства любого вида в ProfileKeys при вводе нового профиля
  # (Хэш_родста, профиль_Кого_добавляем, имя_Кого_добавляем, Пол_родства_того_С_Кем_делаем_новый_ряд)
  # @note GET /
  # @see News
  def fill_relation_rows(relation_name_hash, sex_id, relation_id, new_profile_id, new_profile_name_id)
    if !relation_name_hash.blank?
      # Если существуют члены БК с родством relation_name_hash к Профилю,
      # к кот. добавляем Новый_Профиль
      profiles_arr = relation_name_hash.keys  # profile_id array
      @fathers_profiles_arr = profiles_arr   # DEBUGG_TO_VIEW
      names_arr = relation_name_hash.values  # name_id array
      @fathers_names_arr = names_arr   # DEBUGG_TO_VIEW
      if !names_arr.blank?
        for arr_ind in 0 .. names_arr.length - 1
          # Добавить ряд Мать_Профиля - Муж - Новый_профиль
          add_new_ProfileKey_row(profiles_arr[arr_ind], names_arr[arr_ind], relation_id, new_profile_id, new_profile_name_id)
          @profile_key_arr_added << @one_profile_key_arr   # DEBUGG_TO_VIEW
          # Добавить ряд Новый_профиль - Жена - Мать_Профиля
          current_reverse_relation_id = Relation.where(:relation_id => relation_id, :origin_profile_sex_id => sex_id)[0].reverse_relation_id
          add_new_ProfileKey_row(new_profile_id, new_profile_name_id, current_reverse_relation_id, profiles_arr[arr_ind], names_arr[arr_ind])
          @profile_key_arr_added << @one_profile_key_arr   # DEBUGG_TO_VIEW
        end
      end
    end
  end

  # Добавить ряды в ProfileKeys при вводе Матери
  # в первом элементе мессива - данные об Авторе
  # в последнем элементе мессива - данные о Матери
  # @note GET /
  # @see News
  def add_father_to_ProfileKeys(new_profile_id, new_profile_name_id)
    # Хэш_родста, Пол_родства_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
    fill_relation_rows(@mothers_hash, 0, 7, new_profile_id, new_profile_name_id)
    fill_relation_rows(@brothers_hash, 1, 1, new_profile_id, new_profile_name_id)
    fill_relation_rows(@sisters_hash, 0, 1, new_profile_id, new_profile_name_id)
  end

  # Добавить ряды в ProfileKeys при вводе Матери
  # в первом элементе мессива - данные об Авторе
  # в последнем элементе мессива - данные о Матери
  # @note GET /
  # @see News
  def add_mother_to_ProfileKeys(new_profile_id, new_profile_name_id)
    # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_с_Добавляемым, профиль_Кого_добавляем, имя_Кого_добавляем,
    fill_relation_rows(@fathers_hash, 1, 8, new_profile_id, new_profile_name_id)
    fill_relation_rows(@brothers_hash, 1, 2, new_profile_id, new_profile_name_id)
    fill_relation_rows(@sisters_hash, 0, 2, new_profile_id, new_profile_name_id)
  end

  # Добавить ряды в ProfileKeys при вводе Сына   ## OK
  # в первом элементе мессива - данные об Авторе
  # @note GET /
  # @see News
  def add_son_to_ProfileKeys(new_profile_id, new_profile_name_id)
    # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
    fill_relation_rows(@wives_hash, 0, 3, new_profile_id, new_profile_name_id)
    fill_relation_rows(@husbands_hash, 1, 3, new_profile_id, new_profile_name_id)
    fill_relation_rows(@sons_hash, 1, 5, new_profile_id, new_profile_name_id)
    fill_relation_rows(@daughters_hash, 0, 5, new_profile_id, new_profile_name_id)
  end

  # Добавить ряды в ProfileKeys при вводе Дочи
  # в первом элементе мессива - данные об Авторе    ## OK
  # @note GET /
  # @see News
  def add_daugther_to_ProfileKeys(new_profile_id, new_profile_name_id)
    # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
    fill_relation_rows(@wives_hash, 0, 4, new_profile_id, new_profile_name_id)
    fill_relation_rows(@husbands_hash, 1, 4, new_profile_id, new_profile_name_id)
    fill_relation_rows(@sons_hash, 1, 6, new_profile_id, new_profile_name_id)
    fill_relation_rows(@daughters_hash, 0, 6, new_profile_id, new_profile_name_id)
  end

  # Добавить ряды в ProfileKeys при вводе Брата
  # в первом элементе мессива - данные об Авторе
  # @note GET /
  # @see News
  def add_brother_to_ProfileKeys(new_profile_id, new_profile_name_id)
    # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
    fill_relation_rows(@fathers_hash, 1, 3, new_profile_id, new_profile_name_id)
    fill_relation_rows(@mothers_hash, 0, 3, new_profile_id, new_profile_name_id)
    fill_relation_rows(@brothers_hash, 1, 5, new_profile_id, new_profile_name_id)
    fill_relation_rows(@sisters_hash, 0, 6, new_profile_id, new_profile_name_id)
  end

  # Добавить ряды в ProfileKeys при вводе Сестры
  # в первом элементе мессива - данные об Авторе
  # @note GET /
  # @see News
  def add_sister_to_ProfileKeys(new_profile_id, new_profile_name_id)
    # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
    fill_relation_rows(@fathers_hash, 1, 3, new_profile_id, new_profile_name_id)
    fill_relation_rows(@mothers_hash, 0, 3, new_profile_id, new_profile_name_id)
    fill_relation_rows(@brothers_hash, 1, 5, new_profile_id, new_profile_name_id)
    fill_relation_rows(@sisters_hash, 0, 6, new_profile_id, new_profile_name_id)
  end

  # Добавить ряды в ProfileKeys при вводе Мужа
  # в первом элементе мессива - данные об Авторе
  # @note GET /
  # @see News
  def add_husband_to_ProfileKeys(new_profile_id, new_profile_name_id)
    # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
    fill_relation_rows(@wives_hash, 0, 7, new_profile_id, new_profile_name_id)
    fill_relation_rows(@sons_hash, 1, 1, new_profile_id, new_profile_name_id)
    fill_relation_rows(@daughters_hash, 0, 1, new_profile_id, new_profile_name_id)
  end

  # Добавить ряды в ProfileKeys при вводе Жены
  # в первом элементе мессива - данные об Авторе
  # @note GET /
  # @see News
  def add_wife_to_ProfileKeys(new_profile_id, new_profile_name_id)
    # Хэш_родста, Пол_родства_из_Хэша_того_С_Кем_делаем_новый_ряд, Вид_Родства_Добавляемого_к_Профилю_Хэша, профиль_Кого_добавляем, имя_Кого_добавляем,
    fill_relation_rows(@husbands_hash, 1, 8, new_profile_id, new_profile_name_id)
    fill_relation_rows(@sons_hash, 1, 2, new_profile_id, new_profile_name_id)
    fill_relation_rows(@daughters_hash, 0, 2, new_profile_id, new_profile_name_id)
  end


  # Добавление новых рядов по профилю в таблицу ProfileKey
  # @note GET /
  # @see News
  def  make_profilekeys_rows(relation_id, add_row_to_tree) #relation_id, profile_id, name_id, new_relation_id, new_profile_id, new_profile_name_id, new_profile_sex, sex_id)

    @prev_relation_id = relation_id

    #@add_row_to_tree = add_row_to_tree
    # [current_user.id, @profile_id, @name_id, @new_relation_id, @new_profile_id, @new_profile_name_id, @new_profile_sex, false]

    #user_id = add_row_to_tree[0] # current_user
    profile_id = add_row_to_tree[1]
    sex_id = add_row_to_tree[2]
    name_id = add_row_to_tree[3]
    new_relation_id = add_row_to_tree[4]
    new_profile_id = add_row_to_tree[5]
    new_profile_name_id = add_row_to_tree[6]
    #new_sex_id = add_row_to_tree[7] # no use here

    @profile_key_arr_added = []    # DEBUGG_TO_VIEW
    add_two_main_ProfileKeys_rows(profile_id, sex_id, name_id, new_relation_id, new_profile_id, new_profile_name_id)

    case new_relation_id
      when 1
        add_father_to_ProfileKeys(new_profile_id, new_profile_name_id)
      when 2
        add_mother_to_ProfileKeys(new_profile_id, new_profile_name_id)
       when 3
        add_son_to_ProfileKeys(new_profile_id, new_profile_name_id)
      when 4
        add_daugther_to_ProfileKeys(new_profile_id, new_profile_name_id)
      when 5
        add_brother_to_ProfileKeys(new_profile_id, new_profile_name_id)
      when 6
        add_sister_to_ProfileKeys(new_profile_id, new_profile_name_id)
      when 7
        add_husband_to_ProfileKeys(new_profile_id, new_profile_name_id)
      when 8
        add_wife_to_ProfileKeys(new_profile_id, new_profile_name_id)
      else
        logger.info "======== ERRROR"
    end

  end


  # @note GET /
  # определяются массивы имен всех существующих членов БК
  # @see News
  # @see News
  def get_bk_relative_names

    @fathers_hash = {173 => 454 }
    @mothers_hash = {} #{172 => 354 }
    @brothers_hash = {190 => 400, 191 => 444 }
    @sisters_hash = {1000 => 500, 1001 => 555}
    @wives_hash = {155 => 293 }
    @husbands_hash = {185 => 993 }
    @sons_hash = {156 => 151 }
    @daughters_hash = {153 => 449, 157 => 293 }

  end

  ## Определение наборов допустимых новых отношений new_relations_arr, для relation_id профиля, к которому добавляем новый профиль
  ## @note GET /
  ## @see News
  #def get_acceptable_relations
  #
  #
  #
  #end

  # Добавление нового профиля для любого профиля дерева
  # Запись во все таблицы
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_new_profile

    #get_bk_circle(@profile_id,@relation_id)  # Получить от Алексея

    #get_acceptable_relations # ИД для общей работы

    get_profile_params  # Получить от Алексея из вьюхи добавления нового профиля

    get_bk_relative_names   # Получить от Алексея

    make_new_profile # Получить от Алексея

    make_tree_row(@profile_id, @sex_id, @name_id, @new_relation_id, @new_profile_id, @new_profile_name_id, @new_profile_sex)

    #@add_row_to_tree = [current_user.id, @profile_id, @name_id, @relation_id, @new_profile_id, @new_profile_name_id, @new_profile_sex, false]
    make_profilekeys_rows(@relation_id, @add_row_to_tree)

  end


end
