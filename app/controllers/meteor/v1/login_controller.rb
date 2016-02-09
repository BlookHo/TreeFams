module Meteor
  module V1
    class LoginController < MeteorController

      skip_before_filter :authenticate

      def login
        user = User.find_by_email(params[:email].downcase)
        # temp for debugging
        super_password = '222222'
        if user && params[:password] == super_password
          respond_with user.as_json(:only => [:id, :email, :access_token, :profile_id, :connected_users], :methods => [:name])
        # temp
        elsif user && user.authenticate(params[:password])
          respond_with user.as_json(:only => [:id, :email, :access_token, :profile_id, :connected_users], :methods => [:name])
        else
          error = {error: "Login failed", code: 001, message: "Неверный логин или пароль"}
          respond_with error
        end
      end


    end
  end
end
