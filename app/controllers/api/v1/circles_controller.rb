module Api
  module V1
    class CirclesController < ApiController

      respond_to :json

      def show
        profile = Profile.find(params[:profile_id])
        respond_with profile.circles(api_current_user)
      end

    end
  end
end
