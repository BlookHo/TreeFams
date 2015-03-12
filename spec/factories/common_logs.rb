FactoryGirl.define do
  factory :common_log, class: CommonLog  do
    user_id 1
    log_type 1
    log_id 1
    profile_id 1

    # validation
    trait :uncorrect_type do
      log_type 10
    end
    trait :uncorrect_user do
      user_id  3.5
      log_type  3
    end
    trait :uncorrect_log_id do
      user_id 1
      log_id 1.5
    end
    trait :uncorrect_profile do
      profile_id 1.5
      log_id 1
    end


  end

end
