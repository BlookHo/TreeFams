require 'rails_helper'

RSpec.describe Counter, type: :model do   # , focus: true

  describe 'Model Counter Before methods validation test'   do # , focus: true
    after {
      Counter.delete_all
      Counter.reset_pk_sequence
    }

    it "has a valid factory" do
      puts " Model Counter validation - has a valid factory"
      expect(FactoryGirl.create(:counter)).to be_valid
    end

    it "is invalid without a invites" do
      puts " Model Counter validation - invalid without a invites"
      expect(FactoryGirl.build(:counter, invites: nil)).to_not be_valid
    end

    it "is invalid without a disconnects" do
      puts " Model Counter validation - invalid without a disconnects"
      expect(FactoryGirl.build(:counter, disconnects: nil)).to_not be_valid
    end

  end

end
