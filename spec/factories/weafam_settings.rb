FactoryGirl.define do

    factory :weafam_setting, class: WeafamSetting  do |f|
      f.certain_koeff { Faker::Number.number(1) }
    end

end
