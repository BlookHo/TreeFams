module Meteor
  module V1
    module ConnectionRequests
      class YesConnectController < MeteorController

        before_filter :authenticate


        def yes_connect
          if current_user.double == 1
            puts "From Meteor - in Rails ConnectionRequests#yes_connect: current_user.id = #{current_user.id}, current_user.double = #{current_user.double}"

            # yes_con = { status: true }
            connection_id = params[:connection_id]
            logger.info "In YesConnectController: connection_id = #{connection_id}"
            user_id = params[:user_id]
            logger.info "In YesConnectController: user_id = #{user_id}"

            status_code = 200 # status Ok

            connection_results = @current_user.connection(user_id, connection_id)
            msg_code = connection_results[:diag_connection_item]
            msg      = connection_results[:connection_message]

            logger.info "In YesConnectController: After connect:  msg_code = #{msg_code}, msg = #{msg} "

            status_code = 300 if msg_code > 1 # status NotOk
            if @error
              respond_with @error
            else
              respond_with({status: status_code, msg_code: msg_code, msg: msg})
            end

          else
            puts "From Meteor - in Rails ConnectionRequests#yes_connect: current_user.id = #{current_user.id}, current_user.double = #{current_user.double}"
            puts "Дерево - дубль! Действия по объединению деревьев - запрещены"
            respond_with( {status: 300, msg: "Дерево - дубль! Действия по объединению деревьев - запрещены"} )
          end


        end



      end
    end
  end
end
