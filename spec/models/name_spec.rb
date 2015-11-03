require 'rails_helper'

RSpec.describe Name, :type => :model  do # , focus: true

  describe 'Model Name Before methods validation test' , focus: true  do
    it "has a valid factory" do
      puts " Model Name validation - has a valid factory"
      expect(FactoryGirl.create(:test_model_name)).to be_valid
    end

    # it "is invalid without a name_id" do
    #   puts " Model Name validation - invalid without a name_id"
    #   expect(FactoryGirl.build(:test_model_name, name_id: nil)).to_not be_valid
    # end
    #
    # it "is invalid without a tree_id" do
    #   puts " Model Name validation - invalid without a tree_id"
    #   expect(FactoryGirl.build(:test_model_name, tree_id: nil)).to_not be_valid
    #  end



  end


end