require 'rails_helper'

RSpec.describe "updates_events/show", :type => :view do
  before(:each) do
    @updates_event = assign(:updates_event, UpdatesEvent.create!(
      :name => "MyText",
      :image => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
