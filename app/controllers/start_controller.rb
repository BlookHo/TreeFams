class StartController < ApplicationController








  def enter_myself
    @navigation_var = "Navigation переменная - START контроллер/enter_myself метод"

    form_select_fields  # Формирование массивов значений для форм ввода типа select.


  end

  def enter_father
    @navigation_var = "Navigation переменная - START контроллер/enter_father метод"
    form_select_fields  # Формирование массивов значений для форм ввода типа select.


  end

  def enter_mother
    @navigation_var = "Navigation переменная - START контроллер/enter_mother метод"
    form_select_fields  # Формирование массивов значений для форм ввода типа select.


  end


  def myself_store
    @navigation_var = "Navigation переменная - START контроллер/myself_store метод"

    @user_name = params[:name_select] #
    # извлечение пола из введенного имени
    if !@user_name.blank?
      @user_sex = check_sex_by_name(@user_name) # display sex by name
    end

    redirect_to start_enter_father_path

  end


  def father_store
    @navigation_var = "Navigation переменная - START контроллер/myself_store метод"
    @father_name = params[:father_name_select] #
    # проверка, действ-но ли введено мужское имя?
    if !@father_name.blank?
      if check_sex_by_name(@father_name)
        @father_name_correct = true
      else
        @father_name_correct = false
      end
    end

    redirect_to start_enter_mother_path


  end


  def mother_store
    @navigation_var = "Navigation переменная - START контроллер/myself_store метод"

    @mother_name = params[:mother_name_select] #
    # проверка, действ-но ли введено женское имя?
    if !@mother_name.blank?
      if !check_sex_by_name(@mother_name)
        @mother_name_correct = true
      else
        @mother_name_correct = false
      end
    end

    redirect_to start_enter_mother_path




  end








end
