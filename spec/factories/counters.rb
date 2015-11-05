FactoryGirl.define do

  factory :counter, class: Counter  do |f|
    f.invites { Faker::Number.number(5) }
    f.disconnects { Faker::Number.number(5) }
  end

end
