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

          input_user, password = parse_user(data)
          unless input_user
            return render_json_error("Invalid user params", @@endpoint, data)
          end

          if input_user.valid?
            begin
              user = ActiveRecord::Base.transaction do
                User.create_user_account_with_json_data(data, password)
              end
              send_user_email(user, password)
              send_support_message(user)
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


        def send_support_message(user)
          body =
          "Привет!
           Я очень рад, что вы присоединились к проекту Мы все – родня!
           Мы постарались сделать работу с сайтом простой и понятной, но могут возникнуть ситуации, в которых потребуется моя помощь.
           Пожалуйста, не стесняйся и задавай в чате любые вопросы, по работе сайта. Не обещаю, что отвечу мгновенно, но постараюсь как можно быстрее помочь.
          "
          message = {
            user_id: user.id,
            body: body,
            support_id: 1
          }
          SupportMessage.create(message)
        end

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
