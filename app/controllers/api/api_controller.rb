module Api
  class ApiController < ApplicationController

    respond_to :json
    # helper_method :api_current_user


    def restrict_access
      head :unauthorized unless api_current_user
    end


    def api_current_user
      @api_current_user ||= User.find_by_access_token(params[:token])
    end


  end
end
