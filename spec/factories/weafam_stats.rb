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

    trait :weafam_stat_1 do
      users               22
      users_male          12
      users_female        10
      profiles            150
      profiles_male       80
      profiles_female     70
      trees               6
      invitations         2
      requests            7
      connections         5
      refuse_requests     0
      disconnections      1
      similars_found      0
    end

    trait :weafam_stat_2 do
      users               23
      users_male          12
      users_female        11
      profiles            185
      profiles_male       80
      profiles_female     95
      trees               7
      invitations         2
      requests            8
      connections         6
      refuse_requests     0
      disconnections      1
      similars_found      0
    end

    trait :weafam_stat_3 do
      users               25
      users_male          13
      users_female        12
      profiles            195
      profiles_male       95
      profiles_female     90
      trees               9
      invitations         3
      requests            9
      connections         7
      refuse_requests     0
      disconnections      1
      similars_found      0
    end





  end





end
