class StartController < ApplicationController


  def store_profile(id,relation,name,sex)

    tree_profile_arr = []

    tree_profile_arr[0] = id              # id Profile
    tree_profile_arr[1] = relation        # Relation
    tree_profile_arr[2] = name            # Name
    tree_profile_arr[3] = sex             # Sex

    return tree_profile_arr


  end


  def process_questions

    @navigation_var = "Navigation переменная - START контроллер/process_questions метод"

    @tree_array = []  # Финальный массив стартового дерева
    @id_profile = 1

    ##### MYSELF ##########
    @user_name = params[:name_select] #
    # извлечение пола из введенного имени
    if !@user_name.blank?
      @user_sex = check_sex_by_name(@user_name) # display sex by name

      @tree_profile_arr = store_profile(@id_profile,nil,@user_name,@user_sex)
      @tree_array << @tree_profile_arr
    end


    ##### FATHER ##########
    @father_name = params[:father_name_select] #
    # проверка, действ-но ли введено мужское имя?
    if !@father_name.blank?
      @user_sex = check_sex_by_name(@father_name) # sex by name
      if check_sex_by_name(@father_name)
        @father_name_correct = true
      else
        @father_name_correct = false
      end
      @id_profile += 1

      @tree_profile_arr = store_profile(@id_profile,1,@father_name,@user_sex)
      @tree_array << @tree_profile_arr

    end


    ##### MOTHER ##########
    @mother_name = params[:mother_name_select] #
    # проверка, действ-но ли введено женское имя?
    if !@mother_name.blank?
      @user_sex = check_sex_by_name(@mother_name) # sex by name
      if !check_sex_by_name(@mother_name)
        @mother_name_correct = true
      else
        @mother_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,2,@mother_name,@user_sex)
      @tree_array << @tree_profile_arr

    end




    ##### BROTHER ##########
    @brother_name = params[:brother_name_select] #
    # проверка, действ-но ли введено мужское имя?
    if !@brother_name.blank?
      @user_sex = check_sex_by_name(@brother_name) # sex by name
      if check_sex_by_name(@brother_name)
        @brother_name_correct = true
      else
        @brother_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,3,@brother_name,@user_sex)
      @tree_array << @tree_profile_arr

    end


    ##### SISTER ##########
    @sister_name = params[:sister_name_select] #
    # проверка, действ-но ли введено женское имя?
    if !@sister_name.blank?
      @user_sex = check_sex_by_name(@sister_name) # sex by name
      if !check_sex_by_name(@sister_name)
        @sister_name_correct = true
      else
        @sister_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,4,@sister_name,@user_sex)
      @tree_array << @tree_profile_arr

    end


    ##### SON ##########
    @son_name = params[:son_name_select] #
    # проверка, действ-но ли введено женское имя?
    if !@son_name.blank?
      @user_sex = check_sex_by_name(@son_name) # sex by name
      if !check_sex_by_name(@son_name)
        @son_name_correct = true
      else
        @son_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,5,@son_name,@user_sex)
      @tree_array << @tree_profile_arr
    end


    ##### DAUGTER ##########
    @daugter_name = params[:daugter_name_select] #
    # проверка, действ-но ли введено мужское имя?
    if !@daugter_name.blank?
      @user_sex = check_sex_by_name(@daugter_name) # sex by name
      if check_sex_by_name(@daugter_name)
        @daugter_name_correct = true
      else
        @daugter_name_correct = false
      end
      @id_profile += 1
      @tree_profile_arr = store_profile(@id_profile,6,@daugter_name,@user_sex)
      @tree_array << @tree_profile_arr
    end

    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}

    redirect_to start_show_start_tree_path

  end


  def show_start_tree

    @tree_array = session[:tree_array][:value]


  end




end
