require 'rails_helper'

RSpec.describe "ConnectionRequests", :type => :request do
  describe "GET /connection_requests" do
    it "works! (now write some real specs)" do
      get connection_requests_path
      expect(response.status).to be(200)
    end
  end
end
