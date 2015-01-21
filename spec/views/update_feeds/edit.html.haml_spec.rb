require 'rails_helper'

RSpec.describe "updates_feeds/edit", :type => :view do
  before(:each) do
    @update_feed = assign(:update_feed, UpdateFeed.create!(
      :user_id => 1,
      :update_id => 1,
      :agent_user_id => 1
    ))
  end

  it "renders the edit update_feed form" do
    render

    assert_select "form[action=?][method=?]", update_feed_path(@update_feed), "post" do

      assert_select "input#update_feed_user_id[name=?]", "update_feed[user_id]"

      assert_select "input#update_feed_update_id[name=?]", "update_feed[update_id]"

      assert_select "input#update_feed_agent_user_id[name=?]", "update_feed[agent_user_id]"
    end
  end
end
