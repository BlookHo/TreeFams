module Meteor
  module V1
    module ProfileDatas
      class ProfileDatasPhotosController < MeteorController

        # Remove after debug
        skip_before_filter :authenticate

        def add
          endpoint = "/meteor/v1/profile_datas/add_photo.json"
          data = params
          return render_json_error("Invalid params", endpoint, data)
        end



        def remove
          endpoint = "/meteor/v1/profile_datas/remove_photo.json"
          data = params
          return render_json_error("Invalid params", endpoint, data)
        end

      end
    end
  end
end
