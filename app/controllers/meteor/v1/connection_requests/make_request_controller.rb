module Meteor
  module V1
    module ConnectionRequests
      class MakeRequestController < MeteorController

        before_filter :authenticate


        def make_request
          # yes_con = { status: true }
          with_user_id = params[:user_id_to_connect]
          logger.info "In MakeRequestController: with_user_id = #{with_user_id}"
          logger.info "In MakeRequestController: @current_user.id = #{@current_user.id}"

          ConnectionRequest.make_request(@current_user, with_user_id)

          # respond_with yes_con
          logger.info "In MakeRequestController: @error = #{@error}" if @error
          logger.info "In MakeRequestController: After YES  @current_user.id = #{@current_user.id}"

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
