

describe SimilarsController, :type => :controller , similars: true do

 # include SearchHelper

  let(:current_user) { create(:user) }
  let(:current_user_id) {current_user.id}

  before {
    allow(controller).to receive(:logged_in?)
    allow(controller).to receive(:current_user).and_return current_user
  }

  describe 'GET #internal_similars_search' do

    describe 'Check response of #internal_similars_search' do

      subject { get :internal_similars_search
              puts "In subject after action - current_user_id = #{current_user_id} \n"
              puts "In subject - current_user.profile_id = #{current_user.profile_id} \n" }

      context '- after action - check response status' do
        it 'responds with 200' do
          puts "In GET after internal_similars_search - responds with 200:  current_user_id = #{current_user_id} \n"
          expect(response.status).to eq(200)
        end
      end

      context '- after action - responds with 200 Ok status ' do
        it 'no responds with 401' do
          expect(response.status).to_not eq(401)
        end
      end

      context '- after action - render/redirection ' do
        it "- render_template internal_similars_search" do
          expect(subject).to render_template :internal_similars_search
        end
      end

    end

    describe 'Check methods in #internal_similars_search' do

      context '- after action: get connected_users ' do
        before {
          # FactoryGirl.create(:connected_users, :sims_log_table_row_1, current_user_id: current_user_id)

        }

        it "- receive connected_users for current_user" do
          puts "In connected_users - current_user_id = #{current_user_id} \n"
          # expect(tree_info).to render_template :internal_similars_search

        end


      end

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

    end

  end


end