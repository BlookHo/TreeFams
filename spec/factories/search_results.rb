FactoryGirl.define do
  factory :search_results, :class => 'SearchResults' do

    # CORRECT
    user_id 15
    found_user_id 35
    profile_id 5
    found_profile_id 7
    count 4
    found_profile_ids [7,25]
    searched_profile_ids [5,52]
    counts [4,4]
    connection_id nil

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

    trait :unarray_found_profile_ids do
      # user_id 1222222
      # found_user_id 13333333
      # profile_id 14444444
      # found_profile_id 15555555
      # count 15
      found_profile_ids 155
      searched_profile_ids 14
      # counts [15,2]
      connection_id 77
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
