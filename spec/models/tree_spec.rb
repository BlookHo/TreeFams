require 'rails_helper'

# describe Tree do
RSpec.describe Tree, :type => :model do  # , focus: true

  describe '- validation' do

    describe 'Validation test Before Model Tree methods ' , focus: true  do # , focus: true
      after {
        Tree.delete_all
        Tree.reset_pk_sequence
      }

      it "has a valid factory" do
        puts " Model Tree validation - has a valid factory"
        expect(FactoryGirl.create(:test_model_tree)).to be_valid
      end

      it "is invalid without a user_id" do
        puts " Model Tree validation - invalid without a user_id"
        expect(FactoryGirl.build(:test_model_tree, user_id: nil)).to_not be_valid
      end

      it "is invalid without a profile_id" do
        puts " Model Tree validation - invalid without a profile_id"
        expect(FactoryGirl.build(:test_model_tree, profile_id: nil)).to_not be_valid
      end

      it "is invalid without a name_id" do
        puts " Model Tree validation - invalid without a name_id"
        expect(FactoryGirl.build(:test_model_tree, name_id: nil)).to_not be_valid
      end

      it "is invalid without a relation_id" do
        puts " Model Tree validation - invalid without a relation_id"
        expect(FactoryGirl.build(:test_model_tree, relation_id: nil)).to_not be_valid
      end

      it "is invalid without a is_profile_id" do
        puts " Model Tree validation - invalid without a is_profile_id"
        expect(FactoryGirl.build(:test_model_tree, is_profile_id: nil)).to_not be_valid
      end

      it "is invalid without a is_name_id" do
        puts " Model Tree validation - invalid without a is_name_id"
        expect(FactoryGirl.build(:test_model_tree, is_name_id: nil)).to_not be_valid
      end

    end

    describe '- Method Rename of profile in Tree test - '  do # , focus: true
      before {
        # Tree, 85 - name_id = 370.
        FactoryGirl.create(:tree, :add_tree9_1)   # 85 - 86, name_id = 28
        FactoryGirl.create(:tree, :add_tree9_2)   # 85 - 87, name_id = 48
        FactoryGirl.create(:tree, :add_tree9_3)   # 85 - 88, name_id = 465
        FactoryGirl.create(:tree, :add_tree9_4)   # 85 - 89, name_id = 345
        FactoryGirl.create(:tree, :add_tree9_5)   # 85 - 90, name_id = 343
        FactoryGirl.create(:tree, :add_tree9_6)   # 85 - 91, name_id = 446
        FactoryGirl.create(:tree, :add_tree9_7)   # 85 - 92, name_id = 147
      }
       after {
        Tree.delete_all
        Tree.reset_pk_sequence
      }
      # let(:row_profile) {FactoryGirl.create(:test_model_tree)}
      let(:profile_id) {85}
      let(:new_name_id) {150}

      context "- Before check Method -"  , focus: true  do
        describe '- check Tree have rows count before - Ok' do
          let(:rows_qty) {7}
          it_behaves_like :successful_tree_rows_count
        end

        describe '- check Tree have name_ids array before - Ok' do
          let(:profile_id) {85}
          let(:array_of_name_ids) {[370, 370, 370, 370, 370, 370, 370]}
          it_behaves_like :successful_tree_name_ids_arr
        end

      end


      context "- Check Method -" , focus: true  do  #  , focus: true
        before {  Tree.rename_in_tree(profile_id, new_name_id) }

        it "- profiles in Tree Renamed - Ok " do
          # p " Model Tree: before rename - row_profile.name_id = #{row_profile.name_id}"
          # puts  " Model Profil: after rename - new_name_id = #{Profile.find(row_profile.id).name_id}"
          expect(Tree.where(profile_id: profile_id).first.name_id).to eq(150)
        end

        describe '- check Tree have name_ids array before - Ok' do
          let(:array_of_name_ids) {[150, 150, 150, 150, 150, 150, 150]}
          it_behaves_like :successful_tree_name_ids_arr
        end

      end

    end







    describe '- on create' do

      context '- valid tree_row' do
        let(:tree_row) {FactoryGirl.build(:tree)}
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

        let(:bad_is_sex_wrong) {FactoryGirl.build(:tree, :is_sex_wrong)}
        it '- 10 Dont save: - bad_profile_non_integer - == 6 ' do

          expect(bad_is_sex_wrong).to_not be_valid
        end
      end

    end
  end

  describe '- Model Tree methods' do

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

    describe '#tree_amount *' do

      context '- get profiles_qty' do
        # let(:connected_users) {[current_user_id, other_user_id ]}
        # let(:log_connection_id) { SimilarsLog.current_tree_log_id(connected_users) }
        # it '- return proper log_connection_id for [current_user_id, other_user_id ]' do
        #   # puts "In current_tree_log_id:  current_user_id = #{current_user_id} "
        #   # puts "In current_tree_log_id:  log_connection_id = #{log_connection_id} "
        #   expect(log_connection_id).to eq(41)
        # end
      end

      context '- get tree_is_profiles' do
        # let(:connected_users) {[current_user_id, other_user_id ]}
        # let(:log_connection_id) { SimilarsLog.current_tree_log_id(connected_users) }
        # it '- return proper log_connection_id for [current_user_id, other_user_id ]' do
        #   # puts "In current_tree_log_id:  current_user_id = #{current_user_id} "
        #   # puts "In current_tree_log_id:  log_connection_id = #{log_connection_id} "
        #   expect(log_connection_id).to eq(41)
        # end
      end

    end

    describe '#get_connected_tree *' do

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
