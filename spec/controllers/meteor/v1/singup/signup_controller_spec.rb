require 'rails_helper'
describe Meteor::V1::Signup::SignupController, :type => :controller do

  @@endpoint = "/meteor/v1/signup/create.json"

  @@valid_author_params = '{"author":{"name":"Алексей", "sex_id":1, "id":29, "search_name_id":29, "parent_name":nil, "email":"me@me.ru"}}'


  describe '/meteor/v1/signup/create' do

      subject { post :create }

      it "Should return json error when post without params" do
        json = { format: 'json', data: {}}
        post :create, json
        expected_response = '{"error":"Invalid params","path":"/meteor/v1/signup/create.json"}'
        expect(response.body).to eq(expected_response)
      end

      it "Should return ok status when post vaid params" do
        json = { format: 'json', family: @@valid_author_params}
        post :create, json
        expected_response = '{"status":"ok"}'
        expect(response.body).to eq(expected_response)
      end

  end
end
