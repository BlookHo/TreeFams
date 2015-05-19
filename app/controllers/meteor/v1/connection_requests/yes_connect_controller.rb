module Meteor
  module V1
    module ConnectionRequests
      class YesConnectController < MeteorController

        before_filter :authenticate


        def yes_connect
          # yes_con = { status: true }
          connection_id = params[:connection_id]
          logger.info "In YesConnectController: connection_id = #{connection_id}"
          user_id = params[:user_id]
          logger.info "In YesConnectController: user_id = #{user_id}"

          # logger.info "In RollbacksController: @current_user.id = #{@current_user.id}  "
          # logger.info "In RollbacksController: current_user.id = #{current_user.id}  "
          # conn_request_data = {
          #     connection_id: connection_id,
          #     current_user_id: @current_user.id
          # }

          @current_user.connection(user_id, connection_id)

          # connection_results =
          #     current_user.connection(user_id, connection_id)
          # respond_with yes_con
          logger.info "In YesConnectController: @error = #{@error}" if @error
          logger.info "In YesConnectController: After YES  @current_user.id = #{@current_user.id}"

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
