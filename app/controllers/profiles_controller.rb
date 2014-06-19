class ProfilesController < ApplicationController

  before_filter :logged_in?

  def show
    @profile = Profile.where(id: params[:id]).first
  end


  def edit
    @profile = Profile.where(id: params[:id]).first
  end


  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(profile_params)
      redirect_to profile_path(@profile), :notice => "Профиль сохранен!"
    else
      render :edit, :alert => "Ошибки при сохранении профиля!"
    end
  end


  private

  def profile_params
    params[:profile].permit(:surname,
                             :profile_birthday,
                             :profile_deathday,
                             :country,
                             :city,
                             :about)
  end

end
