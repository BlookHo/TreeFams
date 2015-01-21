require 'rails_helper'

RSpec.describe "updates_events/edit", :type => :view do
  before(:each) do
    @updates_event = assign(:updates_event, UpdatesEvent.create!(
      :name => "MyText",
      :image => "MyText"
    ))
  end

  it "renders the edit updates_event form" do
    render

    assert_select "form[action=?][method=?]", updates_event_path(@updates_event), "post" do

      assert_select "textarea#updates_event_name[name=?]", "updates_event[name]"

      assert_select "textarea#updates_event_image[name=?]", "updates_event[image]"
    end
  end
end
