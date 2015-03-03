require 'rails_helper'


# describe ProfileKey do
RSpec.describe SimilarsLog, :type => :model do
  describe '- validation' do
    describe '- on create' do

      context '- valid profiles' do
        # let(:first_profile) {FactoryGirl.build(:profile_one)}  #
        # it '- saves a valid profile_one' do
        #   expect(first_profile).to be_valid
        # end

        # let(:good_sims_log) {FactoryGirl.build(:similars_log)}
        # it '- 1 Saves a valid similars log' do
        #   expect(good_sims_log).to be_valid
        # end
        #
        # let(:good_sims_log_big) {FactoryGirl.build(:similars_log, :big_IDs)}
        # it '- 2 Saves a valid similars log - big IDs' do
        #   expect(good_sims_log_big).to be_valid
        # end
        #
        # let(:good_sims_written_nil) {FactoryGirl.build(:similars_log, :written_nil)}
        # it '- 3 Saves a valid similars log - written = nil: profiles, user_id' do
        #   expect(good_sims_written_nil).to be_valid
        # end
        #
        # let(:good_sims_table_users) {FactoryGirl.build(:similars_log, :table_users)}
        # it '- 4 Saves a valid similars log - table = users, only field = profile_id' do
        #   expect(good_sims_table_users).to be_valid
        # end
        #
        # let(:good_sims_table_trees_is_profile_id) {FactoryGirl.build(:similars_log, :table_tree_is_profile_id)}
        # it '- 5 Saves a valid similars log - table = trees, one field = is_profile_id' do
        #   expect(good_sims_table_trees_is_profile_id).to be_valid
        # end
        #
        # let(:good_sims_table_trees_profile_id) {FactoryGirl.build(:similars_log, :table_tree_profile_id)}
        # it '- 6 Saves a valid similars log - table = trees, one field = profile_id' do
        #   expect(good_sims_table_trees_profile_id).to be_valid
        # end
        #
        # let(:good_sims_table_pr_key_is_profile_id) {FactoryGirl.build(:similars_log, :table_pr_key_is_profile_id)}
        # it '- 7 Saves a valid similars log - table = profile_keys, one field = is_profile_id' do
        #   expect(good_sims_table_pr_key_is_profile_id).to be_valid
        # end
        #
        # let(:good_sims_table_pr_key_profile_id) {FactoryGirl.build(:similars_log, :table_pr_key_profile_id)}
        # it '- 8 Saves a valid similars log - table = profile_keys, one field = profile_id' do
        #   expect(good_sims_table_pr_key_profile_id).to be_valid
        # end
        #
        # let(:good_sims_overwritten_nil) {FactoryGirl.build(:similars_log, :overwritten_nil)}
        # it '- 9 Saves a valid similars log - overwritten = nil: profiles, user_id' do
        #   expect(good_sims_overwritten_nil).to be_valid
        # end

      end

    end
  end
end
