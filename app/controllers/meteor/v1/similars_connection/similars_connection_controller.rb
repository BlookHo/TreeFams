module Meteor
  module V1
    module SimilarsConnection
      class SimilarsConnectionController < MeteorController

        before_filter :authenticate

        def connecting_similars
          # roll = { status: true }
          first_profile_connecting = params[:first_sim_profile_id]
          logger.info "In SimilarsConnectionController: first_profile_connecting = #{first_profile_connecting}"
          second_profile_connecting = params[:second_sim_profile_id]
          logger.info "In SimilarsConnectionController: second_profile_connecting = #{second_profile_connecting}"

          logger.info "In SimilarsConnectionController: @current_user.id = #{@current_user.id}  "
          ## ЗАПУСК ОБЪЕДИНЕНИЯ ПОХОЖИХ
          @current_user.similars_connection(first_profile_connecting, second_profile_connecting)
          logger.info "In SimilarsConnectionController: After similars_connection: @error = #{@error}  " if @error
          logger.info "In SimilarsConnectionController: After similars_connection"

          # respond_with roll

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

