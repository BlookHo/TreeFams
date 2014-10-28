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
          trees: collect_trees_results(search_data[:by_trees])
        }
      end


      def collect_trees_results(by_trees)
        results = []
        by_trees.each do |tree_result|
          results << {tree_id: tree_result[:found_tree_id], profile_ids: tree_result[:found_profile_ids]}
        end
        return results
      end

    end
  end
end
