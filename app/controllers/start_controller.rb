class StartController < ApplicationController



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
    # извлечение пола из введенного имени
    if !@user_name.blank?
      @user_sex = check_sex_by_name(@user_name) # display sex by name
    end

    @tree_array = []

    @tree_profile_arr = store_profile(1,nil,@user_name,@user_sex)

    @tree_array << @tree_profile_arr


    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}



#    redirect_to start_enter_myself_path

     redirect_to start_enter_father_path



  end


  def father_store

    @tree_array = session[:tree_array][:value]

    @navigation_var = "Navigation переменная - START контроллер/father_store метод"
    @father_name = params[:father_name_select] #
    # проверка, действ-но ли введено мужское имя?
    if !@father_name.blank?
      @user_sex = check_sex_by_name(@father_name) # display sex by name
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
    # проверка, действ-но ли введено женское имя?
    if !@mother_name.blank?
      @user_sex = check_sex_by_name(@mother_name) # display sex by name
      if !check_sex_by_name(@mother_name)
        @mother_name_correct = true
      else
        @mother_name_correct = false
      end
    end

    @tree_profile_arr = store_profile(2,2,@mother_name,@user_sex)

    @tree_array << @tree_profile_arr


    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}


    redirect_to "main/_main_display_tree"




  end








end
