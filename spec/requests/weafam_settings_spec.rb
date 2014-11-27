require 'rails_helper'

RSpec.describe "WeafamSettings", :type => :request do
  describe "GET /weafam_settings" do
    it "works! (now write some real specs)" do
      get weafam_settings_path
      expect(response.status).to be(200)
    end
  end
end
