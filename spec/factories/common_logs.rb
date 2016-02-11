FactoryGirl.define do
  factory :common_log, class: CommonLog  do
    user_id 1
    log_type 1
    log_id 1
    profile_id 2
    base_profile_id 1
    relation_id 3

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
    trait :uncorrect_base_profile do
      profile_id 15
      base_profile_id -21
    end
    trait :uncorrect_relation_id_1 do
      base_profile_id 15
      relation_id -121
    end
    trait :uncorrect_relation_id_2 do
      # base_profile_id 15
      relation_id 124
    end

    # test delete logs action
    trait :log_delete_profile_89 do
      user_id 9
      log_type 2
      log_id 1
      profile_id 89
      base_profile_id 85
      relation_id 6
    end
    trait :log_delete_profile_90 do
      user_id 9
      log_type 2
      log_id 2
      profile_id 90
      base_profile_id 85
      relation_id 3
    end

    # test add logs action
    trait :log_add_profile_172 do
      user_id 9
      log_type 1
      log_id 1
      profile_id 172
      base_profile_id 86
      relation_id 1
    end
    trait :log_add_profile_173 do
      user_id 9
      log_type 1
      log_id 2
      profile_id 173
      base_profile_id 86
      relation_id 2
    end

    # test add logs action
    trait :log_actual_profile_172 do
      user_id 7
      log_type 2
      log_id 1
      profile_id 172
      base_profile_id 86
      relation_id 1
    end
    trait :log_actual_profile_173 do
      user_id 5
      log_type 1
      log_id 2
      profile_id 173
      base_profile_id 86
      relation_id 2
    end
    trait :log_actual_profile_23 do
      user_id 2
      log_type 2
      log_id 12
      profile_id 23
      base_profile_id 17
      relation_id 1
    end
    trait :log_actual_profile_24 do
      user_id 1
      log_type 1
      log_id 11
      profile_id 24
      base_profile_id 8
      relation_id 2
    end



  end

end
