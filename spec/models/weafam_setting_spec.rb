require 'rails_helper'

RSpec.describe WeafamSetting, type: :model do   # , focus: true

  describe 'Model Counter Before methods validation test'   do # , focus: true
    after {
      WeafamSetting.delete_all
      WeafamSetting.reset_pk_sequence
    }

    it "has a valid factory" do
      puts " Model WeafamSetting validation - has a valid factory"
      expect(FactoryGirl.create(:weafam_setting)).to be_valid
    end

    it "is invalid without a certain_koeff" do
      puts " Model WeafamSetting validation - invalid without a certain_koeff"
      expect(FactoryGirl.build(:weafam_setting, certain_koeff: nil)).to_not be_valid
    end

    it "is invalid with certain_koeff = 0" do
      puts " Model WeafamSetting validation - invalid with certain_koeff = 0"
      expect(FactoryGirl.build(:weafam_setting, certain_koeff: 0)).to_not be_valid
    end

    it "is invalid with certain_koeff > 9" do
      puts " Model WeafamSetting validation - invalid with certain_koeff > 9"
      expect(FactoryGirl.build(:weafam_setting, certain_koeff: 10)).to_not be_valid
    end

  end

end
