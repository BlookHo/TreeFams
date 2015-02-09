describe User do

  before(:all) do
    @user = User.new( email: "new@nn.nn", password: '1111', profile_id:  1)
    @user.save
    @user_profile = @user.profile_id

    @profile = Profile.new( user_id: @user_profile, profile_name: 45, relation_id: 2, display_name_id:  45)
    @profile.save
  end

  describe '- validation' do
    describe '- on create' do
      context '- when valid user' do
        let(:user) {FactoryGirl.build(:user)}
        it '- saves a valid user' do
          expect(user).to be_valid
        end
      end

      context '- when invalid user' do
        let(:user) {FactoryGirl.build(:user, :wrong_email)}
        it '- does not save an invalid user' do
          # name = user.name
          # user.update_name
          # expect(name).to_not eq(user.name)
          expect(user).to_not be_valid
        end
      end
    end

  end

  # describe 'on update' do
  #   context 'valid update profile_id field in user' do
  #     let(:user) {FactoryGirl.build(:good_user_profile)}
  #     let(:profile) {FactoryGirl.build(:profile)}
  #     it 'update profile_id in user' do
  #       expect(user).to be_valid
  #       prev_profile_id = user.profile_id
  #       profile_checked = Profile.first #find(prev_profile_id)
  #       new_id = 300
  #       profile_checked.user.update_attributes(:profile_id => new_id, :updated_at => Time.now)
  #       changed_profile_id = user.profile_id
  #       expect(changed_profile_id).to_not eq(prev_profile_id)
  #
  #     end
  #   end
  # end

  # after(:all) do
  #   # SimilarsLog.delete_all
  #   # SimilarsLog.reset_pk_sequence
  #   User.delete_all
  #   Profile.delete_all
  # end
  #


end
