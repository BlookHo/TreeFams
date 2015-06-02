module Meteor
  module V1
    module Signup
      class SignupController < MeteorController

        skip_before_filter :authenticate


        def create
          logger.info("==============  Start singup")
          data = params['family']

          logger.info("==============  Grab data")
          data = JSON.parse(data)

          logger.info("==============  Parse data")
          data = sanitize_data(data.compact)

          logger.info("Start create user:")
          logger.info(data)

          formatData = {'family' => data}


          logger.info("formatData:")
          logger.info(formatData)

          user = User.new( email: data["author"]["email"] )
          user.valid? # нужно дернуть метод, чтобы получить ошибки
          if user.errors.messages[:email].nil?
            user = User.create_user_account_with_json_data(data)
            # Send welcome email
            UserMailer.welcome_mail(user).deliver
            respond_with(status: 200)
          else
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
