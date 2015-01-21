require 'rails_helper'

RSpec.describe "updates_events/index", :type => :view do
  before(:each) do
    assign(:updates_events, [
      UpdatesEvent.create!(
        :name => "MyText",
        :image => "MyText"
      ),
      UpdatesEvent.create!(
        :name => "MyText",
        :image => "MyText"
      )
    ])
  end

  it "renders a list of updates_events" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
