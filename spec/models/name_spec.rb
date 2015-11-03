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
    context "In Name: test for correct values pair: name_id.sex_id & profile.sex_id " do
      let(:row) {FactoryGirl.create(:test_model_name)}
      it "is invalid with name_id.sex_id == 1 and profile.sex_id == 0" do
        # puts " Model Profile validation - invalid with name_id.sex_id == 1 and profile.sex_id == 0"
        puts " Model Name validation - name.id = #{row.id}"
        puts " Model Name validation - name.name = #{row.name}"
        # puts " Model Name validation - name.only_male = #{row.only_male}"
        # puts " Model Name validation - name.name_freq = #{row.name_freq}"
        # puts " Model Name validation - name.is_approved = #{row.is_approved}"
        puts " Model Name validation - name.sex_id = #{row.sex_id}"
      end

    end



  end


end