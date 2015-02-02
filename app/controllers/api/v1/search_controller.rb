module Api
  module V1
    class SearchController < ApiController

      respond_to :json

      def index
        certain_koeff = get_certain_koeff #3
        logger.info "== in index search api:  certain_koeff = #{certain_koeff}"

        tree_info, sim_data = api_current_user.start_similars
        logger.info "== in index search api:  api_current_user.id = #{api_current_user.id}"
        logger.info "== in index search api:  sim_data = #{sim_data}"

        if sim_data.empty?
          search_data = api_current_user.start_search(certain_koeff)
          respond_with collect_search_results(search_data)
        else
          # Здесь - переход на отображение рез-тов поиска Похожих: internal_similars_search.html
          # ? redirect_to(internal_similars_search_path)

        end

        # search_data = api_current_user.start_search(certain_koeff)
        # respond_with collect_search_results(search_data)
      end


      def internal
      end


      private

      def collect_search_results(search_data)
        logger.info "======== search_data:"
        logger.info search_data
        results = {
          total_profiles: search_data[:by_profiles].size,
          total_trees: search_data[:by_trees].size,
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


      # search_data
      # {
      #   :connected_author_arr=>[2, 4],
      #   :qty_of_tree_profiles=>14,
      #   :profiles_relations_arr=>[{12=>{25=>3, 6=>3, 24=>8, 5=>11, 31=>11, 8=>11, 30=>12, 7=>17}}, {32=>{29=>4, 31=>11, 30=>12, 25=>18}}, {30=>{25=>1, 29=>2, 31=>5, 32=>9, 12=>9, 24=>10}}, {31=>{25=>1, 29=>2, 30=>6, 32=>9, 12=>9, 24=>10}}, {7=>{5=>3, 8=>3, 6=>7, 10=>11, 9=>11, 12=>13}}, {24=>{25=>3, 6=>3, 12=>7, 5=>11, 31=>11, 8=>11, 30=>12}}, {8=>{6=>1, 7=>2, 5=>5, 12=>9, 24=>10}}, {10=>{5=>1, 11=>2, 9=>5, 6=>9, 7=>10}}, {5=>{6=>1, 7=>2, 10=>3, 9=>3, 8=>5, 11=>8, 12=>9, 24=>10}}, {25=>{12=>1, 24=>2, 31=>3, 30=>4, 6=>5, 29=>8, 32=>15}}, {29=>{32=>1, 31=>3, 30=>4, 25=>7}}, {11=>{10=>3, 9=>3, 5=>7}}, {9=>{5=>1, 11=>2, 10=>5, 6=>9, 7=>10}}, {6=>{12=>1, 24=>2, 5=>3, 8=>3, 25=>5, 7=>8, 10=>11, 9=>11}}],
      #   :profiles_found_arr=>[{30=>{5=>{38=>[1, 2, 5, 9, 10]}}}, {31=>{5=>{37=>[1, 2, 6, 9, 10]}}}, {24=>{5=>{35=>[3, 3, 7, 11, 12]}}}, {29=>{5=>{39=>[3, 4, 7]}}}, {11=>{3=>{13=>[3, 3, 7]}}}], :uniq_profiles_pairs=>{30=>{5=>38}, 31=>{5=>37}, 24=>{5=>35}, 29=>{5=>39}, 11=>{3=>13}}, :profiles_with_match_hash=>{38=>5, 37=>5, 35=>5, 39=>3, 13=>3},
      #   :by_profiles=>[{:search_profile_id=>30, :found_tree_id=>5, :found_profile_id=>38, :count=>5}, {:search_profile_id=>31, :found_tree_id=>5, :found_profile_id=>37, :count=>5}, {:search_profile_id=>24, :found_tree_id=>5, :found_profile_id=>35, :count=>5}, {:search_profile_id=>29, :found_tree_id=>5, :found_profile_id=>39, :count=>3}, {:search_profile_id=>11, :found_tree_id=>3, :found_profile_id=>13, :count=>3}],
      #   :by_trees=>[{:found_tree_id=>5, :found_profile_ids=>[38, 37, 35, 39]}, {:found_tree_id=>3, :found_profile_ids=>[13]}], :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}
      # }


    end
  end
end
