describe User do
  describe 'validation' do
    describe 'on create' do
      context 'valid user' do
        let(:user) {FactoryGirl.build(:user)}

        it 'saves a valid user' do
          expect(user).to be_valid
        end
      end

      context 'invalid user' do
        let(:user) {FactoryGirl.build(:user, :wrong_email)}

        it 'does not save an invalid user' do
          # name = user.name
          # user.update_name
          # expect(name).to_not eq(user.name)
          expect(user).to_not be_valid
        end
      end
    end

    # describe 'on update' do
    #
    # end
  end


end
