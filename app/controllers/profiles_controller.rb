# encoding: utf-8
class ProfilesController < ApplicationController

  layout 'application.new'
  before_filter :logged_in?
  respond_to :html, :js

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

  # @note: Запуск основного метода создания нового профиля
  def create

    relation_id_param = params[:profile].fetch("relation_id") unless params[:profile].blank?
    # todo: вставить проверки params на nil
    params_to_create = {
        base_profile_id:   params[:base_profile_id],
        profile_name_id:   params[:profile_name_id],
        # relation_id:    params[:profile].fetch("relation_id")
        relation_id:    relation_id_param
    }
    puts "In Profiles_controller: create: params_to_create = #{params_to_create} "

    @base_profile = current_user.creation_profile(params_to_create)
  end



  def destroy
    puts "In Profiles_controller: destroy: profile_to_destroy = #{params[:id]} "
    response = current_user.destroying_profile(params[:id])
    puts "In Profiles_controller: destroy: response = #{response}, response[:message] = #{response[:message]} "

    if response[:status] == 403
      @error = response[:message]
      respond_with @error
    else
      respond_with(status:200)
    end

  end




  # @note: rename profile
  def rename_profile
    # got_profile = params[:profile_to_rename].to_i
    @profile = Profile.find(params[:profile_to_rename].to_i)
    # puts "In Profiles_controller: rename: got_profile = #{got_profile.inspect} "
    puts "In Profiles_controller: rename: @profile = #{@profile.inspect} "
    # prev_name = Name.find(@profile.name_id)
    @new_name_id = params[:new_name_id]
    # @new_name_id = 465 # 465 # 203 = name_id Илья  465=Федор  293=Мария
    puts "In Profiles_controller: rename: @new_name_id = #{@new_name_id.inspect} "

    # new_name = Name.find(@new_name_id)

  #  if new_name.sex_id == @profile.sex_id
      @profile.rename(@new_name_id)
  #    puts "Профиль успешно переименован: с имени #{prev_name} на имя #{new_name}."
   #   flash.now[:notice] = "Профиль успешно переименован с имени #{prev_name} на имя #{new_name}  ."
      # render json: { status: 'ok', redirect: '/home' }
  #  else
  #    puts "Error:400 Выбрано имя не того пола, что Профиль: с имени #{prev_name} на имя #{new_name}."
  #    flash.now[:error] = "Error:400 Выбрано имя не того пола, что Профиль: с имени #{prev_name} на имя #{new_name}  ."
      # render json: { errors: @profile.errors.messages, redirect: '/home' }
      # render json: { errors: "Error:400 Выбрано имя не того пола, что Профиль", redirect: '/home' }
  #  end

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
    @profile.allow_rename = !@profile.user.present?
  end


  def crop
    profile_id = params[:id].blank? ? params[:profile_id] : params[:id]
    @profile = Profile.where(id: profile_id).first
    @profile_datas = @profile.profile_datas
    @current_profile_data = find_current_profile_data
    @current_user_profile_data = current_user_profile_data_for_profile
  end


  def profile_params
    params[:profile].permit(:profile_name,
                            :relation_id,
                            :display_name_id)
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




end


# OLD METHOD CREATE PROFILE WITH QUESTIONS

# # Профиль, к которому добавляем (на котором вызвали меню +)
# @base_profile = Profile.find(params[:base_profile_id])
# puts "In create: @base_profile = #{@base_profile}"
#
# # Sex того профиля, к кому добавляем (на котором вызвали меню +) к автору отображаемого круга
# @base_sex_id = @base_profile.sex_id
#
# # Relation того, к кому добавляем к автору отображаемого круга
# # Его отношение к текущему автору круга. автор круга - шаг назад по пути
# @base_relation_id  = params[:base_relation_id]
#
# # текущий автор отображаемого круга - путь минус один шаг назад или профиль текущего юзера
# @author_profile_id = params[:author_profile_id]
#
# @profile = Profile.new(profile_params)  # Новый добавляемый профиль
# logger.info  "In Profile controller: create  @profile = #{@profile} "
# puts "In Profile controller: create  @profile = #{@profile} "
# logger.info  "In Profile controller: create  @profile.relation_id = #{@profile.relation_id} "
# puts "In Profile controller: create  @profile.relation_id = #{@profile.relation_id} "
#
# # @profile.user_id = 0  # признак того, что это не Юзер (а лишь добавляемый профиль)
#
#
# @profile.tree_id = @base_profile.tree_id # Дерево, которому принадлежит базовый профиль - к кому добавляем
# logger.info  "In Profile controller: create  @profile.tree_id = #{@profile.tree_id} "
# puts "In Profile controller: create  @profile.tree_id = #{@profile.tree_id} "
# # logger.info "In Profile controller: create  @profile.relation_id = #{@profile.relation_id} "
#
# # Имя
# @name = Name.where(id: params[:profile_name_id]).first
#
# # if @name
#   puts "In Profile controller: create  @name = #{@name} "
#
#   @profile.name_id = @name.search_name_id
#   @profile.display_name_id = @name.id
#   @profile.profile_name = @name.name
#
#   # make_questions_data = {
#   #     current_user_id:     current_user.id,
#   #     base_profile_id:     @base_profile.id,
#   #     base_relation_id:    @base_relation_id.to_i,
#   #     profile_relation_id: @profile.relation_id.to_i,
#   #     profile_name_id:     @profile.name_id.to_i,
#   #     author_profile_id:   @author_profile_id,
#   #     connected_users:     current_user.get_connected_users
#   # }
#
#   # questions_hash = current_user.profile.make_questions(make_questions_data)
#   # @questions = create_questions_from_hash(questions_hash)
#   # @profile.answers_hash = params[:answers]
#   @profile.answers_hash = {}
#
#   # Validate for relation questions
#   # if questions_valid?(questions_hash) and @profile.save
#   if @profile.save
#     puts "In create after Save: @profile.id = #{@profile.id}"
#
#     ProfileKey.add_new_profile(@base_sex_id, @base_profile,
#         @profile, @profile.relation_id,
#         exclusions_hash: @profile.answers_hash,
#         tree_ids: current_user.get_connected_users)
#
#     puts "In add_new_profile: Before create_add_log"
#     current_log_type = 1  #  # add: rollback == delete. Тип = добавление нового профиля при rollback
#     new_log_number = CommonLog.new_log_id(@base_profile.tree_id, current_log_type)
#
#     common_log_data = { user_id:         @base_profile.tree_id,   # 3   Алексей к Анне у Натальи
#                         log_type:        current_log_type,        # 1
#                         log_id:          new_log_number,          # 2
#                         profile_id:      @profile.id,             # 215
#                         base_profile_id: @base_profile.id,        # 25
#                         new_relation_id: @profile.relation_id }   # 3
#     # logger.info "In Profile controller: Before create_common_log   common_log_data= #{common_log_data} "
#     CommonLog.create_common_log(common_log_data)
#
#     ##########  UPDATES FEEDS - № 4  # create ###################
#     update_feed_data = { user_id:           current_user.id,    # 3   Алексей к Анне у Натальи
#                          update_id:         4,                  # 4
#                          agent_user_id:     @profile.tree_id,   # 3
#                          read:              false,              #
#                          agent_profile_id:  @profile.id,        # 215
#                          who_made_event:    current_user.id }   # 3
#     logger.info "In Profile controller: Before create UpdatesFeed   update_feed_data= #{update_feed_data} "
#     # update_feed_data= {:user_id=>1, :update_id=>4, :agent_user_id=>2, :read=>false, :agent_profile_id=>219, :who_made_event=>1} (pid:16287)
#
#     UpdatesFeed.create(update_feed_data) #
#
#     ##########  UPDATES FEEDS - № 8, 9, 10 ... 16 #############
#     @profile.case_update_amounts(@profile, current_user)
#
#     @questions = nil
#     @profile.answers_hash = nil
#
#     # TODO create new profile data for d3 graph
#     # flash.now[:alert] = "Вопросы валидны - профиль coздан"
#     # render :new
#     # render create.js.erb
#
#   # Ask relations questions
#   else
#     flash.now[:alert] = "Нет доп.вопросов ИЛИ не создан Профиль "
#     render :new
#   end
# # No name
# # else
# #   @questions = nil
# #   @profile.answers_hash = nil
#
#   # Имя которого нет в базе
#   # if params[:profile_name].blank?
#   #   flash.now[:alert] = "Вы не указали имя"
#   # else
#   #   @new_name = params[:profile_name]
#   #   flash.now[:warning] = "Вы указали имя , которого нет в нашей базе. Хотите добавить новое имя?"
#   # end
#
# #   render :new
# # end
# # render :create
