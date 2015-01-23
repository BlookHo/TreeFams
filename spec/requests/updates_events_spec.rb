require 'rails_helper'

RSpec.describe "UpdatesEvents", :type => :request do
  describe "GET /updates_events" do
    it "works! (now write some real specs)" do
      get updates_events_path
      expect(response.status).to be(200)
    end
  end
end
