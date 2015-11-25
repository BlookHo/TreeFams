module Meteor
  module V1
    module Profiles
      class ProfilesCreateController < MeteorController

          before_filter :authenticate

          # @note: Запуск основного метода создания нового профиля
          def create
            puts "profile create"
            puts params
            params_to_create = {
                base_profile_id:   params[:base_profile_id],
                profile_name_id:   params[:profile_name_id],
                relation_id:       params[:relation_id] }
            puts "From Meteor - in Rails create: params_to_create = #{params_to_create}"
            new_profile = current_user.creation_profile(params_to_create)

            puts "In met/v1/../ProfilesCreateController: After creation_profile: start_search_methods "
            ::SearchResults.start_search_methods_in_thread(current_user)

            respond_with new_profile
          end

      end
    end
  end
end
