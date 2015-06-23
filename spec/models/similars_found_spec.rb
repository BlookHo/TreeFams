require 'rails_helper'

RSpec.describe SimilarsFound, :type => :model  do  # , focus: true
  #pending "add some examples to (or delete) #{__FILE__}"

  describe '- Validation' do
    describe '- on create' do

      context '- valid similars pair' do

        let(:good_similars_found) {FactoryGirl.build(:similars_found)}
        it '- Saves a valid similars pair' do
          puts " Model SimilarsFound validation "
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

    # create users
    let(:user) {FactoryGirl.create(:user)}
    let(:other_user) {FactoryGirl.create(:user, :user_2)}
    let(:third_user) {FactoryGirl.create(:third_user)}
    let(:current_user_id) {user.id}
    let(:other_user_id) {other_user.id}
    let(:third_user_id) {third_user.id}
    let(:connected_users) {[current_user_id, other_user_id ]}

    # create parameters
    let(:sims_profiles_pairs) {[[81, 70],[79, 82]]}

    # create model data
    before do
      FactoryGirl.create(:similars_found, :sims_pair_1, user_id: current_user_id)
      FactoryGirl.create(:similars_found, :sims_pair_2, user_id: current_user_id)
      FactoryGirl.create(:similars_found, :sims_pair_3, user_id: other_user_id)
      FactoryGirl.create(:similars_found, :sims_pair_4, user_id: third_user_id)
      # puts " before  SimilarsFound: SimilarsFound.first.user_id = #{SimilarsFound.first.user_id.inspect} "
    end

    # after {
    #   SimilarsFound.delete_all
    #   SimilarsFound.reset_pk_sequence
    #  }

    # from similars_start.rb#check_new_similars
    describe '* find_stored_similars *' do
      # todo: Use nested Factories here

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
            expect(new_similars).to eq([[81, 70],[79, 82]]) # all new similars
          end
        end
        # 3 user - y, profile1 - y, prof2 - n : => new sim pair => new_sim = one new sims_profiles_pair
        let(:sims_new_pair) {[[81, 70],[79,  400]]}
        context '- Return correct new_similars' do
          it '- 3 Find new_similars PAIR when sims_profiles_pair IS new' do
            new_similars = SimilarsFound.find_stored_similars(sims_new_pair, current_user_id)
            expect(new_similars).to eq([[79, 400]]) # only new similars
          end
        end
        # 4 user - y, profile1 - n, prof2 - n : => all new sim pairs => all sims_profiles_pairs
        let(:sims_all_new_pairs) {[[380, 70], [79, 400]]}
        context '- Return correct new_similars' do
          it '- 4 Find new_similars PAIRS when sims_profiles_pairs ARE new' do
            new_similars = SimilarsFound.find_stored_similars(sims_all_new_pairs, current_user_id)
            expect(new_similars).to eq([[380, 70],[79, 400]]) # all new similars
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
            expect(sims_profiles_pairs).to eq([[81, 70],[79, 82]]) #
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
            expect(first_row.first_profile_id).to eq(81) #
          end
          it '- second_profile_id - Ok' do
            expect(first_row.second_profile_id).to eq(70) #
          end
        end

        context '- Check Second row stored' do
          let(:second_row) { SimilarsFound.second }
          it '- user_id - Ok' do
            expect(second_row.user_id).to eq(user.id)
          end
          it '- first_profile_id - Ok' do
            # puts "2 store_similars check: second_row.first_profile_id = #{second_row.first_profile_id.inspect} "
            expect(second_row.first_profile_id).to eq(79) #
          end
          it '- second_profile_id - Ok' do
            expect(second_row.second_profile_id).to eq(82) #
          end
        end
      end
    end

    # from similars_controller#internal_similars_search
    describe '* clear_tree_similars *' do
      before do
        # puts " clear_tree_similars check: SimilarsFound.first.user_id = #{SimilarsFound.first.user_id.inspect} "
        # puts " clear_tree_similars check: SimilarsFound.first.first_profile_id = #{SimilarsFound.first.first_profile_id.inspect} "
        SimilarsFound.clear_tree_similars(connected_users)
        # puts " clear_tree_similars check: connected_users = #{connected_users.inspect} "
        # puts " clear_tree_similars check: current_user_id = #{current_user_id.inspect} "
        # puts " clear_tree_similars check: other_user_id = #{other_user_id.inspect} "

      end
      context '- clear tree similars' do
        let(:rest_count) { SimilarsFound.all.count }
        it '- after clear_tree_similars check count of rest rows' do
          expect(rest_count).to eq(1)
        end
      end
    end

    # from SimilarsConnection.rb#similars_connect_tree
    describe '* clear_similars_found *' do
      let(:data_to_clear) { {:profiles_to_rewrite => [79, 35, 70, 66], :profiles_to_destroy=>[82, 81, 98, 55],
                             :connected_users_arr => connected_users } }
      before do
        # puts " start: connected_users_arr = #{data_to_clear[:connected_users_arr].inspect} "
        # puts " start: connected_users = #{connected_users.inspect} "
        # puts " clear_similars_found check: count = #{SimilarsFound.all.count.inspect} "
        # puts " clear_similars_found check: 1 = #{SimilarsFound.first.inspect} "
        # puts " clear_similars_found check: 4 = #{SimilarsFound.fourth.inspect} "
        SimilarsFound.clear_similars_found(data_to_clear)
      end
      context '- after clear_similars_found' do
        let(:rest_count) { SimilarsFound.all.count }
        it '- check count of rest rows' do
          expect(rest_count).to eq(1)
        end
      end

    end

  end

  # pending "making test clear_similars_found method in #{__FILE__}"

end
