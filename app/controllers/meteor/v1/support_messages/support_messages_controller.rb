module Meteor
  module V1
    module SupportMessages
      class SupportMessagesController < MeteorController

        @@endpoint = "/meteor/v1/support_messages/create.json"

        def create
          body = params[:body]
          user_id = params[:user_id]
          message = SupportMessage.new({user_id: user_id, body: body})
          if message.save
            render json: {status: 200}
          else
            render_json_error("Invalid params", @@endpoint, params)
          end

        end

      end
    end
  end
end
