FactoryGirl.define do

  factory :weafam_setting, class: WeafamSetting  do
    certain_koeff CERTAIN_KOEFF
  end

  factory :weafam_setting_model_test, class: WeafamSetting  do |f|
      f.certain_koeff { Faker::Number.number(1) }
    end

end
