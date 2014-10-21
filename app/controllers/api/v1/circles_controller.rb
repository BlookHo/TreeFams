module Api
  module V1
    class CirclesController < ApiController

      respond_to :json

      def show
        profile = Profile.find(params[:id])
        respond_with profile.circles
      end

    end
  end
end
