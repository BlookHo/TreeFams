require 'rails_helper'

RSpec.describe SimilarsFound, :type => :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  describe '- Validation' do
    describe '- on create' do

      context '- valid similars pair' do

        let(:good_similars_found) {FactoryGirl.build(:similars_found)}
        it '- Saves a valid similars pair' do
          expect(good_similars_found).to be_valid
        end

        let(:good_similars_found_2) {FactoryGirl.build(:similars_found, :big_IDs)}
        it '- Saves a valid similars pair - big IDs' do
          expect(good_similars_found_2).to be_valid
        end
      end

      context '- Invalid similars pairs' do
        let(:bad_similars_found_1) {FactoryGirl.build(:similars_found, :user_id_nil)}
        it '- Does not save an invalid similars pair - user_id_nil' do
          expect(bad_similars_found_1).to_not be_valid
        end

        let(:bad_similars_found_2) {FactoryGirl.build(:similars_found, :ids_equal)}
        it '- Does not save an invalid similars pair - equal Profile_IDs' do
          expect(bad_similars_found_2).to_not be_valid
        end

        let(:bad_similars_found_3) {FactoryGirl.build(:similars_found, :one_id_less_zero)}
        it '- Does not save an invalid similars pair - one_id_less_zero' do
          expect(bad_similars_found_3).to_not be_valid
        end

        let(:bad_similars_found_4) {FactoryGirl.build(:similars_found, :other_id_less_zero)}
        it '- Does not save an invalid similars pair - other_id_less_zero' do
          expect(bad_similars_found_4).to_not be_valid
        end

        let(:bad_similars_found_5) {FactoryGirl.build(:similars_found, :one_id_Uninteger)}
        it '- Does not save an invalid similars pair - one_id_Uninteger' do
          expect(bad_similars_found_5).to_not be_valid
        end
      end

    end

  end


  describe '- Model methods' do
    #  pending "making test All SimilarsFound methods in #{__FILE__}"
    # create users
    let(:user) {FactoryGirl.create(:user)}
    let(:other_user) {FactoryGirl.create(:other_user)}
    let(:current_user_id) {user.id}
    let(:other_user_id) {other_user.id}

    # create parameters
    let(:sims_profiles_pairs) {[[38, 42], [41, 40]]}

    # from similars_start.rb#check_new_similars
    describe '* find_stored_similars *' do
      # todo: Use nested Factories here
      # let(:first_profile_id_1) {FactoryGirl.create(:profile_one)}   # id 38
      # let(:second_profile_id_1) {FactoryGirl.create(:profile_two)}   # id 42
      # let(:first_profile_id_2) {FactoryGirl.create(:profile_three)} # id 41
      # let(:second_profile_id_2) {FactoryGirl.create(:profile_four)}  # id 40
      # let(:sims_profiles_pairs) {[[:first_profile_id_1, :second_profile_id_1], [:first_profile_id_2, :second_profile_id_2]]}

      # create model data
      before do
        FactoryGirl.create(:similars_found, :sims_pair_1, user_id: current_user_id)
        FactoryGirl.create(:similars_found, :sims_pair_2, user_id: current_user_id)
        FactoryGirl.create(:similars_found, :sims_pair_3, user_id: other_user_id)
      end

      context '- Return Good data: ' do
        # verify data type
        context '- Return proper data type' do
          it '- Found an Array' do
            new_similars = SimilarsFound.find_stored_similars(sims_profiles_pairs, current_user_id)
            # puts "In find_stored_similars:  sims_profiles_pairs = #{sims_profiles_pairs} "
            # puts "In find_stored_similars:  new_similars = #{new_similars} "
            expect(new_similars).to be_a_kind_of(Array)
          end
        end

        # verify correctness new_similars
        # 1 user - y, profile1 - y, prof2 - y : => old sim => new_sim = []
        context '- Return correct new_similars' do
          it '- 1 Find new_similars = [] when sims_profiles_pairs are old' do
            new_similars = SimilarsFound.find_stored_similars(sims_profiles_pairs, current_user_id)
            expect(new_similars).to eq([])
          end
        end
        # 2 user - y, profile1 - n, prof2 - n : => new sim pairs - no records at all => all new sims_profiles_pairs
        context '- Return correct new_similars' do
          it '- 2 Find new_similars PAIRS when sims_profiles_pairs ARE new' do
            new_similars = SimilarsFound.find_stored_similars(sims_profiles_pairs, other_user_id)
            expect(new_similars).to eq([[38, 42],[41, 40]]) # all new similars
          end
        end
        # 3 user - y, profile1 - y, prof2 - n : => new sim pair => new_sim = one new sims_profiles_pair
        let(:sims_new_pair) {[[38, 42], [41, 400]]}
        context '- Return correct new_similars' do
          it '- 3 Find new_similars PAIR when sims_profiles_pair IS new' do
            new_similars = SimilarsFound.find_stored_similars(sims_new_pair, current_user_id)
            expect(new_similars).to eq([[41, 400]]) # only new similars
          end
        end
        # 4 user - y, profile1 - n, prof2 - n : => all new sim pairs => all sims_profiles_pairs
        let(:sims_all_new_pairs) {[[380, 42], [41, 400]]}
        context '- Return correct new_similars' do
          it '- 4 Find new_similars PAIRS when sims_profiles_pairs ARE new' do
            new_similars = SimilarsFound.find_stored_similars(sims_all_new_pairs, current_user_id)
            expect(new_similars).to eq([[380, 42],[41, 400]]) # all new similars
          end
        end
      end
    end

    # from similars_start.rb#check_new_similars
    describe '* store_similars *' do

      context '- Store Good sims_pairs ' do
        before do
          SimilarsFound.delete_all
          SimilarsFound.reset_pk_sequence
          SimilarsFound.store_similars(sims_profiles_pairs, current_user_id)
        end

        context '- Check sims_profiles_pairs to be stored' do
          it '- sims_profiles_pairs equals Ok - two pairs of profiles' do
            expect(sims_profiles_pairs).to eq([[38, 42], [41, 40]]) #
          end
        end

        context '- Check count rows stored' do
          let(:count) { SimilarsFound.all.count }
          it '- check count rows' do
            expect(count).to eq(2)
          end
        end

        context '- Check First row stored' do
          let(:first_row) { SimilarsFound.first }
          it '- user_id - Ok' do
            expect(first_row.user_id).to eq(user.id)
          end
          it '- first_profile_id - Ok' do
            expect(first_row.first_profile_id).to eq(38) #
          end
          it '- second_profile_id - Ok' do
            expect(first_row.second_profile_id).to eq(42) #
          end
        end

        context '- Check Second row stored' do
          let(:second_row) { SimilarsFound.second }
          it '- user_id - Ok' do
            expect(second_row.user_id).to eq(user.id)
          end
          it '- first_profile_id - Ok' do
            # puts "2 store_similars check: first_row.first_profile_id = #{first_row.first_profile_id.inspect} "
            expect(second_row.first_profile_id).to eq(41) #
          end
          it '- second_profile_id - Ok' do
            expect(second_row.second_profile_id).to eq(40) #
          end
        end
      end
    end

    # from similars_controller#internal_similars_search
    describe '* clear_tree_similars *' do
      pending "making test clear_tree_similars method in #{__FILE__}"
      # connected_users =>[5, 4] - input param


    end

    # from SimilarsConnection.rb#similars_connect_tree
    describe '* clear_similars_found *' do
      pending "making test clear_similars_found method in #{__FILE__}"
      # connection_data- input param
      # {:profiles_to_rewrite=>[41, 35, 42, 44, 52], :profiles_to_destroy=>[40, 39, 38, 43, 34],
      # :current_user_id=>5, :connection_id=>8, :connected_users_arr=>[5, 4], :table_name=>"profile_keys"}


    end

  end


end
