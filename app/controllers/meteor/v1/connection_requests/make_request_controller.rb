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

          status_code = 200 # status Ok
          msg, msg_code = ConnectionRequest.make_request(@current_user, with_user_id)

          
          # Start search for conn_request Contr-agent
          certain_koeff = WeafamSetting.first.certain_koeff
          logger.info "In SearchResultsController: certain_koeff = #{certain_koeff}, @current_user.id = #{@current_user.id}  "
          ## ЗАПУСК ПОИСКА
          with_user_id.start_search(certain_koeff)
          logger.info "In SearchResultsController: After start_search: @error = #{@error}  " if @error
          logger.info "In SearchResultsController: After start_search"

          # respond_with yes_con

          # logger.info "In MakeRequestController: @error = #{@error}" if @error
          # logger.info "In MakeRequestController: After connect:  @current_user.id = #{@current_user.id}"
          logger.info "In MakeRequestController: After connect:  msg_code = #{msg_code}, msg = #{msg} "
          status_code = 600 if msg_code > 1 # status NotOk

          if @error
            respond_with @error
          else
            respond_with( {status: status_code, msg_code: msg_code, msg: msg} )
          end

        end


      end
    end
  end
end
