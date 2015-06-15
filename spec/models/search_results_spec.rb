require 'rails_helper'

RSpec.describe SearchResults, type: :model , focus: true   do  #, focus: true

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

        let(:bad_unarray_found_profile_ids) {FactoryGirl.build(:search_results, :unarray_found_profile_ids)}
        it '- 4 Dont save: - unarray field found_profile_ids' do
          expect(bad_unarray_found_profile_ids).to_not be_valid
        end

        let(:bad_unarray_searched_profile_ids) {FactoryGirl.build(:search_results, :unarray_searched_profile_ids)}
        it '- 5 Dont save: - unarray field searched_profile_ids' do
          expect(bad_unarray_searched_profile_ids).to_not be_valid
        end

        let(:bad_unarray_counts) {FactoryGirl.build(:search_results, :unarray_counts)}
        it '- 6 Dont save: - unarray fields counts' do
          expect(bad_unarray_counts).to_not be_valid
        end

        let(:bad_users_equals) {FactoryGirl.build(:search_results, :users_equals)}
        it '- 7 Dont save: - :user_id  AND :found_user_id - equals' do
          expect(bad_users_equals).to_not be_valid
        end

        let(:bad_profiles_equals) {FactoryGirl.build(:search_results, :profiles_equals)}
        it '- 8 Dont save: - :profile_id  AND :found_profile_id - equals' do
          expect(bad_profiles_equals).to_not be_valid
        end

      end

    end

  end




end
