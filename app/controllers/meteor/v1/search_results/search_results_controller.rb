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


      end
    end
  end
end
