require 'rails_helper'

RSpec.describe "updates_feeds/show", :type => :view do
  before(:each) do
    @update_feed = assign(:update_feed, UpdateFeed.create!(
      :user_id => 1,
      :update_id => 2,
      :agent_user_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
