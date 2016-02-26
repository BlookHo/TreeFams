require 'faker'

FactoryGirl.define do

  factory :test_search_service_logs, class: SearchServiceLogs do |f|
    f.name                    { Faker::Name.name } # str
    f.search_event            { [1,2,3,4,5,6,7,100].sample } # int of valid Array
    f.time                    { Faker::Number.positive(from = 1.00, to = 5000.00) } # float
    f.connected_users         { [1,2,100] }               # arr
    f.searched_profiles       { Faker::Number.number(5) } # int
    f.ave_profile_search_time { Faker::Number.positive(from = 1.00, to = 5000.00) } # float
    f.all_tree_profiles       { Faker::Number.number(5) } # int
    f.all_profiles            { Faker::Number.number(5) } # int
  end

  factory :search_service_logs, :class => SearchServiceLogs do
    # CORRECT
    name                    "Добавлен профиль"
    search_event             1
    time                     150.93
    connected_users          [1,2,10, 150]
    searched_profiles        15
    ave_profile_search_time  157.68
    all_tree_profiles        26
    all_profiles             156

    trait :correct2 do
      name                    "Удален профиль"
      search_event             2
      time                     110.93
      connected_users          [1,200,10, 150]
      searched_profiles        25
      ave_profile_search_time  137.68
      all_tree_profiles        45
      all_profiles             155
    end

    trait :correct3 do
      name                    "Объединение деревьев"
      search_event             100
      time                     1350.93
      connected_users          [100,2,10, 1500]
      searched_profiles        27
      ave_profile_search_time  75.68
      all_tree_profiles        27
      all_profiles             158
    end

    trait :uncorrect_search_event do
      search_event             1100
    end

    trait :uncorrect_time do
      search_event             100
      time                     -1350.93
    end

    trait :uncorrect_searched_profiles do
      # name                    "Объединение деревьев"
      # search_event             100
      time                     1350.93
      # connected_users          [1,2,10, 150]
      searched_profiles        -15
      # ave_profile_search_time  75.68
      # all_tree_profiles        25
      # all_profiles             155
    end

    trait :uncorrect_all_tree_profiles do
      # name                    "Объединение деревьев"
      # search_event             100
      # time                     1350.93
      # connected_users          [1,2,10, 150]
      searched_profiles        45
      # ave_profile_search_time  75.68
      all_tree_profiles        0
      # all_profiles             155
    end

  end

end