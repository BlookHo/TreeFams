

describe SimilarsController, :type => :controller , similars: true do

 # include SearchHelper

  let(:current_user) { create(:user) }

  before {
    allow(controller).to receive(:logged_in?)
    allow(controller).to receive(:current_user).and_return current_user
  }

  describe 'GET #internal_similars_search' do

    subject { get :internal_similars_search
              puts "In after action - current_user.id = #{current_user.id} \n"
              puts "In subject - current_user.profile_id = #{current_user.profile_id} \n" }
    context '- after action - responds with 200 Ok status ' do
      it 'responds with 200' do
        puts "In GET after action - responds with 200:  current_user.id = #{current_user.id} \n"
        expect(response.status).to eq(200)
      end
    end

    context '- after action - responds with 200 Ok status ' do
      it 'no responds with 401' do
        expect(response.status).to_not eq(401)
      end
    end

    context '- after action - render/redirection ' do

      #render_views
      # it "- redirect_to internal_similars_search " do
      #   expect(response.status).to be_success
      #   expect(subject).to redirect_to :action => :internal_similars_search #
      # end

      it "- render_template internal_similars_search" do
        expect(subject).to render_template :internal_similars_search
      end

    end

  end

  # describe 'POST #internal_similars_search' do
  #   subject { post :internal_similars_search }
  #   context '- after action - redirects to ' do
  #     expect(subject).to redirect_to :action => :internal_similars_search
  #   end
  #
  # end
  #



end