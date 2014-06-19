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


  def new
    @profile = Profile.new
    @target_profile = Profile.find(params[:target_profile_id])
  end

  def create
    @target_profile = Profile.find(params[:target_profile_id])
    @profile = Profile.new(profile_params)
    @name = Name.where(name: params[:profile][:name].mb_chars.downcase).first

    if @name
      @profile.name_id = @name.id
      if @profile.save
        flash[:notice] = "Профиль id: #{@profile.id} сохранен"
        redirect_to :main_page
      else
        flash.now[:alert] = "Ошибка при добавления профиля"
        render :new
      end
    else
      flash.now[:alert] = "Ошибка при добавления профиля. Новое имя."
      render :new
    end

  end


  private

  def profile_params
    params[:profile].permit(:surname,
                            :profile_birthday,
                            :profile_deathday,
                            :country,
                            :city,
                            :about,
                            :profile_name,
                            :relation_id)
  end

end
