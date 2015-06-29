module Meteor
  module V1
    module ProfileData
      class ProfileDataUpdateController < MeteorController

        before_filter :authenticate

        def update
          profile_data = find_profile_data

          if (params["last_name"])
            map_last_name(profile_data)
          # elsif params.birthday
          #   map_birthday(profile_data)
          elsif params["city"]
            map_city(profile_data)
          end


          if profile_data.save
            respond_with profile_data
          else
            respond_with profile_data.errors
          end
        end


        private

        def map_last_name(profile_data)
          if params["last_name"].blank?
            return profile_data.last_name = nil
          else
            return profile_data.last_name = params["last_name"]
          end
        end

        def map_city(profile_data)
          if params["city"].blank?
            return profile_data.city = nil
          else
            return profile_data.city = params["city"]
          end
        end



        def find_profile_data
          # TODO secure issue
          profile = Profile.where(id: params["profile_id"]).first
          profile.profile_data ? profile.profile_data : profile.build_profile_data
        end

      end
    end
  end
end
