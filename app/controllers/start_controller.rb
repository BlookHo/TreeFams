class StartController < ApplicationController



  ####  ENTER PROFILE  ########################

  def enter_myself

    Tree.delete_all
    Tree.reset_pk_sequence

    #User.delete_all
    #User.reset_pk_sequence

    Profile.delete_all
    Profile.reset_pk_sequence

    form_select_arrays  # Формирование массивов значений для форм ввода типа select.

    session[:sel_names] = {:value => @sel_names, :updated_at => Time.current}
    session[:sel_names_male] = {:value => @sel_names_male, :updated_at => Time.current}
    session[:sel_names_female] = {:value => @sel_names_female, :updated_at => Time.current}

  end

  def enter_father
    @profiles_array = session[:profiles_array][:value]
    @sel_names_male = session[:sel_names_male][:value]
  end

  def enter_mother
    @profiles_array = session[:profiles_array][:value]
    @sel_names_female = session[:sel_names_female][:value]
  end

  def enter_brother
    @profiles_array = session[:profiles_array][:value]
    @sel_names_male = session[:sel_names_male][:value]
  end

  def enter_sister
    @profiles_array = session[:profiles_array][:value]
    @sel_names_female = session[:sel_names_female][:value]
  end

  def enter_son
    @profiles_array = session[:profiles_array][:value]
    @sel_names_male = session[:sel_names_male][:value]
  end

  def enter_daugther
    @profiles_array = session[:profiles_array][:value]
    @sel_names_female = session[:sel_names_female][:value]
  end

  def enter_husband
    @profiles_array = session[:profiles_array][:value]
    @sel_names_male = session[:sel_names_male][:value]
  end

  def enter_wife
    @profiles_array = session[:profiles_array][:value]
    @sel_names_female = session[:sel_names_female][:value]
  end


  ####  CHECK PROFILE TO BE ENTERED ########################

  def check_brothers
    #form_select_fields  # Формирование массивов значений для форм ввода типа select.
    @check_yea_nau = ["Yea", "No"]
    @brothers_exists = params[:brothers_exist?]

    if !@brothers_exists.blank?
      redirect_to enter_brothers_path
    end

  end

  def check_sisters
    @navigation_var = "Navigation переменная - START контроллер/check_brothers метод"

    #form_select_fields  # Формирование массивов значений для форм ввода типа select.
    @check_yea_nau = ["Yea", "No"]
    @brothers_exists = params[:brothers_exist?]

    if !@brothers_exists.blank?
      redirect_to enter_brothers_path
    end

  end


  def check_sons
    @navigation_var = "Navigation переменная - START контроллер/check_brothers метод"

    #form_select_fields  # Формирование массивов значений для форм ввода типа select.
    @check_yea_nau = ["Yea", "No"]
    @brothers_exists = params[:brothers_exist?]

    if !@brothers_exists.blank?
      redirect_to enter_brothers_path
    end

  end


  def check_daugthers
    @navigation_var = "Navigation переменная - START контроллер/check_brothers метод"

    #form_select_fields  # Формирование массивов значений для форм ввода типа select.
    @check_yea_nau = ["Yea", "No"]
    @brothers_exists = params[:brothers_exist?]

    if !@brothers_exists.blank?
      redirect_to enter_brothers_path
    end

  end


  def check_husband_or_wife

    @user_sex = session[:user_sex][:value]

    @sel_names_male = session[:sel_names_male][:value]
    @sel_names_female = session[:sel_names_female][:value]
    if @user_sex    # = true -> User = Male

      @render_name = 'start/enter_wife'
      #redirect_to enter_wife_path
    else
      @render_name = 'start/enter_husband'
     # redirect_to enter_husband_path
    end
    @render_name
  end

  def check_husband
    @user_sex = session[:user_sex][:value]
    @navigation_var = "Navigation переменная - START контроллер/check_brothers метод"

    #form_select_fields  # Формирование массивов значений для форм ввода типа select.
    @check_yea_nau = ["Yea", "No"]
    @brothers_exists = params[:brothers_exist?]

    if !@brothers_exists.blank?
      redirect_to enter_brothers_path
    end

  end


  def check_wife
    @navigation_var = "Navigation переменная - START контроллер/check_brothers метод"

    #form_select_fields  # Формирование массивов значений для форм ввода типа select.
    @check_yea_nau = ["Yea", "No"]
    @brothers_exists = params[:brothers_exist?]

    if !@brothers_exists.blank?
      redirect_to enter_brothers_path
    end

  end


  ####  STORE TREE PROFILE  ########################

  def store_myself
    @user_name = params[:name_select] #
    if !@user_name.blank?
      @user_sex = check_sex_by_name(@user_name) # display sex by name = извлечение пола из введенного имени
    end

    @profiles_array = []  #
    one_profile_id = 1  #
    one_profile_arr = add_profile(one_profile_id,nil,@user_name,@user_sex)
    @profiles_array << one_profile_arr
    one_profile_id += 1

    session[:profiles_array] = {:value => @profiles_array, :updated_at => Time.current}
    session[:user_sex] = {:value => @user_sex, :updated_at => Time.current}
    session[:one_profile_id] = {:value => one_profile_id, :updated_at => Time.current}


    @sel_names_male = session[:sel_names_male][:value]
    respond_to do |format|
      format.html
      format.js { render 'start/store_myself' }
    end
    #redirect_to enter_father_path

  end


  def store_father

    @profiles_array = session[:profiles_array][:value]
    @user_sex = session[:user_sex][:value]
    one_profile_id = session[:tree_profile_id][:value]

    @father_name = params[:father_name_select] #

    if !@father_name.blank?
      @father_sex = check_sex_by_name(@father_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@father_name)
        @father_name_correct = true
      else
        @father_name_correct = false
      end
      # Сохранять отчество Юзера в зависимости от его пола @user_sex!
      one_profile_arr = add_profile(one_profile_id,1,@father_name,@father_sex)
      @profiles_array << one_profile_arr
      one_profile_id += 1

      session[:profiles_array] = {:value => @profiles_array, :updated_at => Time.current}
      session[:one_profile_id] = {:value => one_profile_id, :updated_at => Time.current}
    end

    @sel_names_female = session[:sel_names_female][:value]
    respond_to do |format|
      format.html
      format.js { render 'start/store_father' }
    end
    #redirect_to enter_mother_path

  end

  def store_mother

    @profiles_array = session[:profiles_array][:value]
    @user_sex = session[:user_sex][:value]
    one_profile_id = session[:tree_profile_id][:value]

    @mother_name = params[:mother_name_select] #

    if !@mother_name.blank?
      @mother_sex = check_sex_by_name(@mother_name) # display sex by name # проверка, действ-но ли введено женское имя?
      if !check_sex_by_name(@mother_name)
        @mother_name_correct = true
      else
        @mother_name_correct = false
      end
      one_profile_arr = add_profile(one_profile_id,2,@mother_name,@user_sex)
      @profiles_array << one_profile_arr
      one_profile_id += 1

      session[:profiles_array] = {:value => @profiles_array, :updated_at => Time.current}
      session[:one_profile_id] = {:value => one_profile_id, :updated_at => Time.current}
    end
    @sel_names_male = session[:sel_names_male][:value]
    respond_to do |format|
      format.html
      format.js { render 'start/store_mother' }
    end
#    redirect_to enter_brother_path

  end

  def store_brother

    @profiles_array = session[:profiles_array][:value]
    one_profile_id = session[:tree_profile_id][:value]

    @brother_name = params[:brother_name_select] #

    if !@brother_name.blank?
      @brother_sex = check_sex_by_name(@brother_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@brother_name)
        @brother_name_correct = true
      else
        @brother_name_correct = false
      end
      one_profile_arr = add_profile(one_profile_id,5,@brother_name,@brother_sex)
      @profiles_array << one_profile_arr
      one_profile_id += 1

      session[:profiles_array] = {:value => @profiles_array, :updated_at => Time.current}
      session[:one_profile_id] = {:value => one_profile_id, :updated_at => Time.current}
    end
    @sel_names_female = session[:sel_names_female][:value]
    respond_to do |format|
      format.html
      format.js { render 'start/store_brother' }
    end
 #   redirect_to enter_sister_path

  end

  def store_sister

    @profiles_array = session[:profiles_array][:value]
    one_profile_id = session[:tree_profile_id][:value]

    @sister_name = params[:sister_name_select] #

    if !@sister_name.blank?
      @user_sex = check_sex_by_name(@sister_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@sister_name)
        @sister_name_correct = true
      else
        @sister_name_correct = false
      end
      one_profile_arr = add_profile(one_profile_id,6,@sister_name,@user_sex)
      @profiles_array << one_profile_arr
      one_profile_id += 1

      session[:profiles_array] = {:value => @profiles_array, :updated_at => Time.current}
      session[:one_profile_id] = {:value => one_profile_id, :updated_at => Time.current}
    end

    @next_view = check_husband_or_wife   #
    respond_to do |format|
      format.html
      format.js { render 'start/store_sister' }
    end

 #   redirect_to start_enter_son_path

  end

  def store_husband

    @profiles_array = session[:profiles_array][:value]
    one_profile_id = session[:tree_profile_id][:value]

    @husband_name = params[:husband_name_select] #

    if !@husband_name.blank?  # надо ли проверять пол мужа - геи?
      @husband_sex = check_sex_by_name(@husband_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@husband_name)
        @husband_name_correct = true
      else
        @husband_name_correct = false
      end
      one_profile_arr = add_profile(one_profile_id,7,@husband_name,@husband_sex)
      @profiles_array << one_profile_arr
      one_profile_id += 1

      session[:profiles_array] = {:value => @profiles_array, :updated_at => Time.current}
      session[:one_profile_id] = {:value => one_profile_id, :updated_at => Time.current}
    end

    @sel_names_male = session[:sel_names_male][:value]
    respond_to do |format|
      format.html
      format.js { render 'start/store_husband' }
    end
#    redirect_to enter_son_path

  end

  def store_wife

    @profiles_array = session[:profiles_array][:value]
    one_profile_id = session[:tree_profile_id][:value]

    @wife_name = params[:wife_name_select] #

    if !@wife_name.blank?   # надо ли проверять пол жены - геи?
      @wife_sex = check_sex_by_name(@wife_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@wife_name)
        @wife_name_correct = true
      else
        @wife_name_correct = false
      end
      one_profile_arr = add_profile(one_profile_id,8,@wife_name,@wife_sex)
      @profiles_array << one_profile_arr
      one_profile_id += 1

      session[:profiles_array] = {:value => @profiles_array, :updated_at => Time.current}
      session[:one_profile_id] = {:value => one_profile_id, :updated_at => Time.current}
    end

    @sel_names_male = session[:sel_names_male][:value]
    respond_to do |format|
      format.html
      format.js { render 'start/store_wife' }
    end
#    redirect_to enter_son_path

  end


  def store_son

    @profiles_array = session[:profiles_array][:value]
    @user_sex = session[:user_sex][:value]
    one_profile_id = session[:tree_profile_id][:value]

    @son_name = params[:son_name_select] #

    if !@son_name.blank?
      @son_sex = check_sex_by_name(@son_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@son_name)
        @son_name_correct = true
      else
        @son_name_correct = false
      end

      # Сохранять отчество Profile в зависимости от пола @user_sex!
      one_profile_arr = add_profile(one_profile_id,3,@son_name,@son_sex)
      @profiles_array << one_profile_arr
      one_profile_id += 1

      session[:profiles_array] = {:value => @profiles_array, :updated_at => Time.current}
      session[:one_profile_id] = {:value => one_profile_id, :updated_at => Time.current}
    end

    @sel_names_female = session[:sel_names_female][:value]
    respond_to do |format|
      format.html
      format.js { render 'start/store_son' }
    end
#    redirect_to enter_daugther_path

  end

  def store_daugther

    @profiles_array = session[:profiles_array][:value]
    @user_sex = session[:user_sex][:value]
    one_profile_id = session[:tree_profile_id][:value]

    @daugther_name = params[:daugther_name_select] #

    if !@daugther_name.blank?
      @daugther_sex = check_sex_by_name(@daugther_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@daugther_name)
        @daugther_name_correct = true
      else
        @daugther_name_correct = false
      end
      # Сохранять отчество Profile в зависимости от  пола @user_sex!
      one_profile_arr = add_profile(one_profile_id,4,@daugther_name,@daugther_sex)
      @profiles_array << one_profile_arr
      one_profile_id += 1

      session[:profiles_array] = {:value => @profiles_array, :updated_at => Time.current}
      session[:one_profile_id] = {:value => one_profile_id, :updated_at => Time.current}
    end

    @sel_names_female = session[:sel_names_female][:value]
    respond_to do |format|
      format.html
      format.js { render 'start/store_daugther' }
    end
#    redirect_to show_tree_table_path  #########

  end

  def show_tree_table

  end

  def save_start_tables

    Tree.delete_all             # DEBUGG
    Tree.reset_pk_sequence

    #User.delete_all             # DEBUGG
    #User.reset_pk_sequence

    Profile.delete_all          # DEBUGG
    Profile.reset_pk_sequence

    @profiles_array = session[:profiles_array][:value]
    @user_sex = session[:user_sex][:value]

    @id_author = @profiles_array[0][0]  # Только для отображения в виде таблицы
    @user_email = 'mail'

    @profile_arr = save_profiles(@profiles_array,@user_email)

    @tree_arr = save_tree(@profiles_array,@profile_arr,current_user.id )

    update_user

    session[:profile_arr] = {:value => @profile_arr, :updated_at => Time.current}


  end


  ####  SAVE TREE PROFILE  ########################


  # Добавление в массив дерева одного введенного профиля стартового дерева Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see
  def add_profile(index,relation,name,sex)
    one_profile_arr = []

    one_profile_arr[0] = index           # index
    one_profile_arr[1] = relation        # Relation
    one_profile_arr[2] = name            # Name
    one_profile_arr[3] = sex             # Sex

    return one_profile_arr
  end


  # Добавление в массив дерева одного введенного профиля стартового дерева Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see
  def save_profiles(profiles_array, user_email)

    profiles_tree_arr = []
    new_profile_arr = []             #

    #one_profile_arr[0] = id              # id
    #one_profile_arr[1] = relation        # Relation
    #one_profile_arr[2] = name            # Name
    #one_profile_arr[3] = sex             # Sex

    for arr_i in 0 .. profiles_array.length-1

      new_profile = Profile.new
        if arr_i == 0 # only for email для user
          ##############################################

          new_profile.user_id = current_user.id if user_signed_in?   # user_id - берем после регистрации

          ##############################################
          new_profile.email = user_email    # user_id
        else
          new_profile.user_id = nil  # profile - not user_id
          new_profile.email = nil    # profile - not user_id
        end
        new_profile.name_id = Name.find_by_name(profiles_array[arr_i][2]).id  # name_id
        if profiles_array[arr_i][3]
          new_profile.sex_id = 1    # sex_id - MALE
        else
          new_profile.sex_id = 0    # sex_id - FEMALE
        end
      new_profile.save


      # FOR DEBUGG - ARRAY
      if arr_i == 0 # only for email для user
        new_profile_arr[0] = current_user.id  # user_id
        new_profile_arr[2] = user_email
      else
        new_profile_arr[0] = arr_i + 1  # profile_id
      end
      new_profile_arr[1] = Name.find_by_name(profiles_array[arr_i][2]).id  # name_id
      new_profile_arr[3] = profiles_array[arr_i][3] # sex_id

      profiles_tree_arr <<  new_profile_arr
      new_profile_arr = []
      # END DEBUGG - ARRAY


    end

    return profiles_tree_arr

  end


  # Добавление в массив дерева одного введенного профиля стартового дерева Юзера.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see
  def save_tree(profiles_array, profile_arr, new_user_id)

    @new_tree_arr = []
    @tree_arr = []             #

    #one_profile_arr[0] = id              # id
    #one_profile_arr[1] = relation        # Relation
    #one_profile_arr[2] = name            # Name
    #one_profile_arr[3] = sex             # Sex


    for arr_i in 1 .. profiles_array.length-1

      @new_tree = Tree.new
      @new_tree.user_id = new_user_id        # user_email
      @new_tree.profile_id = profiles_array[arr_i][0]     # profile_id
      @new_tree.relation_id = profiles_array[arr_i][1]     # relation_id
      @new_tree.save


      @new_tree_arr[0] = new_user_id  # user_id
      @new_tree_arr[1] = profiles_array[arr_i][0]     # profile_id
      @new_tree_arr[2] = profiles_array[arr_i][1]     # relation_id

      @tree_arr <<  @new_tree_arr
      @new_tree_arr = []

    end

      return @tree_arr

  end

  # Занесение для current_user в поле profile_id значения id из таблицы Profile
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see
  def update_user



  end



  end
