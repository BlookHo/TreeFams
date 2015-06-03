module Meteor
  module V1
    module Signup
      class SignupController < MeteorController

        skip_before_filter :authenticate

        def test
          user = User.first
          respond_with user
        end


        def create
          data = params['family']
          data = JSON.parse(data)
          data = sanitize_data(data.compact)
          formatData = {'family' => data}

          user = User.new( email: data["author"]["email"] )
          user.valid? # нужно дернуть метод, чтобы получить ошибки
          if user.errors.messages[:email].nil?
            user = User.create_user_account_with_json_data(data)
            # Send welcome email
            UserMailer.welcome_mail(user).deliver

            logger.info("RESPOND WITH USER:")
            logger.info(user)
            respond_with({token: user.access_token})
          else
            logger.info("RESPOND WITH 500")
            respond_with(status: 500)
          end
        end


        private


        def sanitize_data(data)
          proc = Proc.new { |k, v| v.kind_of?(Hash) ? (v.delete_if(&proc); nil) : v.blank? };
          data.delete_if(&proc)
          # data["brothers"].each do |member, index|
          #   logger.info(member)
          # end
          # data
        end


      end
    end
  end
end
