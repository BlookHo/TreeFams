module Meteor
  module V1
    module ProfileDatas
      class ProfileDatasUpdateController < MeteorController

        # skip_before_filter :verify_authenticity_token
        before_filter :authenticate

        def update

          if @current_user.double == 1
            puts "From Meteor - in Rails ProfileDatas#update: @current_user.id = #{@current_user.id}, @current_user.double = #{@current_user.double}"

            profile_data = find_profile_data

            if (params["last_name"])
              profile_data.last_name = params["last_name"]
            elsif params["city"]
              profile_data.city = params["city"]
            elsif params["birthday"]
              profile_data.birthday = params["birthday"]
            elsif params["avatar_mongo_id"]
              profile_data.avatar_mongo_id = params["avatar_mongo_id"]
            end


            if profile_data.save
              respond_with profile_data
            else
              respond_with profile_data.errors
            end
          else
            puts "From Meteor - in Rails ProfileDatas#update: @current_user.id = #{@current_user.id}, @current_user.double = #{@current_user.double}"
            puts "Дерево - дубль! Действия по изменению данных профиля - запрещены"
            respond_with(errorCode: 403, message: "Возможно, Ваше - дубль! Действия по изменению данных профиля - временно запрещены")
          end
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
