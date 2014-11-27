require "rails_helper"

RSpec.describe WeafamSettingsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/weafam_settings").to route_to("weafam_settings#index")
    end

    it "routes to #new" do
      expect(:get => "/weafam_settings/new").to route_to("weafam_settings#new")
    end

    it "routes to #show" do
      expect(:get => "/weafam_settings/1").to route_to("weafam_settings#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/weafam_settings/1/edit").to route_to("weafam_settings#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/weafam_settings").to route_to("weafam_settings#create")
    end

    it "routes to #update" do
      expect(:put => "/weafam_settings/1").to route_to("weafam_settings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/weafam_settings/1").to route_to("weafam_settings#destroy", :id => "1")
    end

  end
end
