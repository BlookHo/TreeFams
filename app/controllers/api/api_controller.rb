module Api
  class ApiController < ApplicationController

    before_filter :api_current_user
    respond_to :json

    helper_method :api_current_user


    def api_current_user
      @api_current_user ||= User.find_by_access_token(params[:token])
    end


    private

    def restrict_access
      head :unauthorized unless api_current_user
    end




  end
end
