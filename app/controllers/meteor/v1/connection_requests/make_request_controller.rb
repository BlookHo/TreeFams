module Meteor
  module V1
    module ConnectionRequests
      class MakeRequestController < MeteorController

        before_filter :authenticate


        def make_request
          if @current_user.double == 1
            puts "From Meteor - in Rails ConnectionRequests#make_request: @current_user.id = #{@current_user.id}, @current_user.double = #{@current_user.double}"

            # yes_con = { status: true }
            with_user_id = params[:user_id_to_connect]
            logger.info "In MakeRequestController: with_user_id = #{with_user_id}"
            logger.info "In MakeRequestController: @current_user.id = #{@current_user.id}"

            status_code = 200 # status Ok
            msg, msg_code = ConnectionRequest.make_request(@current_user, with_user_id)

            # start_counter_search(with_user_id)

            # respond_with yes_con
            logger.info "In MakeRequestController: After make_request:  msg_code = #{msg_code}, msg = #{msg} "
            status_code = 600 if msg_code > 1 # status NotOk

            if @error
              respond_with @error
            else
              respond_with( {status: status_code, msg_code: msg_code, msg: msg} )
            end

          else
            puts "From Meteor - in Rails ConnectionRequests#make_request: @current_user.id = #{@current_user.id}, @current_user.double = #{@current_user.double}"
            puts "Дерево - дубль! Действия по объединению деревьев - запрещены"
            respond_with(errorCode: 403, message: "Возможно, Ваше - дубль! Действия по объединению деревьев - временно запрещены")
          end



        end


        # @note: Start search for conn_request Counter-agent
        def start_counter_search(with_user_id)

          # certain_koeff = WeafamSetting.first.certain_koeff
          # logger.info "In MakeRequestController: certain_koeff = #{certain_koeff} "
          with_user = User.find(with_user_id)
          logger.info "In MakeRequestController: with_user_id = #{with_user_id} "

          ## ЗАПУСК ПОИСКА НАВСТРЕЧУ
          with_user.start_search#(certain_koeff)
          logger.info "In MakeRequestController: After start_search: @error = #{@error}  " if @error
          logger.info "In MakeRequestController: After start_search"

        end



      end
    end
  end
end
