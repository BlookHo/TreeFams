class Users::RegistrationsController < Devise::RegistrationsController

  # @todo: поставить условия на случай регистрации без дерева + рефакторить
  def create
    #super
    # Devise default code:
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        #respond_with resource, location: after_sign_up_path_for(resource)

            #


        Tree.delete_all             # DEBUGG
        Tree.reset_pk_sequence

        #User.delete_all             # DEBUGG
        #User.reset_pk_sequence

        Profile.delete_all          # DEBUGG
        Profile.reset_pk_sequence

        #@tree_array = session[:tree_array][:value]
        #@user_sex = session[:user_sex][:value]
        #@id_author = @tree_array[0][0]  # Только для отображения в виде таблицы
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
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end

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
