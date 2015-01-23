require 'rails_helper'

RSpec.describe "updates_events/new", :type => :view do
  before(:each) do
    assign(:updates_event, UpdatesEvent.new(
      :name => "MyText",
      :image => "MyText"
    ))
  end

  it "renders new updates_event form" do
    render

    assert_select "form[action=?][method=?]", updates_events_path, "post" do

      assert_select "textarea#updates_event_name[name=?]", "updates_event[name]"

      assert_select "textarea#updates_event_image[name=?]", "updates_event[image]"
    end
  end
end
