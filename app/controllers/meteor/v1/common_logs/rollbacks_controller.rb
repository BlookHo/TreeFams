module Meteor
  module V1
    module CommonLogs
      class RollbacksController < MeteorController

        before_filter :authenticate

        def rollback

          roll = { status: true }
          rollback_id = params[:id]
          logger.info "In RollbacksController: rollback_id = #{rollback_id}"
# ,  rollback_date = #{rollback_date} "

          respond_with roll
        end





        end
      end
   end
end