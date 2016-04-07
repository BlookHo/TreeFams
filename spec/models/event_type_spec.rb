require 'rails_helper'

RSpec.describe EventType, type: :model do   # , focus: true

  describe '- validation' do
    describe '- on create' do

      context '- valid event_type' do
        let(:event_type_row) {FactoryGirl.build(:event_type)}  #
        it '- saves a valid event_type_row' do
          puts " Model EventType validation "
          expect(event_type_row).to be_valid
        end
      end
      context '- invalid event_type_row' do
        let(:bad_type_number) {FactoryGirl.build(:event_type, :type_uncorrect)}
        it '- 1 Dont save: - bad_type_number - more 26' do
          expect(bad_type_number).to_not be_valid
        end
        let(:bad_name) {FactoryGirl.build(:event_type, :uncorrect_name)}
        it '- 3 Dont save: - bad_name - not string' do
          expect(bad_name).to_not be_valid
        end
      end

    end
  end







end
