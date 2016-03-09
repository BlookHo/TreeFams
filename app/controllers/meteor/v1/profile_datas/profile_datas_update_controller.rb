module Meteor
  module V1
    module ProfileDatas
      class ProfileDatasUpdateController < MeteorController

        # skip_before_filter :verify_authenticity_token
        before_filter :authenticate

        @@endpoint = "/meteor/v1/signup/create.json"
        @@permit_params = %w(last_name prev_last_name city birthday deathdate biography avatar_mongo_id)

        def update

          if @current_user.double == 1
            profile_data = find_profile_data
            @@permit_params.each do |param|
              profile_data[param.to_sym] = params[param.to_s] if params[param.to_s]
            end
            profile_data.save ? respond_with(profile_data) : respond_with(profile_data.errors)
          else
            respond_with(errorCode: 403, message: "Возможно, Ваше - дубль! Действия по изменению данных профиля - временно запрещены")
          end
        end


        private

        def find_profile_data
          # TODO secure issue
          # check user access to profile
          profile = Profile.where(id: params["profile_id"]).first
          puts "found pfoiel #{profile}"
          profile.profile_data ? profile.profile_data : profile.build_profile_data
        end

      end
    end
  end
end
