module Meteor
  module V1
    module Signup
      class SignupController < MeteorController

        skip_before_filter :authenticate


        def create
          data = params['family']
          data = JSON.parse(data)
          data = sanitize_data(data.compact)

          password =  User.generate_password
          user = User.new( email: data["author"]["email"], password: password, password_confirmation: password)
          user.valid? # нужно дернуть метод, чтобы получить ошибки

          if user.errors.messages[:email].nil?
            user = User.create_user_account_with_json_data(data, password)
            Thread.new do
              UserMailer.welcome_mail(user, password).deliver
            end
            ::SearchResults.start_search_methods_in_thread(user)
            render json: {token: user.access_token}
          else
            respond_with(status: 500)
          end
        end


        private

        def sanitize_data(data)
          proc = Proc.new { |k, v| v.kind_of?(Hash) ? (v.delete_if(&proc); nil) : v.blank? };
          data.delete_if(&proc)
        end



      end
    end
  end
end
