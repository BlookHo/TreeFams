module Meteor
  module V1
    module ProfileDatas
      class ProfileDatasPhotosController < MeteorController

        # skip_before_filter :authenticate

        @@add_endpoint = "/meteor/v1/profile_datas/add_photo.json"
        @@remove_endpoint = "/meteor/v1/profile_datas/add_photo.json"

        def add
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
          filename = params["filename"]
          profile_data = find_profile_data
          profile_data.photos.delete(filename)
          if profile_data.save
            return render json: {filename: filename}
          else
            render_json_error("Invalid params", @@remove_endpoint, params)
          end
        end


        private

        def find_profile_data
          profile = Profile.where(id: params["profile_id"]).first
          profile.profile_data ? profile.profile_data : profile.build_profile_data
        end

      end
    end
  end
end
