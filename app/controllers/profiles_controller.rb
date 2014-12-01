# encoding: utf-8
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
    # Профиль, к которому добавляем (на котором вызвали меню +)
    @base_profile = Profile.find(params[:base_profile_id])

    # Relation того, к кому добавляем к автору отображаемого круга
    # Его отношение к текущему автору круга. автор круга - шаг назад по пути
    @base_relation_id  = params[:base_relation_id]

    # текущий автор отображаемого круга - путь минус один шаг назад или профиль текущего юзера
    @author_profile_id = params[:author_profile_id]

    @profile = Profile.new(profile_params)  # Новый добавляемый профиль
    # @profile.user_id = 0  # признак того, что это не Юзер (а лишь добавляемый профиль)
    @profile.tree_id = @base_profile.tree_id # Дерево, которому принадлежит базовый профиль - к кому добавляем

    # Имя
    @name = Name.where(id: params[:profile_name_id]).first

    if @name
      @profile.name_id = @name.id
      @profile.profile_name = @name.name

      make_questions_data = {
          current_user_id:     current_user.id,
          base_profile_id:     @base_profile.id,
          base_relation_id:    @base_relation_id.to_i,
          profile_relation_id: @profile.relation_id.to_i,
          profile_name_id:     @profile.name_id.to_i,
          author_profile_id:   @author_profile_id,
          connected_users:     current_user.get_connected_users
      }

      questions_hash = current_user.profile.make_questions(make_questions_data)
      @questions = create_questions_from_hash(questions_hash)

      @profile.answers_hash = params[:answers]

      # Validate for relation questions
      if questions_valid?(questions_hash) and @profile.save

        ProfileKey.add_new_profile(@base_profile,
            @profile, @profile.relation_id,
            exclusions_hash: @profile.answers_hash,
            tree_ids: current_user.get_connected_users)


        @questions = nil
        @profile.answers_hash = nil

        # TODO create new profile data for d3 graph
        # flash.now[:alert] = "Вопросы валидны - профиль coздан"
        # render :new
        # render create.js.erb


      # Ask relations questions
      else
        flash.now[:alert] = "Уточняющие вопросы"
        render :new
      end
    # No name
    else
      @questions = nil
      @profile.answers_hash = nil
      flash.now[:alert] = "Вы не указали имя"
      render :new
    end
  end






  def pre_create

    # Профиль, к которому добавляем (на котором вызвали меню +)
    @base_profile = Profile.find(params[:base_profile_id])
    @base_profile_id   = @base_profile.id

    # текущий автор отображаемого круга - путь минус один шаг назад или профиль текущего юзера
    @author_profile_id = params[:author_profile_id]

    # relation того, к кому добавляем, к автору отображаемого круга
    # Его отношение к текущему центру круга
    @base_relation_id  = params[:base_relation_id]


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
      @profile.profile_name = @name.name

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

        # ProfileKey.add_new_profile(@base_profile,
        #     @profile, @profile.relation_id,
        #     exclusions_hash: @profile.answers_hash,
        #     tree_ids: current_user.get_connected_users)

        # redirect_to to profile circle path if exist, via js
        # if params[:path_link].blank?
        #   @circle = current_user.profile.circle(current_user.id)
        #   @author = current_user.profile
        # else
        #   @path_link = params[:path_link]
        # end

      # Ask relations questions
      else
        flash.now[:alert] = "Уточняющие вопросы"
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
     @error = "Вы можете удалить только последнего родственника в цепочке"
    elsif @profile.user.present?
     @error = "Вы не можете удалить профиль у которого есть реальный владелец (юзер)"
    elsif @profile.user_id == current_user.id
     @error = "Вы не можете удалить свой профиль"
    else
       ProfileKey.where("is_profile_id = ? OR profile_id = ?", @profile.id, @profile.id).map(&:destroy)
       Tree.where("is_profile_id = ? OR profile_id = ?", @profile.id, @profile.id).map(&:destroy)
       ProfileData.where(profile_id: @profile.id).map(&:destroy)
       @profile.destroy
    end
    respond_to do |format|
      format.js
      format.html
    end
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
    @profile.allow_destroy = !@profile.user.present?  && !(@profile.tree_circle(current_user.get_connected_users, @profile.id).size > 0) && (@profile.owner_user.get_connected_users.include? current_user.id)
    @profile.allow_invite = !@profile.user.present?
    @profile.allow_conversation = @profile.user.present? && @profile.user.id != current_user.id
  end


  def enter_email

    @profile_id = params[:profile_id].to_i #
    @current_user_id = params[:curr_user_id].to_i
    logger.info "In enter_email 11: params[:curr_user_id].to_i:  #{params[:curr_user_id].to_i.inspect} , @current_user_id:  #{@current_user_id.inspect}"
    session[:profile_id] = {:value => @profile_id} if @profile_id != 0
    #logger.info "In enter_email 13: session[:profile_id]:  #{session[:profile_id].inspect}"
    #logger.info "In enter_email 131: @current_user_id:  #{@current_user_id.inspect}"
    session[:current_user_id] = {:value => @current_user_id} if @current_user_id != 0
    logger.info "In enter_email 14: session[:current_user_id]:  #{session[:current_user_id].inspect}"
    @email_name = params[:profile_email] # email = "zoneiva@gmail.com" #@profile.email
    #@current_user_id = current_user.id
    #logger.info "In enter_email 15: @current_user_id:  #{@current_user_id.inspect}"
    if !@email_name.blank?
      @profile_id = session[:profile_id][:value]
      @current_user_id = session[:current_user_id][:value]
      logger.info "In enter_email 22: @profile_id:  #{@profile_id.inspect}, @current_user_id:  #{@current_user_id.inspect}"
      logger.info "In enter_email 23: params[:profile_id].to_i:  #{params[:profile_id].to_i.inspect}"
      logger.info "In enter_email 24: enter_email:  delivered!  @email_name = #{@email_name.inspect}" if WeafamMailer.invitation_email(@email_name, @profile_id, @current_user_id).deliver
    else
      logger.info "In enter_email 3: enter_email  !@email_name.blank?: #{!@email_name.blank?}"
    end

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
