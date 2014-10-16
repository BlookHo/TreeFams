module Api
  module V1
    class ProfilesController < ApplicationController

      before_filter :restrict_access
      respond_to :json

      def index
        respond_with Profile.all.only(:id, :user_id, :name_id, :sex_id)
      end




      private

      def restrict_access
        api_key = User.find_by_access_token(params[:access_token])
        head :unauthorized unless api_key
      end



    end
  end
end
