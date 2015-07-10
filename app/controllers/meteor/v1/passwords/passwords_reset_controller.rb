module Meteor
  module V1
    module Passwords
      class PasswordsResetController < MeteorController

        skip_before_filter :authenticate

        def reset
          email = params[:email]
          user = User.where({email: email}).first
          if user && user.reset_password
            respond_with(status:200)
          else
            respond_with(error: "Пользователь с таким адресом не найден")
          end
        end

      end
    end
  end
end
