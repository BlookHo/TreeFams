module Meteor
  module V1
    module Validations
      module Emails
        class EmailsController < MeteorController

          skip_before_filter :authenticate

          def exist
            email = params[:email]
            user = User.where({email: email}).first
            if user
              respond = {email: email, exist: true}
            else
              respond = {email: email, exist: false}
            end
            respond_with respond
          end


        end
      end
    end
  end
end
