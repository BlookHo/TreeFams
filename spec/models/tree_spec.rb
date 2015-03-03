require 'rails_helper'

# describe Tree do
RSpec.describe Tree, :type => :model do

  describe '- validation' do
    describe '- on create' do

      context '- valid tree_row' do
        let(:tree_row) {FactoryGirl.build(:tree, :tree_key_good)}
        it '- saves a valid tree_row' do
          puts " Model Tree validation "
          expect(tree_row).to be_valid
        end

        let(:good_tree_row_big) {FactoryGirl.build(:tree, :big_IDs)}
        it '- 2 Saves a valid tree_row - big IDs' do
          expect(good_tree_row_big).to be_valid
        end
      end

      context '- invalid tree_row' do
        let(:bad_user_id) {FactoryGirl.build(:tree, :user_less_zero)}
        it '- 1 Dont save: - bad_user_id - less 0' do
          expect(bad_user_id).to_not be_valid
        end

        let(:bad_profile_id) {FactoryGirl.build(:tree, :profile_id_less_zero)}
        it '- 2 Dont save: - bad_profile_id - less 0' do
          expect(bad_profile_id).to_not be_valid
        end

        let(:bad_name_id) {FactoryGirl.build(:tree, :name_id_less_zero)}
        it '- 3 Dont save: - bad_name_id - less 0' do
          expect(bad_name_id).to_not be_valid
        end

        let(:bad_relation_id_less_zero) {FactoryGirl.build(:tree, :relation_id_less_zero)}
        it '- 4 Dont save: - bad_relation_id - less 0' do
          expect(bad_relation_id_less_zero).to_not be_valid
        end

        let(:bad_is_profile_id) {FactoryGirl.build(:tree, :is_profile_id_equ_zero)}
        it '- 5 Dont save: - bad_is_profile_id - == 0' do
          expect(bad_is_profile_id).to_not be_valid
        end

        let(:bad_is_name_id) {FactoryGirl.build(:tree, :is_name_id_equ_zero)}
        it '- 6 Dont save: - bad_is_name_id - == 0' do
          expect(bad_is_name_id).to_not be_valid
        end

        let(:bad_relation_id_wrong_number) {FactoryGirl.build(:tree, :relation_wrong)}
        it '- 7 Dont save: - bad_relation_id_wrong_number - == 9' do
          expect(bad_relation_id_wrong_number).to_not be_valid
        end

        let(:bad_profiles_wrong_equal) {FactoryGirl.build(:tree, :profiles_wrong_equal)}
        it '- 8 Dont save: - bad_profiles_wrong_equal - == ' do
          expect(bad_profiles_wrong_equal).to_not be_valid
        end

        let(:bad_profile_non_integer) {FactoryGirl.build(:tree, :profile_non_integer)}
        it '- 9 Dont save: - bad_profile_non_integer - == 6.77 ' do
          expect(bad_profile_non_integer).to_not be_valid
        end
      end

    end
  end

  describe '- Model methods' do
    # create parameters
    # let(:current_user_id) {user.id}
    # let(:other_user_id) {other_user.id}

    # create model data
    before do
      # FactoryGirl.create(:tree, :sims_log_1, current_user_id: current_user_id)
      # FactoryGirl.create(:tree, :sims_log_2, current_user_id: current_user_id)
      # FactoryGirl.create(:tree, :sims_log_3, current_user_id: other_user_id)
      # FactoryGirl.create(:tree, :sims_log_4, current_user_id: third_user_id)
      # FactoryGirl.create(:tree, :sims_log_5, current_user_id: third_user_id)
    end

    describe '* get_connected_tree *' do

      context '- get tree arr' do
        # let(:connected_users) {[current_user_id, other_user_id ]}
        # let(:log_connection_id) { SimilarsLog.current_tree_log_id(connected_users) }
        # it '- return proper log_connection_id for [current_user_id, other_user_id ]' do
        #   # puts "In current_tree_log_id:  current_user_id = #{current_user_id} "
        #   # puts "In current_tree_log_id:  log_connection_id = #{log_connection_id} "
        #   expect(log_connection_id).to eq(41)
        # end
      end

    end

  end


end
