describe SimilarsController, :type => :controller , similars: true do

  describe 'GET #internal_similars_search' do

    let(:current_user) { create(:user) }  #
    let(:currentuser_id) {current_user.id} # 1

    before {
      allow(controller).to receive(:logged_in?)
      allow(controller).to receive(:current_user).and_return current_user
      puts "In before - currentuser_id = #{currentuser_id} \n"
      puts "In before - current_user.profile_id = #{current_user.profile_id} \n"

      FactoryGirl.create(:user, :user_2)  #
      FactoryGirl.create(:user, :user_3)  #
      FactoryGirl.create(:user, :user_4)  #
      puts "before All: User.last.id = #{User.last.id} \n"       # user_id = 1

      FactoryGirl.create(:connected_user, :correct)       # 1  2
      FactoryGirl.create(:connected_user, :correct_3_4)  # 3   4
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
      puts "before All: Tree.last.user_id = #{Tree.last.is_profile_id} \n"  # is_profile_id = 84
      puts "before All: Tree.count = #{Tree.all.count} \n" # 21

      # Profiles

      #Profile_Keys


    }

    after {
      User.delete_all
      User.reset_pk_sequence
      ConnectedUser.delete_all
      ConnectedUser.reset_pk_sequence
    }

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
      it "- log_connection_id, connected_users" do
        get :internal_similars_search
        puts "In check instances :  currentuser_id = #{currentuser_id} \n"
        puts "In check instances :  current_user.profile_id = #{current_user.profile_id} \n"
        expect(assigns(:log_connection_id)).to eq([])
        expect(assigns(:connected_users)).to eq([1,2])
        expect(assigns(:current_user_id)).to eq(1)
      end
    end




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
