class StartController < ApplicationController



  ####  ENTER PROFILE  ########################

  def enter_myself

    ####  DEBUGG PLACE  ########################

    #    any method        # DEBUGG:

    ####  DEBUGG PLACE  ########################

    #### ZEROUVING OF TABLES FOR DEBUGG ########################

    #Tree.delete_all
    #Tree.reset_pk_sequence
    #
    #Profile.delete_all
    #Profile.reset_pk_sequence
    #
    #User.delete_all
    #User.reset_pk_sequence


    form_select_arrays  # Формирование массивов значений для форм ввода типа select.

    session[:sel_names] = {:value => @sel_names, :updated_at => Time.current}
    session[:sel_names_male] = {:value => @sel_names_male, :updated_at => Time.current}
    session[:sel_names_female] = {:value => @sel_names_female, :updated_at => Time.current}
  end

  def enter_father
    profiles_array = session[:profiles_array][:value]
    @sel_names_male = session[:sel_names_male][:value]
  end

  def enter_mother
    profiles_array = session[:profiles_array][:value]
    @sel_names_female = session[:sel_names_female][:value]
  end

  def enter_brother
    profiles_array = session[:profiles_array][:value]
    @sel_names_male = session[:sel_names_male][:value]
  end

  def enter_sister
    profiles_array = session[:profiles_array][:value]
    @sel_names_female = session[:sel_names_female][:value]
  end

  def enter_son
    profiles_array = session[:profiles_array][:value]
    @sel_names_male = session[:sel_names_male][:value]
  end

  def enter_daugther
    profiles_array = session[:profiles_array][:value]
    @sel_names_female = session[:sel_names_female][:value]
  end

  def enter_husband
    profiles_array = session[:profiles_array][:value]
    @sel_names_male = session[:sel_names_male][:value]
  end

  def enter_wife
    profiles_array = session[:profiles_array][:value]
    @sel_names_female = session[:sel_names_female][:value]
  end


  ####  CHECK PROFILE TO BE ENTERED ########################
  def check_husband_or_wife
    user_sex = session[:user_sex][:value]
    if user_sex == 1    # = true -> User = Male
      @render_name = 'start/enter_wife'
      # redirect_to enter_wife_path
    else
      @render_name = 'start/enter_husband'
      # redirect_to enter_husband_path
    end
   # @render_name
  end


  # Добавить ряды в ProfileKeys при вводе Отца
  # в первом элементе мессива - данные об Авторе
  # в последнем элементе мессива - данные об Отце
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_father_to_ProfileKeys(profiles_array)

    #profiles_array = [[nil, author_name, true], [1, father_name, true]].
    author_ProfileKeys_arr = []  # Массив для записи в ProfileKeys рядов о father
    father_ProfileKeys_arr = []  # Массив для записи в ProfileKeys рядов о father

    author_name = profiles_array[0][1]
    author_sex = profiles_array[0][2]
    father_name = profiles_array[1][1]

    # add Author rows
    author_ProfileKeys_arr << [author_name, 1, father_name, 1]
    @author_ProfileKeys_arr = author_ProfileKeys_arr # DEBUGG TO VIEW

    # add Father rows
    if author_sex
      father_ProfileKeys_arr << [father_name, 3, author_name, 0]
    else
      father_ProfileKeys_arr << [father_name, 4, author_name, 0]
    end
    @father_ProfileKeys_arr = father_ProfileKeys_arr # DEBUGG TO VIEW

    session[:author_ProfileKeys_arr] = {:value => author_ProfileKeys_arr, :updated_at => Time.current}
    session[:father_ProfileKeys_arr] = {:value => father_ProfileKeys_arr, :updated_at => Time.current}

  end

  # Добавить ряды в ProfileKeys при вводе Матери
  # в первом элементе мессива - данные об Авторе
  # в последнем элементе мессива - данные о Матери
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_mother_to_ProfileKeys(profiles_array)

    #profiles_array = [[nil, "author_name", true], [1, "mother_name", true], [2, "mother_name", false]]
    author_ProfileKeys_arr = session[:author_ProfileKeys_arr][:value]
    father_ProfileKeys_arr = session[:father_ProfileKeys_arr][:value]
    mother_ProfileKeys_arr = []  # Массив для записи в ProfileKeys рядов о mother
    brother_ProfileKeys_arr = []  #
    brothers_names_arr = []  # Имена братьев
    sister_ProfileKeys_arr = []  #
    sisters_names_arr = []  # Имена сестер

    author_name = profiles_array[0][1]
    author_sex =  profiles_array[0][2]
    father_name = profiles_array[1][1]
    mother_name = profiles_array[2][1]

    # add Author rows
    author_ProfileKeys_arr << [author_name, 2, mother_name, 2]
    @author_ProfileKeys_arr = author_ProfileKeys_arr # DEBUGG TO VIEW

    # add Father rows
    father_ProfileKeys_arr << [father_name, 8, mother_name, 2]
    @father_ProfileKeys_arr = father_ProfileKeys_arr # DEBUGG TO VIEW

    # add Mother rows
    mother_ProfileKeys_arr << [mother_name, 7, father_name, 1]
    if author_sex
      mother_ProfileKeys_arr << [mother_name, 3, author_name, 0]
    else
      mother_ProfileKeys_arr << [mother_name, 4, author_name, 0]
    end
    @mother_ProfileKeys_arr = mother_ProfileKeys_arr # DEBUGG TO VIEW

    session[:author_ProfileKeys_arr] = {:value => author_ProfileKeys_arr, :updated_at => Time.current}
    session[:father_ProfileKeys_arr] = {:value => father_ProfileKeys_arr, :updated_at => Time.current}
    session[:mother_ProfileKeys_arr] = {:value => mother_ProfileKeys_arr, :updated_at => Time.current}
    session[:brother_ProfileKeys_arr] = {:value => brother_ProfileKeys_arr, :updated_at => Time.current}
    session[:brothers_names_arr] = {:value => brothers_names_arr, :updated_at => Time.current}
    session[:sister_ProfileKeys_arr] = {:value => sister_ProfileKeys_arr, :updated_at => Time.current}
    session[:sisters_names_arr] = {:value => sisters_names_arr, :updated_at => Time.current}

  end

  # Добавить ряды в ProfileKeys при вводе Брата
  # в первом элементе массива - данные об Авторе
  # в последнем элементе массива - данные о Брате
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_brother_to_ProfileKeys(profiles_array)

    #profiles_array = [[nil, "author_name", true], [1, "mother_name", true], [2, "mother_name", false]]
    author_ProfileKeys_arr = session[:author_ProfileKeys_arr][:value]
    father_ProfileKeys_arr = session[:father_ProfileKeys_arr][:value]
    mother_ProfileKeys_arr = session[:mother_ProfileKeys_arr][:value]  #
    brother_ProfileKeys_arr = session[:brother_ProfileKeys_arr][:value]  #
    brothers_names_arr = session[:brothers_names_arr][:value]  # Имена братьев
    sister_ProfileKeys_arr = session[:sister_ProfileKeys_arr][:value]  #
    sisters_names_arr = session[:sisters_names_arr][:value]  #
    #sister_ProfileKeys_arr = []  #
    #sisters_names_arr = []  # Имена сестер

    author_name = profiles_array[0][1]
    author_sex = profiles_array[0][2]
    father_name = profiles_array[1][1]
    mother_name = profiles_array[2][1]

    profiles_array_length = profiles_array.length
    brother_name = profiles_array[profiles_array_length-1][1] ## Name of last brother

    # add Author rows
    author_ProfileKeys_arr << [author_name, 5, brother_name, 5]
    @author_ProfileKeys_arr = author_ProfileKeys_arr # DEBUGG TO VIEW

    # add Father rows
    father_ProfileKeys_arr << [father_name, 3, brother_name, 5]
    @father_ProfileKeys_arr = father_ProfileKeys_arr # DEBUGG TO VIEW

    # add Mother rows
    mother_ProfileKeys_arr << [mother_name, 3, brother_name, 5]
    @mother_ProfileKeys_arr = mother_ProfileKeys_arr # DEBUGG TO VIEW

    # add Brother rows
    brother_ProfileKeys_arr << [brother_name, 1, father_name, 1]
    brother_ProfileKeys_arr << [brother_name, 2, mother_name, 2]
    if author_sex
      brother_ProfileKeys_arr << [brother_name, 5, author_name, 0]
    else
      brother_ProfileKeys_arr << [brother_name, 6, author_name, 0]
    end

    if !brothers_names_arr.blank?
      for arr_ind in 0 .. brothers_names_arr.length - 1
        brother_ProfileKeys_arr << [brothers_names_arr[arr_ind], 5, brother_name, 5] # Сохранение пары братьев в один массив Братьев
        brother_ProfileKeys_arr << [brother_name, 5, brothers_names_arr[arr_ind], 5] # Сохранение пары братьев в один массив Братьев
      end
    end

    brothers_names_arr << brother_name
    @brother_ProfileKeys_arr = brother_ProfileKeys_arr # DEBUGG TO VIEW

    @brothers_names_arr = brothers_names_arr # DEBUGG TO VIEW

    session[:author_ProfileKeys_arr] = {:value => author_ProfileKeys_arr, :updated_at => Time.current}
    session[:father_ProfileKeys_arr] = {:value => father_ProfileKeys_arr, :updated_at => Time.current}
    session[:mother_ProfileKeys_arr] = {:value => mother_ProfileKeys_arr, :updated_at => Time.current}
    session[:brother_ProfileKeys_arr] = {:value => brother_ProfileKeys_arr, :updated_at => Time.current}
    session[:brothers_names_arr] = {:value => brothers_names_arr, :updated_at => Time.current}
    session[:sister_ProfileKeys_arr] = {:value => sister_ProfileKeys_arr, :updated_at => Time.current}
    session[:sisters_names_arr] = {:value => sisters_names_arr, :updated_at => Time.current}

  end

  # Добавить ряды в ProfileKeys при вводе Сестры
  # в первом элементе массива - данные об Авторе
  # в последнем элементе массива - данные о Сестры
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_sister_to_ProfileKeys(profiles_array)

    #profiles_array = [[nil, "author_name", true], [1, "mother_name", true], [2, "mother_name", false]]
    author_ProfileKeys_arr = session[:author_ProfileKeys_arr][:value]
    father_ProfileKeys_arr = session[:father_ProfileKeys_arr][:value]
    mother_ProfileKeys_arr = session[:mother_ProfileKeys_arr][:value]  #
    brother_ProfileKeys_arr = session[:brother_ProfileKeys_arr][:value]
    brothers_names_arr = session[:brothers_names_arr][:value]  #
    @brothers_names_arr = brothers_names_arr # DEBUGG TO VIEW

    sister_ProfileKeys_arr = session[:sister_ProfileKeys_arr][:value]  #
    sisters_names_arr = session[:sisters_names_arr][:value]  #

    author_name = profiles_array[0][1]
    author_sex = profiles_array[0][2]
    father_name = profiles_array[1][1]
    mother_name = profiles_array[2][1]

    profiles_array_length = profiles_array.length
    sister_name = profiles_array[profiles_array_length-1][1] # Name of last sister

    # add Author rows
    author_ProfileKeys_arr << [author_name, 6, sister_name, 6]
    @author_ProfileKeys_arr = author_ProfileKeys_arr # DEBUGG TO VIEW

    # add Father rows
    father_ProfileKeys_arr << [father_name, 4, sister_name, 6]
    @father_ProfileKeys_arr = father_ProfileKeys_arr # DEBUGG TO VIEW

    # add Mother rows
    mother_ProfileKeys_arr << [mother_name, 4, sister_name, 6]
    @mother_ProfileKeys_arr = mother_ProfileKeys_arr # DEBUGG TO VIEW

    if !brothers_names_arr.blank?
      for arr_ind in 0 .. brothers_names_arr.length - 1
        brother_ProfileKeys_arr << [brothers_names_arr[arr_ind], 6, sister_name, 6]
         # Сохранение пары брат - сестра в один массив Братьев
        sister_ProfileKeys_arr << [sister_name, 5, brothers_names_arr[arr_ind], 5]
        # Сохранение пары сестра - брат в один массив Сестер
      end
    end
    @brother_ProfileKeys_arr = brother_ProfileKeys_arr # DEBUGG TO VIEW

    # add Sister rows
    sister_ProfileKeys_arr << [sister_name, 1, father_name, 1]
    sister_ProfileKeys_arr << [sister_name, 2, mother_name, 2]
    if author_sex
      sister_ProfileKeys_arr << [sister_name, 5, author_name, 0]
    else
      sister_ProfileKeys_arr << [sister_name, 6, author_name, 0]
    end
    if !sisters_names_arr.blank?  # Если есть уже сестры?
      for arr_ind in 0 .. sisters_names_arr.length - 1
        sister_ProfileKeys_arr << [sisters_names_arr[arr_ind], 6, sister_name, 6] # Сохранение пары братьев в один массив Братьев
        sister_ProfileKeys_arr << [sister_name, 6, sisters_names_arr[arr_ind], 6] # Сохранение пары братьев в один массив Братьев
      end
    end

    sisters_names_arr << sister_name
    @sisters_names_arr = sisters_names_arr # DEBUGG TO VIEW
    @sister_ProfileKeys_arr = sister_ProfileKeys_arr # DEBUGG TO VIEW

    session[:author_ProfileKeys_arr] = {:value => author_ProfileKeys_arr, :updated_at => Time.current}
    session[:father_ProfileKeys_arr] = {:value => father_ProfileKeys_arr, :updated_at => Time.current}
    session[:mother_ProfileKeys_arr] = {:value => mother_ProfileKeys_arr, :updated_at => Time.current}
    session[:brother_ProfileKeys_arr] = {:value => brother_ProfileKeys_arr, :updated_at => Time.current}
    session[:brothers_names_arr] = {:value => brothers_names_arr, :updated_at => Time.current}
    session[:sister_ProfileKeys_arr] = {:value => sister_ProfileKeys_arr, :updated_at => Time.current}
    session[:sisters_names_arr] = {:value => sisters_names_arr, :updated_at => Time.current}

  end

  # Добавить ряды в ProfileKeys при вводе Жены (если пол Автора = true)
  # в первом элементе мессива - всегда - данные об Авторе
  # в последнем элементе мессива - данные о Жене
  # @note GET
  # Структура одной записи:  author_ProfileKeys_arr << [author_name, 8, wife_name, 8]
  # author_ProfileKeys_arr - массив накапливания записей для формирования рядов
  # [author_name, 8, wife_name, 8]
  # author_name имеет wife_name с отношением 8; при этом wife_name является 8 в массиве профилей profiles_array.
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_wife_to_ProfileKeys(profiles_array)

    #profiles_array = [], ......, [nil, "wife_name", true]]
    author_ProfileKeys_arr = session[:author_ProfileKeys_arr][:value]
    wife_ProfileKeys_arr = []  # Массив для записи в ProfileKeys рядов о wife
    husband_ProfileKeys_arr = []  # Массив для записи в ProfileKeys рядов о mother
    son_ProfileKeys_arr = []  #
    sons_names_arr = []  # Имена сынов
    daugther_ProfileKeys_arr = []  #
    daugthers_names_arr = []  # Имена Дочерей

    profiles_array_length = profiles_array.length
    author_name = profiles_array[0][1]  #
    wife_name = profiles_array[profiles_array_length-1][1]  #
    husband_name = ""

    # add Author rows
    author_ProfileKeys_arr << [author_name, 8, wife_name,8]
    @author_ProfileKeys_arr = author_ProfileKeys_arr # DEBUGG TO VIEW

    # add Wife rows
    wife_ProfileKeys_arr << [wife_name, 7, author_name,0]
    @wife_ProfileKeys_arr = wife_ProfileKeys_arr # DEBUGG TO VIEW

    session[:author_ProfileKeys_arr] = {:value => author_ProfileKeys_arr, :updated_at => Time.current}
    session[:wife_ProfileKeys_arr] = {:value => wife_ProfileKeys_arr, :updated_at => Time.current}
    session[:husband_ProfileKeys_arr] = {:value => husband_ProfileKeys_arr, :updated_at => Time.current}
    session[:husband_name] = {:value => husband_name, :updated_at => Time.current}  # Пока - это не массив имен
    session[:wife_name] = {:value => wife_name, :updated_at => Time.current}  # Пока - это не массив имен
    # считаем, что жена - одна.
    session[:son_ProfileKeys_arr] = {:value => son_ProfileKeys_arr, :updated_at => Time.current}
    session[:sons_names_arr] = {:value => sons_names_arr, :updated_at => Time.current}
    session[:daugther_ProfileKeys_arr] = {:value => daugther_ProfileKeys_arr, :updated_at => Time.current}
    session[:daugthers_names_arr] = {:value => daugthers_names_arr, :updated_at => Time.current}

  end

  # Добавить ряды в ProfileKeys при вводе Мужа (если пол Автора = false) )
  # в первом элементе мессива - данные об Авторе
  # в последнем элементе мессива - данные о Муже
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_husband_to_ProfileKeys(profiles_array)

    #profiles_array = [], ......, [nil, "husband_name", true]]
    author_ProfileKeys_arr = session[:author_ProfileKeys_arr][:value]
    husband_ProfileKeys_arr = []   # Массив для записи в ProfileKeys рядов о mother
    wife_ProfileKeys_arr = []      # Массив для записи в ProfileKeys рядов о wife
    son_ProfileKeys_arr = []       #
    sons_names_arr = []            # Имена сынов
    daugther_ProfileKeys_arr = []  #
    daugthers_names_arr = []  # Имена Дочерей

    profiles_array_length = profiles_array.length
    author_name = profiles_array[0][1]  #
    husband_name = profiles_array[profiles_array_length-1][1] #
    wife_name = ""

    # add Author rows
    author_ProfileKeys_arr << [author_name, 7, husband_name, 7]
    @author_ProfileKeys_arr = author_ProfileKeys_arr # DEBUGG TO VIEW

    # add Husband rows
    husband_ProfileKeys_arr << [husband_name, 8, author_name, 0]
    @husband_ProfileKeys_arr = husband_ProfileKeys_arr # DEBUGG TO VIEW

    session[:author_ProfileKeys_arr] = {:value => author_ProfileKeys_arr, :updated_at => Time.current}
    session[:husband_ProfileKeys_arr] = {:value => husband_ProfileKeys_arr, :updated_at => Time.current}
    session[:husband_name] = {:value => husband_name, :updated_at => Time.current}  # Пока - это не массив имен
    # считаем, что муж - один.
    session[:wife_ProfileKeys_arr] = {:value => wife_ProfileKeys_arr, :updated_at => Time.current}
    session[:wife_name] = {:value => wife_name, :updated_at => Time.current}  # Пока - это не массив имен
    session[:son_ProfileKeys_arr] = {:value => son_ProfileKeys_arr, :updated_at => Time.current}
    session[:sons_names_arr] = {:value => sons_names_arr, :updated_at => Time.current}
    session[:daugther_ProfileKeys_arr] = {:value => daugther_ProfileKeys_arr, :updated_at => Time.current}
    session[:daugthers_names_arr] = {:value => daugthers_names_arr, :updated_at => Time.current}

  end

  # Добавить ряды в ProfileKeys при вводе Сына
  # в первом элементе массива - данные об Авторе
  # в последнем элементе массива - данные о Сыне
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_son_to_ProfileKeys(profiles_array)

    #profiles_array = [[nil, "author_name", true], [1, "mother_name", true], [2, "mother_name", false]]
    author_ProfileKeys_arr = session[:author_ProfileKeys_arr][:value]
    husband_ProfileKeys_arr = session[:husband_ProfileKeys_arr][:value]
    husband_name = session[:husband_name][:value]
    wife_ProfileKeys_arr = session[:wife_ProfileKeys_arr][:value]  #
    wife_name = session[:wife_name][:value]
    son_ProfileKeys_arr = session[:son_ProfileKeys_arr][:value]
    sons_names_arr = session[:sons_names_arr][:value]


    author_name = profiles_array[0][1]
    author_sex = profiles_array[0][2]
    father_name = profiles_array[1][1]
    mother_name = profiles_array[2][1]

    profiles_array_length = profiles_array.length
    son_name = profiles_array[profiles_array_length-1][1] ## Name of last son

    # add Author rows
    author_ProfileKeys_arr << [author_name, 3, son_name, 3]
    @author_ProfileKeys_arr = author_ProfileKeys_arr # DEBUGG TO VIEW

    # add Son & wife & husband rows
    if author_sex
      son_ProfileKeys_arr << [son_name, 1, author_name, 0]
      son_ProfileKeys_arr << [son_name, 2, wife_name, 8]
      wife_ProfileKeys_arr << [wife_name, 3, son_name, 3]
    else
      son_ProfileKeys_arr << [son_name, 2, author_name, 0]
      son_ProfileKeys_arr << [son_name, 1, husband_name, 7]
      husband_ProfileKeys_arr << [husband_name, 3, son_name, 3]
    end
    @husband_ProfileKeys_arr = husband_ProfileKeys_arr # DEBUGG TO VIEW
    @wife_ProfileKeys_arr = wife_ProfileKeys_arr # DEBUGG TO VIEW

    if !sons_names_arr.blank?
      for arr_ind in 0 .. sons_names_arr.length - 1
        son_ProfileKeys_arr << [sons_names_arr[arr_ind], 5, son_name, 3] # Сохранение пары братьев в один массив Братьев
        son_ProfileKeys_arr << [son_name, 5, sons_names_arr[arr_ind], 3] # Сохранение пары братьев в один массив Братьев
      end
    end

    @son_ProfileKeys_arr = son_ProfileKeys_arr # DEBUGG TO VIEW
    sons_names_arr << son_name
    @sons_names_arr = sons_names_arr # DEBUGG TO VIEW

    session[:author_ProfileKeys_arr] = {:value => author_ProfileKeys_arr, :updated_at => Time.current}
    session[:wife_ProfileKeys_arr] = {:value => wife_ProfileKeys_arr, :updated_at => Time.current}
    session[:husband_ProfileKeys_arr] = {:value => husband_ProfileKeys_arr, :updated_at => Time.current}
    session[:sons_names_arr] = {:value => sons_names_arr, :updated_at => Time.current}
    session[:son_ProfileKeys_arr] = {:value => son_ProfileKeys_arr, :updated_at => Time.current}
    session[:husband_name] = {:value => husband_name, :updated_at => Time.current}
    session[:wife_name] = {:value => wife_name, :updated_at => Time.current}

  end
  # Добавить ряды в ProfileKeys при вводе Дочери
  # в первом элементе массива - данные об Авторе
  # в последнем элементе массива - данные о Дочери
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see News
  def add_daugther_to_ProfileKeys(profiles_array)

    #profiles_array = [[nil, "author_name", true], [1, "mother_name", true], [2, "mother_name", false]]
    author_ProfileKeys_arr = session[:author_ProfileKeys_arr][:value]
    husband_ProfileKeys_arr = session[:husband_ProfileKeys_arr][:value]
    husband_name = session[:husband_name][:value]
    wife_ProfileKeys_arr = session[:wife_ProfileKeys_arr][:value]  #
    wife_name = session[:wife_name][:value]
    son_ProfileKeys_arr = session[:son_ProfileKeys_arr][:value]
    sons_names_arr = session[:sons_names_arr][:value]
    daugther_ProfileKeys_arr = session[:daugther_ProfileKeys_arr][:value]
    daugthers_names_arr = session[:daugthers_names_arr][:value]


    author_name = profiles_array[0][1]
    author_sex = profiles_array[0][2]
    #father_name = profiles_array[1][1]
    #mother_name = profiles_array[2][1]

    profiles_array_length = profiles_array.length
    daugther_name = profiles_array[profiles_array_length-1][1] ## Name of last daugther_name

    # add Author rows
    author_ProfileKeys_arr << [author_name, 4, daugther_name, 4]
    @author_ProfileKeys_arr = author_ProfileKeys_arr # DEBUGG TO VIEW

    # add Daughter & wife & husband rows
    if author_sex
      daugther_ProfileKeys_arr << [daugther_name, 1, author_name, 0]
      daugther_ProfileKeys_arr << [daugther_name, 2, wife_name, 8]
      wife_ProfileKeys_arr << [wife_name, 4, daugther_name, 4]
    else
      daugther_ProfileKeys_arr << [daugther_name, 2, author_name, 0]
      daugther_ProfileKeys_arr << [daugther_name, 1, husband_name, 7]
      husband_ProfileKeys_arr << [husband_name, 4, daugther_name, 4]
    end
    @husband_ProfileKeys_arr = husband_ProfileKeys_arr # DEBUGG TO VIEW
    @wife_ProfileKeys_arr = wife_ProfileKeys_arr # DEBUGG TO VIEW

    if !daugthers_names_arr.blank?
      for arr_ind in 0 .. daugthers_names_arr.length - 1
        daugther_ProfileKeys_arr << [daugthers_names_arr[arr_ind], 6, daugther_name, 4] # Сохранение пары братьев в один массив Братьев
        daugther_ProfileKeys_arr << [daugther_name, 6, daugthers_names_arr[arr_ind], 4] # Сохранение пары братьев в один массив Братьев
      end
    end

    if !sons_names_arr.blank?
      for arr_ind in 0 .. sons_names_arr.length - 1
        son_ProfileKeys_arr << [sons_names_arr[arr_ind], 6, daugther_name, 4]
        # Сохранение пары брат - сестра в один массив Братьев
        daugther_ProfileKeys_arr << [daugther_name, 5, sons_names_arr[arr_ind], 3]
        # Сохранение пары сестра - брат в один массив Сестер
      end
    end
    @son_ProfileKeys_arr = son_ProfileKeys_arr # DEBUGG TO VIEW

    @daugther_ProfileKeys_arr = daugther_ProfileKeys_arr # DEBUGG TO VIEW
    daugthers_names_arr << daugther_name
    @daugthers_names_arr = daugthers_names_arr # DEBUGG TO VIEW

    session[:author_ProfileKeys_arr] = {:value => author_ProfileKeys_arr, :updated_at => Time.current}
    session[:wife_ProfileKeys_arr] = {:value => wife_ProfileKeys_arr, :updated_at => Time.current}
    session[:wife_name] = {:value => wife_name, :updated_at => Time.current}
    session[:husband_ProfileKeys_arr] = {:value => husband_ProfileKeys_arr, :updated_at => Time.current}
    session[:husband_name] = {:value => husband_name, :updated_at => Time.current}
    session[:sons_names_arr] = {:value => sons_names_arr, :updated_at => Time.current}
    session[:son_ProfileKeys_arr] = {:value => son_ProfileKeys_arr, :updated_at => Time.current}
    session[:daugther_ProfileKeys_arr] = {:value => daugther_ProfileKeys_arr, :updated_at => Time.current}
    session[:daugthers_names_arr] = {:value => daugthers_names_arr, :updated_at => Time.current}

  end

  ####  STORE TREE PROFILE  ########################

  def store_myself
    @user_name = params[:name_select] #
    if !@user_name.blank?
      user_sex = 0    # Female name
      find_name=Name.select(:only_male).where(:name => @user_name)
      @find_name = find_name
      user_sex = 1 if !find_name.blank? and find_name[0]['only_male']    # Male name
      @user_sex = user_sex
   #       check_sex_by_name(@user_name) # display sex by name = извлечение пола из введенного имени
    end

    # Begin All Arrays
    profiles_array = []  #

    daughter_ProfileKeys_arr = []  # Массив для записи в ProfileKeys рядов о mother
    son_ProfileKeys_arr = []  # Массив для записи в ProfileKeys рядов о mother
    sister_ProfileKeys_arr = []  # Массив для записи в ProfileKeys рядов о mother

    one_profile_arr = add_profile(0,@user_name,@user_sex)
    profiles_array << one_profile_arr

    session[:profiles_array] = {:value => profiles_array, :updated_at => Time.current}
    session[:user_sex] = {:value => @user_sex, :updated_at => Time.current}

    session[:daughter_ProfileKeys_arr] = {:value => daughter_ProfileKeys_arr, :updated_at => Time.current}
    session[:son_ProfileKeys_arr] = {:value => son_ProfileKeys_arr, :updated_at => Time.current}
    session[:sister_ProfileKeys_arr] = {:value => sister_ProfileKeys_arr, :updated_at => Time.current}

    @profiles_array = profiles_array # DEBUGG TO VIEW

    @sel_names_male = session[:sel_names_male][:value]
    respond_to do |format|
      format.html
      format.js { render 'start/store_myself' }
    end
    #redirect_to enter_father_path

  end


  def store_father

    profiles_array = session[:profiles_array][:value]
    @user_sex = session[:user_sex][:value]
    #author_ProfileKeys_arr = session[:author_ProfileKeys_arr][:value]
    #father_ProfileKeys_arr = session[:father_ProfileKeys_arr][:value]
    #mother_ProfileKeys_arr = session[:mother_ProfileKeys_arr][:value]

    @father_name = params[:father_name_select] #

    if !@father_name.blank?
      @father_sex = check_sex_by_name(@father_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@father_name)
        @father_name_correct = true
      else
        @father_name_correct = false
      end
      # todo: Сохранять отчество Profile в зависимости от пола @user_sex!
      one_profile_arr = add_profile(1,@father_name,@father_sex)
      profiles_array << one_profile_arr

      add_father_to_ProfileKeys(profiles_array)

      session[:profiles_array] = {:value => profiles_array, :updated_at => Time.current}

      @profiles_array = profiles_array # DEBUGG TO VIEW
    end


    @sel_names_female = session[:sel_names_female][:value]
    respond_to do |format|
      format.html
      format.js { render 'start/store_father' }
    end
    #redirect_to enter_mother_path

  end

  def store_mother

    profiles_array = session[:profiles_array][:value]


    @mother_name = params[:mother_name_select] #

    if !@mother_name.blank?
      @mother_sex = check_sex_by_name(@mother_name) # display sex by name # проверка, действ-но ли введено женское имя?
      if !check_sex_by_name(@mother_name)
        @mother_name_correct = true
      else
        @mother_name_correct = false
      end
      one_profile_arr = add_profile(2,@mother_name,@mother_sex)
      profiles_array << one_profile_arr

      add_mother_to_ProfileKeys(profiles_array)

      session[:profiles_array] = {:value => profiles_array, :updated_at => Time.current}

      @profiles_array = profiles_array # DEBUGG TO VIEW


    end
    @sel_names_male = session[:sel_names_male][:value]
    respond_to do |format|
      format.html
      format.js { render 'start/store_mother' }
    end
#    redirect_to enter_brother_path # in store_mother.js
  end



  def store_brother

    profiles_array = session[:profiles_array][:value]
    @user_sex = session[:user_sex][:value]
    @sel_names_male = session[:sel_names_male][:value]
    @sel_names_female = session[:sel_names_female][:value]

    @more_brothers_exists = params[:more_brothers_exist?]
    @brother_name = params[:brother_name_select] #

    if params[:more_brothers_exist?] == "yes" #
      # todo: Принять меры если имя Сына не соответствует полу
      if !@brother_name.blank?
        @brother_sex = check_sex_by_name(@brother_name) # display sex by name # проверка, действ-но ли введено мужское имя?
        if check_sex_by_name(@brother_name)
          @brother_name_correct = true
        else
          @brother_name_correct = false
        end
        # todo: Сохранять отчество Profile в зависимости от пола @user_sex!
        one_profile_arr = add_profile(5,@brother_name,@brother_sex)
        profiles_array << one_profile_arr

        add_brother_to_ProfileKeys(profiles_array)

        session[:profiles_array] = {:value => profiles_array, :updated_at => Time.current}

        @profiles_array = profiles_array # DEBUGG TO VIEW

      end
      @next_view = 'start/enter_brother'

    else
      session[:profiles_array] = {:value => profiles_array, :updated_at => Time.current}
      @profiles_array = profiles_array # DEBUGG TO VIEW
      @next_view = 'start/enter_sister'   #
    end

    respond_to do |format|
      format.html
      format.js { render 'start/store_brother' }
    end
 #   redirect_to @next_view

  end



  def store_sister

    profiles_array = session[:profiles_array][:value]
    @sel_names_male = session[:sel_names_male][:value]
    @sel_names_female = session[:sel_names_female][:value]

    @more_sisters_exists = params[:more_sisters_exists?]
    @sister_name = params[:sister_name_select] #

    if params[:more_sisters_exists?] == "yes" #
      if !@sister_name.blank?
        @sister_sex = check_sex_by_name(@sister_name) # display sex by name # проверка, действ-но ли введено мужское имя?
        if check_sex_by_name(@sister_name)
          @sister_name_correct = true
        else
          @sister_name_correct = false
        end
        # todo: Сохранять отчество Profile sister в зависимости от пола @user_sex!
        one_profile_arr = add_profile(6,@sister_name,@sister_sex)
        profiles_array << one_profile_arr

        session[:profiles_array] = {:value => profiles_array, :updated_at => Time.current}

        add_sister_to_ProfileKeys(profiles_array)

        @profiles_array = profiles_array # DEBUGG TO VIEW

      end
      @next_view = 'start/enter_sister' # повтор ввода новой сестры

    else
      session[:profiles_array] = {:value => profiles_array, :updated_at => Time.current}
      @profiles_array = profiles_array # DEBUGG TO VIEW
      @next_view = check_husband_or_wife   # взавис-ти от пола - переход к жене или мужу

    end

    respond_to do |format|
      format.html
      format.js { render 'start/store_sister' }
    end

  end

  def store_husband

    profiles_array = session[:profiles_array][:value]

    @husband_name = params[:husband_name_select] #

    if !@husband_name.blank?  # надо ли проверять пол мужа - геи?
      @husband_sex = check_sex_by_name(@husband_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@husband_name)
        @husband_name_correct = true
      else
        @husband_name_correct = false
      end
      one_profile_arr = add_profile(7,@husband_name,@husband_sex)
      profiles_array << one_profile_arr

      add_husband_to_ProfileKeys(profiles_array)

      session[:profiles_array] = {:value => profiles_array, :updated_at => Time.current}

      @profiles_array = profiles_array # DEBUGG TO VIEW

    end

    @sel_names_male = session[:sel_names_male][:value]
    respond_to do |format|
      format.html
      format.js { render 'start/store_husband' }
    end
#    redirect_to enter_son_path

  end

  def store_wife

    profiles_array = session[:profiles_array][:value]

    @wife_name = params[:wife_name_select] #

    if !@wife_name.blank?   # надо ли проверять пол жены - геи?
      @wife_sex = check_sex_by_name(@wife_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@wife_name)
        @wife_name_correct = true
      else
        @wife_name_correct = false
      end
      # todo: Сохранять фамилию жены по мужу? Или девичью?
      one_profile_arr = add_profile(8,@wife_name,@wife_sex)
      profiles_array << one_profile_arr

      add_wife_to_ProfileKeys(profiles_array)

      session[:profiles_array] = {:value => profiles_array, :updated_at => Time.current}

      @profiles_array = profiles_array # DEBUGG TO VIEW

    end

    @sel_names_male = session[:sel_names_male][:value]
    respond_to do |format|
      format.html
      format.js { render 'start/store_wife' }
    end
#    redirect_to enter_son_path

  end


  def store_son

    profiles_array = session[:profiles_array][:value]
    @user_sex = session[:user_sex][:value]
    @sel_names_male = session[:sel_names_male][:value]
    @sel_names_female = session[:sel_names_female][:value]

    @more_sons_exists = params[:more_sons_exist?]
    @son_name = params[:son_name_select] #

    if params[:more_sons_exist?] == "yes" #
      if !@son_name.blank?
        @son_sex = check_sex_by_name(@son_name) # display sex by name # проверка, действ-но ли введено мужское имя?
        # todo: Принять меры если имя Сына не соответствует полу
        if check_sex_by_name(@son_name)
          @son_name_correct = true
        else
          @son_name_correct = false
        end
        # todo: Сохранять отчество Profile в зависимости от пола @user_sex!
        one_profile_arr = add_profile(3,@son_name,@son_sex)
        profiles_array << one_profile_arr

        add_son_to_ProfileKeys(profiles_array)

        session[:profiles_array] = {:value => profiles_array, :updated_at => Time.current}

        @profiles_array = profiles_array # DEBUGG TO VIEW

      end
      @next_view = 'start/enter_son'

    else
      session[:profiles_array] = {:value => profiles_array, :updated_at => Time.current}
      @profiles_array = profiles_array # DEBUGG TO VIEW
      @next_view = 'start/enter_daugther'   #
    end

    respond_to do |format|
      format.html
      format.js { render 'start/store_son' }
    end
#    redirect_to @next_view

  end

  def store_daugther

    profiles_array = session[:profiles_array][:value]
    @user_sex = session[:user_sex][:value]
    @sel_names_female = session[:sel_names_female][:value]

    @more_daugthers_exists = params[:more_daugthers_exist?]
    @daugther_name = params[:daugther_name_select] #

    if params[:more_daugthers_exist?] == "yes" #
      # todo: Принять меры если имя Дочери не соответствует полу
      if !@daugther_name.blank?
        @daugther_sex = check_sex_by_name(@daugther_name) # display sex by name # проверка, действ-но ли введено мужское имя?
        if check_sex_by_name(@daugther_name)
          @daugther_name_correct = true
        else
          @daugther_name_correct = false
        end
        # #todo: Сохранять отчества Profile в зависимости от  пола @user_sex!
        one_profile_arr = add_profile(4,@daugther_name,@daugther_sex)
        profiles_array << one_profile_arr

        add_daugther_to_ProfileKeys(profiles_array)

        session[:profiles_array] = {:value => profiles_array, :updated_at => Time.current}

        @profiles_array = profiles_array # DEBUGG TO VIEW

      end
      @next_view = 'start/enter_daugther'

    else
      session[:profiles_array] = {:value => profiles_array, :updated_at => Time.current}
      @profiles_array = profiles_array  # DEBUGG: for show in _show_tree_table
      @next_view = 'start/show_tree_table'   #
    end

    respond_to do |format|
      format.html
      format.js { render 'start/store_daugther' }
    end
    #   redirect_to @next_view
  end

  # Добавление в массив дерева одного введенного профиля стартового дерева Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see
  def add_profile(relation,name,sex)
    one_profile_arr = []

    one_profile_arr[0] = relation        # Relation
    one_profile_arr[1] = name            # Name
    one_profile_arr[2] = sex             # Sex

    return one_profile_arr
  end



  ####  SAVE START TREE PROFILES  ########################


  # Сохранение стартового дерева
  # Профили, Дерево, Юзер вставка ИД профиля
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see
  def save_start_tables

    #### ZEROUVING OF TABLES FOR DEBUGG ########################

    #User.delete_all             # DEBUGG
    #User.reset_pk_sequence

    #Tree.delete_all             # DEBUGG
    #Tree.reset_pk_sequence
    #
    #Profile.delete_all          # DEBUGG
    #Profile.reset_pk_sequence

    #ProfileKey.delete_all             # DEBUGG
    #ProfileKey.reset_pk_sequence

    if !session[:profiles_array].blank?
      profiles_array = session[:profiles_array][:value]
      @profiles_array = profiles_array # DEBUGG TO VIEW
    end

  # 14 user:
  #profiles_array = [[0, "Александр", 1],   # DEBUGG TO VIEW
  #[1, "Борис", 1], [2, "Мария", 0],
  #[5, "Виктор", 1], [5, "Денис", 1],
  #[6, "Анна", 0], [6, "Ольга", 0],
  #[8, "Виктория", 0]]

  #[3, "Борис", true], [3, "Иван", true],
  #[4, "Мария", false], [4, "Юлия", false]]   # DEBUGG TO VIEW
#  @profiles_array = profiles_array # DEBUGG TO VIEW

 # Массивы для ProfileKeys: # DEBUGG TO VIEW
 #author_ProfileKeys_arr = [["Александр", 1, "Борис", 1], ["Александр", 2, "Мария", 2], ["Александр", 5, "Виктор", 5], ["Александр", 5, "Денис", 5], ["Александр", 6, "Анна", 6], ["Александр", 6, "Ольга", 6], ["Александр", 8, "Виктория", 8], ["Александр", 3, "Борис", 3], ["Александр", 3, "Иван", 3], ["Александр", 4, "Мария", 4], ["Александр", 4, "Юлия", 4]]
 #
 #father_ProfileKeys_arr = [["Борис", 3, "Александр", 0], ["Борис", 8, "Мария", 2], ["Борис", 3, "Виктор", 5], ["Борис", 3, "Денис", 5], ["Борис", 4, "Анна", 6], ["Борис", 4, "Ольга", 6]]
 #mother_ProfileKeys_arr = [["Мария", 7, "Борис", 1], ["Мария", 3, "Александр", 0], ["Мария", 3, "Виктор", 5], ["Мария", 3, "Денис", 5], ["Мария", 4, "Анна", 6], ["Мария", 4, "Ольга", 6]]
 #brother_ProfileKeys_arr = [["Виктор", 1, "Борис", 1], ["Виктор", 2, "Мария", 2], ["Виктор", 5, "Александр", 0], ["Денис", 1, "Борис", 1], ["Денис", 2, "Мария", 2], ["Денис", 5, "Александр", 0], ["Виктор", 5, "Денис", 5], ["Денис", 5, "Виктор", 5], ["Виктор", 6, "Анна", 6], ["Денис", 6, "Анна", 6], ["Виктор", 6, "Ольга", 6], ["Денис", 6, "Ольга", 6]]
 #sister_ProfileKeys_arr = [["Анна", 5, "Виктор", 5], ["Анна", 5, "Денис", 5], ["Анна", 1, "Борис", 1], ["Анна", 2, "Мария", 2], ["Анна", 5, "Александр", 0], ["Ольга", 5, "Виктор", 5], ["Ольга", 5, "Денис", 5], ["Ольга", 1, "Борис", 1], ["Ольга", 2, "Мария", 2], ["Ольга", 5, "Александр", 0], ["Анна", 6, "Ольга", 6], ["Ольга", 6, "Анна", 6]]
 #
 #wife_ProfileKeys_arr = [["Виктория", 7, "Александр", 0], ["Виктория", 3, "Борис", 3], ["Виктория", 3, "Иван", 3], ["Виктория", 4, "Мария", 4], ["Виктория", 4, "Юлия", 4]]
 #husband_ProfileKeys_arr = []
 #son_ProfileKeys_arr = [["Борис", 1, "Александр", 0], ["Борис", 2, "Виктория", 8], ["Иван", 1, "Александр", 0], ["Иван", 2, "Виктория", 8], ["Борис", 5, "Иван", 3], ["Иван", 5, "Борис", 3], ["Борис", 6, "Мария", 4], ["Иван", 6, "Мария", 4], ["Борис", 6, "Юлия", 4], ["Иван", 6, "Юлия", 4]]
 #daugther_ProfileKeys_arr = [["Мария", 1, "Александр", 0], ["Мария", 2, "Виктория", 8], ["Мария", 5, "Борис", 3], ["Мария", 5, "Иван", 3], ["Юлия", 1, "Александр", 0], ["Юлия", 2, "Виктория", 8], ["Мария", 6, "Юлия", 4], ["Юлия", 6, "Мария", 4], ["Юлия", 5, "Борис", 3], ["Юлия", 5, "Иван", 3]]
 #daugthers_names_arr = ["Мария", "Юлия"]

 #   @profile_id_hash: {1=>["Александр", 0], 2=>["Борис", 1], 3=>["Мария", 2], 4=>["Виктор", 5], 5=>["Денис", 5], 6=>["Анна", 6], 7=>["Ольга", 6], 8=>["Виктория", 8], 9=>["Борис", 3], 10=>["Иван", 3], 11=>["Мария", 4], 12=>["Юлия", 4]}

    if user_signed_in?

      profiles_arr_w_ids, profile_id_hash = save_profiles(profiles_array)  # появление profile_id
      @profiles_arr_w_ids = profiles_arr_w_ids # DEBUGG TO VIEW
      @profile_id_hash = profile_id_hash # DEBUGG TO VIEW

      save_tree(profiles_arr_w_ids)

      update_user

      make_profile_keys(profiles_arr_w_ids, profile_id_hash )

    else
      @message = "User not signed"
    end

    session[:profiles_arr_w_ids] = {:value => profiles_arr_w_ids, :updated_at => Time.current}

  #  redirect_to main_page_path  ##

  end


  # Сохранение профилей в таблице Profile. Получение значений profile_id.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see
  def save_profiles(profiles_array)

    profiles_arr_w_ids = []
    new_profile_arr = []     #
    profile_id_hash = Hash.new
    if !profiles_array.blank?
      for arr_i in 0 .. profiles_array.length-1
        new_profile = Profile.new
          if arr_i == 0 # only for email для user
            new_profile.user_id = current_user.id  # user_id - берем после регистрации
            new_profile.email = current_user.email # user regged email
          else
            new_profile.user_id = 0  # profile - not user_id
            new_profile.email = ""   # profile - not user_id
          end
          new_profile.name_id = Name.find_by_name(profiles_array[arr_i][1]).id  # name_id
          if profiles_array[arr_i][2] # sex_id
            new_profile.sex_id = 1    # sex_id - MALE
          else
            new_profile.sex_id = 0    # sex_id - FEMALE
          end
        new_profile.save

        profile_id_hash.merge!({new_profile.id => [profiles_array[arr_i][1], profiles_array[arr_i][0]]}) # include elem in hash

        new_profile_arr[0] = new_profile.id             # profile_id
        new_profile_arr[1] = profiles_array[arr_i][1]   # name
        new_profile_arr[2] = new_profile.name_id        # name_id
        new_profile_arr[3] = profiles_array[arr_i][2]   # sex_id
        new_profile_arr[4] = profiles_array[arr_i][0]   # Relation_id

        profiles_arr_w_ids <<  new_profile_arr
        new_profile_arr = []
      end
    end
    @profile_id_hash = profile_id_hash  # DEBUGG TO VIEW
    return profiles_arr_w_ids, profile_id_hash # новый массив с profile_id

  end

  # Сохранение стартового дерева Юзера в таблице Tree.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see
  def save_tree(profiles_arr_w_ids)
    for arr_i in 0 .. profiles_arr_w_ids.length-1
      new_tree = Tree.new
      new_tree.user_id = current_user.id                    # user_id ID От_Профиля (From_Profile)
      new_tree.profile_id = current_user.profile_id         # profile_id От_Профиля
      new_tree.name_id = Profile.find(current_user.profile_id).name_id       # name_id От_Профиля

      new_tree.relation_id = profiles_arr_w_ids[arr_i][4]   # relation_id ID Родства От_Профиля с К_Профилю (To_Profile)

      new_tree.is_profile_id = profiles_arr_w_ids[arr_i][0] # is_profile_id К_Профиля
      new_tree.is_name_id = profiles_arr_w_ids[arr_i][2]    # is_name_id К_Профиля
      new_tree.is_sex_id = profiles_arr_w_ids[arr_i][3]     # is_sex_id К_Профиля

      new_tree.connected = false           # Пока не Объединено дерево К_Профиля с другим деревом

      new_tree.save
    end
  end

  # Занесение для current_user в поле profile_id значения id из таблицы Profile
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see
  def update_user
    user_profile = Profile.where(:user_id => current_user.id, :email => current_user.email)
    if !user_profile.blank?
      current_user.profile_id = user_profile[0]['id']
      current_user.save
    end
  end

  # Заполнение таблицы ProfileKey для введенного дерева
  # для current_user
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see
  def save_profile_keys(name, profile_id, profile_id_hash, profile_keys_arr)

    for row_ind in 0 .. profile_keys_arr.length-1
      if !profile_keys_arr[row_ind][4] and (profile_keys_arr[row_ind][0] == name)
        new_profile_key_row = ProfileKey.new
        new_profile_key_row.user_id = current_user.id                           # user_id
        new_profile_key_row.profile_id = profile_id                                # profile_id

        #new_profile_key_row.name_id = profiles_arr_w_ids[arr_i][2]             ### name_id
        name_id = Name.find_by_name(profile_keys_arr[row_ind][0]).id                 # name_id
        new_profile_key_row.name_id = name_id                                    # name_id

        new_profile_key_row.relation_id = profile_keys_arr[row_ind][1]               # relation_id

        is_profile_id = profile_id_hash.key([profile_keys_arr[row_ind][2], profile_keys_arr[row_ind][3]])
        new_profile_key_row.is_profile_id = is_profile_id                        # is_profile_id

        #new_profile_key_row.name_id = profile_keys_arr[row_ind][0]               ### name_id
        is_name_id = Name.find_by_name(profile_keys_arr[row_ind][2]).id             # is_name_id
        new_profile_key_row.is_name_id = is_name_id                              # is_name_id

        new_profile_key_row.save
        profile_keys_arr[row_ind][4] = true
      end
    end


  end
  # Заполнение таблицы ProfileKey для введенного Ближнего круга
  # формирование групп рядов ProfileKey для каждого профиля дерева/
  # для current_user
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see
  def make_profile_keys(profiles_arr_w_ids, profile_id_hash)

    # Массивы для ProfileKeys:
    #author_ProfileKeys_arr = [["Александр", 1, "Борис", 1], ["Александр", 2, "Мария", 2], ["Александр", 5, "Виктор", 5], ["Александр", 5, "Денис", 5], ["Александр", 6, "Анна", 6], ["Александр", 6, "Ольга", 6], ["Александр", 8, "Виктория", 8], ["Александр", 3, "Борис", 3], ["Александр", 3, "Иван", 3], ["Александр", 4, "Мария", 4], ["Александр", 4, "Юлия", 4]]
    #
    #father_ProfileKeys_arr = [["Борис", 3, "Александр", 0], ["Борис", 8, "Мария", 2], ["Борис", 3, "Виктор", 5], ["Борис", 3, "Денис", 5], ["Борис", 4, "Анна", 6], ["Борис", 4, "Ольга", 6]]
    #mother_ProfileKeys_arr = [["Мария", 7, "Борис", 1], ["Мария", 3, "Александр", 0], ["Мария", 3, "Виктор", 5], ["Мария", 3, "Денис", 5], ["Мария", 4, "Анна", 6], ["Мария", 4, "Ольга", 6]]
    #brother_ProfileKeys_arr = [["Виктор", 1, "Борис", 1], ["Виктор", 2, "Мария", 2], ["Виктор", 5, "Александр", 0], ["Денис", 1, "Борис", 1], ["Денис", 2, "Мария", 2], ["Денис", 5, "Александр", 0], ["Виктор", 5, "Денис", 5], ["Денис", 5, "Виктор", 5], ["Виктор", 6, "Анна", 6], ["Денис", 6, "Анна", 6], ["Виктор", 6, "Ольга", 6], ["Денис", 6, "Ольга", 6]]
    #sister_ProfileKeys_arr = [["Анна", 5, "Виктор", 5], ["Анна", 5, "Денис", 5], ["Анна", 1, "Борис", 1], ["Анна", 2, "Мария", 2], ["Анна", 5, "Александр", 0], ["Ольга", 5, "Виктор", 5], ["Ольга", 5, "Денис", 5], ["Ольга", 1, "Борис", 1], ["Ольга", 2, "Мария", 2], ["Ольга", 5, "Александр", 0], ["Анна", 6, "Ольга", 6], ["Ольга", 6, "Анна", 6]]
    #
    #wife_ProfileKeys_arr = [["Виктория", 7, "Александр", 0], ["Виктория", 3, "Борис", 3], ["Виктория", 3, "Иван", 3], ["Виктория", 4, "Мария", 4], ["Виктория", 4, "Юлия", 4]]
    #husband_ProfileKeys_arr = []
    #son_ProfileKeys_arr = [["Борис", 1, "Александр", 0], ["Борис", 2, "Виктория", 8], ["Иван", 1, "Александр", 0], ["Иван", 2, "Виктория", 8], ["Борис", 5, "Иван", 3], ["Иван", 5, "Борис", 3], ["Борис", 6, "Мария", 4], ["Иван", 6, "Мария", 4], ["Борис", 6, "Юлия", 4], ["Иван", 6, "Юлия", 4]]
    #daugther_ProfileKeys_arr = [["Мария", 1, "Александр", 0], ["Мария", 2, "Виктория", 8], ["Мария", 5, "Борис", 3], ["Мария", 5, "Иван", 3], ["Юлия", 1, "Александр", 0], ["Юлия", 2, "Виктория", 8], ["Мария", 6, "Юлия", 4], ["Юлия", 6, "Мария", 4], ["Юлия", 5, "Борис", 3], ["Юлия", 5, "Иван", 3]]
    #daugthers_names_arr = ["Мария", "Юлия"]



    all_profiles_keys_arr = []
    profile_keys_arr = []
    relation_profile_keys_arr = []     #
    if !profiles_arr_w_ids.blank?
      for arr_i in 0 .. profiles_arr_w_ids.length-1

        name = profiles_arr_w_ids[arr_i][1]
        profile_id = profiles_arr_w_ids[arr_i][0]

        relation_id = profiles_arr_w_ids[arr_i][4]
        @relation_id = relation_id   # DEBUGG TO VIEW
        case relation_id

          when 0
            author_ProfileKeys_arr = session[:author_ProfileKeys_arr][:value]
            save_profile_keys(name, profile_id, profile_id_hash, author_ProfileKeys_arr)

          when 1  # "father"
            father_ProfileKeys_arr = session[:father_ProfileKeys_arr][:value]
            save_profile_keys(name, profile_id, profile_id_hash, father_ProfileKeys_arr)

          when 2  # "mother"
            mother_ProfileKeys_arr = session[:mother_ProfileKeys_arr][:value]  #
            save_profile_keys(name, profile_id, profile_id_hash, mother_ProfileKeys_arr)

          when 3   # "son"
            son_ProfileKeys_arr = session[:son_ProfileKeys_arr][:value]
            sons_names_arr = session[:sons_names_arr][:value]
            save_profile_keys(name, profile_id, profile_id_hash, son_ProfileKeys_arr)

          when 4   # "daughter"
            daugther_ProfileKeys_arr = session[:daugther_ProfileKeys_arr][:value]
            daugthers_names_arr = session[:daugthers_names_arr][:value]
            save_profile_keys(name, profile_id, profile_id_hash, daugther_ProfileKeys_arr)

          when 5  # "brother"
            brother_ProfileKeys_arr = session[:brother_ProfileKeys_arr][:value]
            brothers_names_arr = session[:brothers_names_arr][:value]  #
            save_profile_keys(name, profile_id, profile_id_hash, brother_ProfileKeys_arr)

          when 6   # "sister"
            sister_ProfileKeys_arr = session[:sister_ProfileKeys_arr][:value]  #
            sisters_names_arr = session[:sisters_names_arr][:value]  #
            save_profile_keys(name, profile_id, profile_id_hash, sister_ProfileKeys_arr)

          when 7   # "husband"
            husband_ProfileKeys_arr = session[:husband_ProfileKeys_arr][:value]
            husband_name = session[:husband_name][:value]
            save_profile_keys(name, profile_id, profile_id_hash, husband_ProfileKeys_arr)

          when 8   # "wife"
            wife_ProfileKeys_arr = session[:wife_ProfileKeys_arr][:value]  #
            wife_name = session[:wife_name][:value]
            save_profile_keys(name, profile_id, profile_id_hash, wife_ProfileKeys_arr)

          else
           @search_relation = "ERROR: no relation in tree profile"
           # TODO: call error_processing

        end

      end

    end

  end




  end
