module Meteor
  module V1
    module Signup
      class SignupController < MeteorController

        skip_before_filter :authenticate

        @@endpoint = "/meteor/v1/signup/create.json"

        def create
          unless data = parse_data(data)
            return render_json_error("Invalid params", @@endpoint, data)
          end

          user, password = parse_user(data)
          unless user
            return render_json_error("Invalid user params", @@endpoint, data)
          end

          if user.valid?
            begin
              ActiveRecord::Base.transaction do
                user = User.create_user_account_with_json_data(data, password)
              end
      #        send_user_email(user, password)
              search_event = 6
              ::SearchResults.start_search_methods_in_thread(user, search_event)
              return render json: {token: user.access_token}
            rescue Exception => e
              return render_json_error("Unknown signup error", @@endpoint, data)
            end
          else
            render_json_error("Invalid user params", @@endpoint, data)
          end
        end

        private

        def send_user_email(user, password)
          Thread.new do
            UserMailer.welcome_mail(user, password).deliver
            # ActiveRecord::Base.connection_pool.release_connection(conn)
            # ActiveRecord::Base.connection_handler.connection_pool_list.each(&:clear_stale_cached_connections!)
          end
          current_size = ActiveRecord::Base.connection_pool.connections.size
          logger.info "== AR POOL SIZE LOG: {signup.send_user_email} size: #{current_size}"
        end


        def parse_user(data)
          begin
            password =  User.generate_password
            user = User.new( email: data["author"]["email"], password: password, password_confirmation: password)
            return user, password
          rescue Exception => e
            return false
          end
        end


        def parse_data(data)
          begin
            data = params['family']
            data = JSON.parse(data)
            data = sanitize_data(data.compact)
          rescue Exception => e
            return false
          end
        end


        def sanitize_data(data)
          proc = Proc.new { |k, v| v.kind_of?(Hash) ? (v.delete_if(&proc); nil) : v.blank? };
          data.delete_if(&proc)
        end



        # def create_org
        #   data = params['family']
        #   data = JSON.parse(data)
        #   data = sanitize_data(data.compact)
        #
        #   password =  User.generate_password
        #   user = User.new( email: data["author"]["email"], password: password, password_confirmation: password)
        #   user.valid? # нужно дернуть метод, чтобы получить ошибки
        #
        #   if user.errors.messages[:email].nil?
        #     user = User.create_user_account_with_json_data(data, password)
        #
        #     Thread.new do
        #       logger.info "LOG_KEY SignupController: AR CONNECTION POOL SIZE (BEFORE): #{ActiveRecord::Base.connection_pool.connections.size}"
        #
        #       UserMailer.welcome_mail(user, password).deliver
        #
        #       ActiveRecord::Base.connection_pool.release_connection(conn)
        #       ActiveRecord::Base.connection_handler.connection_pool_list.each(&:clear_stale_cached_connections!)
        #
        #       logger.info "LOG_KEY SignupController: AR CONNECTION POOL SIZE (AFTER): #{ActiveRecord::Base.connection_pool.connections.size}"
        #
        #     end
        #     ::SearchResults.start_search_methods_in_thread(user)
        #     render json: {token: user.access_token}
        #   else
        #     respond_with(status: 500)
        #   end
        # end


      end
    end
  end
end
