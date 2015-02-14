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
        it '- Saves a valid similars log - table = users, only field = profile_id' do
          expect(good_sims_table_users).to be_valid
        end

        let(:good_sims_table_trees_is_profile_id) {FactoryGirl.build(:similars_log, :table_tree_is_profile_id)}
        it '- Saves a valid similars log - table = trees, one field = is_profile_id' do
          expect(good_sims_table_trees_is_profile_id).to be_valid
        end

        let(:good_sims_table_trees_profile_id) {FactoryGirl.build(:similars_log, :table_tree_profile_id)}
        it '- Saves a valid similars log - table = trees, one field = profile_id' do
          expect(good_sims_table_trees_profile_id).to be_valid
        end

        let(:good_sims_table_pr_key_is_profile_id) {FactoryGirl.build(:similars_log, :table_pr_key_is_profile_id)}
        it '- Saves a valid similars log - table = profile_keys, one field = is_profile_id' do
          expect(good_sims_table_pr_key_is_profile_id).to be_valid
        end

        let(:good_sims_table_pr_key_profile_id) {FactoryGirl.build(:similars_log, :table_pr_key_profile_id)}
        it '- Saves a valid similars log - table = profile_keys, one field = profile_id' do
          expect(good_sims_table_pr_key_profile_id).to be_valid
        end



      end
      context '- invalid similars log' do

        let(:bad_sims_written_equal_overwritten) {FactoryGirl.build(:similars_log, :bad_written_and_overwritten)}
        it '- Dont save: - written_and_overwritten - equal' do
          expect(bad_sims_written_equal_overwritten).to_not be_valid
        end

        let(:bad_sims_written_nil_table) {FactoryGirl.build(:similars_log, :bad_written_nil_table)}
        it '- Dont save: - written = nil: table = trees, user_id' do
          expect(bad_sims_written_nil_table).to_not be_valid
        end

        let(:bad_sims_written_nil_field) {FactoryGirl.build(:similars_log, :bad_written_nil_field)}
        it '- Dont save: - written = nil: table = profiles, wrong field = profile_id' do
          expect(bad_sims_written_nil_field).to_not be_valid
        end

        let(:bad_sims_table_tree_wrong_field) {FactoryGirl.build(:similars_log, :bad_table_tree_and_field)}
        it '- Dont save: - wrong_field for table tree' do
          expect(bad_sims_table_tree_wrong_field).to_not be_valid
        end

        let(:bad_sims_table_pr_key_wrong_field) {FactoryGirl.build(:similars_log, :bad_table_pr_key_and_field)}
        it '- Dont save: - wrong_field for table pr_key' do
          expect(bad_sims_table_pr_key_wrong_field).to_not be_valid
        end

        let(:bad_sims_table_user_wrong_field) {FactoryGirl.build(:similars_log, :bad_table_user_and_field)}
        it '- Dont save: - wrong_field for table user' do
          expect(bad_sims_table_user_wrong_field).to_not be_valid
        end

        let(:bad_sims_table_profile_wrong_field) {FactoryGirl.build(:similars_log, :bad_table_profile_and_field)}
        it '- Dont save: - wrong_field for table profile' do
          expect(bad_sims_table_profile_wrong_field).to_not be_valid
        end


      end

    end


  end

  describe '- Methods' do

    context '- test current_tree_log_id' do

      pending "making test current_tree_log_id method in #{__FILE__}"


    end

  end

end
