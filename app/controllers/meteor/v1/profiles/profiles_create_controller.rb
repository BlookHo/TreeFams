module Meteor
  module V1
    module Profiles
      class ProfilesCreateController < MeteorController

          before_filter :authenticate


          def create
            profile = Profile.where(id: params[:profile_id]).first  # base_profile
            name = Name.where(id: params[:name_id]).first   # new profile name id
            relation_id = params[:relation_id]  # new profile relation_id
            current_user = @current_user

            new_profile = create_profile(name, current_user)
            create_keys(profile, new_profile, relation_id, current_user)
            # create_extra_keys( key, value, user )

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
            update_feed_data = { user_id:           current_user.id,    # 3   Алексей к Анне у Натальи
                                 update_id:         4,                  # 4
                                 agent_user_id:     new_profile.tree_id,   # 3
                                 read:              false,              #
                                 agent_profile_id:  new_profile.id,        # 215
                                 who_made_event:    current_user.id }   # 3

            UpdatesFeed.create(update_feed_data) #
            new_profile.case_update_amounts(new_profile, current_user)
            ################################

            respond_with new_profile
          end



          def create_profile(name, user)
            Profile.create({
              name_id:          name.search_name_id,
              display_name_id:  name.id,
              sex_id:           name.sex_id,
              tree_id:          user.id
              })
          end


          # base_sex_id,
          # base_profile,
          # new_profile,
          # new_relation_id,
          # exclusions_hash: nil,
          # tree_ids: tree_ids

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



          def create_extra_keys(relation_name, data, user)
            extra_profile = get_extra_profile(relation_name, user)
            ProfileKey.add_new_profile(
              extra_profile.sex_id,
              extra_profile,
              create_profile(data.merge({tree_id: user.id}.as_json), user),
              get_id_for_extra_relation(relation_name),
              exclusions_hash: nil,
              tree_ids: user.get_connected_users
            )
          end


      end
    end
  end
end
