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
              logger.info "LOG_KEY SignupController: AR CONNECTION POOL SIZE (BEFORE): #{ActiveRecord::Base.connection_pool.connections.size}"

              UserMailer.welcome_mail(user, password).deliver

              ActiveRecord::Base.connection_pool.release_connection(conn)
              ActiveRecord::Base.connection_handler.connection_pool_list.each(&:clear_stale_cached_connections!)

              logger.info "LOG_KEY SignupController: AR CONNECTION POOL SIZE (AFTER): #{ActiveRecord::Base.connection_pool.connections.size}"

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
