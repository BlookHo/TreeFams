module Meteor
  module V1
    module CommonLogs
      class RollbacksController < MeteorController

        before_filter :authenticate

        def rollback
          # roll = { status: true }
          rollback_id = params[:id]
          logger.info "In RollbacksController: rollback_id = #{rollback_id}"
          logger.info "In RollbacksController: @current_user.id = #{@current_user.id}  "
          logger.info "In RollbacksController: current_user.id = #{current_user.id}  "
          CommonLog.rollback(rollback_id, @current_user)
          # respond_with roll
          logger.info "In RollbacksController: After rollback: @error = #{@error}  " if @error
          logger.info "In RollbacksController: After rollback"

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
