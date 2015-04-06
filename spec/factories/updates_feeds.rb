FactoryGirl.define do
  factory :updates_feed, class: UpdatesFeed do
    user_id           1
    update_id         1
    agent_user_id     2
    agent_profile_id  1
    who_made_event    1
    read              false

    # validation
    trait :uncorrect_user do
      user_id  3.5
    end
    trait :uncorrect_update_id do
      user_id   1
      update_id 1.5
    end
    trait :uncorrect_agent_user_id do
      agent_user_id 1.5
      update_id     1
    end
    trait :uncorrect_agent_profile_id do
      agent_user_id     15
      agent_profile_id -21
    end
    trait :uncorrect_who_made_event do
      who_made_event     1.5
      agent_profile_id   1
    end
    trait :uncorrect_read do
      read             nil
      who_made_event 14
    end
    trait :uncorrect_user_and_agent_user do
      user_id         15
      agent_user_id   15
      read            true
    end

  end

end

