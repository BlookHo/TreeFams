require 'rails_helper'

RSpec.describe SimilarsLog, :type => :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  describe '- Validation' do
    describe '- on create' do

      context '- valid similars log' do

        let(:good_sims_log) {FactoryGirl.build(:similars_log)}
        it '- Saves a valid similars log' do
          expect(good_sims_log).to be_valid
        end

        let(:good_sims_log_big) {FactoryGirl.build(:similars_log, :big_IDs)}
        it '- Saves a valid similars log - big IDs' do
          # puts "In find_stored_similars:  sims_profiles_pairs = #{sims_profiles_pairs} "
          expect(good_sims_log_big).to be_valid
        end

        let(:good_sims_written_nil) {FactoryGirl.build(:similars_log, :written_nil)}
        it '- Saves a valid similars log - written = nil: profiles, user_id' do
          expect(good_sims_written_nil).to be_valid
        end

        let(:good_sims_table_users) {FactoryGirl.build(:similars_log, :table_users)}
        it '- Saves a valid similars log - table = users, field = profile_id' do
          expect(good_sims_table_users).to be_valid
        end

        let(:good_sims_table_trees) {FactoryGirl.build(:similars_log, :table_tree_pr_key)}
        it '- Saves a valid similars log - table = trees, field = is_profile_id' do
          expect(good_sims_table_trees).to be_valid
        end




      end
      context '- invalid similars log' do

        let(:bad_sims_written_nil_table) {FactoryGirl.build(:similars_log, :bad_written_nil_table)}
        it '- Dont save valid similars log - written = nil: table = trees, user_id' do
          expect(bad_sims_written_nil_table).to_not be_valid
        end

        let(:bad_sims_written_nil_field) {FactoryGirl.build(:similars_log, :bad_written_nil_field)}
        it '- Dont save valid similars log - written = nil: profiles, field = profile_id' do
          expect(bad_sims_written_nil_field).to_not be_valid
        end

        let(:bad_sims_table_wrong_field) {FactoryGirl.build(:similars_log, :bad_table_tree_and_field)}
        it '- Dont save valid similars log - wrong_field for table tree' do
          expect(bad_sims_table_wrong_field).to_not be_valid
        end


      end

    end

    # pending "making test clear_similars_found method in #{__FILE__}"

  end
end
