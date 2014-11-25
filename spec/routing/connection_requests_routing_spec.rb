require "rails_helper"

RSpec.describe ConnectionRequestsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/connection_requests").to route_to("connection_requests#index")
    end

    it "routes to #new" do
      expect(:get => "/connection_requests/new").to route_to("connection_requests#new")
    end

    it "routes to #show" do
      expect(:get => "/connection_requests/1").to route_to("connection_requests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/connection_requests/1/edit").to route_to("connection_requests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/connection_requests").to route_to("connection_requests#create")
    end

    it "routes to #update" do
      expect(:put => "/connection_requests/1").to route_to("connection_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/connection_requests/1").to route_to("connection_requests#destroy", :id => "1")
    end

  end
end
