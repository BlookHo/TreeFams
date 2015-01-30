describe Profile do
  describe 'validation' do
    describe 'on create' do
      context 'valid profile' do
        let(:profile) {FactoryGirl.build(:profile)}

        it 'saves a valid profile' do
          expect(profile).to be_valid
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
