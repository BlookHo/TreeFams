FactoryGirl.define do
  factory :search_result, :class => 'SearchResults' do
    user_id 1
    found_user_id 1
    profile_id 1
    found_profile_id 1
    count 1
    found_profile_ids [1,2]
    searched_profile_ids [1,2]
    counts [1,2]
  end

end
