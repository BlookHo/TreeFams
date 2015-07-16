module ProfileCreation
  extend ActiveSupport::Concern



  # @note: Основной метод создания нового профиля
  def creation_profile(params_to_create)

    puts "In Rails Concern: creation_profile: params_to_create = #{params_to_create} "

    profile = Profile.where(id: params_to_create[:base_profile_id] ).first  # base_profile
    name = Name.where(id: params_to_create[:profile_name_id]).first   # new profile name id
    relation_id = params_to_create[:relation_id]  # new profile relation_id

    new_profile = create_one_profile(name, self.id)
    create_keys(profile, new_profile, relation_id, self)

    ################################
    current_log_type = 1  #  # add: rollback == delete. Тип = добавление нового профиля при rollback
    new_log_number = CommonLog.new_log_id(profile.tree_id, current_log_type)

    common_log_data = { user_id:         profile.tree_id,   # 3   Алексей к Анне у Натальи
                        log_type:        current_log_type,        # 1
                        log_id:          new_log_number,          # 2
                        profile_id:      new_profile.id,             # 215
                        base_profile_id: profile.id,        # 25
                        new_relation_id: relation_id }   # 3


    CommonLog.create_common_log(common_log_data)

    ##########  UPDATES FEEDS - № 4  # create ###################
    update_feed_data = { user_id:           self.id,    # 3   Алексей к Анне у Натальи
                         update_id:         4,                  # 4
                         agent_user_id:     new_profile.tree_id,   # 3
                         read:              false,              #
                         agent_profile_id:  new_profile.id,        # 215
                         who_made_event:    self.id }   # 3

    UpdatesFeed.create(update_feed_data) #
    new_profile.case_update_amounts(new_profile, self)
    ################################

     new_profile
  # respond_with new_profile

  end



  def create_one_profile(name, user_id)
    Profile.create({
                       name_id:          name.search_name_id,
                       display_name_id:  name.id,
                       sex_id:           name.sex_id,
                       tree_id:          user_id
                   })
  end


  # @note
  # @params base_sex_id,
  #   base_profile,
  #   new_profile,
  #   new_relation_id,
  #   exclusions_hash: nil,
  #   tree_ids: tree_ids
  def create_keys(profile, new_profile, relation_id, user)
    ProfileKey.add_new_profile(
        profile.sex_id,
        profile,
        new_profile,
        relation_id,
        exclusions_hash: nil,
        tree_ids: user.get_connected_users
    )
  end





  #   base_profile_id = params_to_create[:base_profile_id]    # use in Met
          #   # base_relation_id = params_to_create[:base_relation_id]
          #   # author_profile_id = params_to_create[:author_profile_id]
          #   # profile_params = params_to_create[:profile_params]   # use in Met relation_id
          #   profile_name_id = params_to_create[:profile_name_id]  # use in Met name_id
          #   relation_id =  params_to_create[:relation_id]
          #
          #   puts "In create: params_to_create[:relation_id] = #{params_to_create[:relation_id]}"
          #
          #   # Профиль, к которому добавляем (на котором вызвали меню +)
          #   @base_profile = Profile.find(base_profile_id)
          #
          #   puts "In create: @base_profile = #{@base_profile}"
          #
          #   # Sex того профиля, к кому добавляем (на котором вызвали меню +) к автору отображаемого круга
          #   @base_sex_id = @base_profile.sex_id
          #
          #   # Relation того, к кому добавляем к автору отображаемого круга
          #   # Его отношение к текущему автору круга. автор круга - шаг назад по пути
          #   # @base_relation_id  = base_relation_id
          #
          #   # текущий автор отображаемого круга - путь минус один шаг назад или профиль текущего юзера
          #   # @author_profile_id = author_profile_id
          #
          #   @profile = Profile.new#(profile_params)  # Новый добавляемый профиль
          #   logger.info  "In Profile controller: create  @profile = #{@profile} "
          #   puts "In Profile controller: create  @profile = #{@profile} "
          #   @profile.relation_id = relation_id
          #   logger.info  "In Profile controller: create  @profile.relation_id = #{@profile.relation_id} "
          #   puts "In Profile controller: create  @profile.relation_id = #{@profile.relation_id} "
          #
          #   @profile.tree_id = @base_profile.tree_id # Дерево, которому принадлежит базовый профиль - к кому добавляем
          #   logger.info  "In Profile controller: create  @profile.tree_id = #{@profile.tree_id} "
          #   puts "In Profile controller: create  @profile.tree_id = #{@profile.tree_id} "
          #
          #   # Имя
          #   @name = Name.where(id: profile_name_id).first
          #
          #   puts "In Profile controller: create  @name = #{@name} "
          #
          #   @profile.name_id = @name.search_name_id
          #   @profile.display_name_id = @name.id
          #   @profile.profile_name = @name.name
          #
          #   @profile.answers_hash = {}
          #
          #   if @profile.save
          #     puts "In create after Save: @profile.id = #{@profile.id}"
          #
          #     ProfileKey.add_new_profile(@base_sex_id, @base_profile,
          #                                @profile, @profile.relation_id,
          #                                # @profile, relation_id,
          #                                exclusions_hash: @profile.answers_hash,
          #                                tree_ids: self.get_connected_users)
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
          #     CommonLog.create_common_log(common_log_data)
          #
          #     ##########  UPDATES FEEDS - № 4  # create ###################
          #     update_feed_data = { user_id:           self.id,    # 3   Алексей к Анне у Натальи
          #                          update_id:         4,                  # 4
          #                          agent_user_id:     @profile.tree_id,   # 3
          #                          read:              false,              #
          #                          agent_profile_id:  @profile.id,        # 215
          #                          who_made_event:    self.id }   # 3
          #     logger.info "In Profile controller: Before create UpdatesFeed   update_feed_data= #{update_feed_data} "
          #     # update_feed_data= {:user_id=>1, :update_id=>4, :agent_user_id=>2, :read=>false, :agent_profile_id=>219, :who_made_event=>1} (pid:16287)
          #
          #     UpdatesFeed.create(update_feed_data) #
          #
          #     ##########  UPDATES FEEDS - № 8, 9, 10 ... 16 #############
          #     @profile.case_update_amounts(@profile, self)
          #
          #     @questions = nil
          #     @profile.answers_hash = nil
          #
          #   else
          #     flash.now[:alert] = "Нет доп.вопросов ИЛИ не создан Профиль "
          #     render :new
          #   end
          #
          #   @profile
          #
          # end




  # def create_extra_keys(relation_name, data, user)
  #   extra_profile = get_extra_profile(relation_name, user)
  #   ProfileKey.add_new_profile(
  #       extra_profile.sex_id,
  #       extra_profile,
  #       create_profile(data.merge({tree_id: user.id}.as_json), user),
  #       get_id_for_extra_relation(relation_name),
  #       exclusions_hash: nil,
  #       tree_ids: user.get_connected_users
  #   )
  # end







end