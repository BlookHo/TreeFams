require 'rails_helper'

RSpec.describe "weafam_settings/new", :type => :view do
  before(:each) do
    assign(:weafam_setting, WeafamSetting.new(
      :certain_koeff => 1
    ))
  end

  it "renders new weafam_setting form" do
    render

    assert_select "form[action=?][method=?]", weafam_settings_path, "post" do

      assert_select "input#weafam_setting_certain_koeff[name=?]", "weafam_setting[certain_koeff]"
    end
  end
end
