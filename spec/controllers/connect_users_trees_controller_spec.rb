require 'spec_helper'

describe ConnectUsersTreesController do

  describe "GET 'connect_users'" do
    it "returns http success" do
      get 'connect_users'
      response.should be_success
    end
  end

  describe "GET 'connect_profiles'" do
    it "returns http success" do
      get 'connect_profiles'
      response.should be_success
    end
  end

  describe "GET 'connect_trees'" do
    it "returns http success" do
      get 'connect_trees'
      response.should be_success
    end
  end

  describe "GET 'connect_profiles_keys'" do
    it "returns http success" do
      get 'connect_profiles_keys'
      response.should be_success
    end
  end

end
