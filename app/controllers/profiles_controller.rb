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
    @profile.relation_id = params[:relation_id]
    @base_profile = Profile.find(params[:base_profile_id])
  end


  def create
    @base_profile = Profile.find(params[:base_profile_id])
    @base_profile_id = params[:base_profile_id]

    @profile = Profile.new(profile_params)
    @profile.user_id = 0

    @name = Name.where(name: params[:profile][:name].mb_chars.downcase).first

    # Name exist and valid
    if @name
      @profile.name_id = @name.id

      # Validate for relation questions
      # if relation_qustions_valid? and @profile.save
      if @profile.save
        ProfileKey.add_new_profile(@base_profile, @base_relation_id, @profile, @profile.relation_id, current_user)

        # only js response
        # flash[:notice] = "Профиль id: #{@profile.id} сохранен"
        # redirect_to :main_page

        # redirect_to to profile circle path if exist, via js
        if params[:path_link].blank?
          @circle = current_user.profile.circle(current_user.id)
          @author = current_user.profile
        else
          @path_link = params[:path_link]
        end

      # Ask relations questions
      else
        flash.now[:alert] = "Задаем уточняющие вопросы"
        render :new
      end

    # Name validation
    else
      if params[:profile][:name].blank?
        flash.now[:alert] = "Вы не указли имя."
        render :new
      else
        flash.now[:warning] = "Вы указали имя, которого нет в нашей базе, возможно, вы ошиблись!?"
        render :new
      end
    end
  end


  def relation_qustions_valid?
    false
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


  def destroy
    @profile = Profile.where(id: params[:id]).first
    if @profile and @profile.user_id != current_user.id
      ProfileKey.where("is_profile_id = ? OR profile_id = ?", @profile.id, @profile).map(&:destroy)
      Tree.where(:is_profile_id => 297).map(&:destroy)
      @profile.destroy
      flash.now[:notice] = "Профиль удален"
    else
      flash.now[:alert] = "Ошибка удаления профиля"
    end
    redirect_to :back
  end


  def show_dropdown_menu
    @profile = Profile.find(params[:profile_id])
    @base_relation_id = params[:base_relation_id]
    @path_link = params[:path_link]
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
