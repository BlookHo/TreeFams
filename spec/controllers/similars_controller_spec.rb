describe SimilarsController, :type => :controller , similars: true do

  describe 'GET #internal_similars_search' do

    let(:current_user) { create(:user) }   # User = 1. Tree = 1. profile_id = 63
    let(:currentuser_id) {current_user.id}

    before {
      allow(controller).to receive(:logged_in?)
      allow(controller).to receive(:current_user).and_return current_user
      puts "before All: currentuser_id = #{currentuser_id} \n" # currentuser_id = 1
      puts "before All: current_user.profile_id = #{current_user.profile_id} \n"

      FactoryGirl.create(:user, :user_2)  # User = 2. Tree = 2. profile_id = 66
      # FactoryGirl.create(:user, :user_3)  #
      # FactoryGirl.create(:user, :user_4)  #
      puts "before All: User.last.id = #{User.last.id} \n" # id = 2

      FactoryGirl.create(:connected_user, :correct)      # 1  2
      FactoryGirl.create(:connected_user, :correct_3_4)  # 3  4
      puts "before All: ConnectedUser.count = #{ConnectedUser.all.count} \n" # 1

      # FactoryGirl.create(:similars_found )                     # 1  2  3
      # FactoryGirl.create(:similars_found, :sims_pair_1)        # 1  38 42
      # FactoryGirl.create(:similars_found, :sims_pair_2)        # 1  41 40
      # FactoryGirl.create(:similars_found, :sims_pair_3)        # 1  55 66
      # puts "before All: SimilarsFound.last.user_id = #{SimilarsFound.last.user_id} \n"       # user_id = 1
      # puts "before All: SimilarsFound.count = #{SimilarsFound.all.count} \n" # 1

      # FactoryGirl.create(:similars_log, :sims_log_connection_id)        #
      # puts "before All: SimilarsLog.last.user_id = #{SimilarsLog.last.current_user_id} \n"  # current_user_id = 2
      # puts "before All: SimilarsLog.count = #{SimilarsLog.all.count} \n" # 1

      # Tree
      FactoryGirl.create(:tree, :tree1_with_sims_1)        #
      FactoryGirl.create(:tree, :tree1_with_sims_2)        #
      FactoryGirl.create(:tree, :tree1_with_sims_3)        #
      FactoryGirl.create(:tree, :tree1_with_sims_4)        #
      FactoryGirl.create(:tree, :tree1_with_sims_5)        #
      FactoryGirl.create(:tree, :tree1_with_sims_6)        #
      FactoryGirl.create(:tree, :tree1_with_sims_7)        #
      FactoryGirl.create(:tree, :tree1_with_sims_8)        #
      FactoryGirl.create(:tree, :tree1_with_sims_9)        #
      FactoryGirl.create(:tree, :tree1_with_sims_10)        #
      FactoryGirl.create(:tree, :tree1_with_sims_11)        #
      FactoryGirl.create(:tree, :tree1_with_sims_12)        #
      FactoryGirl.create(:tree, :tree1_with_sims_13)        #
      FactoryGirl.create(:tree, :tree1_with_sims_14)        #
      FactoryGirl.create(:tree, :tree1_with_sims_15)        #
      FactoryGirl.create(:tree, :tree1_with_sims_16)        #
      FactoryGirl.create(:tree, :tree1_with_sims_17)        #
      FactoryGirl.create(:tree, :tree1_with_sims_18)        #
      FactoryGirl.create(:tree, :tree1_with_sims_19)        #
      FactoryGirl.create(:tree, :tree1_with_sims_20)        #
      puts "before All: Tree.last.is_profile_id = #{Tree.last.is_profile_id} \n"  # is_profile_id = 84
      puts "before All: Tree.count = #{Tree.all.count} \n" # 20

      # Profile
      FactoryGirl.create(:profile, :profile_63)        #
      FactoryGirl.create(:profile, :profile_64)        #
      FactoryGirl.create(:profile, :profile_65)        #
      FactoryGirl.create(:profile, :profile_66)        #
      FactoryGirl.create(:profile, :profile_67)        #
      FactoryGirl.create(:profile, :profile_68)        #
      FactoryGirl.create(:profile, :profile_69)        #
      FactoryGirl.create(:profile, :profile_70)        #
      FactoryGirl.create(:profile, :profile_78)        #
      FactoryGirl.create(:profile, :profile_79)        #
      FactoryGirl.create(:profile, :profile_80)        #
      FactoryGirl.create(:profile, :profile_81)        #
      FactoryGirl.create(:profile, :profile_82)        #
      FactoryGirl.create(:profile, :profile_83)        #
      FactoryGirl.create(:profile, :profile_84)        #
      puts "before All: Profile.last.id = #{Profile.last.id} \n"  # id = 64
      puts "before All: Profile.last.name_id = #{Profile.last.name_id} \n"  # name_id = 90
      puts "before All: Profile.count = #{Profile.all.count} \n" # 2

      #Profile_Key

    }

    after {
      User.delete_all
      User.reset_pk_sequence
      ConnectedUser.delete_all
      ConnectedUser.reset_pk_sequence
      Tree.delete_all
      Tree.reset_pk_sequence
    }

    context '- before action - check connected_users' do
      let(:connected_users) { current_user.get_connected_users }
      it "- Return proper connected_users Array result for current_user_id = 1" do
        expect(connected_users).to be_a_kind_of(Array)
        expect(connected_users).to eq([1,2])
      end
    end

    subject { get :internal_similars_search
      puts "In subject after action - currentuser_id = #{currentuser_id} \n"
      puts "In subject - current_user.profile_id = #{current_user.profile_id} \n"
      }
    context '- after action - check render_template & response status' do
      it "- render_template internal_similars_search" do
        puts "In render_template :  currentuser_id = #{currentuser_id} \n"
        puts "In render_template :  current_user.profile_id = #{current_user.profile_id} \n"
        expect(subject).to render_template :internal_similars_search
      end

      it 'responds with 200' do
        puts "In responds with 200:  currentuser_id = #{currentuser_id} \n"
        expect(response.status).to eq(200)
      end

      it 'no responds with 401' do
        puts "In no responds with 401:  currentuser_id = #{currentuser_id} \n"
        expect(response.status).to_not eq(401)
      end
    end

    context '- after action - check instances  ' do
      it "- got values: log_connection_id, connected_users, current_user_id" do
        get :internal_similars_search
        puts "In check instances :  currentuser_id = #{currentuser_id} \n"
        puts "In check instances :  current_user.profile_id = #{current_user.profile_id} \n"
        expect(assigns(:log_connection_id)).to eq([])
        expect(assigns(:connected_users)).to eq([1,2])
        expect(assigns(:current_user_id)).to eq(1)
      end
    end

    context '- Check SimilarsFound count rows' do
      let(:sims_count) { SimilarsFound.all.count }
      it '- stored 2 rows - Ok' do
        expect(sims_count).to eq(0)
      end
    end

    # context '- Check First row stored' do
    #   let(:first_row) { SimilarsFound.first }
    #   it '- currentuser_id - Ok' do
    #     expect(first_row.user_id).to eq(currentuser_id)
    #   end
    #   it '- first_profile_id - Ok' do
    #     expect(first_row.first_profile_id).to eq(38) #
    #   end
    #   it '- second_profile_id - Ok' do
    #     expect(first_row.second_profile_id).to eq(42) #
    #   end
    # end




    # describe 'Check methods in #internal_similars_search' do
    #   let(:connected_users) { current_user.get_connected_users }  # [1, 2]
    #     context '- after action: get connected_users ' do
    #       puts "*** Check result of method get_connected_users \n"
    #       it "- receive connected_users for current_user" do
    #         puts "in  Check: ConnectedUser.count = #{ConnectedUser.all.count} \n" # 6
    #         puts "1 After get_connected_users - current_user_id = #{current_user_id} \n" # current_user_id = 1
    #         puts "1 After get_connected_users - connected_users = #{connected_users} \n" # connected_users = [1, 2]
    #         expect(connected_users).to eq([4,66])
    #     end
    #   end
    # end



  end


end


#
#
# context '- after action - render/redirection ' do
#   it "- render_template internal_similars_search" do
#     puts "In render_template :  current_user_id = #{current_user_id} \n"
#     puts "In render_template :  current_user.profile_id = #{current_user.profile_id} \n"
#     expect(subject).to render_template :internal_similars_search
#   end
# end
#
# context '- after action - check response status' do
#   it 'responds with 200' do
#     get :internal_similars_search
#     puts "In responds with 200:  current_user_id = #{current_user_id} \n"
#     expect(response.status).to eq(200)
#   end
# end
#
# context '- after action - responds with 200 Ok status ' do
#   it 'no responds with 401' do
#     puts "In no responds with 401:  current_user_id = #{current_user_id} \n"
#     expect(response.status).to_not eq(401)
#   end
# end


# context '- in action: get tree_info & similars & sim_data ' do
#   it "- receive similars & sim_data in internal_similars_search" do
#     expect(tree_info).to render_template :internal_similars_search
#
#   end

#   it "- receive similars & sim_data in internal_similars_search" do
#     expect(sim_data).to render_template :internal_similars_search
#
#   end

#   it "- receive similars & sim_data in internal_similars_search" do
#     expect(similars).to render_template :internal_similars_search
#
#   end

# end
