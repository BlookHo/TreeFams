require 'faker'

FactoryGirl.define do

  factory :test_search_service_logs, class: SearchServiceLogs do |f|
    f.name                    { Faker::Name.name } # str
    f.search_event            { Faker::Number.number(1) } # int
    f.time                    { Faker::Number.positive(from = 1.00, to = 5000.00) } # float
    f.connected_users         { [1,2,100] }               # arr
    f.searched_profiles       { Faker::Number.number(5) } # int
    f.ave_profile_search_time { Faker::Number.positive(from = 1.00, to = 5000.00) } # float
  end

  factory :search_service_logs, :class => 'SearchServiceLogs' do
    # CORRECT
    name                    "Добавлен профиль"
    search_event             1
    time                     150.93
    connected_users          [1,2,10, 150]
    searched_profiles        15
    ave_profile_search_time  157.68

    trait :correct2 do
      name                    "Удален профиль"
      search_event             2
      time                     110.93
      connected_users          [1,2,10, 150]
      searched_profiles        15
      ave_profile_search_time  137.68
    end

    trait :correct3 do
      name                    "Объединение деревьев"
      search_event             100
      time                     1350.93
      connected_users          [1,2,10, 150]
      searched_profiles        15
      ave_profile_search_time  75.68
    end

  end

end