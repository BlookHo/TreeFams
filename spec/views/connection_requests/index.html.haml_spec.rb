require 'rails_helper'

RSpec.describe "connection_requests/index", :type => :view do
  before(:each) do
    assign(:connection_requests, [
      ConnectionRequest.create!(
        :user_id => 1,
        :with_user_id => 2,
        :confirm => 3,
        :done => false
      ),
      ConnectionRequest.create!(
        :user_id => 1,
        :with_user_id => 2,
        :confirm => 3,
        :done => false
      )
    ])
  end

  it "renders a list of connection_requests" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
