class PasswordController < ApplicationController

  def reset
    if request.post?
      email = params[:email]
      user = User.where(email: email).first
      if user
        user.reset_password
        flash[:notice] = "Новый пароль отправлен на #{email}"
        redirect_to :login
      else
        flash.now[:alert] = "Пользователь с таким email адресом не найден"
        render :reset
      end
    else
      # render form
    end
  end

end
