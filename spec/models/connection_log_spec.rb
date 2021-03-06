require 'rails_helper'

RSpec.describe ConnectionLog, type: :model  do  # , focus: true

  after {
    ConnectionRequest.delete_all
    ConnectionRequest.reset_pk_sequence
    User.delete_all
    User.reset_pk_sequence
    ConnectedUser.delete_all
    ConnectedUser.reset_pk_sequence
    Tree.delete_all
    Tree.reset_pk_sequence
    Profile.delete_all
    Profile.reset_pk_sequence
    ProfileKey.delete_all
    ProfileKey.reset_pk_sequence
    # WeafamSetting.delete_all
    # WeafamSetting.reset_pk_sequence
    Name.delete_all
    Name.reset_pk_sequence
    ConnectionLog.delete_all
    ConnectionLog.reset_pk_sequence
    CommonLog.delete_all
    CommonLog.reset_pk_sequence
    UpdatesFeed.delete_all
    UpdatesFeed.reset_pk_sequence
    SearchResults.delete_all
    SearchResults.reset_pk_sequence
  }

  describe '- Validation' do
    describe '- on create' do

      context '- valid connection_log'   do  # , focus: true

        let(:good_connections_log) {FactoryGirl.build(:connection_log)}
        it '- 1 Saves a valid connection_log' do
          puts " Model ConnectionLog validation "
          expect(good_connections_log).to be_valid
        end

        let(:good_connections_log_big) {FactoryGirl.build(:connection_log, :big_IDs)}
        it '- 2 Saves a valid connection_log - big IDs' do
          expect(good_connections_log_big).to be_valid
        end

        let(:good_connections_written_nil) {FactoryGirl.build(:connection_log, :written_nil)}
        it '- 3 Saves a valid connection_log - written = nil: profiles, user_id' do
          expect(good_connections_written_nil).to be_valid
        end

        let(:good_connections_table_users) {FactoryGirl.build(:connection_log, :table_users)}
        it '- 4 Saves a valid connection_log - table = users, only field = profile_id' do
          expect(good_connections_table_users).to be_valid
        end

        let(:good_connections_table_trees_is_profile_id) {FactoryGirl.build(:connection_log, :table_tree_is_profile_id)}
        it '- 5 Saves a valid connection_log - table = trees, one field = is_profile_id' do
          expect(good_connections_table_trees_is_profile_id).to be_valid
        end

        let(:good_connections_table_trees_profile_id) {FactoryGirl.build(:connection_log, :table_tree_profile_id)}
        it '- 6 Saves a valid connection_log - table = trees, one field = profile_id' do
          expect(good_connections_table_trees_profile_id).to be_valid
        end

        let(:good_sims_table_pr_key_is_profile_id) {FactoryGirl.build(:connection_log, :table_pr_key_is_profile_id)}
        it '- 7 Saves a valid connection_log - table = profile_keys, one field = is_profile_id' do
          expect(good_sims_table_pr_key_is_profile_id).to be_valid
        end

        let(:good_connections_table_pr_key_profile_id) {FactoryGirl.build(:connection_log, :table_pr_key_profile_id)}
        it '- 8 Saves a valid connection_log - table = profile_keys, one field = profile_id' do
          expect(good_connections_table_pr_key_profile_id).to be_valid
        end

        let(:good_connections_overwritten_nil) {FactoryGirl.build(:connection_log, :overwritten_nil)}
        it '- 9 Saves a valid connection_log - overwritten = nil: profiles, user_id' do
          expect(good_connections_overwritten_nil).to be_valid
        end

      end


      context '- invalid connection_log'   do  # , focus: true

        # let(:bad_connections_written_equal_overwritten) {FactoryGirl.build(:connection_log, :bad_written_and_overwritten)}
        # it '- 1 Dont save: - written_and_overwritten - equal' , focus: true do
        #   expect(bad_connections_written_equal_overwritten).to_not be_valid
        # end
        #
        # let(:bad_connections_written_nil_table) {FactoryGirl.build(:connection_log, :bad_written_nil_table)}
        # it '- 2 Dont save: - written = nil: table = trees, user_id' do
        #   expect(bad_connections_written_nil_table).to_not be_valid
        # end
        #
        # let(:bad_connections_written_nil_field) {FactoryGirl.build(:connection_log, :bad_written_nil_field)}
        # it '- 3 Dont save: - written = nil: table = profiles, wrong field = profile_id' do
        #   expect(bad_connections_written_nil_field).to_not be_valid
        # end

        let(:bad_connections_table_tree_wrong_field) {FactoryGirl.build(:connection_log, :bad_table_tree_and_field)}
        it '- 4 Dont save: - wrong_field for table tree' do
          expect(bad_connections_table_tree_wrong_field).to_not be_valid
        end

        let(:bad_connections_table_pr_key_wrong_field) {FactoryGirl.build(:connection_log, :bad_table_pr_key_and_field)}
        it '- 5 Dont save: - wrong_field for table pr_key' do
          expect(bad_connections_table_pr_key_wrong_field).to_not be_valid
        end

        let(:bad_connections_table_user_wrong_field) {FactoryGirl.build(:connection_log, :bad_table_user_and_field)}
        it '- 6 Dont save: - wrong_field for table user' do
          expect(bad_connections_table_user_wrong_field).to_not be_valid
        end

        let(:bad_connections_table_profile_wrong_field) {FactoryGirl.build(:connection_log, :bad_table_profile_and_field)}
        it '- 7 Dont save: - wrong_field for table profile' do
          expect(bad_connections_table_profile_wrong_field).to_not be_valid
        end

        let(:bad_connections_overwritten_nil_table) {FactoryGirl.build(:connection_log, :bad_overwritten_nil_table)}
        it '- 8 Dont save: - overwritten = nil: table = profiles, wrong field = profile_id' do
          expect(bad_connections_overwritten_nil_table).to_not be_valid
        end

        let(:bad_connections_overwritten_nil_field) {FactoryGirl.build(:connection_log, :bad_overwritten_nil_field)}
        it '- 9 Dont save: - overwritten = nil: table = profiles, wrong field = profile_id' do
          expect(bad_connections_overwritten_nil_field).to_not be_valid
        end

      end

    end

  end

  describe '- Model ConnectionLog methods'    do

    # create users
    let(:user) {FactoryGirl.create(:user)}
    let(:other_user) {FactoryGirl.create(:other_user)}
    let(:third_user) {FactoryGirl.create(:third_user)}
    let(:four_user) {FactoryGirl.create(:four_user)}

    # create parameters
    let(:current_user_id) {user.id}
    let(:other_user_id) {other_user.id}
    let(:third_user_id) {third_user.id}
    let(:four_user_id) {four_user.id}

    # create model data
    before do
      FactoryGirl.create(:connection_log, :connections_log_1, current_user_id: current_user_id)
      FactoryGirl.create(:connection_log, :connections_log_2, current_user_id: current_user_id)
      FactoryGirl.create(:connection_log, :connections_log_3, current_user_id: other_user_id)
      FactoryGirl.create(:connection_log, :connections_log_4, current_user_id: third_user_id)
      FactoryGirl.create(:connection_log, :connections_log_5, current_user_id: third_user_id)
    end

    describe '* current_tree_log_id *' do

      context '- test log_connection_id' do
        let(:connected_users) {[current_user_id, other_user_id ]}
        let(:log_connection_id) { ConnectionLog.current_tree_log_id(connected_users) }
        it '- return proper log_connection_id for [current_user_id, other_user_id ]' do
          # puts "In current_tree_log_id:  current_user_id = #{current_user_id} "
          # puts "In current_tree_log_id:  log_connection_id = #{log_connection_id} "
          expect(log_connection_id).to eq(41)
        end
      end

      context '- test log_connection_id' do
        let(:connected_users) {[third_user_id]}
        let(:log_connection_id) { ConnectionLog.current_tree_log_id(connected_users) }
        it '- return proper log_connection_id for [third_user_id]' do
          # puts "In current_tree_log_id:  connected_users = #{connected_users} "
          # puts "In current_tree_log_id:  log_connection_id = #{log_connection_id} "
          expect(log_connection_id).to eq(42)
        end
      end

      context '- test log_connection_id' do
        let(:connected_users) {[four_user_id]}
        let(:log_connection_id) { ConnectionLog.current_tree_log_id(connected_users) }
        it '- return proper log_connection_id = [] for [third_user_id]' do
          # puts "In current_tree_log_id:  connected_users = #{connected_users} "
          # puts "In current_tree_log_id:  log_connection_id = #{log_connection_id} "
          expect(log_connection_id).to eq([])
        end
      end

    end

    describe '* store connection logs* - valid build'   do # , focus: true

      before do
        ConnectionLog.delete_all
        ConnectionLog.reset_pk_sequence
        FactoryGirl.create(:connection_log, :connections_log_table_row_1, current_user_id: current_user_id)
      end
      let(:first_row) { ConnectionLog.first}
      context '- Check table_row to be stored' do
        let(:one_second_row) { FactoryGirl.build(:connection_log, :connections_log_table_row_2, current_user_id: current_user_id)}
        it '- table_rows CAN BE equal for two specific rows' do
          # puts "1. first_row = #{first_row.inspect} \n"
          # puts "2. second_row = #{one_second_row.inspect} "
          expect(one_second_row).to be_valid #
        end
      end

      context '- Check table_row to be stored' do
        let(:other_second_row) { FactoryGirl.build(:connection_log, :connections_log_table_row_3, current_user_id: current_user_id)}
        it '- table_rows CAN NOT BE equal for two specific rows' do
          puts "1. first_row = #{first_row[:table_row].inspect} \n"
          puts "3. other_row = #{other_second_row[:table_row].inspect} "
          expect(other_second_row).to_not be_valid #
        end
      end

    end

  end

end
