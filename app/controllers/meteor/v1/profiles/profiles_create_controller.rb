module Meteor
  module V1
    module Profiles
      class ProfilesCreateController < MeteorController

          before_filter :authenticate

          # @note: Запуск основного метода создания нового профиля
          def create
            if @current_user.double == 1
              puts "From Meteor - in Rails Profiles#create: @current_user.id = #{@current_user.id}, @current_user.double = #{@current_user.double}"
              puts "From Meteor - in Rails Profiles#create: current_user.id = #{current_user.id}, current_user.double = #{current_user.double}"

              puts "profile create"
              puts params
              params_to_create = {
                  base_profile_id:   params[:base_profile_id],
                  profile_name_id:   params[:profile_name_id],
                  relation_id:       params[:relation_id] }
              puts "From Meteor - in Rails create: params_to_create = #{params_to_create}"
              new_profile = @current_user.creation_profile(params_to_create)

              puts "In met/v1/../ProfilesCreateController: After creation_profile: start_search_methods "
              ::SearchResults.start_search_methods_in_thread(@current_user)

              respond_with new_profile
            else
              puts "From Meteor - in Rails Profiles#create: @current_user.id = #{@current_user.id}, @current_user.double = #{@current_user.double}"
              puts "From Meteor - in Rails Profiles#create: current_user.id = #{current_user.id}, current_user.double = #{current_user.double}"
              puts "Дерево - дубль! Действия по добавлению нового профиля - запрещены"
              respond_with(errorCode: 403, message: "Возможно, Ваше дерево - дубль! Действия по добавлению нового профиля - временно запрещены")
            end

          end

      end
    end
  end
end
