module Meteor
  module V1
    module Profiles
      class ProfilesCreateController < MeteorController

          before_filter :authenticate


          def create
            profile = Profile.where(id: params[:profile_id]).first
            name = Name.where(id: params[:name_id]).first
            relation_id = params[:relation_id]
            user = @current_user

            new_profile = create_profile(name, user)
            create_keys(profile, new_profile, relation_id, user)
            # create_extra_keys( key, value, user )
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
              create_profile(data.merge({tree_id: user.id}.as_json)),
              get_id_for_extra_relation(relation_name),
              exclusions_hash: nil,
              tree_ids: user.get_connected_users
            )
          end


      end
    end
  end
end