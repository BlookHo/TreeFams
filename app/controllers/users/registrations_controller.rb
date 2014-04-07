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


        ### @todo:  Поставить здесь условие контроля зарегенности
        #@passw_name = params[:passw] # ?????????
        #if !@passw_name.blank?
        #
        #else
        #  # @todo:  сообщить Юзеру о том, что он незарегился. Причина - диагноз.
        #  #       redirect_to main_page_path  #########
        #end

        if user_signed_in?
          redirect_to save_start_tables_path  #########
        else
          # @todo:  сообщить Юзеру о том, что он незарегился. Причина - диагноз.
          redirect_to main_page_path  #########
        end

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
