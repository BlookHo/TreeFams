class InvitesController < ApplicationController

  def new
    # render form
    @profile_id = params[:profile_id]
  end


  def create
    @profile_id = params[:profile_id]
    @email_name = params[:profile_email]

    if !@email_name.blank? and is_a_valid_email?(@email_name)
      WeafamMailer.invitation_email(@email_name, @profile_id, current_user.id).deliver
      flash.now[:notice] = "Приглашение отправлено"
    else
      flash.now[:alert] = "Некорректный email"
      render :new
    end
  end


  private

  def is_a_valid_email?(email)
    email  =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end

end
