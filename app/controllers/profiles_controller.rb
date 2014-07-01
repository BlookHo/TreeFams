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
    @base_profile = Profile.find(params[:base_profile_id])
  end

  def create
    @base_profile = Profile.find(params[:base_profile_id])
    @base_profile_id = params[:base_profile_id]

    @profile = Profile.new(profile_params)
    @profile.user_id = 0
    @name = Name.where(name: params[:profile][:name].mb_chars.downcase).first

    if @name
      @profile.name_id = @name.id
      if @profile.save

        ProfileKey.add_new_profile(@base_profile, @base_relation_id, @profile, @profile.relation_id, current_user)

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


  def destroy
    @profile = Profile.where(id: params[:id]).first
    if @profile
      # TODO удалять вложенные профили и свзяи при их наличии
      # current_user.trees.where(is_profile_id: @profile.id).map(&:destroy)
      # current_user.profile_keys.where(is_profile_id:@profile.id).map(&:destroy)
      # current_user.profile_keys.where(profile_id:@profile.id).map(&:destroy)
      # @profile.destroy
      flash.now[:notice] = "Профиль удален"
    else
      flash.now[:alert] = "Ошибка удаления профиля"
    end
    redirect_to :back
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
