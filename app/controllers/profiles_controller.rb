class ProfilesController < ApplicationController

  before_filter :logged_in?

  def show
    @profile = Profile.where(id: params[:id]).first
    @profile_datas = @profile.profile_datas
    @profile_data = @profile_datas.first
  end


  def edit
    @profile = Profile.find(params[:profile_id])
    @profile_data = find_or_create_profile_data
  end


  # def update
  #   @profile = Profile.find(params[:id])
  #   @profile_data = find_or_create_profile_data
  #   if @profile_data.update_attributes(profile_data_params)
  #     redirect_to profile_path(@profile), :notice => "Профиль сохранен!"
  #   else
  #     render :edit, :alert => "Ошибки при сохранении профиля!"
  #   end
  # end



  def new
    # Новый профиль
    @profile = Profile.new
    # Отношение нового профиля (кого добавляем: мать, отец...)
    @profile.relation_id = params[:relation_id]
    # Профиль К КОТОРОМУ добавляем
    @base_profile = Profile.find(params[:base_profile_id])
    # Дерево в котором происходит добавление
    @profile.tree_id = @base_profile.tree_id
  end



  def create

    @base_profile = Profile.find(params[:base_profile_id]) # Старый профиль, к которому добавляем
    @base_profile_id   = @base_profile.id #  профиль того, к кому добавляем
    # текущий автор отображаемого круга
    # теперь это и есть base_profile
    @author_profile_id = @base_profile_id

    # @base_relation_id  = params[:base_relation_id] # relation того, к кому добавляем, к автору отображаемого круга
    @base_relation_id = 0

    @profile = Profile.new(profile_params)  # Новый добавляемый профиль
    @profile.user_id = 0  # признак того, что это не Юзер (а лишь добавляемый профиль)
    @profile.tree_id = @base_profile.tree_id # Дерево, которому принадлежит базовый профиль - к кому добавляем


    @name = Name.where(name: params[:profile_name].mb_chars.capitalize).first

    # if !@name and !params[:profile_name].blank? and params[:new_name_confirmation]
    #   @name = Name.create(name: params[:profile_name])
    # end

    # Name exist and valid:
    # 1. collect questions
    # 2. Validate answers
    if @name
      @profile.name_id = @name.id

      make_questions_data = {
          current_user_id:     current_user.id, #
          base_profile_id:     @base_profile.id, #
          base_relation_id:    @base_relation_id.to_i, #
          profile_relation_id: @profile.relation_id.to_i, #
          profile_name_id:     @profile.name_id.to_i, #
          author_profile_id:   @author_profile_id, #
          connected_users:     current_user.get_connected_users #
      }

      ################ MAIN MAKE NON-STANDARD QUESTIONS #####################
      questions_hash = current_user.profile.make_questions(make_questions_data)

      @questions = create_questions_from_hash(questions_hash)

      ################ COILLECT ANSWERS FOR NON-STANDARD QUESTIONS #####################
      @profile.answers_hash = params[:answers]
      logger.info "==== Вопросы по новому профилю  @questions = #{@questions.inspect}"
      logger.info " @profile.answers_hash = #{@profile.answers_hash} " if !@profile.answers_hash.nil?

      # Validate for relation questions
      if questions_valid?(questions_hash) and @profile.save
        logger.info "==== Start ProfileKey.add_new_profile ====== "
        ProfileKey.add_new_profile(@base_profile,
            @profile, @profile.relation_id,
            exclusions_hash: @profile.answers_hash,
            tree_ids: current_user.get_connected_users) #

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
        flash.now[:alert] = "Вы не указали имя."
        render :new
      else
        flash.now[:name_warning] = "Вы указали имя, которого нет в нашей базе, возможно, вы ошиблись!?"
        render :new
      end
    end
  end






  def OLD_create

    logger.info "==== Profiles_controller.Create ===== Start add new profile!!!"

    @base_profile = Profile.find(params[:base_profile_id]) # Старый профиль, к которому добавляем
    @base_profile_id   = params[:base_profile_id] #  профиль того, к кому добавляем
    @author_profile_id = params[:author_profile_id] # текущий автор отображаемого круга
    @base_relation_id  = params[:base_relation_id] # relation того, к кому добавляем, к автору отображаемого круга

    @profile = Profile.new(profile_params)  # Новый добавляемый профиль
    @profile.user_id = 0  # признак того, что это не Юзер (а лишь добавляемый профиль)
    @profile.tree_id = @base_profile.tree_id # Дерево, которому принадлежит базовый профиль - к кому добавляем

    logger.info " @author_profile_id = #{@author_profile_id}, @profile.tree_id = #{@profile.tree_id} "

    @name = Name.where(name: params[:profile_name].mb_chars.capitalize).first
    #  :profile_name = имя нового профиля

    if !@name and !params[:profile_name].blank? and params[:new_name_confirmation]
      @name = Name.create(name: params[:profile_name])
    end

    logger.info " in create: @name.name = #{@name.name}"
    # Name exist and valid:
    # 1. collect questions
    # 2. Validate answers
    if @name
      @profile.name_id = @name.id
      logger.info " in create: @base_profile.id = #{@base_profile.id}, @base_relation_id.to_i = #{@base_relation_id.to_i}, @profile.relation_id.to_i = #{@profile.relation_id.to_i}, "
      logger.info " in create: current_user.id = #{current_user.id}, @profile.name_id.to_i = #{@profile.name_id.to_i} "
      logger.info " in create: @author_profile_id = #{@author_profile_id}, current_user.get_connected_users = #{current_user.get_connected_users} "
      logger.info " in create: current_user.profile.id = #{current_user.profile.id} "

      make_questions_data = {
          current_user_id:     current_user.id, #
          base_profile_id:     @base_profile.id, #
          base_relation_id:    @base_relation_id.to_i, #
          profile_relation_id: @profile.relation_id.to_i, #
          profile_name_id:     @profile.name_id.to_i, #
          author_profile_id:   @author_profile_id, #
          connected_users:     current_user.get_connected_users #
      }

      ################ MAIN MAKE NON-STANDARD QUESTIONS #####################
      questions_hash = current_user.profile.make_questions(make_questions_data)
      logger.info " in create: questions_hash = #{questions_hash}"

      @questions = create_questions_from_hash(questions_hash)

      ################ COILLECT ANSWERS FOR NON-STANDARD QUESTIONS #####################
      @profile.answers_hash = params[:answers]
      logger.info "==== Вопросы по новому профилю  @questions = #{@questions.inspect}"
      logger.info " @profile.answers_hash = #{@profile.answers_hash} " if !@profile.answers_hash.nil?

      # Validate for relation questions
      if questions_valid?(questions_hash) and @profile.save
        logger.info "==== Start ProfileKey.add_new_profile ====== "
        ProfileKey.add_new_profile(@base_profile,
            @profile, @profile.relation_id,
            exclusions_hash: @profile.answers_hash,
            tree_ids: current_user.get_connected_users)
        #
        # redirect_to to profile circle path if exist, via js
        # if params[:path_link].blank?
        #   @circle = current_user.profile.circle(current_user.id)
        #   @author = current_user.profile
        # else
        #   @path_link = params[:path_link]
        # end

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
        flash.now[:alert] = "Вы не указали имя."
        render :new
      else
        flash.now[:name_warning] = "Вы указали имя, которого нет в нашей базе, возможно, вы ошиблись!?"
        render :new
      end
    end
  end





  def destroy
    @profile = Profile.where(id: params[:id]).first

    if @profile.tree_circle(current_user.get_connected_users, @profile.id).size > 0
     flash[:alert] = "Вы можете удалить только последнего родственника в цепочке"
    elsif @profile.user.present?
     flash[:alert] = "Вы не можете удалить профиль у которого есть реальный владелец (юзер)"
    elsif @profile.user_id == current_user.id
     flash[:alert] = "Вы не можете удалить свой профиль"
    else
       ProfileKey.where("is_profile_id = ? OR profile_id = ?", @profile.id, @profile.id).map(&:destroy)
       Tree.where("is_profile_id = ? OR profile_id = ?", @profile.id, @profile.id).map(&:destroy)
       ProfileData.where(profile_id: @profile.id).map(&:destroy)
       @profile.destroy
       flash[:notice] = "Профиль удален"
       # flash[:alert] = "Ошибка удаления профиля"
    end
    redirect_to :back
  end





  def show_dropdown_menu
    @author_profile_id = params[:author_profile_id]
    @profile = Profile.find(params[:profile_id])
    @base_relation_id = params[:base_relation_id]
    @path_link = params[:path_link]
  end



  def context_menu
    @profile = Profile.find(params[:profile_id])
    @profile.allow_add_relation = @profile.owner_user.get_connected_users.include? current_user.id
    @profile.allow_destroy = !@profile.user.present? # && @profile last in chains
    @profile.allow_invite = !@profile.user.present? && @profile.tree_circle(current_user.get_connected_users, @profile.id).size > 0
    @profile.allow_conversation = @profile.user.present? && @profile.user.id != current_user.id
  end


  private


  def questions_valid?(questions_hash)
    # return true if questions_hash.blank?
    return true if questions_hash.empty?
    questions_hash.try(:size) == params[:answers].try(:size)
  end


  def create_questions_from_hash(questions_hash)
    logger.info "=== debugging in  create_questions_from_hash========="
    logger.info " questions_hash = #{questions_hash.inspect}"
    logger.info questions_hash.blank?

    if questions_hash.nil? or questions_hash.empty?
      return nil
    else
      result = []
      questions_hash.keys.each do |profile_id|
        result << Hashie::Mash.new({id: profile_id, text: questions_hash[profile_id]})
      end
      result
    end
  end



  def find_or_create_profile_data
    profile_data = @profile.profile_datas.where(creator_id: current_user.id).first
    if profile_data.nil?
      profile_data = @profile.profile_datas.create(creator_id: current_user.id)
    end
    return profile_data
  end



  def profile_data_params
    params[:profile_data].permit(:middle_name, :last_name, :biography)
  end



  def profile_params
    params[:profile].permit(:surname,
                            :profile_birthday,
                            :profile_deathday,
                            :country,
                            :city,
                            :about,
                            :profile_name,
                            :relation_id,
                            :profile_datas_attributes =>[:id, :middle_name, :last_name])
  end

end
