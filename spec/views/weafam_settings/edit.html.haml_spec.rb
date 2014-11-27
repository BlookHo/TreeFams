require 'rails_helper'

RSpec.describe "weafam_settings/edit", :type => :view do
  before(:each) do
    @weafam_setting = assign(:weafam_setting, WeafamSetting.create!(
      :certain_koeff => 1
    ))
  end

  it "renders the edit weafam_setting form" do
    render

    assert_select "form[action=?][method=?]", weafam_setting_path(@weafam_setting), "post" do

      assert_select "input#weafam_setting_certain_koeff[name=?]", "weafam_setting[certain_koeff]"
    end
  end
end
