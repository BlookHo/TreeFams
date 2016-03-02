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
    current_log_type = 1  #  add: rollback == delete. Тип = добавление нового профиля при rollback
    new_log_number = CommonLog.new_log_id(profile.tree_id, current_log_type)

    common_log_data = { user_id:         profile.tree_id,   # 3   Алексей к Анне у Натальи
                        log_type:        current_log_type,        # 1
                        log_id:          new_log_number,          # 2
                        profile_id:      new_profile.id,             # 215
                        base_profile_id: profile.id,        # 25
                        new_relation_id: relation_id }   # 3

    CommonLog.create_common_log(common_log_data)

    # ##########  UPDATES FEEDS - № 4  # create ###################
    # update_feed_data = { user_id:           self.id,    # 3   Алексей к Анне у Натальи
    #                      update_id:         4,                  # 4
    #                      agent_user_id:     new_profile.tree_id,   # 3
    #                      read:              false,              #
    #                      agent_profile_id:  new_profile.id,        # 215
    #                      who_made_event:    self.id }   # 3
    #
    # UpdatesFeed.create(update_feed_data) #
    # new_profile.case_update_amounts(new_profile, self)
    # ################################

    # sims & search
    # puts "In Rails Concern: After creation_profile: start_search_methods "
    # puts "In models/concern/profile_creation: In creation_profile: self.id = #{self.id} "
    # SearchResults.start_search_methods(self)

    new_profile
  # respond_with new_profile

  end



  def create_one_profile(name, user_id)
    Profile.create({
                       name_id:          name.search_name_id,
                       # display_name_id:  name.id,
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
    logger.info "In Rails Concern: create_keys: profile.id = #{profile.id}, new_profile.id = #{new_profile.id}, relation_id = #{relation_id}, user.id = #{user.id} "
    ProfileKey.add_new_profile(
        profile.sex_id,
        profile,
        new_profile,
        relation_id,
        exclusions_hash: nil,
        tree_ids: user.get_connected_users
    )
  end



end