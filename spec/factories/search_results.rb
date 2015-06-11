FactoryGirl.define do
  factory :search_results, :class => 'SearchResults' do

    # CORRECT
    user_id 1
    found_user_id 3
    profile_id 5
    found_profile_id 7
    count 4
    found_profile_ids [1,2]
    searched_profile_ids [1,2]
    counts [1,2]

    trait :big_IDs do
      user_id 1222222
      found_user_id 13333333
      profile_id 14444444
      found_profile_id 15555555
      count 15
      found_profile_ids [15555555,222222222]
      searched_profile_ids [14444444,277777777]
      counts [15,2]
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

    trait :unarray_found_profile_ids do
      # user_id 1222222
      # found_user_id 13333333
      # profile_id 14444444
      # found_profile_id 15555555
      count 15
      found_profile_ids 155
      searched_profile_ids 14
      # counts [15,2]
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
