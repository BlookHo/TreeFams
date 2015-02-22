describe SimilarsController, :type => :controller , similars: true do

  describe 'GET #internal_similars_search' do

    let(:current_user) { create(:user) }  #
    let(:current_user_id) {current_user.id} # 1

    before {
      allow(controller).to receive(:logged_in?)
      allow(controller).to receive(:current_user).and_return current_user
      puts "In before - current_user_id = #{current_user_id} \n"
      puts "In before - current_user.profile_id = #{current_user.profile_id} \n"

      FactoryGirl.create(:user, :user_2)  #
      FactoryGirl.create(:user, :user_3)  #
      FactoryGirl.create(:user, :user_4)  #
      puts "before All: User.last.id = #{User.last.id} \n"       # user_id = 1

      FactoryGirl.create(:connected_user, :correct)       # 1  2
      FactoryGirl.create(:connected_user, :correct_3_4)  # 3   4
      puts "before All: ConnectedUser.count = #{ConnectedUser.all.count} \n" # 1

      FactoryGirl.create(:similars_found )                     # 1  2  3
      FactoryGirl.create(:similars_found, :sims_pair_1)        # 1  38 42
      FactoryGirl.create(:similars_found, :sims_pair_2)        # 1  41 40
      FactoryGirl.create(:similars_found, :sims_pair_3)        # 1  55 66
      puts "before All: SimilarsFound.last.user_id = #{SimilarsFound.last.user_id} \n"       # user_id = 1
      puts "before All: SimilarsFound.count = #{SimilarsFound.all.count} \n" # 1

      FactoryGirl.create(:similars_log, :sims_log_connection_id)        #
      puts "before All: SimilarsLog.last.user_id = #{SimilarsLog.last.current_user_id} \n"  # current_user_id = 2
      puts "before All: SimilarsLog.count = #{SimilarsLog.all.count} \n" # 1

    }

    after {
      User.delete_all
      User.reset_pk_sequence
      ConnectedUser.delete_all
      ConnectedUser.reset_pk_sequence
    }

    subject { get :internal_similars_search
    puts "In subject after action - current_user_id = #{current_user_id} \n"
    puts "In subject - current_user.profile_id = #{current_user.profile_id} \n"
    }

    context '- after action - check render_template ' do
      it "- render_template internal_similars_search" do
        subject { get :internal_similars_search }
        puts "In render_template :  current_user_id = #{current_user_id} \n"
        puts "In render_template :  current_user.profile_id = #{current_user.profile_id} \n"
        expect(subject).to render_template :internal_similars_search
      end
    end

    context '- after action - check instances  ' do
      it "- log_connection_id, connected_users" do
        get :internal_similars_search
        puts "In check instances :  current_user_id = #{current_user_id} \n"
        puts "In check instances :  current_user.profile_id = #{current_user.profile_id} \n"
        expect(assigns(:log_connection_id)).to eq(77)
        expect(assigns(:connected_users)).to eq([1,2])
      end
    end

    context '- after action - check response status' do
      it 'responds with 200' do
        get :internal_similars_search
        puts "In responds with 200:  current_user_id = #{current_user_id} \n"
        expect(response.status).to eq(200)
      end
    end

    context '- after action - responds with 200 Ok status ' do
      it 'no responds with 401' do
        puts "In no responds with 401:  current_user_id = #{current_user_id} \n"
        expect(response.status).to_not eq(401)
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
