require 'rails_helper'

RSpec.describe CommonLog, type: :model do
 # pending "add some examples to (or delete) #{__FILE__}"

  describe '- validation' do
    describe '- on create' do

      context '- valid common_log_row' do
        let(:common_log_row) {FactoryGirl.build(:common_log)}  #
        it '- saves a valid common_log_row' do
          puts " Model LogType validation "
          expect(common_log_row).to be_valid
        end
      end

      context '- invalid log_type_number' do
        let(:bad_type_number) {FactoryGirl.build(:common_log, :uncorrect_type)}
        it '- 1 Dont save: - bad_type_number - out of range' do
          expect(bad_type_number).to_not be_valid
        end

        let(:bad_user) {FactoryGirl.build(:common_log, :uncorrect_user)}
        it '- 2 Dont save: - bad_user - uninteger' do
          expect(bad_user).to_not be_valid
        end 

        let(:bad_uncorrect_log_id) {FactoryGirl.build(:common_log, :uncorrect_log_id)}
        it '- 3 Dont save: - bad_log_id - uninteger' do
          expect(bad_uncorrect_log_id).to_not be_valid
        end

        let(:bad_uncorrect_profile) {FactoryGirl.build(:common_log, :uncorrect_profile)}
        it '- 4 Dont save: - bad_log_id - uninteger' do
          expect(bad_uncorrect_profile).to_not be_valid
        end
      end

    end
  end






end
