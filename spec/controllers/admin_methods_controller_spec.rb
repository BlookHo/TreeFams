require 'spec_helper'

describe AdminMethodsController do

  describe "GET 'service_method_1'" do
    it "returns http success" do
      get 'service_method_1'
      response.should be_success
    end
  end

  describe "GET 'service_method_2'" do
    it "returns http success" do
      get 'service_method_2'
      response.should be_success
    end
  end

end
