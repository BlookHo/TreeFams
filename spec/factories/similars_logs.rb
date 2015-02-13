FactoryGirl.define do
  factory :similars_log do
    connected_at      5
    current_user_id   15
    table_name      "profiles" # "trees"  #
    table_row         225
    field          "profile_id" #  "user_id" #
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
      table_name      "profiles" #  "trees"
      written           nil
      field             "user_id"
    end

    trait :table_users do   # корректная ситуация
      table_name      "users" #
      written           2222
      field            "profile_id" #
    end

    trait :table_tree_pr_key do   # корректная ситуация
      table_name      "trees" #
      # written           2222
      field            "is_profile_id" #
    end



    trait :bad_table_tree_and_field do   # НЕкорректная ситуация
      table_name      "trees"  #  "profiles"
      # written           nil
      field             "user_id"
    end


    trait :bad_written_nil_table do   # НЕкорректная ситуация
      table_name      "trees"  #  "profiles"
      written           nil
      field             "user_id"
    end

    trait :bad_written_nil_field do   # НЕкорректная ситуация
      table_name      "profiles" # "trees"  #
      written           nil
      field            "profile_id" # "user_id" #
    end

  end



end