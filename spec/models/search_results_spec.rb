require 'rails_helper'

RSpec.describe SearchResults, type: :model ,  focus: true  do  #, focus: true

  describe '- Validation' do
    describe '- on create' do

      context '- valid search_results'  do  # , focus: true

        let(:good_search_results) {FactoryGirl.build(:search_results)}
        it '- 1 Saves a valid search_results' do
          puts " Model SearchResults validation "
          expect(good_search_results).to be_valid
        end

        let(:good_search_results_big_ids) {FactoryGirl.build(:search_results, :big_IDs)}
        it '- 2 Saves a valid search_results - big IDs' do
          expect(good_search_results_big_ids).to be_valid
        end

        let(:good_search_results2) {FactoryGirl.build(:search_results, :correct2)}
        it '- 2 Saves a valid good_search_results2 - big IDs' do
          expect(good_search_results2).to be_valid
        end

      end

      context '- invalid search_results'  do  # , focus: true

        let(:bad_search_results_nonintegers) {FactoryGirl.build(:search_results, :unintegers)}
        it '- 1 Dont save: - unintegers fields' do
          expect(bad_search_results_nonintegers).to_not be_valid
        end

        let(:bad_search_results_nonintegers2) {FactoryGirl.build(:search_results, :unintegers2)}
        it '- 2 Dont save: - unintegers fields' do
          expect(bad_search_results_nonintegers2).to_not be_valid
        end

        let(:bad_search_results_nonintegers3) {FactoryGirl.build(:search_results, :unintegers3)}
        it '- 3 Dont save: - unintegers fields' do
          expect(bad_search_results_nonintegers3).to_not be_valid
        end

        let(:bad_search_results_nonintegers4) {FactoryGirl.build(:search_results, :unintegers4)}
        it '- 4 Dont save: - unintegers fields' do
          expect(bad_search_results_nonintegers4).to_not be_valid
        end

        let(:bad_search_results_nonintegers5) {FactoryGirl.build(:search_results, :unintegers5)}
        it '- 5 Dont save: - unintegers fields' do
          expect(bad_search_results_nonintegers5).to_not be_valid
        end

        let(:bad_unarray_found_profile_ids) {FactoryGirl.build(:search_results, :unarray_found_profile_ids)}
        it '- 6 Dont save: - unarray field found_profile_ids' do
          expect(bad_unarray_found_profile_ids).to_not be_valid
        end

        let(:bad_unarray_searched_profile_ids) {FactoryGirl.build(:search_results, :unarray_searched_profile_ids)}
        it '- 7 Dont save: - unarray field searched_profile_ids' do
          expect(bad_unarray_searched_profile_ids).to_not be_valid
        end

        let(:bad_unarray_counts) {FactoryGirl.build(:search_results, :unarray_counts)}
        it '- 8 Dont save: - unarray fields counts' do
          expect(bad_unarray_counts).to_not be_valid
        end

        let(:bad_users_equals) {FactoryGirl.build(:search_results, :users_equals)}
        it '- 9 Dont save: - :user_id  AND :found_user_id - equals' do
          expect(bad_users_equals).to_not be_valid
        end

        let(:bad_profiles_equals) {FactoryGirl.build(:search_results, :profiles_equals)}
        it '- 10 Dont save: - :profile_id  AND :found_profile_id - equals' do
          expect(bad_profiles_equals).to_not be_valid
        end

      end

    end

    context '- check SearchResults methods'    do #  , focus: true
      # create model data
      before {
        # Users
        FactoryGirl.create(:user_search_results, :user_34 )  # User = 34 . Tree = 34. profile_id = 539  #1
        FactoryGirl.create(:user_search_results, :user_45 )  # User = 45 . Tree = 45. profile_id = 645  #2
        FactoryGirl.create(:user_search_results, :user_46 )  # User = 46 . Tree = 46. profile_id = 656  #3
        FactoryGirl.create(:user_search_results, :user_47 )  # User = 47 . Tree = 47. profile_id = 666  #4

        # SearchResults
        FactoryGirl.create(:search_results)
        FactoryGirl.create(:search_results, :correct2)
        FactoryGirl.create(:search_results, :correct3)

        FactoryGirl.create(:connection_request, :conn_request_1_2)    #
        FactoryGirl.create(:connection_request, :conn_request_7_8)    #
        FactoryGirl.create(:connection_request, :conn_request_3_1)    #
        FactoryGirl.create(:connection_request, :conn_request_3_2)    #
        FactoryGirl.create(:connection_request, :conn_request_34_46)    #

      }

      after {
        User.delete_all
        User.reset_pk_sequence
        SearchResults.delete_all
        SearchResults.reset_pk_sequence
        ConnectionRequest.delete_all
        ConnectionRequest.reset_pk_sequence
      }

      context '- Before actions - check table values '  do   #   , focus: true
        describe '- check SearchResults have rows count Before <store_search_results> - Ok' do
          let(:rows_qty) {3}
          it_behaves_like :successful_search_results_rows_count
        end
        it '- check SearchResults First Factory row - Ok' do # , focus: true
          search_results_fields = SearchResults.first.attributes.except('created_at','updated_at')
          expect(search_results_fields).to eq({"id"=>1, "user_id"=>15, "found_user_id"=>35, "profile_id"=>5,
                                               "found_profile_id"=>7, "count"=>4, "found_profile_ids"=>[7, 25],
                                               "searched_profile_ids"=>[5, 52], "counts"=>[4, 4],
                                               "connection_id"=>nil, "pending_connect"=>0,
                                               "searched_connected"=>[15], "founded_connected"=>[35] } )
        end
        it '- check SearchResults Second Factory row - Ok' do # , focus: true
          search_results_fields = SearchResults.second.attributes.except('created_at','updated_at')
          expect(search_results_fields).to eq({"id"=>2, "user_id"=>2, "found_user_id"=>3, "profile_id"=>1555,
                                               "found_profile_id"=>1444, "count"=>5, "found_profile_ids"=>[1444, 22222],
                                               "searched_profile_ids"=>[1555, 27777], "counts"=>[5, 5],
                                               "connection_id"=>7, "pending_connect"=>1,
                                               "searched_connected"=>[2], "founded_connected"=>[3] } )
        end
        it '- check SearchResults Second Factory row - Ok' do # , focus: true
          search_results_fields = SearchResults.third.attributes.except('created_at','updated_at')
          expect(search_results_fields).to eq({"id"=>3, "user_id"=>1, "found_user_id"=>3, "profile_id"=>11,
                                               "found_profile_id"=>25, "count"=>7,
                                               "found_profile_ids"=>[22, 23, 24, 25, 26, 27, 28, 29],
                                               "searched_profile_ids"=>[11, 12, 13, 14, 18, 19, 20, 21],
                                               "counts"=>[7, 7, 7, 7, 5, 5, 5, 5], "connection_id"=>3,
                                               "pending_connect"=>0,
                                               "searched_connected"=>[1], "founded_connected"=>[3] } )
        end
      end

      context 'check Action <store_search_results> with duplicates_one_to_many'    do   #   , focus: true
        let(:search_results)  {
           {  connected_author_arr: [46],
              by_profiles:      [{:search_profile_id=>665, :found_tree_id=>45, :found_profile_id=>647, :count=>7},
                                {:search_profile_id=>657, :found_tree_id=>47, :found_profile_id=>667, :count=>7},
                                {:search_profile_id=>664, :found_tree_id=>45, :found_profile_id=>646, :count=>7},
                                {:search_profile_id=>658, :found_tree_id=>47, :found_profile_id=>668, :count=>7},
                                {:search_profile_id=>658, :found_tree_id=>45, :found_profile_id=>645, :count=>7},
                                {:search_profile_id=>659, :found_tree_id=>47, :found_profile_id=>666, :count=>7},
                                {:search_profile_id=>659, :found_tree_id=>45, :found_profile_id=>650, :count=>7},
                                {:search_profile_id=>656, :found_tree_id=>47, :found_profile_id=>669, :count=>7},
                                {:search_profile_id=>656, :found_tree_id=>45, :found_profile_id=>649, :count=>7},
                                {:search_profile_id=>665, :found_tree_id=>47, :found_profile_id=>673, :count=>5},
                                {:search_profile_id=>662, :found_tree_id=>47, :found_profile_id=>670, :count=>5},
                                {:search_profile_id=>662, :found_tree_id=>34, :found_profile_id=>540, :count=>5},
                                {:search_profile_id=>657, :found_tree_id=>45, :found_profile_id=>651, :count=>5},
                                {:search_profile_id=>657, :found_tree_id=>34, :found_profile_id=>539, :count=>5},
                                {:search_profile_id=>664, :found_tree_id=>47, :found_profile_id=>672, :count=>5},
                                {:search_profile_id=>658, :found_tree_id=>34, :found_profile_id=>544, :count=>5},
                                {:search_profile_id=>659, :found_tree_id=>34, :found_profile_id=>543, :count=>5},
                                {:search_profile_id=>663, :found_tree_id=>47, :found_profile_id=>671, :count=>5},
                                {:search_profile_id=>663, :found_tree_id=>34, :found_profile_id=>541, :count=>5},
                                {:search_profile_id=>656, :found_tree_id=>34, :found_profile_id=>542, :count=>5}],
             by_trees:  [{:found_tree_id=>34, :found_profile_ids=>[542, 541, 543, 544, 539, 540]},
                         {:found_tree_id=>45, :found_profile_ids=>[649, 650, 645, 646, 651, 647]},
                         {:found_tree_id=>47, :found_profile_ids=>[669, 671, 666, 668, 672, 667, 670, 673]}],
             duplicates_one_to_many:  {711=>{45=>{648=>5, 710=>5}}},
             duplicates_many_to_one:  {}
          }
        }
        let(:current_user_id) { 46 }
        before { SearchResults.store_search_results(search_results, current_user_id) }

        describe ' - check SearchResults have rows count After <store_search_results> with duplicates_one_to_many - Ok'   do
          let(:rows_qty) {7}
          it_behaves_like :successful_search_results_rows_count
        end
        it '- check SearchResults Fourth Factory row - Ok' do # , focus: true
          puts "Check SearchResults.store_search_results[:by_trees] with duplicates_one_to_many: #{search_results[:by_trees]} \n"   # 0
          puts "In SearchResults.store_search_results[:duplicates_one_to_many]: #{search_results[:duplicates_one_to_many]} \n"   # 0
          search_results_fields = SearchResults.find(4).attributes.except('created_at','updated_at')
          expect(search_results_fields).to eq({"id"=>4, "user_id"=>46, "found_user_id"=>34, "profile_id"=>662,
                                               "found_profile_id"=>540, "count"=>5,
                                               "found_profile_ids"=>[540, 539, 544, 543, 541, 542],
                                               "searched_profile_ids"=>[662, 657, 658, 659, 663, 656],
                                               "counts"=>[5, 5, 5, 5, 5, 5],

                                               "connection_id"=>888, "pending_connect"=>0,

                                               "searched_connected"=>[46], "founded_connected"=>[34] } )
        end
        it '- check SearchResults Fifth  Factory row - Ok' do # , focus: true
          search_results_fields = SearchResults.find(5).attributes.except('created_at','updated_at')
          expect(search_results_fields).to eq({"id"=>5, "user_id"=>34, "found_user_id"=>46, "profile_id"=>540,
                                               "found_profile_id"=>662, "count"=>5,
                                               "found_profile_ids"=>[662, 657, 658, 659, 663, 656],
                                               "searched_profile_ids"=>[540, 539, 544, 543, 541, 542],
                                               "counts"=>[5, 5, 5, 5, 5, 5],
                                               "connection_id"=>nil, "pending_connect"=>1,
                                               "searched_connected"=>[34], "founded_connected"=>[46] } )
        end
        it '- check SearchResults Sixth Factory row - Ok' do # , focus: true
          search_results_fields = SearchResults.find(6).attributes.except('created_at','updated_at')
          expect(search_results_fields).to eq({"id"=>6, "user_id"=>46, "found_user_id"=>47, "profile_id"=>657,
                                               "found_profile_id"=>667, "count"=>7,
                                               "found_profile_ids"=>[667, 668, 666, 669, 673, 670, 672, 671],
                                               "searched_profile_ids"=>[657, 658, 659, 656, 665, 662, 664, 663],
                                               "counts"=>[7, 7, 7, 7, 5, 5, 5, 5],
                                               "connection_id"=>nil, "pending_connect"=>0,
                                               "searched_connected"=>[46], "founded_connected"=>[47] } )
        end
        it '- check SearchResults Seventh Factory row - Ok' do # , focus: true
          search_results_fields = SearchResults.find(7).attributes.except('created_at','updated_at')
          expect(search_results_fields).to eq({"id"=>7, "user_id"=>47, "found_user_id"=>46, "profile_id"=>667,
                                               "found_profile_id"=>657, "count"=>7,
                                               "found_profile_ids"=>[657, 658, 659, 656, 665, 662, 664, 663],
                                               "searched_profile_ids"=>[667, 668, 666, 669, 673, 670, 672, 671],
                                               "counts"=>[7, 7, 7, 7, 5, 5, 5, 5],
                                               "connection_id"=>nil, "pending_connect"=>0,
                                               "searched_connected"=>[47], "founded_connected"=>[46] } )
        end
      end

      context ' - check Action <store_search_results> with BOTH types duplicates'   do   #   , focus: true
        let(:search_results)  {
          {  connected_author_arr: [46],
             by_profiles:      [{:search_profile_id=>665, :found_tree_id=>45, :found_profile_id=>647, :count=>7},
                                {:search_profile_id=>657, :found_tree_id=>47, :found_profile_id=>667, :count=>7},
                                {:search_profile_id=>664, :found_tree_id=>45, :found_profile_id=>646, :count=>7},
                                {:search_profile_id=>658, :found_tree_id=>47, :found_profile_id=>668, :count=>7},
                                {:search_profile_id=>658, :found_tree_id=>45, :found_profile_id=>645, :count=>7},
                                {:search_profile_id=>659, :found_tree_id=>47, :found_profile_id=>666, :count=>7},
                                {:search_profile_id=>659, :found_tree_id=>45, :found_profile_id=>650, :count=>7},
                                {:search_profile_id=>656, :found_tree_id=>47, :found_profile_id=>669, :count=>7},
                                {:search_profile_id=>656, :found_tree_id=>45, :found_profile_id=>649, :count=>7},
                                {:search_profile_id=>665, :found_tree_id=>47, :found_profile_id=>673, :count=>5},
                                {:search_profile_id=>662, :found_tree_id=>47, :found_profile_id=>670, :count=>5},
                                {:search_profile_id=>662, :found_tree_id=>34, :found_profile_id=>540, :count=>5},
                                {:search_profile_id=>657, :found_tree_id=>45, :found_profile_id=>651, :count=>5},
                                {:search_profile_id=>657, :found_tree_id=>34, :found_profile_id=>539, :count=>5},
                                {:search_profile_id=>664, :found_tree_id=>47, :found_profile_id=>672, :count=>5},
                                {:search_profile_id=>658, :found_tree_id=>34, :found_profile_id=>544, :count=>5},
                                {:search_profile_id=>659, :found_tree_id=>34, :found_profile_id=>543, :count=>5},
                                {:search_profile_id=>663, :found_tree_id=>47, :found_profile_id=>671, :count=>5},
                                {:search_profile_id=>663, :found_tree_id=>34, :found_profile_id=>541, :count=>5},
                                {:search_profile_id=>656, :found_tree_id=>34, :found_profile_id=>542, :count=>5}],
             by_trees:  [{:found_tree_id=>34, :found_profile_ids=>[542, 541, 543, 544, 539, 540]},
                         {:found_tree_id=>45, :found_profile_ids=>[649, 650, 645, 646, 651, 647]},
                         {:found_tree_id=>47, :found_profile_ids=>[669, 671, 666, 668, 672, 667, 670, 673]}],
             duplicates_one_to_many:  {711=>{45=>{648=>5, 710=>5}}},
             duplicates_many_to_one:  {648=>{47=>711}, 710=>{47=>711}}
          }
        }
        let(:current_user_id) { 46 }
        before { SearchResults.store_search_results(search_results, current_user_id)  }

        describe ' - check SearchResults have rows count After <store_search_results> with BOTH types duplicates - Ok' do
          let(:rows_qty) {5}
          it_behaves_like :successful_search_results_rows_count
        end
        it ' - check SearchResults Fourth Factory row - Ok' do # , focus: true
          puts "Check SearchResults.store_search_results[:by_trees] with BOTH types duplicates: #{search_results[:by_trees]} \n"   # 0
          puts "In SearchResults.store_search_results[:duplicates_one_to_many]: #{search_results[:duplicates_one_to_many]} \n"   # 0
          puts "In SearchResults.store_search_results[:duplicates_many_to_one]: #{search_results[:duplicates_many_to_one]} \n"   # 0
          search_results_fields = SearchResults.find(4).attributes.except('created_at','updated_at')
          expect(search_results_fields).to eq({"id"=>4, "user_id"=>46, "found_user_id"=>34, "profile_id"=>662,
                                               "found_profile_id"=>540, "count"=>5,
                                               "found_profile_ids"=>[540, 539, 544, 543, 541, 542],
                                               "searched_profile_ids"=>[662, 657, 658, 659, 663, 656],
                                               "counts"=>[5, 5, 5, 5, 5, 5],
                                               "connection_id"=>888, "pending_connect"=>0,
                                               "searched_connected"=>[46], "founded_connected"=>[34] } )
        end
        it ' - check SearchResults Five Factory row - Ok' do # , focus: true
          puts "Check SearchResults.store_search_results[:by_trees] with BOTH types duplicates: #{search_results[:by_trees]} \n"   # 0
          puts "In SearchResults.store_search_results[:duplicates_one_to_many]: #{search_results[:duplicates_one_to_many]} \n"   # 0
          puts "In SearchResults.store_search_results[:duplicates_many_to_one]: #{search_results[:duplicates_many_to_one]} \n"   # 0
          search_results_fields = SearchResults.find(5).attributes.except('created_at','updated_at')
          expect(search_results_fields).to eq({"id"=>5, "user_id"=>34, "found_user_id"=>46, "profile_id"=>540,
                                               "found_profile_id"=>662, "count"=>5,
                                               "found_profile_ids"=>[662, 657, 658, 659, 663, 656],
                                               "searched_profile_ids"=>[540, 539, 544, 543, 541, 542],
                                               "counts"=>[5, 5, 5, 5, 5, 5],
                                               "connection_id"=>nil, "pending_connect"=>1,
                                               "searched_connected"=>[34], "founded_connected"=>[46] } )
        end

      end




    end


  end

end
