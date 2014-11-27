require 'rails_helper'

RSpec.describe "weafam_settings/show", :type => :view do
  before(:each) do
    @weafam_setting = assign(:weafam_setting, WeafamSetting.create!(
      :certain_koeff => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
  end
end
