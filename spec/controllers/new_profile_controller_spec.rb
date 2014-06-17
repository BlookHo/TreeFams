require 'spec_helper'

describe NewProfileController do

  describe "GET 'get_profile_params'" do
    it "returns http success" do
      get 'get_profile_params'
      response.should be_success
    end
  end

  describe "GET 'make_new_profile'" do
    it "returns http success" do
      get 'make_new_profile'
      response.should be_success
    end
  end

  describe "GET 'make_tree_row'" do
    it "returns http success" do
      get 'make_tree_row'
      response.should be_success
    end
  end

  describe "GET 'make_profilekeys_rows'" do
    it "returns http success" do
      get 'make_profilekeys_rows'
      response.should be_success
    end
  end

end
