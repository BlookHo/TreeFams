require 'rails_helper'

# describe Profile do

RSpec.describe Profile, :type => :model do

  describe '- validation' do
    describe '- on create' do
      # context '- valid profiles' do
      #   let(:first_profile) {FactoryGirl.build(:profile_one)}  # id 38
      #   it '- 1 saves a valid profile_one' do
      #     puts " Model Profile validation "
      #     expect(first_profile).to be_valid
      #   end
      #
      #   let(:second_profile) {FactoryGirl.build(:profile_two)}  # id 42
      #   it '- 2 saves a valid profile_two' do
      #     expect(second_profile).to be_valid
      #   end
      #
      #   let(:first_profile_2) {FactoryGirl.build(:profile_three)} # id 41
      #   it '- 3 saves a valid profile_three' do
      #     expect(first_profile_2).to be_valid
      #   end
      #
      #   let(:second_profile_2) {FactoryGirl.build(:profile_four)}  # id 40
      #   it '- 4 saves a valid profile_four' do
      #     expect(second_profile_2).to be_valid
      #   end
      #
      #   let(:good_profile_row_big) {FactoryGirl.build(:profile_one, :big_IDs)}
      #   it '- 5 Saves a valid profile_row - big IDs' do
      #     expect(good_profile_row_big).to be_valid
      #   end
      #
      #   let(:good_profile_row_no_user_id) {FactoryGirl.build(:profile_one, :without_user_id)}
      #   it '- 5 Saves a valid profile_row - no_user_id' do
      #     expect(good_profile_row_no_user_id).to be_valid
      #   end
      #
      # end
      # before {
      #   #Name - for profile = 85
      #   FactoryGirl.create(:name, :name_370)   # Петр
      #   puts "before All in Profile valid-s: Name.first.name = #{Name.first.name} \n"  # Алексей
      # }
      # let(:base_profile_85) { create(:add_profile, :add_profile_85) }  # User = 9. Tree = 9. profile_id = 85
      #
      # context '- check profile creation' do
      #   it 'creation profile - Ok' do
      #     puts "before All: base_profile_85.id = #{base_profile_85.id} \n"  # id =
      #     expect(base_profile_85).to be_valid
      #   end
      # end


    end

  end
end
