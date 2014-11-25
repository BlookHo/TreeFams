require 'rails_helper'

RSpec.describe "messages/index", :type => :view do
  before(:each) do
    assign(:messages, [
      Message.create!(
        :text => "MyText",
        :sender_id => 1,
        :receiver_id => 2,
        :read => false,
        :sender_deleted => false,
        :receiver_deleted => false
      ),
      Message.create!(
        :text => "MyText",
        :sender_id => 1,
        :receiver_id => 2,
        :read => false,
        :sender_deleted => false,
        :receiver_deleted => false
      )
    ])
  end

  it "renders a list of messages" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
