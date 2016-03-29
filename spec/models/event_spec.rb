require 'rails_helper'

RSpec.describe Event, type: :model do

  describe '- validation' do
    describe '- on create' do

      context '- valid Faker event' do
        let(:event_row) {FactoryGirl.build(:event)}  #
        it '- saves a valid Faker event_row' do
          puts " Model Faker Event validation "
          expect(event_row).to be_valid
        end
      end
      context '- valid event one row' do
        let(:event_row) {FactoryGirl.build(:event_common)}  #
        it '- saves a valid event_row' do
          puts " Model Event validation "
          expect(event_row).to be_valid
        end
      end
      context '- invalid event_type_row' do
        let(:bad_type_number) {FactoryGirl.build(:event_common, :type_uncorrect)}
        it '- 1 Dont save: - bad_type_number - more 26' do
          expect(bad_type_number).to_not be_valid
        end
        let(:bad_profile_id) {FactoryGirl.build(:event_common, :profile_id_uncorrect)}
        it '- 2 Dont save: - bad profile_id - == 0' do
          expect(bad_profile_id).to_not be_valid
        end
        let(:bad_agent_user_id) {FactoryGirl.build(:event_common, :agent_user_id_uncorrect)}
        it '- 3 Dont save: - bad agent_user_id - == 0' do
          expect(bad_agent_user_id).to_not be_valid
        end
      end

    end

  end







end
