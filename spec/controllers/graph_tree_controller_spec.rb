require 'spec_helper'

describe GraphTreeController do

  describe "GET 'show_graph_tree'" do
    it "returns http success" do
      get 'show_graph_tree'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit'
      response.should be_success
    end
  end

  describe "GET 'move'" do
    it "returns http success" do
      get 'move'
      response.should be_success
    end
  end

end
