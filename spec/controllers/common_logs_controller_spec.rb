require 'rails_helper'

RSpec.describe CommonLogsController, type: :controller do

  let(:current_user) { create(:user) }   # User = 1. Tree = 1. profile_id = 63
  let(:currentuser_id) {current_user.id}

  before {
    allow(controller).to receive(:logged_in?)
    allow(controller).to receive(:current_user).and_return current_user

    FactoryGirl.create(:user, :user_2)  # User = 2. Tree = 2. profile_id = 66
    # puts "before All: current_user.id = #{current_user.id} \n" # id = 1
    # puts "before All: User.last.id = #{User.last.id} \n" # id = 2
    # puts "before All: User.find(2).profile_id = #{User.find(2).profile_id} \n" # id = 2 profile_id = 66

    FactoryGirl.create(:connected_user, :correct)      # 1  2
    FactoryGirl.create(:connected_user, :correct_3_4)  # 3  4
    # puts "before All: ConnectedUser.count = #{ConnectedUser.all.count} \n" # 2 rows
  }

  after {
    User.delete_all
    User.reset_pk_sequence
    ConnectedUser.delete_all
    ConnectedUser.reset_pk_sequence
    Tree.delete_all
    Tree.reset_pk_sequence
    Profile.delete_all
    Profile.reset_pk_sequence
    Name.delete_all
    Name.reset_pk_sequence
  }

  describe 'CHECK CommonLogsController methods' do
    let(:connected_users) { current_user.get_connected_users }

    context '- before actions - check connected_users' do
      # let(:connected_users) { current_user.get_connected_users }
      it "- Return proper connected_users Array result for current_user_id = 1" do
        puts "Check CommonLogsController \n"
        puts "Before All - data created \n"  #
        # puts "In check connected_users :  connected_users = #{connected_users} \n"
        expect(connected_users).to be_a_kind_of(Array)
      end
      it "- Return proper connected_users Array result for current_user_id = 1" do
        # puts "1 2 In check connected_users :  connected_users = #{connected_users} \n"
        expect(connected_users).to eq([1,2])
      end
    end

    describe "GET #index" do
      context '- after action <index> - check render_template & response status' do
        subject { get :index }
        it "- render_template index" do
          puts "Check #index\n"
          # puts "In render_template :  currentuser_id = #{currentuser_id} \n"
          expect(subject).to render_template :index
        end
        it '- responds with 200' do
          expect(response.status).to eq(200)
        end
        it "returns http success" do
          expect(subject).to have_http_status(:success)
        end
        it '- no responds with 401' do
          # puts "In no responds with 401:  currentuser_id = #{currentuser_id} \n"
          expect(response.status).to_not eq(401)
        end
      end
    end

    # describe "GET #create" do
    #   it "returns http success" do
    #     get :create
    #     expect(response).to have_http_status(:success)
    #   end
    # end
    #
    # describe "GET #show" do
    #   it "returns http success" do
    #     get :show
    #     expect(response).to have_http_status(:success)
    #   end
    # end
    #
    # describe "GET #destroy" do
    #   it "returns http success" do
    #     get :destroy
    #     expect(response).to have_http_status(:success)
    #   end
    # end

  end


end
