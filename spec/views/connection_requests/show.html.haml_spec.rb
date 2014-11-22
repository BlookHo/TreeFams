require 'rails_helper'

RSpec.describe "connection_requests/show", :type => :view do
  before(:each) do
    @connection_request = assign(:connection_request, ConnectionRequest.create!(
      :user_id => 1,
      :with_user_id => 2,
      :confirm => 3,
      :done => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/false/)
  end
end
