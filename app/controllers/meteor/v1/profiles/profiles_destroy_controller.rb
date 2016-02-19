module Meteor
  module V1
    module Profiles
      class ProfilesDestroyController < MeteorController

          before_filter :authenticate

          def destroy
            if @current_user.double == 1
              puts "From Meteor - in Rails Profiles#create: @current_user.id = #{@current_user.id}, @current_user.double = #{@current_user.double}"
              puts "From Meteor - in Rails Profiles#create: current_user.id = #{current_user.id}, current_user.double = #{current_user.double}"

              response = @current_user.destroying_profile(params[:profile_id])
              if response[:status] == 403
                respond_with(errorCode: 403, message: response[:message])
              else
                puts "In met/v1/../ProfilesDestroyController: After destroying_profile: start_search_methods "
                search_event = 2
                ::SearchResults.start_search_methods_in_thread(@current_user, search_event)
                respond_with(status:200)
              end

            else
              puts "From Meteor - in Rails Profiles#destroy: @current_user.id = #{@current_user.id}, @current_user.double = #{@current_user.double}"
              puts "Дерево - дубль! Действия по удалению профиля - запрещены"
              respond_with(errorCode: 403, message: "Возможно, Ваше дерево - дубль! Действия по удалению профиля - временно запрещены")
            end

          end


      end
    end
  end
end
