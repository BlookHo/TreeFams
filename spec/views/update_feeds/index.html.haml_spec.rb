require 'rails_helper'

RSpec.describe "updates_feeds/index", :type => :view do
  before(:each) do
    assign(:updates_feeds, [
      UpdateFeed.create!(
        :user_id => 1,
        :update_id => 2,
        :agent_user_id => 3
      ),
      UpdateFeed.create!(
        :user_id => 1,
        :update_id => 2,
        :agent_user_id => 3
      )
    ])
  end

  it "renders a list of updates_feeds" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
