require 'rails_helper'

RSpec.describe ConnectedUser, :type => :model do

  describe '- Validation' do
    describe '- on create' do

      context '- valid connected_users' do
        let(:good_connected_users) {FactoryGirl.build(:connected_user, :correct)}
        it '- 1. Saves a valid good_connected_users pair' do
          puts " Model ConnectedUser validation "
          expect(good_connected_users).to be_valid
        end

        let(:good_connected_users_2) {FactoryGirl.build(:connected_user, :big_IDs)}
        it '- 2. Saves a valid connected_users pair - big IDs' do
          expect(good_connected_users_2).to be_valid
        end
      end

      context '- Invalid connected_users pairs' do
        let(:bad_connected_users_1) {FactoryGirl.build(:connected_user, :user_id_nil)}
        it '- 1. Does not save an invalid connected_users pair - user_id_nil' do
          expect(bad_connected_users_1).to_not be_valid
        end

        let(:bad_connected_users_2) {FactoryGirl.build(:connected_user, :ids_equal)}
        it '- 2. Does not save an invalid connected_users pair - equal Profile_IDs' do
          expect(bad_connected_users_2).to_not be_valid
        end

        let(:bad_connected_users_3) {FactoryGirl.build(:connected_user, :one_id_less_zero)}
        it '- 3. Does not save an invalid connected_users pair - one_id_less_zero' do
          expect(bad_connected_users_3).to_not be_valid
        end

        let(:bad_connected_users_4) {FactoryGirl.build(:connected_user, :other_id_less_zero)}
        it '- 4. Does not save an invalid connected_users pair - other_id_less_zero' do
          expect(bad_connected_users_4).to_not be_valid
        end

        let(:bad_connected_users_5) {FactoryGirl.build(:connected_user, :one_id_Uninteger)}
        it '- 5. Does not save an invalid connected_users pair - one_id_Uninteger' do
          expect(bad_connected_users_5).to_not be_valid
        end
      end

      context '- invalid connected_users rows' do

        let(:bad_profiles_fields_are_equal) {FactoryGirl.build(:connected_user, :bad_profiles_fields_eual)}
        it '- 1 Dont save: - bad_profiles_fields - equal' do
          expect(bad_profiles_fields_are_equal).to_not be_valid
        end

      end
    end

  end

end