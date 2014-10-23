module Api
  module V1
    class SearchController < ApiController

      respond_to :json

      def index
        certain_koeff = 3
        search_data = api_current_user.start_search(certain_koeff)
        respond_with collect_search_results(search_data)
      end


      private

      def collect_search_results(search_data)
        results = {
          total: search_data[:by_profiles].size,
          by_profiles: search_data[:by_profiles]
        }
      end

    end
  end
end
