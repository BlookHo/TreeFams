require 'rails_helper'

RSpec.describe DeletionLog, type: :model do # , focus: true

  after {
    DeletionLog.delete_all
    DeletionLog.reset_pk_sequence

    # ConnectionRequest.delete_all
    # ConnectionRequest.reset_pk_sequence
    # User.delete_all
    # User.reset_pk_sequence
    # ConnectedUser.delete_all
    # ConnectedUser.reset_pk_sequence
    # Tree.delete_all
    # Tree.reset_pk_sequence
    # Profile.delete_all
    # Profile.reset_pk_sequence
    # ProfileKey.delete_all
    # ProfileKey.reset_pk_sequence
    # # WeafamSetting.delete_all
    # # WeafamSetting.reset_pk_sequence
    # Name.delete_all
    # Name.reset_pk_sequence
    # ConnectionLog.delete_all
    # ConnectionLog.reset_pk_sequence
    # CommonLog.delete_all
    # CommonLog.reset_pk_sequence
    # UpdatesFeed.delete_all
    # UpdatesFeed.reset_pk_sequence
    # SearchResults.delete_all
    # SearchResults.reset_pk_sequence
  }


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

      context '- invalid deletion_log'  , focus: true do  # , focus: true

        let(:bad_deletion_log_uncorrect_log_number) {FactoryGirl.build(:deletion_log, :uncorrect_log_number)}
        # let(:last_log_number) { DeletionLog.last.log_number }

        it '- 1 Dont save: - uncorrect_log_number' do
          # puts "In uncorrect_log_number:  last_log_number = #{last_log_number} "

          expect(bad_deletion_log_uncorrect_log_number).to_not be_valid
        end

        let(:bad_deletion_log_uncorrect_table_row) {FactoryGirl.build(:deletion_log, :uncorrect_table_row)}
        it '- 2 Dont save: - uncorrect_table_row' do
          expect(bad_deletion_log_uncorrect_table_row).to_not be_valid
        end

        let(:bad_deletion_log_uncorrect_table_name) {FactoryGirl.build(:deletion_log, :uncorrect_table_name)}
        it '- 3 Dont save: - uncorrect_table_name' do
          expect(bad_deletion_log_uncorrect_table_name).to_not be_valid
        end

        let(:bad_deletion_log_uncorrect_user) {FactoryGirl.build(:deletion_log, :uncorrect_user)}
        it '- 4 Dont save: - uncorrect_user' do
          expect(bad_deletion_log_uncorrect_user).to_not be_valid
        end

        let(:bad_deletion_log_uncorrect_written) {FactoryGirl.build(:deletion_log, :uncorrect_written)}
        it '- 5 Dont save: - uncorrect_written' do
          expect(bad_deletion_log_uncorrect_written).to_not be_valid
        end

      end

    end

  end




end
