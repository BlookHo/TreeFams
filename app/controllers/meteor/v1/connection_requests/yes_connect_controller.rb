module Meteor
  module V1
    module ConnectionRequests
      class YesConnectController < MeteorController

        before_filter :authenticate


        def yes_connect
          # no_con = { status: true }
          connection_id = params[:connection_id]
          logger.info "In NoConnectController: connection_id = #{connection_id}"
          # logger.info "In RollbacksController: @current_user.id = #{@current_user.id}  "
          # logger.info "In RollbacksController: current_user.id = #{current_user.id}  "
          conn_request_data = {
              connection_id: connection_id,
              current_user_id: @current_user.id
          }
          ConnectionRequest.no_to_request(conn_request_data)
          # respond_with no_con
          logger.info "In NoConnectController: @error = #{@error}  " if @error
          logger.info "In NoConnectController: After NO"

          if @error
            respond_with @error
          else
            respond_with(status:200)
          end

        end



      end
    end
  end
end
