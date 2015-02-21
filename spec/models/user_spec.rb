describe User do




  # before do
  #   @user = User.new( email: "new@nn.nn", password: '1111', profile_id:  1)
  #   @user.save
  #   @user_profile = @user.profile_id
  #
  #   @profile = Profile.new( user_id: @user_profile, profile_name: 45, relation_id: 2, display_name_id:  45)
  #   @profile.save
  # end

  describe '- validation' do
    before do
      @user = User.new( email: "new@nn.nn", password: '1111', profile_id:  1)
      @user.save
      @user_profile = @user.profile_id

      @profile = Profile.new( user_id: @user_profile, profile_name: 45, relation_id: 2, display_name_id:  45)
      @profile.save
    end



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

    after do
      User.delete_all
      User.reset_pk_sequence
    end

  end

  describe '- Check methods in User model' do
    describe '- Check method get_connected_users' do

      before do
        ConnectedUser.delete_all
        ConnectedUser.reset_pk_sequence
        FactoryGirl.create(:connected_user, )
        FactoryGirl.create(:connected_user, :connected_user_2)
        FactoryGirl.create(:connected_user, :connected_user_3)
        FactoryGirl.create(:connected_user, :connected_user_4)
        FactoryGirl.create(:connected_user, :connected_user_5)
        FactoryGirl.create(:connected_user, :connected_user_6)
        puts "before 1. connected_user = #{ConnectedUser.first.user_id} \n"
        puts "before 2. connected_user = #{ConnectedUser.find(2).user_id} \n"
        puts "before 3. connected_user = #{ConnectedUser.find(3).user_id} \n"
        puts "before 4. connected_user = #{ConnectedUser.find(4).user_id} \n"
        puts "before 5. connected_user = #{ConnectedUser.find(5).user_id} \n"
        puts "before 6. connected_user = #{ConnectedUser.find(6).user_id} \n"

      end
      let(:current_user) { create(:user) }
      let(:current_user_id) { current_user.id }
      let(:connected_users) { current_user.get_connected_users }

      context '- 1. after action: Check proper result of proper data type ' do
        it "- First Return proper Array Sorted result for current_user_id = 1" do
          puts " 1. After get_connected_users - current_user_id = #{current_user_id} \n"
          puts " 1. After get_connected_users - conn_users = #{connected_users} \n"
          expect(connected_users).to be_a_kind_of(Array)
          expect(connected_users).to eq([1,4,5])
        end
      end

      context '- 2. after action: Check proper result of proper data type ' do
        it "- Second Return proper Array Sorted result for current_user_id = 2" do
          puts " 2. After get_connected_users - current_user_id = #{current_user_id} \n"
          puts " 2. After get_connected_users - conn_users = #{connected_users} \n"
          expect(connected_users).to be_a_kind_of(Array)
          expect(connected_users).to eq([2,3,55,66])
        end
      end

      context '- 3. after action: Check proper result of proper data type ' do
        it "- Third Return proper Array Sorted result for current_user_id = 3" do
          puts " 3. After get_connected_users - current_user_id = #{current_user_id} \n"
          puts " 3. After get_connected_users - conn_users = #{connected_users} \n"
          expect(connected_users).to be_a_kind_of(Array)
          expect(connected_users).to eq([2,3,55,66])
        end
      end

      context '- 4. after action: Check proper result of proper data type ' do
        it "- Fourth Return proper Array Sorted result for current_user_id = 4" do
          puts " 4. After get_connected_users - current_user_id = #{current_user_id} \n"
          puts " 4. After get_connected_users - conn_users = #{connected_users} \n"
          expect(connected_users).to be_a_kind_of(Array)
          expect(connected_users).to eq([1,4,5])
        end
      end

      context '- 5. after action: Check proper result of proper data type ' do
        it "- Fifth Return UNproper Type result for current_user_id = 5" do
          puts " 5. After get_connected_users - current_user_id = #{current_user_id} \n"
          puts " 5. After get_connected_users - conn_users = #{connected_users} \n"
          expect(connected_users).to_not be_a_kind_of(Hash)
          expect(connected_users).to_not eq([1,5])
        end
      end

      context '- 6. after action: Check proper result of proper data type ' do
        it "- Sixth Return UNproper Array result for current_user_id = 6" do
          puts " 6. After get_connected_users - current_user_id = #{current_user_id} \n"
          puts " 6. After get_connected_users - conn_users = #{connected_users} \n"
          expect(connected_users).to be_a_kind_of(Array)
          expect(connected_users).to_not eq([1])
        end
      end

      context '- 7. after action: Check proper result of proper data type ' do
        it "- Seventh Return proper Array not_[] result for current_user_id = 7" do
          puts " 7. After get_connected_users - current_user_id = #{current_user_id} \n"
          puts " 7. After get_connected_users - conn_users = #{connected_users} \n"
          expect(connected_users).to be_a_kind_of(Array)
          expect(connected_users).to_not eq([])
        end
      end

      context '- after action: get_connected_users ' do
        # before {
        #   FactoryGirl.create(:connected_users, :sims_log_table_row_1, current_user_id: current_user_id)
        #
        # }

        # it "- receive [connected_users] for current_user" do
        #   puts "After get_connected_users - current_user_id = #{current_user_id} \n"
        #   # expect(response.status).to eq(200)
        # end

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
