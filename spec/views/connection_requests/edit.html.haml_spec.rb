require 'rails_helper'

RSpec.describe "connection_requests/edit", :type => :view do
  before(:each) do
    @connection_request = assign(:connection_request, ConnectionRequest.create!(
      :user_id => 1,
      :with_user_id => 1,
      :confirm => 1,
      :done => false
    ))
  end

  it "renders the edit connection_request form" do
    render

    assert_select "form[action=?][method=?]", connection_request_path(@connection_request), "post" do

      assert_select "input#connection_request_user_id[name=?]", "connection_request[user_id]"

      assert_select "input#connection_request_with_user_id[name=?]", "connection_request[with_user_id]"

      assert_select "input#connection_request_confirm[name=?]", "connection_request[confirm]"

      assert_select "input#connection_request_done[name=?]", "connection_request[done]"
    end
  end
end
