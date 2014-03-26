class StartController < ApplicationController


  def store_profile(id,relation,name,sex)

    @tree_profile_arr = []

    @tree_profile_arr[0] = id              # id
    @tree_profile_arr[1] = relation        # Relation
    @tree_profile_arr[2] = name            # Name
    @tree_profile_arr[3] = sex             # Sex

    return @tree_profile_arr


  end


  def process_questions

    @navigation_var = "Navigation переменная - START контроллер/process_questions метод"

    @user_name = params[:name_select] #
    # извлечение пола из введенного имени
    if !@user_name.blank?
      @user_sex = check_sex_by_name(@user_name) # display sex by name
    end

    father_name_select


    mother_name_select

    brother_name_select

    sister_name_select

    son_name_select

    daugter_name_select









    @tree_array = []
#    @tree_array = session[:tree_array][:value]

    @tree_profile_arr = store_profile(1,nil,@user_name,@user_sex)

    @tree_array << @tree_profile_arr


    session[:tree_array] = {:value => @tree_array, :updated_at => Time.current}



#    redirect_to start_enter_myself_path

    redirect_to start_enter_father_path



  end




end
