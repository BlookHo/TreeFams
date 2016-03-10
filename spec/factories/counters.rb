require 'faker'

FactoryGirl.define  do

  factory :counter, class: Counter  do |f|
    f.invites { Faker::Number.number(5) }
    f.disconnects { Faker::Number.number(5) }
  end

  factory :counter_row, class: Counter do
    invites 2689
    disconnects 67
  end




end
