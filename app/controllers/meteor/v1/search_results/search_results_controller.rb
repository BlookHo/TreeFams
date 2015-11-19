module Meteor
  module V1
    module SearchResults
      class SearchResultsController < MeteorController

        before_filter :authenticate

        def search
          Thread.new do
            ActiveRecord::Base.connection_pool.with_connection do
              certain_koeff = WeafamSetting.first.certain_koeff
              if @current_user.start_similars[:similars].blank?
                @current_user.start_search(certain_koeff)
              end
            end
          end
          respond_with(status:200)
        end



        def search_old
          # roll = { status: true }
          # rollback_id = params[:id]
          # logger.info "In SearchResultsController: rollback_id = #{rollback_id}"

          certain_koeff = WeafamSetting.first.certain_koeff
          logger.info "In SearchResultsController: certain_koeff = #{certain_koeff}, @current_user.id = #{@current_user.id}  "
          ## ЗАПУСК ПОИСКА
          @current_user.start_search(certain_koeff)
          logger.info "In SearchResultsController: After start_search: @error = #{@error}  " if @error
          logger.info "In SearchResultsController: After start_search"

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
