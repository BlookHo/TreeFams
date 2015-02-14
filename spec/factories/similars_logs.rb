FactoryGirl.define do
  factory :similars_log do

    # CORRECT

    connected_at      5
    current_user_id   15
    table_name        "profiles"
    table_row         225
    field             "user_id" # or "trees"
    written           446
    overwritten       555

    trait :big_IDs do
      connected_at    3333333333
      current_user_id 1000000000
      table_row       5555555555
      written         2222222222
      overwritten     9999999999
    end

    trait :written_nil do   # корректная ситуация
      table_name      "profiles" # written = nil разрешено только в этой комбинации
      written         nil
      field           "user_id"
    end

    trait :table_users do   # корректная ситуация
      table_name      "users" # разрешена только эта комбинация: "users" + "profile_id"
      written          2222
      field           "profile_id"
    end

    trait :table_tree_is_profile_id do   # корректная ситуация
      table_name      "trees"
      field           "is_profile_id"
    end

    trait :table_tree_profile_id do   # корректная ситуация
      table_name      "trees"
      field           "profile_id"
    end

    trait :table_pr_key_is_profile_id do   # корректная ситуация
      table_name      "profile_keys"
      field           "is_profile_id"
    end

    trait :table_pr_key_profile_id do   # корректная ситуация
      table_name      "profile_keys"
      field           "profile_id"
    end


    # UNCORRECT

    trait :bad_written_and_overwritten do   # НЕкорректная ситуация
      written          333 # не д.б. равны
      overwritten      333 # не д.б. равны
    end

    trait :bad_written_nil_table do   # НЕкорректная ситуация
      table_name       "trees"  # д.б. "profiles" при written = nil
      written          nil
      field            "user_id"
    end

    trait :bad_written_nil_field do   # НЕкорректная ситуация for nil
      table_name       "profiles"
      written          nil
      field            "profile_id" # should be "user_id"
    end

    trait :bad_table_tree_and_field do   # НЕкорректная ситуация
      table_name        "trees"
      field             "user_id" # д.б. "profiles" или "is_profile_id"
    end

    trait :bad_table_pr_key_and_field do   # НЕкорректная ситуация
      table_name        "profile_keys"
      field             "user_id" # д.б. "profiles" или "is_profile_id"
    end

    trait :bad_table_user_and_field do   # НЕкорректная ситуация
      table_name        "users"
      field             "user_id" # should be "profile_id"
    end

    trait :bad_table_profile_and_field do   # НЕкорректная ситуация
      table_name       "profiles"
      written          2222
      field            "profile_id" # should be "user_id" or "trees"
    end

  end

end