module Api
  module V1
    class CirclesController < ApiController

      respond_to :json

      def show
        profile = Profile.find(params[:id])
        respond_with profile.circles(current_user_id: session[:user_id])
      end

    end
  end
end
