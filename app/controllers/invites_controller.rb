class InvitesController < ApplicationController

  def new
    # render form
    @profile_id = params[:profile_id]
  end

  # todo: Разнесим на методы create Updates
  def create
    @profile_id = params[:profile_id]
    @email_name = params[:profile_email]

    if !@email_name.blank? and is_a_valid_email?(@email_name)
      WeafamMailer.invitation_email(@email_name, @profile_id, current_user.id).deliver
      flash.now[:notice] = "Приглашение отправлено"

      user_profile = Profile.find(params[:profile_id].to_i).tree_id
      logger.info "In create invitation_email:  user_profile = #{user_profile},
                   params[:profile_id].to_i = #{params[:profile_id].to_i} " #

      ##########  UPDATES - № 5  ####################         agent_user_id: current_user.id,
      updates_data = { user_id: current_user.id, update_id: 5, agent_user_id: user_profile,
                       agent_profile_id: params[:profile_id].to_i,  who_made_event: current_user.id, read: false}
      UpdatesFeed.create(updates_data)
      ###############################################

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
