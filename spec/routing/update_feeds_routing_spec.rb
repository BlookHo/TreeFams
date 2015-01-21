require "rails_helper"

RSpec.describe UpdateFeedsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/updates_feeds").to route_to("updates_feeds#index")
    end

    it "routes to #new" do
      expect(:get => "/updates_feeds/new").to route_to("updates_feeds#new")
    end

    it "routes to #show" do
      expect(:get => "/updates_feeds/1").to route_to("updates_feeds#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/updates_feeds/1/edit").to route_to("updates_feeds#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/updates_feeds").to route_to("updates_feeds#create")
    end

    it "routes to #update" do
      expect(:put => "/updates_feeds/1").to route_to("updates_feeds#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/updates_feeds/1").to route_to("updates_feeds#destroy", :id => "1")
    end

  end
end
