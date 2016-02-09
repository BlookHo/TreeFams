module Meteor
  class MeteorController < ApplicationController

    respond_to :json
    skip_before_filter :verify_authenticity_token
    before_filter :authenticate


    protected

    def render_json_error(error, endpoint, params)
      payload = {error: error, path: endpoint}
      render json: payload, status: 400
    end

    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        @current_user = User.find_by(access_token: token)
      end
    end

  end
end
