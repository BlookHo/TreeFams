require 'rails_helper'

RSpec.describe "messages/new", :type => :view do
  before(:each) do
    assign(:message, Message.new(
      :text => "MyText",
      :sender_id => 1,
      :receiver_id => 1,
      :read => false,
      :sender_deleted => false,
      :receiver_deleted => false
    ))
  end

  it "renders new message form" do
    render

    assert_select "form[action=?][method=?]", messages_path, "post" do

      assert_select "textarea#message_text[name=?]", "message[text]"

      assert_select "input#message_sender_id[name=?]", "message[sender_id]"

      assert_select "input#message_receiver_id[name=?]", "message[receiver_id]"

      assert_select "input#message_read[name=?]", "message[read]"

      assert_select "input#message_sender_deleted[name=?]", "message[sender_deleted]"

      assert_select "input#message_receiver_deleted[name=?]", "message[receiver_deleted]"
    end
  end
end
