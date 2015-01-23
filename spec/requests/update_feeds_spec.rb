require 'rails_helper'

RSpec.describe "UpdateFeeds", :type => :request do
  describe "GET /updates_feeds" do
    it "works! (now write some real specs)" do
      get update_feeds_path
      expect(response.status).to be(200)
    end
  end
end
