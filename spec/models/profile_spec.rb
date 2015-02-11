describe Profile do
  describe '- validation' do
    describe '- on create' do
      context '- valid profiles' do
        let(:first_profile) {FactoryGirl.build(:profile_one)}  # id 38
        it '- saves a valid profile_one' do
          expect(first_profile).to be_valid
        end

        let(:second_profile) {FactoryGirl.build(:profile_two)}  # id 42
        it '- saves a valid profile_two' do
          expect(second_profile).to be_valid
        end

        let(:first_profile_2) {FactoryGirl.build(:profile_three)} # id 41
        it '- saves a valid profile_three' do
          expect(first_profile_2).to be_valid
        end

        let(:second_profile_2) {FactoryGirl.build(:profile_four)}  # id 40
        it '- saves a valid profile_four' do
          expect(second_profile_2).to be_valid
        end

      end

      # context 'invalid profile' do
      #   let(:profile) {FactoryGirl.build(:profile, :wrong_email)}
      #
      #   it 'does not save an invalid profile' do
      #     # name = user.name
      #     # user.update_name
      #     # expect(name).to_not eq(user.name)
      #     expect(profile).to_not be_valid
      #   end
      # end


    end

  end
end
