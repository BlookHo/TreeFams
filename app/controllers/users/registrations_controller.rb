class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super

    Tree.delete_all             # DEBUGG
    Tree.reset_pk_sequence

    User.delete_all             # DEBUGG
    User.reset_pk_sequence

    Profile.delete_all          # DEBUGG
    Profile.reset_pk_sequence

    @tree_array = session[:tree_array][:value]
    #@user_sex = session[:user_sex][:value]
    @id_author = @tree_array[0][0]  # Только для отображения в виде таблицы
    @profile_arr = []

    @passw_name = params[:passw] #
    if !@passw_name.blank?

      @profile_arr = save_profiles(@tree_array,@user_email,current_user.id)

      @tree_arr = save_tree(@tree_array,@profile_arr,current_user.id )
    end



    #session[:email_name] = {:value => @email_name, :updated_at => Time.current}
    #session[:passw_name] = {:value => @passw_name, :updated_at => Time.current}
    session[:profile_arr] = {:value => @profile_arr, :updated_at => Time.current}
    #session[:new_user_id] = {:value => @new_user_id, :updated_at => Time.current}
    session[:tree_arr] = {:value => @tree_arr, :updated_at => Time.current}

    redirect_to main_page_path  #########
  end

  def new
    super
  end


  # Страница Сообщений и Бесед Юзера. На ней отображаются инфа обо всех новостях и обновлениях юзера
  def edit
    super

    @first_var = "Первая переменная - SETTINGS"
    @navigation_var = "Navigation переменная - PAGES контроллер/settings метод"

  end
end
