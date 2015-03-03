module Api
  module V1
    class SessionsController < ApplicationController

      respond_to :json

      def index
        user = User.find_by_email(params[:email])
        if user && user.authenticate(params[:password])
          respond_with user
        else
          render :json => { :errors => {message: "User not found", code: 1} }
        end
      end



    end
  end
end
