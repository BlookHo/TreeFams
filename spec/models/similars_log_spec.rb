require 'rails_helper'

RSpec.describe SimilarsLog, :type => :model  do  # , focus: true
  #pending "add some examples to (or delete) #{__FILE__}"

  describe '- Validation' do
    describe '- on create' do

      context '- valid similars log' do

        let(:good_sims_log) {FactoryGirl.build(:similars_log)}
        it '- 1 Saves a valid similars log' do
          puts " Model SimilarsLog validation "
          expect(good_sims_log).to be_valid
        end

        let(:good_sims_log_big) {FactoryGirl.build(:similars_log, :big_IDs)}
        it '- 2 Saves a valid similars log - big IDs' do
          expect(good_sims_log_big).to be_valid
        end

        let(:good_sims_written_nil) {FactoryGirl.build(:similars_log, :written_nil)}
        it '- 3 Saves a valid similars log - written = nil: profiles, user_id' do
          expect(good_sims_written_nil).to be_valid
        end

        let(:good_sims_table_users) {FactoryGirl.build(:similars_log, :table_users)}
        it '- 4 Saves a valid similars log - table = users, only field = profile_id' do
          expect(good_sims_table_users).to be_valid
        end

        let(:good_sims_table_trees_is_profile_id) {FactoryGirl.build(:similars_log, :table_tree_is_profile_id)}
        it '- 5 Saves a valid similars log - table = trees, one field = is_profile_id' do
          expect(good_sims_table_trees_is_profile_id).to be_valid
        end

        let(:good_sims_table_trees_profile_id) {FactoryGirl.build(:similars_log, :table_tree_profile_id)}
        it '- 6 Saves a valid similars log - table = trees, one field = profile_id' do
          expect(good_sims_table_trees_profile_id).to be_valid
        end

        let(:good_sims_table_pr_key_is_profile_id) {FactoryGirl.build(:similars_log, :table_pr_key_is_profile_id)}
        it '- 7 Saves a valid similars log - table = profile_keys, one field = is_profile_id' do
          expect(good_sims_table_pr_key_is_profile_id).to be_valid
        end

        let(:good_sims_table_pr_key_profile_id) {FactoryGirl.build(:similars_log, :table_pr_key_profile_id)}
        it '- 8 Saves a valid similars log - table = profile_keys, one field = profile_id' do
          expect(good_sims_table_pr_key_profile_id).to be_valid
        end

        let(:good_sims_overwritten_nil) {FactoryGirl.build(:similars_log, :overwritten_nil)}
        it '- 9 Saves a valid similars log - overwritten = nil: profiles, user_id' do
          expect(good_sims_overwritten_nil).to be_valid
        end



      end
      context '- invalid similars log' do

        let(:bad_sims_written_equal_overwritten) {FactoryGirl.build(:similars_log, :bad_written_and_overwritten)}
        it '- 1 Dont save: - written_and_overwritten - equal' do
          expect(bad_sims_written_equal_overwritten).to_not be_valid
        end

        let(:bad_sims_written_nil_table) {FactoryGirl.build(:similars_log, :bad_written_nil_table)}
        it '- 2 Dont save: - written = nil: table = trees, user_id' do
          expect(bad_sims_written_nil_table).to_not be_valid
        end

        let(:bad_sims_written_nil_field) {FactoryGirl.build(:similars_log, :bad_written_nil_field)}
        it '- 3 Dont save: - written = nil: table = profiles, wrong field = profile_id' do
          expect(bad_sims_written_nil_field).to_not be_valid
        end

        let(:bad_sims_table_tree_wrong_field) {FactoryGirl.build(:similars_log, :bad_table_tree_and_field)}
        it '- 4 Dont save: - wrong_field for table tree' do
          expect(bad_sims_table_tree_wrong_field).to_not be_valid
        end

        let(:bad_sims_table_pr_key_wrong_field) {FactoryGirl.build(:similars_log, :bad_table_pr_key_and_field)}
        it '- 5 Dont save: - wrong_field for table pr_key' do
          expect(bad_sims_table_pr_key_wrong_field).to_not be_valid
        end

        let(:bad_sims_table_user_wrong_field) {FactoryGirl.build(:similars_log, :bad_table_user_and_field)}
        it '- 6 Dont save: - wrong_field for table user' do
          expect(bad_sims_table_user_wrong_field).to_not be_valid
        end

        let(:bad_sims_table_profile_wrong_field) {FactoryGirl.build(:similars_log, :bad_table_profile_and_field)}
        it '- 7 Dont save: - wrong_field for table profile' do
          expect(bad_sims_table_profile_wrong_field).to_not be_valid
        end

        let(:bad_sims_overwritten_nil_table) {FactoryGirl.build(:similars_log, :bad_overwritten_nil_table)}
        it '- 8 Dont save: - overwritten = nil: table = profiles, wrong field = profile_id' do
          expect(bad_sims_overwritten_nil_table).to_not be_valid
        end

        let(:bad_sims_overwritten_nil_field) {FactoryGirl.build(:similars_log, :bad_overwritten_nil_field)}
        it '- 9 Dont save: - overwritten = nil: table = profiles, wrong field = profile_id' do
          expect(bad_sims_overwritten_nil_field).to_not be_valid
        end


      end

    end

  end

  describe '- Model methods' do

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

    # let(:sims_profiles_pairs) {[[38, 42], [41, 40]]}

    # create model data
    before do
      FactoryGirl.create(:similars_log, :sims_log_1, current_user_id: current_user_id)
      FactoryGirl.create(:similars_log, :sims_log_2, current_user_id: current_user_id)
      FactoryGirl.create(:similars_log, :sims_log_3, current_user_id: other_user_id)
      FactoryGirl.create(:similars_log, :sims_log_4, current_user_id: third_user_id)
      FactoryGirl.create(:similars_log, :sims_log_5, current_user_id: third_user_id)
    end
    #<SimilarsLog id: 754, connected_at: 25, current_user_id: 5, table_name: "users", table_row: 5, field: "profile_id", written: 52, overwritten: 34, created_at: "2015-01-26 18:08:49", updated_at: "2015-01-26 18:08:49">,
    #<SimilarsLog id: 755, connected_at: 25, current_user_id: 5, table_name: "profiles", table_row: 52, field: "user_id", written: 5, overwritten: nil, created_at: "2015-01-26 18:08:49", updated_at: "2015-01-26 18:08:49">,
    #<SimilarsLog id: 756, connected_at: 25, current_user_id: 5, table_name: "profiles", table_row: 52, field: "tree_id", written: 5, overwritten: 4, created_at: "2015-01-26 18:08:49", updated_at: "2015-01-26 18:08:49">,
    #<SimilarsLog id: 757, connected_at: 25, current_user_id: 5, table_name: "profiles", table_row: 34, field: "user_id", written: nil, overwritten: 5, created_at: "2015-01-26 18:08:49", updated_at: "2015-01-26 18:08:49">

    # from similars_start.rb#start_similars
    # from similars_controller.rb#internal_similars_search
    # from home_controller.rb#index
    describe '* current_tree_log_id *' do

      context '- test log_connection_id' do
        let(:connected_users) {[current_user_id, other_user_id ]}
        let(:log_connection_id) { SimilarsLog.current_tree_log_id(connected_users) }
        it '- return proper log_connection_id for [current_user_id, other_user_id ]' do
          expect(log_connection_id).to eq(41)
        end
      end

      context '- test log_connection_id' do
        let(:connected_users) {[third_user_id]}
        let(:log_connection_id) { SimilarsLog.current_tree_log_id(connected_users) }
        it '- return proper log_connection_id for [third_user_id]' do
          expect(log_connection_id).to eq(42)
        end
      end

      context '- test log_connection_id' do
        let(:connected_users) {[four_user_id]}
        let(:log_connection_id) { SimilarsLog.current_tree_log_id(connected_users) }
        it '- return proper log_connection_id = [] for [third_user_id]' do
          expect(log_connection_id).to eq([])
        end
      end

    end

    describe '* store similars logs*' do

        before do
          SimilarsLog.delete_all
          SimilarsLog.reset_pk_sequence
          FactoryGirl.create(:similars_log, :sims_log_table_row_1, current_user_id: current_user_id)
        end
        let(:first_row) { SimilarsLog.first}
        context '- Check table_row to be stored' do
          let(:second_row) { FactoryGirl.build(:similars_log, :sims_log_table_row_2, current_user_id: current_user_id)}
          it '- table_rows CAN BE equal for two specific rows' do
             expect(second_row).to be_valid #
          end
        end

        context '- Check table_row to be stored' do
          let(:third_row) { FactoryGirl.build(:similars_log, :sims_log_table_row_3, current_user_id: current_user_id)}
          it '- table_rows CAN NOT BE equal for two specific rows' do
            expect(third_row).to_not be_valid #
          end
        end

    end

  end
  # pending "making test current_tree_log_id method in #{__FILE__}"

end
