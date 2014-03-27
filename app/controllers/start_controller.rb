class StartController < ApplicationController




  ####  ENTER PROFILE  ########################

  def enter_myself
    @navigation_var = "Navigation переменная - START контроллер/enter_myself метод"

    form_select_fields  # Формирование массивов значений для форм ввода типа select.


  end

  def enter_father
    @tree_array = session[:tree_array][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_father метод"
    form_select_fields  # Формирование массивов значений для форм ввода типа select.


  end

  def enter_mother
    @tree_array = session[:tree_array][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_mother метод"
    form_select_fields  # Формирование массивов значений для форм ввода типа select.


  end

  def enter_brother
    @tree_array = session[:tree_array][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_brother метод"
    form_select_fields  # Формирование массивов значений для форм ввода типа select.

  end

  def enter_sister
    @tree_array = session[:tree_array][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_sister метод"
    form_select_fields  # Формирование массивов значений для форм ввода типа select.

  end

  def enter_son
    @tree_array = session[:tree_array][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_son метод"
    form_select_fields  # Формирование массивов значений для форм ввода типа select.

  end

  def enter_daugther
    @tree_array = session[:tree_array][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_daugther метод"
    form_select_fields  # Формирование массивов значений для форм ввода типа select.

  end

  def enter_husband
    @tree_array = session[:tree_array][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_husband метод"
    form_select_fields  # Формирование массивов значений для форм ввода типа select.

  end

  def enter_wife
    @tree_array = session[:tree_array][:value]
    @navigation_var = "Navigation переменная - START контроллер/enter_wife метод"
    form_select_fields  # Формирование массивов значений для форм ввода типа select.

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


  def check_husband
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

  def store_profile(id,relation,name,sex)

    @tree_profile_arr = []

    @tree_profile_arr[0] = id              # id
    @tree_profile_arr[1] = relation        # Relation
    @tree_profile_arr[2] = name            # Name
    @tree_profile_arr[3] = sex             # Sex

    return @tree_profile_arr


  end


  def myself_store
    @navigation_var = "Navigation переменная - START контроллер/myself_store метод"

    @user_name = params[:name_select] #
    if !@user_name.blank?
      @user_sex = check_sex_by_name(@user_name) # display sex by name = извлечение пола из введенного имени
    end

    @tree_array = []
    @tree_profile_arr = store_profile(1,nil,@user_name,@user_sex)
    @tree_array << @tree_profile_arr

    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
    redirect_to start_enter_father_path

  end


  def father_store

    @tree_array = session[:tree_array][:value]

    @navigation_var = "Navigation переменная - START контроллер/father_store метод"
    @father_name = params[:father_name_select] #

    if !@father_name.blank?
      @user_sex = check_sex_by_name(@father_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@father_name)
        @father_name_correct = true
      else
        @father_name_correct = false
      end
    end

    @tree_profile_arr = store_profile(2,1,@father_name,@user_sex)
    @tree_array << @tree_profile_arr

    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
    redirect_to start_enter_mother_path

  end


  def mother_store

    @tree_array = session[:tree_array][:value]

    @navigation_var = "Navigation переменная - START контроллер/mother_store метод"
    @mother_name = params[:mother_name_select] #

    if !@mother_name.blank?
      @user_sex = check_sex_by_name(@mother_name) # display sex by name # проверка, действ-но ли введено женское имя?
      if !check_sex_by_name(@mother_name)
        @mother_name_correct = true
      else
        @mother_name_correct = false
      end
    end

    @tree_profile_arr = store_profile(2,2,@mother_name,@user_sex)
    @tree_array << @tree_profile_arr

    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}

    redirect_to start_check_brothers_path

  end

  def brother_store

    @tree_array = session[:tree_array][:value]

    @navigation_var = "Navigation переменная - START контроллер/father_store метод"
    @father_name = params[:father_name_select] #

    if !@father_name.blank?
      @user_sex = check_sex_by_name(@father_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@father_name)
        @father_name_correct = true
      else
        @father_name_correct = false
      end
    end

    @tree_profile_arr = store_profile(2,1,@father_name,@user_sex)
    @tree_array << @tree_profile_arr

    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
    redirect_to start_enter_mother_path

  end

  def sister_store

    @tree_array = session[:tree_array][:value]

    @navigation_var = "Navigation переменная - START контроллер/father_store метод"
    @father_name = params[:father_name_select] #

    if !@father_name.blank?
      @user_sex = check_sex_by_name(@father_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@father_name)
        @father_name_correct = true
      else
        @father_name_correct = false
      end
    end

    @tree_profile_arr = store_profile(2,1,@father_name,@user_sex)
    @tree_array << @tree_profile_arr

    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
    redirect_to start_enter_mother_path

  end

  def son_store

    @tree_array = session[:tree_array][:value]

    @navigation_var = "Navigation переменная - START контроллер/father_store метод"
    @father_name = params[:father_name_select] #

    if !@father_name.blank?
      @user_sex = check_sex_by_name(@father_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@father_name)
        @father_name_correct = true
      else
        @father_name_correct = false
      end
    end

    @tree_profile_arr = store_profile(2,1,@father_name,@user_sex)
    @tree_array << @tree_profile_arr

    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
    redirect_to start_enter_mother_path

  end

  def daugther_store

    @tree_array = session[:tree_array][:value]

    @navigation_var = "Navigation переменная - START контроллер/father_store метод"
    @father_name = params[:father_name_select] #

    if !@father_name.blank?
      @user_sex = check_sex_by_name(@father_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@father_name)
        @father_name_correct = true
      else
        @father_name_correct = false
      end
    end

    @tree_profile_arr = store_profile(2,1,@father_name,@user_sex)
    @tree_array << @tree_profile_arr

    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
    redirect_to start_enter_mother_path

  end

  def husband_store

    @tree_array = session[:tree_array][:value]

    @navigation_var = "Navigation переменная - START контроллер/father_store метод"
    @father_name = params[:father_name_select] #

    if !@father_name.blank?
      @user_sex = check_sex_by_name(@father_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@father_name)
        @father_name_correct = true
      else
        @father_name_correct = false
      end
    end

    @tree_profile_arr = store_profile(2,1,@father_name,@user_sex)
    @tree_array << @tree_profile_arr

    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
    redirect_to start_enter_mother_path

  end

  def wife_store

    @tree_array = session[:tree_array][:value]

    @navigation_var = "Navigation переменная - START контроллер/father_store метод"
    @father_name = params[:father_name_select] #

    if !@father_name.blank?
      @user_sex = check_sex_by_name(@father_name) # display sex by name # проверка, действ-но ли введено мужское имя?
      if check_sex_by_name(@father_name)
        @father_name_correct = true
      else
        @father_name_correct = false
      end
    end

    @tree_profile_arr = store_profile(2,1,@father_name,@user_sex)
    @tree_array << @tree_profile_arr

    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}
    redirect_to start_enter_mother_path

  end



  def show_tree_table

    @tree_array = session[:tree_array][:value]


    @navigation_var = "Navigation переменная - START контроллер/mother_store метод"



  end





  end
