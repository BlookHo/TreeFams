FactoryGirl.define do

  factory :weafam_stat, class: WeafamStat  do |f|
    f.users { Faker::Number.number(5) }
    f.users_male { Faker::Number.number(5) }
    f.users_female { Faker::Number.number(5) }
    f.profiles { Faker::Number.number(5) }
    f.profiles_male { Faker::Number.number(5) }
    f.profiles_female { Faker::Number.number(5) }
    f.trees { Faker::Number.number(5) }
    f.invitations { Faker::Number.number(5) }
    f.requests { Faker::Number.number(5) }
    f.connections { Faker::Number.number(5) }
    f.refuse_requests { Faker::Number.number(5) }
    f.disconnections { Faker::Number.number(5) }
    f.similars_found { Faker::Number.number(5) }
  end


end
