require 'rails_helper'

RSpec.describe WeafamStat, type: :model  do
  describe 'Model WeafamStat Before methods validation test'   do # , focus: true
    after {
      WeafamStat.delete_all
      WeafamStat.reset_pk_sequence
    }

    it "has a valid factory" do
      puts " Model WeafamStat validation - has a valid factory"
      expect(FactoryGirl.create(:weafam_stat)).to be_valid
    end

    it "is invalid without a users" do
      puts " Model WeafamStat validation - invalid without a users"
      expect(FactoryGirl.build(:weafam_stat, users: nil)).to_not be_valid
    end

    it "is invalid without a users_male" do
      puts " Model WeafamStat validation - invalid without a users_male"
      expect(FactoryGirl.build(:weafam_stat, users_male: nil)).to_not be_valid
    end

    it "is invalid without a users_female" do
      puts " Model WeafamStat validation - invalid without a users_female"
      expect(FactoryGirl.build(:weafam_stat, users_female: nil)).to_not be_valid
    end

    it "is invalid without a profiles" do
      puts " Model WeafamStat validation - invalid without a profiles"
      expect(FactoryGirl.build(:weafam_stat, profiles: nil)).to_not be_valid
    end

    it "is invalid without a profiles_male" do
      puts " Model WeafamStat validation - invalid without a profiles_male"
      expect(FactoryGirl.build(:weafam_stat, profiles_male: nil)).to_not be_valid
    end

    it "is invalid without a profiles_female" do
      puts " Model WeafamStat validation - invalid without a profiles_female"
      expect(FactoryGirl.build(:weafam_stat, profiles_female: nil)).to_not be_valid
    end

    it "is invalid without a trees" do
      puts " Model WeafamStat validation - invalid without a trees"
      expect(FactoryGirl.build(:weafam_stat, trees: nil)).to_not be_valid
    end


  end
end
