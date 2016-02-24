require 'faker'

FactoryGirl.define do

  factory :test_search_results, class: SearchResults do |f|
    f.user_id              { Faker::Number.number(5) }
    f.found_user_id        { Faker::Number.number(5) }
    f.profile_id           { Faker::Number.number(5) }
    f.found_profile_id     { Faker::Number.number(5) }
    f.count                { Faker::Number.number(5) }
    f.found_profile_ids    { [1,100] }
    f.searched_profile_ids { [1,100] }
    f.counts               { [5,5] }
    f.pending_connect      { Faker::Number.between(0, 1)}
    f.connection_id        { Faker::Number.number(5) }
    f.searched_connected   { [1,100] }
    f.founded_connected    { [2,200] }
  end

  factory :search_results, :class => 'SearchResults' do
    # CORRECT
    user_id 15
    found_user_id 35
    profile_id 5
    found_profile_id 7
    count 5
    found_profile_ids [7,25]
    searched_profile_ids [5,52]
    counts [5,5]
    connection_id nil
    pending_connect 0
    searched_connected [15]
    founded_connected [35]

    trait :correct2 do
      user_id 2
      found_user_id 3
      profile_id 1555
      found_profile_id 1444
      count 5
      found_profile_ids [1444,22222]
      searched_profile_ids [1555,27777]
      counts [5,5]
      connection_id 7
      pending_connect 1
      searched_connected [2]
      founded_connected [3]
    end

    trait :correct2_1_connected do
      user_id 2
      found_user_id 3
      profile_id 1555
      found_profile_id 1444
      count 5
      found_profile_ids [1444,22222, 333345]
      searched_profile_ids [1555,27777, 333336]
      counts [5,5]
      connection_id 7
      pending_connect 1
      searched_connected [1,2]
      founded_connected [3]
    end

    trait :correct3 do
      user_id 1
      found_user_id 3
      profile_id 11
      found_profile_id 25
      count 7
      found_profile_ids [22, 23, 24, 25, 26, 27, 28, 29]
      searched_profile_ids [11, 12, 13, 14, 18, 19, 20, 21]
      counts [7, 7, 7, 7, 5, 5, 5, 5]
      connection_id 3
      pending_connect 0
      searched_connected [1]
      founded_connected [3]

    end

    trait :connected_10_11_12_to_3 do
      user_id 10
      found_user_id 3
      profile_id 110
      found_profile_id 250
      count 7
      found_profile_ids [220, 230, 240, 250, 260, 270, 280, 290]
      searched_profile_ids [110, 120, 130, 140, 180, 190, 200, 210]
      counts [7, 7, 7, 7, 5, 5, 5, 5]
      connection_id 30
      pending_connect 0
      searched_connected [10,11,12]
      founded_connected [3]
    end

    trait :correct_9_to_7_8 do
      user_id 9
      found_user_id 7
      profile_id 85
      found_profile_id 777
      count 7
      found_profile_ids [7110, 7120, 7130, 7140, 7180, 7190, 7200, 7210]
      searched_profile_ids [84, 86, 87, 88, 93, 94, 95, 173]
      counts [7, 7, 7, 7, 5, 5, 5, 5]
      connection_id 31
      pending_connect 0
      searched_connected [9]
      founded_connected [7,8]
    end

    trait :correct_7_8_to_9 do
      user_id 7
      found_user_id 9
      profile_id 777
      found_profile_id 85
      count 7
      found_profile_ids [84, 86, 87, 88, 93, 94, 95, 173]
      searched_profile_ids [7110, 7120, 7130, 7140, 7180, 7190, 7200, 7210]
      counts [7, 7, 7, 7, 5, 5, 5, 5]
      connection_id 31
      pending_connect 0
      searched_connected [7,8]
      founded_connected [9]
    end


    trait :connected_10_11_12_to_7_8 do
      user_id 11
      found_user_id 7
      profile_id 110
      found_profile_id 2500
      count 7
      found_profile_ids [2200, 2300, 2400, 2500, 2600, 2700, 280, 290]
      searched_profile_ids [410, 420, 430, 440, 480, 490, 200, 210]
      counts [7, 7, 7, 7, 5, 5, 5, 5]
      connection_id 300
      pending_connect 0
      searched_connected [10,11,12]
      founded_connected [7,8]
    end

    trait :big_IDs do
      user_id 1222222
      found_user_id 13333333
      profile_id 14444444
      found_profile_id 15555555
      count 15
      found_profile_ids [15555555,222222222]
      searched_profile_ids [14444444,277777777]
      counts [15,2]
      connection_id 7777777
    end

    # UNCORRECT
    trait :unintegers do
      user_id 12.22222
      # found_user_id 13333333
      # profile_id 14.444444
      # found_profile_id 15555555
      # count 15
      # found_profile_ids [15555555,222222222]
      # searched_profile_ids [14444444,277777777]
      # counts [15,2]
    end

    trait :unintegers2 do
      user_id 1222222
      # found_user_id 13333333
      profile_id 14.444444
      # found_profile_id 15555555
      # count 15
      # found_profile_ids [15555555,222222222]
      # searched_profile_ids [14444444,277777777]
      # counts [15,2]
    end

    trait :unintegers3 do
      # user_id 1222222
      # found_user_id 13333333
      profile_id 14444444
      # found_profile_id 15555555
      count 1.5
      # found_profile_ids [15555555,222222222]
      # searched_profile_ids [14444444,277777777]
      # counts [15,2]
    end

    trait :unintegers4 do
      # user_id 1222222
      # found_user_id 13333333
      # profile_id 14444444
      # found_profile_id 15555555
      count 15
      # found_profile_ids [15555555,222222222]
      # searched_profile_ids [14444444,277777777]
      # counts [15,2]
      connection_id 777.7777
    end

    trait :unintegers5 do
      # user_id 1222222
      # found_user_id 13333333
      # profile_id 14444444
      # found_profile_id 15555555
      # count 15
      # found_profile_ids [15555555,222222222]
      # searched_profile_ids [14444444,277777777]
      # counts [15,2]
      connection_id 777
      pending_connect 2
    end

    trait :unarray_found_profile_ids do
      # user_id 1222222
      # found_user_id 13333333
      # profile_id 14444444
      # found_profile_id 15555555
      # count 15
      found_profile_ids 155
      searched_profile_ids 14
      # counts [15,2]
      # connection_id 77
      pending_connect 0
    end

    trait :unarray_searched_profile_ids do
      # user_id 1222222
      # found_user_id 13333333
      # profile_id 14444444
      # found_profile_id 15555555
      # count 15
      found_profile_ids  [1555,222]
      searched_profile_ids 444
      # counts [15,2]
    end

    trait :unarray_counts do
      # user_id 1222222
      # found_user_id 13333333
      # profile_id 14444444
      # found_profile_id 15555555
      # count 15
      # found_profile_ids 15555555
      searched_profile_ids [1444,277]
      counts 15
    end

    trait :users_equals do
      user_id 122
      found_user_id 122
      # profile_id 14444444
      # found_profile_id 15555555
      # count 15
      # found_profile_ids 15555555
      # searched_profile_ids [1444,277]
      counts [15,2]
    end

    trait :profiles_equals do
      # user_id 122
      found_user_id 155
      profile_id 144
      found_profile_id 144
      # count 15
      # found_profile_ids 15555555
      # searched_profile_ids [1444,277]
      # counts [15,2]
    end

  end

end
