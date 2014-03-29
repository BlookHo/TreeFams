class StartController < ApplicationController




  ####  ENTER PROFILE  ########################

  def enter_myself
    @navigation_var = "Navigation переменная - START контроллер/enter_myself метод"

    Tree.delete_all
    Tree.reset_pk_sequence

    User.delete_all
    User.reset_pk_sequence

    Profile.delete_all
    Profile.reset_pk_sequence

    form_select_fields  # Формирование массивов значений для форм ввода типа select.
    session[:sel_names] = {:value => @sel_names, :updated_at => Time.current}
    session[:sel_names_male] = {:value => @sel_names_male, :updated_at => Time.current}
    session[:sel_names_female] = {:value => @sel_names_female, :updated_at => Time.current}

  end

  def enter_father
    @tree_array = session[:tree_array][:value]
    @sel_names_male = session[:sel_names_male][:value]

    @navigation_var = "Navigation переменная - START контроллер/enter_father метод"

  end

  def enter_mother
    @tree_array = session[:tree_array][:value]
    @sel_names_female = session[:sel_names_female][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_mother метод"

  end

  def enter_brother
    @tree_array = session[:tree_array][:value]
    @sel_names_male = session[:sel_names_male][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_brother метод"

  end

  def enter_sister
    @tree_array = session[:tree_array][:value]
    @sel_names_female = session[:sel_names_female][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_sister метод"

  end

  def enter_son
    @tree_array = session[:tree_array][:value]
    @sel_names_male = session[:sel_names_male][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_son метод"

  end

  def enter_daugther
    @tree_array = session[:tree_array][:value]
    @sel_names_female = session[:sel_names_female][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_daugther метод"

  end

  def enter_husband
    @tree_array = session[:tree_array][:value]
    @sel_names_male = session[:sel_names_male][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_husband метод"

  end

  def enter_wife
    @tree_array = session[:tree_array][:value]
    @sel_names_female = session[:sel_names_female][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_wife метод"

  end


  ####  CHECK PROFILE TO BE ENTERED ########################

  def check_brothers
    @navigation_var = "Navigation переменная - START контроллер/check_brothers метод"

    form_select_fields  # Формирование массивов значений для форм ввода типа select.
    @check_yea_nau = ["Yea", "No"]
    @brothers_exists = params[:brothers_exist?]

    if !@brothers_exists.blank?
      redirect_to start_enter_brothers_path
    end

  end

  def check_sisters
    @navigation_var = "Navigation переменная - START контроллер/check_brothers метод"

    form_select_fields  # Формирование массивов значений для форм ввода типа select.
    @check_yea_nau = ["Yea", "No"]
    @brothers_exists = params[:brothers_exist?]

    if !@brothers_exists.blank?
      redirect_to start_enter_brothers_path
    end

  end


  def check_sons
    @navigation_var = "Navigation переменная - START контроллер/check_brothers метод"

    form_select_fields  # Формирование массивов значений для форм ввода типа select.
    @check_yea_nau = ["Yea", "No"]
    @brothers_exists = params[:brothers_exist?]


    if !@brothers_exists.blank?
      redirect_to start_enter_brothers_path
    end

  end


  def check_daugthers
    @navigation_var = "Navigation переменная - START контроллер/check_brothers метод"

    form_select_fields  # Формирование массивов значений для форм ввода типа select.
    @check_yea_nau = ["Yea", "No"]
    @brothers_exists = params[:brothers_exist?]


    if !@brothers_exists.blank?
      redirect_to start_enter_brothers_path
    end

  end


  def check_husband_or_wife

    @user_sex = session[:user_sex][:value]
    @navigation_var = "Navigation переменная - START контроллер/check_brothers метод"

 #   form_select_fields  # Формирование массивов значений для форм ввода типа select.
 #   @check_yea_nau = ["Yea", "No"]

    if @user_sex    # = true -> User = Male
      redirect_to start_enter_wife_path
    else
      redirect_to start_enter_husband_path
    end

  end

  def check_husband
    @user_sex = session[:user_sex][:value]
    @navigation_var = "Navigation переменная - START контроллер/check_brothers метод"

    form_select_fields  # Формирование массивов значений для форм ввода типа select.
    @check_yea_nau = ["Yea", "No"]
    @brothers_exists = params[:brothers_exist?]


    if !@brothers_exists.blank?
      redirect_to start_enter_brothers_path
    end

  end


  def check_wife
    @navigation_var = "Navigation переменная - START контроллер/check_brothers метод"

    form_select_fields  # Формирование массивов значений для форм ввода типа select.
    @check_yea_nau = ["Yea", "No"]
    @brothers_exists = params[:brothers_exist?]


    if !@brothers_exists.blank?
      redirect_to start_enter_brothers_path
    end

  end


  ####  STORE ENTERED PROFILE  ########################

  def add_profile(id,relation,name,sex)


    @tree_profile_arr = []

    @tree_profile_arr[0] = id              # id
    @tree_profile_arr[1] = relation        # Relation
    @tree_profile_arr[2] = name            # Name
    @tree_profile_arr[3] = sex             # Sex

    return @tree_profile_arr

  end


  def store_myself
    @navigation_var = "Navigation переменная - START контроллер/myself_store метод"

    @user_name = params[:name_select] #
    if !@user_name.blank?
      @user_sex = check_sex_by_name(@user_name) # display sex by name = извлечение пола из введенного имени
    end

    @tree_array = []
    @tree_profile_id = 1
    @tree_profile_arr = add_profile(@tree_profile_id,nil,@user_name,@user_sex)
    @tree_array << @tree_profile_arr
    @tree_profile_id += 1

    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
    session[:user_sex] = {:value => @user_sex, :updated_at => Time.current}
    session[:tree_profile_id] = {:value => @tree_profile_id, :updated_at => Time.current}

    redirect_to start_enter_father_path

  end


  def store_father

    @tree_array = session[:tree_array][:value]
    @user_sex = session[:user_sex][:value]
    @tree_profile_id = session[:tree_profile_id][:value]

    @navigation_var = "Navigation переменная - START контроллер/father_store метод"
    @father_name = params[:father_name_select] #

    if !@father_name.blank?
      @father_sex = check_sex_by_name(@father_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@father_name)
        @father_name_correct = true
      else
        @father_name_correct = false
      end
      # Сохранять отчество Юзера в зависимости от его пола @user_sex!
      @tree_profile_arr = add_profile(@tree_profile_id,1,@father_name,@father_sex)
      @tree_array << @tree_profile_arr
      @tree_profile_id += 1

      session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
      session[:tree_profile_id] = {:value => @tree_profile_id, :updated_at => Time.current}
    end

    redirect_to start_enter_mother_path

  end


  def store_mother

    @tree_array = session[:tree_array][:value]
    @user_sex = session[:user_sex][:value]
    @tree_profile_id = session[:tree_profile_id][:value]

    @navigation_var = "Navigation переменная - START контроллер/mother_store метод"
    @mother_name = params[:mother_name_select] #

    if !@mother_name.blank?
      @user_sex = check_sex_by_name(@mother_name) # display sex by name # проверка, действ-но ли введено женское имя?
      if !check_sex_by_name(@mother_name)
        @mother_name_correct = true
      else
        @mother_name_correct = false
      end
      @tree_profile_arr = add_profile(@tree_profile_id,2,@mother_name,@user_sex)
      @tree_array << @tree_profile_arr
      @tree_profile_id += 1

      session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
      session[:tree_profile_id] = {:value => @tree_profile_id, :updated_at => Time.current}
    end

    redirect_to start_enter_brother_path

  end

  def store_brother

    @tree_array = session[:tree_array][:value]
    @tree_profile_id = session[:tree_profile_id][:value]

    @navigation_var = "Navigation переменная - START контроллер/brother_store метод"
    @brother_name = params[:brother_name_select] #

    if !@brother_name.blank?
      @user_sex = check_sex_by_name(@brother_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@brother_name)
        @brother_name_correct = true
      else
        @brother_name_correct = false
      end
      @tree_profile_arr = add_profile(@tree_profile_id,5,@brother_name,@user_sex)
      @tree_array << @tree_profile_arr
      @tree_profile_id += 1

      session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
      session[:tree_profile_id] = {:value => @tree_profile_id, :updated_at => Time.current}
    end

    redirect_to start_enter_sister_path

  end

  def store_sister

    @tree_array = session[:tree_array][:value]
    @tree_profile_id = session[:tree_profile_id][:value]

    @navigation_var = "Navigation переменная - START контроллер/sister_store метод"
    @sister_name = params[:sister_name_select] #

    if !@sister_name.blank?
      @user_sex = check_sex_by_name(@sister_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@sister_name)
        @sister_name_correct = true
      else
        @sister_name_correct = false
      end
      @tree_profile_arr = add_profile(@tree_profile_id,6,@sister_name,@user_sex)
      @tree_array << @tree_profile_arr
      @tree_profile_id += 1

      session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
      session[:tree_profile_id] = {:value => @tree_profile_id, :updated_at => Time.current}
    end

    check_husband_or_wife   #

 #   redirect_to start_enter_son_path

  end

  def store_husband

    @tree_array = session[:tree_array][:value]
    @tree_profile_id = session[:tree_profile_id][:value]

    @navigation_var = "Navigation переменная - START контроллер/store_husband метод"
    @husband_name = params[:husband_name_select] #

    if !@husband_name.blank?  # надо ли проверять пол мужа - геи?
      @husband_sex = check_sex_by_name(@husband_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@husband_name)
        @husband_name_correct = true
      else
        @husband_name_correct = false
      end
      @tree_profile_arr = add_profile(@tree_profile_id,7,@husband_name,@husband_sex)
      @tree_array << @tree_profile_arr
      @tree_profile_id += 1

      session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
      session[:tree_profile_id] = {:value => @tree_profile_id, :updated_at => Time.current}
    end

    redirect_to start_enter_son_path

  end

  def store_wife

    @tree_array = session[:tree_array][:value]
    @tree_profile_id = session[:tree_profile_id][:value]

    @navigation_var = "Navigation переменная - START контроллер/store_wife метод"
    @wife_name = params[:wife_name_select] #

    if !@wife_name.blank?   # надо ли проверять пол жены - геи?
      @wife_sex = check_sex_by_name(@wife_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@wife_name)
        @wife_name_correct = true
      else
        @wife_name_correct = false
      end
      @tree_profile_arr = add_profile(@tree_profile_id,8,@wife_name,@wife_sex)
      @tree_array << @tree_profile_arr
      @tree_profile_id += 1

      session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
      session[:tree_profile_id] = {:value => @tree_profile_id, :updated_at => Time.current}
    end

    redirect_to start_enter_son_path

  end


  def store_son

    @tree_array = session[:tree_array][:value]
    @user_sex = session[:user_sex][:value]
    @tree_profile_id = session[:tree_profile_id][:value]

    @navigation_var = "Navigation переменная - START контроллер/store_son метод"
    @son_name = params[:son_name_select] #

    if !@son_name.blank?
      @son_sex = check_sex_by_name(@son_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@son_name)
        @son_name_correct = true
      else
        @son_name_correct = false
      end

      # Сохранять отчество Profile в зависимости от пола @user_sex!
      @tree_profile_arr = add_profile(@tree_profile_id,3,@son_name,@son_sex)
      @tree_array << @tree_profile_arr
      @tree_profile_id += 1

      session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
      session[:tree_profile_id] = {:value => @tree_profile_id, :updated_at => Time.current}
    end

    redirect_to start_enter_daugther_path

  end

  def store_daugther

    @tree_array = session[:tree_array][:value]
    @user_sex = session[:user_sex][:value]
    @tree_profile_id = session[:tree_profile_id][:value]

    @navigation_var = "Navigation переменная - START контроллер/store_daugther метод"
    @daugther_name = params[:daugther_name_select] #

    if !@daugther_name.blank?
      @daugther_sex = check_sex_by_name(@daugther_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@daugther_name)
        @daugther_name_correct = true
      else
        @daugther_name_correct = false
      end
      # Сохранять отчество Profile в зависимости от  пола @user_sex!
      @tree_profile_arr = add_profile(@tree_profile_id,4,@daugther_name,@daugther_sex)
      @tree_array << @tree_profile_arr
      @tree_profile_id += 1

      session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
      session[:tree_profile_id] = {:value => @tree_profile_id, :updated_at => Time.current}
    end

    redirect_to show_tree_table_path  #########

  end



  def show_tree_table

    @navigation_var = "Navigation переменная - START контроллер/show_tree_table метод"
    @tree_array = session[:tree_array][:value]
    @user_sex = session[:user_sex][:value]

    @id_author = @tree_array[0][0]  # Только для отображения в виде таблицы

  end


  def save_start

    Tree.delete_all             # DEBUGG
    Tree.reset_pk_sequence

    User.delete_all             # DEBUGG
    User.reset_pk_sequence

    Profile.delete_all          # DEBUGG
    Profile.reset_pk_sequence

    @navigation_var = "Navigation переменная - START контроллер/show_tree_table метод"
    @tree_array = session[:tree_array][:value]
    @user_sex = session[:user_sex][:value]
    @id_author = @tree_array[0][0]  # Только для отображения в виде таблицы
    @profile_arr = []

    @user_email = params[:email] #
    if !@user_email.blank?

      @passw_name = params[:passw] #
      if !@passw_name.blank?

        @new_user_id = user_registration(@user_email,@passw_name)

        @profile_arr = save_profiles(@tree_array,@user_email,@new_user_id)
        #
   #     @user_arr = save_user(@tree_array,@profile_arr)
        #
        #
        #save_tree



      end

    end


    session[:email_name] = {:value => @email_name, :updated_at => Time.current}
    session[:passw_name] = {:value => @passw_name, :updated_at => Time.current}
    session[:profile_arr] = {:value => @profile_arr, :updated_at => Time.current}
    session[:new_user_id] = {:value => @new_user_id, :updated_at => Time.current}

    redirect_to main_page_path  #########

  end


  def user_registration(user_email,passw_name)

        @new_user = User.new
        @new_user.email = user_email        # user_email
        @new_user.password = passw_name     # passw_name
        @new_user.save

        @last_user = User.last
        @last_user_id = User.last.id

        return @last_user_id

  end


  def save_profiles(tree_array, user_email, user_id)

    @profile_arr = []
    @new_profile_arr = []             #

    #@tree_profile_arr[0] = id              # id
    #@tree_profile_arr[1] = relation        # Relation
    #@tree_profile_arr[2] = name            # Name
    #@tree_profile_arr[3] = sex             # Sex


    for arr_i in 0 .. tree_array.length-1

    #  @new_profile = Profile.new
    #  @new_profile[0] =     # после
    #  @id_name_profile = Name.find_by_name(tree_array[arr_i][2])

      if arr_i == 0 # only for email для user
         @new_profile_arr[0] = user_id  # user_id
         @new_profile_arr[2] = user_email
      else
        @new_profile_arr[0] = arr_i + 1  # profile_id
      end
      @new_profile_arr[1] = Name.find_by_name(tree_array[arr_i][2]).id  # name_id
      @new_profile_arr[3] = tree_array[arr_i][3] # sex_id

      @profile_arr <<  @new_profile_arr
      @new_profile_arr = []

     #   @new_profile.save

    end

    return @profile_arr

  end


  def save_user(profile_array)


  end




  def display_saved_tree

end



  end
