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

    # Имя
    @name = Name.where(id: params[:profile_name_id]).first

    logger.info "=====================NAME==========="
    logger.info @name.inspect
    logger.info "=====================NAME==========="

    if @name

      @profile.name_id = @name.search_name_id
      @profile.display_name_id = @name.id
      @profile.profile_name = @name.name


      logger.info "=====================PROFILE==========="
      logger.info @name.inspect
      logger.info "=====================name id==========="
      logger.info @name.id
      logger.info "=====================profile inspect==========="
      logger.info @profile.inspect
      logger.info "=====================PROFILE==========="


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

        ProfileKey.add_new_profile(@base_sex_id, @base_profile,
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
    logger.info "In enter_email:  params[:profile_id].to_i = #{params[:profile_id].to_i.inspect}"
    session[:profile_id] = {:value => @profile_id} if @profile_id != 0
    @email_name = params[:profile_email] #
    # konstantin.starovoytov@gmail.com
    # denis@lobkov.net
    # medvedev.alexey@gmail.com
    # email = "zoneiva@gmail.com" #@profile.email
    if !@email_name.blank?
      @profile_id = session[:profile_id][:value]
      logger.info "In enter_email: delivered - @email_name = #{@email_name.inspect}" if WeafamMailer.invitation_email(@email_name, @profile_id, current_user.id).deliver
      logger.info "In enter_email: delivered - @profile_id = #{@profile_id.inspect}, current_user.id = #{current_user.id.inspect}"
      #logger.info "In enter_email: delivered - @email_name = #{@email_name.inspect}" if WeafamMailer.invitation_email(@email_name, current_user.id).deliver
      #logger.info "In enter_email: delivered - current_user.id = #{current_user.id.inspect}"
    else
      logger.info "In enter_email: enter_email  !@email_name.blank?: #{!@email_name.blank?}"
      flash[:alert] = "Введите адрес электронной почты. Почтовое сообщение не отправлено. "
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
    params[:profile].permit(:profile_name,
                            :relation_id,
                            :display_name_id)
  end

end
