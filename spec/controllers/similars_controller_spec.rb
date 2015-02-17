

describe SimilarsController, type: :controller, similars: true do

  include SearchHelper

  let(:current_user) { create(:user) }



  describe 'GET #internal_similars_search' do

    subject { get :internal_similars_search }
    # subject { post :internal_similars_search }
    context '- after action - responds with 200 Ok status ' do
      it 'responds with 200' do
        expect(response.status).to eq(200)
      end
    end

    it "renders the internal_similars_search template" do
      # expect(subject).to render_template(:home)
 #     expect(subject).to redirect_to(home_url)
      # expect(subject).to render_template(:internal_similars_search)
      # expect(subject).to render_template("internal_similars_search")
      # expect(subject).to render_template("similars/internal_similars_search")
    end


    context '- after action - Bad' do
      it 'responds with 404'
    end


    # context "start_similars - show results" do
    #
    #   it "redirects to internal_similars_search" do
    #     expect(subject).to redirect_to(internal_similars_search_path)
    #   end
    # end






  end





end