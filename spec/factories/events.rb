FactoryGirl.define do
  factory :event do
    event_type 1
    read false
    user_id 1
    email "MyString"
    profile_id 1
    agent_user_id 1
    agent_profile_id ""
    profiles_qty 1
    log_type 1
    log_id 1
  end
end
