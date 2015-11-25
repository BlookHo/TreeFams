module Meteor
  module V1
    module Profiles
      class ProfilesDestroyController < MeteorController

          before_filter :authenticate

          def destroy
            response = @current_user.destroying_profile(params[:profile_id])
            if response[:status] == 403
              respond_with(errorCode: 403, message: response[:message])
            else

              puts "In met/v1/../ProfilesDestroyController: After destroying_profile: start_search_methods "
              SearchResults.start_search_methods(@current_user)

              respond_with(status:200)
            end

          end


      end
    end
  end
end
