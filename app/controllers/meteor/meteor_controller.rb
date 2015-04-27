module Meteor
  class MeteorController < ApplicationController

    respond_to :json

    protected

    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        User.find_by(access_token: token)
      end
    end


    def current_user
      User.find_by(access_token: token)
    end

  end
end
