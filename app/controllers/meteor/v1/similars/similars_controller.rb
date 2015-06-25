module Meteor
  module V1
    module Similars
      class SimilarsController < MeteorController

        before_filter :authenticate

        def search_similars
          # roll = { status: true }

          logger.info "In SimilarsController: @current_user.id = #{@current_user.id}  "
          ## ЗАПУСК ПОИСКА ПОХОЖИХ
          @current_user.start_similars
          logger.info "In SimilarsController: After start_similars: @error = #{@error}  " if @error
          logger.info "In SimilarsController: After start_similars"

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

