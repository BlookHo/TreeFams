module Meteor
  module V1
    module Profiles
      class ProfilesRenameController < MeteorController
        before_filter :authenticate

        def rename
          if @current_user.double == 1
            p "From Meteor - in Rails Profiles#rename: @current_user.id = #{@current_user.id}, @current_user.double = #{@current_user.double}"

            profile = Profile.where(id: params[:profileId]).first
            name = Name.where(id: params[:nameId]).first
            puts "in Rails Profiles: Before profile.rename: profile.id = #{profile.id}, name.id = #{name.id}"
            if profile && name
              profile.rename(name.id)
              puts "in Rails Profiles#rename: profile.id = #{profile.id}, name.id = #{name.id}"

              p "In met/v1/../ProfilesRenameController: After rename: start_search_methods "
              search_event = 5
              ::SearchResults.start_search_methods_in_thread(@current_user, search_event)

              respond_with(status:200)
            else
              respond_with(errorCode: 403, message:"Ошибка при переименовании профиля")
            end

          else
            puts "From Meteor - in Rails Profiles#rename: @current_user.id = #{@current_user.id}, @current_user.double = #{@current_user.double}"
            puts "Дерево - дубль! Действия по переименованию профиля - запрещены"
            respond_with(errorCode: 403, message: "Возможно, Ваше Дерево - дубль! Действия по переименованию профиля - временно запрещены")
          end

        end

      end
    end
  end
end
