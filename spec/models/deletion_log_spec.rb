require 'rails_helper'

RSpec.describe DeletionLog, type: :model do # , focus: true

  describe '- Validation' do
    describe '- on create' do

      context '- valid deletion_log' , focus: true do  # , focus: true

        let(:good_deletion_log) {FactoryGirl.build(:deletion_log)}
        it '- 1 Saves a valid deletion_log' do
          puts " Model DeletionLog validation "
          expect(good_deletion_log).to be_valid
        end

        let(:good_deletion_log_big) {FactoryGirl.build(:deletion_log, :big_IDs)}
        it '- 2 Saves a valid deletion_log - big IDs' do
          expect(good_deletion_log_big).to be_valid
        end

        let(:good_deletion_log_table_trees) {FactoryGirl.build(:deletion_log, :table_tree_deleted)}
        it '- 3 Saves a valid deletion_log - table = trees, one field = deleted' do
          expect(good_deletion_log_table_trees).to be_valid
        end

        let(:good_deletion_log_table_pr_key) {FactoryGirl.build(:deletion_log, :table_pr_key_deleted)}
        it '- 4 Saves a valid deletion_log - table = profile_keys, one field = deleted' do
          expect(good_deletion_log_table_pr_key).to be_valid
        end

      end

      context '- invalid deletion_log'  do  # , focus: true

        let(:bad_connections_written_equal_overwritten) {FactoryGirl.build(:deletion_log, :bad_written_and_overwritten)}
        it '- 1 Dont save: - written_and_overwritten - equal' do
          expect(bad_connections_written_equal_overwritten).to_not be_valid
        end

        let(:bad_connections_written_nil_table) {FactoryGirl.build(:deletion_log, :bad_written_nil_table)}
        it '- 2 Dont save: - written = nil: table = trees, user_id' do
          expect(bad_connections_written_nil_table).to_not be_valid
        end

        let(:bad_connections_written_nil_field) {FactoryGirl.build(:deletion_log, :bad_written_nil_field)}
        it '- 3 Dont save: - written = nil: table = profiles, wrong field = profile_id' do
          expect(bad_connections_written_nil_field).to_not be_valid
        end

        let(:bad_connections_table_tree_wrong_field) {FactoryGirl.build(:deletion_log, :bad_table_tree_and_field)}
        it '- 4 Dont save: - wrong_field for table tree' do
          expect(bad_connections_table_tree_wrong_field).to_not be_valid
        end

        let(:bad_connections_table_pr_key_wrong_field) {FactoryGirl.build(:deletion_log, :bad_table_pr_key_and_field)}
        it '- 5 Dont save: - wrong_field for table pr_key' do
          expect(bad_connections_table_pr_key_wrong_field).to_not be_valid
        end

        let(:bad_connections_table_user_wrong_field) {FactoryGirl.build(:deletion_log, :bad_table_user_and_field)}
        it '- 6 Dont save: - wrong_field for table user' do
          expect(bad_connections_table_user_wrong_field).to_not be_valid
        end

        let(:bad_connections_table_profile_wrong_field) {FactoryGirl.build(:deletion_log, :bad_table_profile_and_field)}
        it '- 7 Dont save: - wrong_field for table profile' do
          expect(bad_connections_table_profile_wrong_field).to_not be_valid
        end

        let(:bad_connections_overwritten_nil_table) {FactoryGirl.build(:deletion_log, :bad_overwritten_nil_table)}
        it '- 8 Dont save: - overwritten = nil: table = profiles, wrong field = profile_id' do
          expect(bad_connections_overwritten_nil_table).to_not be_valid
        end

        let(:bad_connections_overwritten_nil_field) {FactoryGirl.build(:deletion_log, :bad_overwritten_nil_field)}
        it '- 9 Dont save: - overwritten = nil: table = profiles, wrong field = profile_id' do
          expect(bad_connections_overwritten_nil_field).to_not be_valid
        end


      end

    end

  end




  # pending "add some examples to (or delete) #{__FILE__}"
end
