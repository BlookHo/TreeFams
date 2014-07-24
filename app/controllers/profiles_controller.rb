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
    @author_profile_id = params[:author_profile_id]
    @base_relation_id = params[:base_relation_id]


    @profile = Profile.new(profile_params)
    @profile.user_id = 0

    @name = Name.where(name: params[:profile][:name].mb_chars.downcase).first

    # if new name - create
    if !@name and !params[:profile][:name].blank? and params[:new_name_confirmation]
      @name = Name.create(name: params[:profile][:name])
    end



    # Name exist and valid:
    # 1. collect questions
    # 2. Validate answers
    if @name
      @profile.name_id = @name.id

      # user_id           Дерево в которое добавляем
      # profile_id        Профиль к которому добавляем
      # relation_add_to   Отношение К которому добавляем
      # relation_added    Отношение КОТОРОЕ добавляем (кого добавляем)
      # name_id_added     ID имени нового отношения
      # make_questions(user_id, profile_id, relation_add_to, relation_added, name_id_added)
      questions_hash = current_user.profile.make_questions(current_user.id, @base_profile.id, @base_relation_id.to_i, @profile.relation_id.to_i, @profile.name_id.to_i, @author_profile_id)
      # questions_hash = current_user.profile.make_questions(current_user.id, current_user.profile_id, @base_relation_id.to_i, @profile.relation_id.to_i, @profile.name_id.to_i)
      @questions = create_questions_from_hash(questions_hash)
      @profile.answers_hash = params[:answers]


      # Validate for relation questions
      if questions_valid?(questions_hash) and @profile.save
        ProfileKey.add_new_profile(@base_profile, @base_relation_id, @profile, @profile.relation_id, current_user, exclusions_hash: @profile.answers_hash)

        # redirect_to to profile circle path if exist, via js
        if params[:path_link].blank?
          @circle = current_user.profile.circle(current_user.id)
          @author = current_user.profile
        else
          @path_link = params[:path_link]
        end

      # Ask relations questions
      else
        # flash.now[:alert] = "Уточняющие вопросы"
        render :new
      end

    # Name validation
    # reset question
    else
      @questions = nil
      @profile.answers_hash = nil

      if params[:profile][:name].blank?
        flash.now[:alert] = "Вы не указли имя."
        render :new
      else
        flash.now[:name_warning] = "Вы указали имя, которого нет в нашей базе, возможно, вы ошиблись!?"
        render :new
      end
    end
  end






  def destroy

    @profile = Profile.where(id: params[:id]).first

    if @profile.tree_circle(current_user.id, @profile.id).size > 0
      flash[:alert] = "Вы можете удалить только последнего родственника в цепочке"
    else
      if @profile and @profile.user_id != current_user.id
        ProfileKey.where("is_profile_id = ? OR profile_id = ?", @profile.id, @profile.id).map(&:destroy)
        Tree.where("is_profile_id = ? OR profile_id = ?", @profile.id, @profile.id).map(&:destroy)
        @profile.destroy
        flash[:notice] = "Профиль удален"
      else
        flash[:alert] = "Ошибка удаления профиля"
      end
    end


    redirect_to :back
  end


  def show_dropdown_menu
    @author_profile_id = params[:author_profile_id]
    @profile = Profile.find(params[:profile_id])
    @base_relation_id = params[:base_relation_id]
    @path_link = params[:path_link]
  end



  private


  def questions_valid?(questions_hash)

    # return true if questions_hash.blank?
    return true if questions_hash.nil?
    questions_hash.try(:size) == params[:answers].try(:size)
  end


  def create_questions_from_hash(questions_hash)
    logger.info "=== debugging create_questions_from_hash========="
    logger.info questions_hash
    logger.info questions_hash.blank?

    if questions_hash.nil?
      return nil
    else
      result = []
      questions_hash.keys.each do |profile_id|
        result << Hashie::Mash.new({id: profile_id, text: questions_hash[profile_id]})
      end
      result
    end
  end


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
