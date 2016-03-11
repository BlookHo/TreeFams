module Meteor
  module V1
    module ProfileDatas
      class ProfileDatasPhotosController < MeteorController

        # Remove after debug
        skip_before_filter :authenticate

        @@add_endpoint = "/meteor/v1/profile_datas/add_photo.json"
        @@remove_endpoint = "/meteor/v1/profile_datas/add_photo.json"

        def add
          endpoint = "/meteor/v1/profile_datas/add_photo.json"
          filename = params["filename"]

          profile_data = find_profile_data
          profile_data.photos.push(filename)
          if profile_data.save
            return render json: {filename: filename}
          else
            render_json_error("Invalid params", @@add_endpoint, params)
          end
        end


        def remove
          endpoint = "/meteor/v1/profile_datas/remove_photo.json"
          data = params
          return render_json_error("Invalid params", endpoint, data)
        end

        private

        def find_profile_data
          # TODO secure issue
          # check user access to profile
          profile = Profile.where(id: params["profile_id"]).first
          profile.profile_data ? profile.profile_data : profile.build_profile_data
        end

      end
    end
  end
end
