# encoding: utf-8
class ProfilesController < ApplicationController

  layout 'application.new'
  before_filter :logged_in?

  def show
    profile_id = params[:id].blank? ? params[:profile_id] : params[:id]

    @profile = Profile.where(id: profile_id).first
    @profile_datas = @profile.profile_datas

    @current_profile_data = find_current_profile_data
    @current_user_profile_data = current_user_profile_data_for_profile

  end


  def edit
    @profile = Profile.find(params[:profile_id])
    @profile_data = find_or_create_profile_data
  end


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

    # Sex того профиля, к кому добавляем (на котором вызвали меню +) к автору отображаемого круга
    @base_sex_id = @base_profile.sex_id

    # Relation того, к кому добавляем к автору отображаемого круга
    # Его отношение к текущему автору круга. автор круга - шаг назад по пути
    @base_relation_id  = params[:base_relation_id]

    # текущий автор отображаемого круга - путь минус один шаг назад или профиль текущего юзера
    @author_profile_id = params[:author_profile_id]

    @profile = Profile.new(profile_params)  # Новый добавляемый профиль
    # @profile.user_id = 0  # признак того, что это не Юзер (а лишь добавляемый профиль)
    @profile.tree_id = @base_profile.tree_id # Дерево, которому принадлежит базовый профиль - к кому добавляем
    logger.info "In Profile controller: create  @profile.tree_id = #{@profile.tree_id} "
    logger.info "In Profile controller: create  @profile.relation_id = #{@profile.relation_id} "

    # Имя
    @name = Name.where(id: params[:profile_name_id]).first

    if @name

      @profile.name_id = @name.search_name_id
      @profile.display_name_id = @name.id
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
      # logger.info "In Profile controller: create   questions_hash = #{questions_hash} "

      @questions = create_questions_from_hash(questions_hash)

      @profile.answers_hash = params[:answers]
      # logger.info "In Profile controller: create   questions_valid?(questions_hash) = #{questions_valid?(questions_hash)} "

      # Validate for relation questions
      if questions_valid?(questions_hash) and @profile.save

        logger.info "In Profile controller: create AFTER SAVE  @profile.id = #{@profile.id} "
        logger.info "In Profile controller: create AFTER SAVE  @profile.relation_id = #{@profile.relation_id} "


        ProfileKey.add_new_profile(@base_sex_id, @base_profile,
            @profile, @profile.relation_id,
            exclusions_hash: @profile.answers_hash,
            tree_ids: current_user.get_connected_users)


        # logger.info "In add_new_profile: Before create_add_log"
        current_log_type = 1  #  # add: rollback == delete. Тип = добавление нового профиля при rollback
        new_log_number = CommonLog.new_log_id(@base_profile.tree_id, current_log_type)
        # logger.info "In add_new_profile: Before common_log_data   new_log_number = #{new_log_number}"
        common_log_data = { user_id: @base_profile.tree_id, log_type: current_log_type,
                            log_id:  new_log_number, profile_id: @profile.id,
                            base_profile_id: @base_profile.id,
                            new_relation_id: @profile.relation_id }
        logger.info "In Profile controller: Before create_common_log   @profile.relation_id = #{@profile.relation_id},
                                                        @base_profile.id = #{@base_profile.id}          "
        CommonLog.create_common_log(common_log_data)





        ##########  UPDATES FEEDS - № 4  ####################
        UpdatesFeed.create(user_id: current_user.id, update_id: 4, agent_user_id: current_user.id, agent_profile_id: @profile.id, read: false)
        ##########  UPDATES FEEDS - № 8, 9, 10  #############
        @profile.case_update_amounts(@profile, current_user)

        @questions = nil
        @profile.answers_hash = nil

        # TODO create new profile data for d3 graph
        # flash.now[:alert] = "Вопросы валидны - профиль coздан"
        # render :new
        # render create.js.erb

      # Ask relations questions
      else
        flash.now[:alert] = "Нет доп.вопросов ИЛИ не создан Профиль "
        render :new
      end
    # No name
    else
      @questions = nil
      @profile.answers_hash = nil

      # Имя которого нет в базе
      if params[:profile_name].blank?
        flash.now[:alert] = "Вы не указали имя"
      else
        @new_name = params[:profile_name]
        flash.now[:warning] = "Вы указали имя , которого нет в нашей базе. Хотите добавить новое имя?"
      end

      render :new
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

       tree_row = Tree.where(is_profile_id: params[:id])
       new_relation_id = tree_row[0].relation_id
       logger.info "In Profiles_contr destroy: Before delete Tree  new_relation_id = #{new_relation_id} "
       # Профиль, к которому добавляем (на котором вызвали меню +)
       base_profile = Profile.find(tree_row[0].profile_id)  #
       logger.info "In Profiles_contr destroy: Before delete Tree  base_profile.id = #{base_profile.id} "


       Tree.where("is_profile_id = ? OR profile_id = ?", @profile.id, @profile.id).map(&:destroy)
       # todo: не удалять ProfileData?
       ProfileData.where(profile_id: @profile.id).map(&:destroy)
       # @profile.destroy # Не удаляем профили, чтобы иметь возм-ть повторить создание удаленных профилей

       logger.info "In Profiles_contr destroy: Before create_add_log"
       current_log_type = 2  #  # delete : rollback == add. Тип = удаление нового профиля при rollback
       new_log_number = CommonLog.new_log_id(base_profile.tree_id, current_log_type)
       logger.info "In add_new_profile: Before common_log_data   new_log_number = #{new_log_number}"

       common_log_data = { user_id: base_profile.tree_id, log_type: current_log_type, # ok
                           log_id:  new_log_number, profile_id: params[:id],    # ok
           base_profile_id: base_profile.id,
           new_relation_id: new_relation_id,
       # base_sex_id: base_profile.sex_id

       }

       logger.info "In add_new_profile: Before create_add_log   common_log_data = #{common_log_data}"
       # common_log_data = {:user_id=>2, :log_type=>1, :log_id=>7, :profile_id=>113}
       # common_log_data = { user_id: base_profile.tree_id,
       #                     log_type: 2,  # delete: rollback == add
       #                     log_type: 1,  # add: rollback == delete
       #                     profile_id: base_profile.id,
       #                     relation_id: relation_id, # where?
       #                     new_profile_id: new_profile.id,
       #                     new_sex_id: new_profile.sex_id,
       #                     new_name_id: new_profile.name_id,
       #                     new_disp_name_id: new_profile.display_name_id,
       #
       #                     log_id:  new_log_number, profile_id: new_profile.id }
       CommonLog.create_common_log(common_log_data)


    end
    respond_to do |format|
      format.js
      format.html
    end
  end




  # Старый метод - не исп-ся!!!
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


  def crop
    profile_id = params[:id].blank? ? params[:profile_id] : params[:id]
    @profile = Profile.where(id: profile_id).first
    @profile_datas = @profile.profile_datas
    @current_profile_data = find_current_profile_data
    @current_user_profile_data = current_user_profile_data_for_profile
  end



  private


  def questions_valid?(questions_hash)
    # return true if questions_hash.blank?
    return true if questions_hash.empty?
    # или одинак. размеры массива вопросов и хэша
    questions_hash.try(:size) == params[:answers].try(:size)
  end


  def create_questions_from_hash(questions_hash)
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




  def current_user_profile_data_for_profile
    profile_data = @profile.profile_datas.where(creator_id: current_user.id).first
    if profile_data.nil?
      profile_data = @profile.profile_datas.new(creator_id: current_user.id)
    end
    return profile_data
  end


  def find_current_profile_data
    if params[:profile_data_id].blank?
      if @profile_datas.empty?
        profile_data = @profile.profile_datas.new(creator_id: current_user.id)
      else
        @profile_datas.first
      end
    else
      profile_data = @profile.profile_datas.where(id: params[:profile_data_id]).first
    end
  end






  def profile_data_params
    params[:profile_data].permit(:middle_name, :last_name, :biography)
  end



  def profile_params
    params[:profile].permit(:profile_name,
                            :relation_id,
                            :display_name_id)
  end

end
