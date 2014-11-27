require 'rails_helper'

RSpec.describe "weafam_settings/index", :type => :view do
  before(:each) do
    assign(:weafam_settings, [
      WeafamSetting.create!(
        :certain_koeff => 1
      ),
      WeafamSetting.create!(
        :certain_koeff => 1
      )
    ])
  end

  it "renders a list of weafam_settings" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
