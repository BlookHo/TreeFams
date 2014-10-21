module Api
  class ApiController < ApplicationController

    # before_filter :restrict_access
    respond_to :json

    private

    def restrict_access
      api_key = User.find_by_access_token(params[:access_token])
      head :unauthorized unless api_key
    end

  end
end
