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

    trait :overwritten_nil do   # корректная ситуация
      table_name      "profiles" # overwritten = nil разрешено только в этой комбинации
      overwritten      nil
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

    trait :bad_overwritten_nil_table do   # НЕкорректная ситуация
      table_name       "trees"  # д.б. "profiles" при overwritten = nil
      overwritten          nil
      field            "user_id"
    end

    trait :bad_overwritten_nil_field do   # НЕкорректная ситуация for nil
      table_name       "profiles"
      overwritten          nil
      field            "profile_id" # should be "user_id"
    end


    # Model methods traits
    #<SimilarsLog id: 754, connected_at: 25, current_user_id: 5, table_name: "users", table_row: 5, field: "profile_id", written: 52, overwritten: 34, created_at: "2015-01-26 18:08:49", updated_at: "2015-01-26 18:08:49">,
    trait :sims_log_1  do
      # current_user_id  user.id
      connected_at  40           #
      table_name    "profile_keys"   #
      table_row     55  #
      field         "profile_id"  #
      written       111  #
      overwritten   222  #
    end

    trait :sims_log_2 do
      # current_user_id  user.id
      connected_at  40           #
      table_name    "profile_keys"   #
      table_row     66  #
      field         "profile_id"  #
      written       111  #
      overwritten   222  #
    end

    trait :sims_log_3 do
      # current_user_id  other_user.id
      connected_at  41           #
      table_name    "profile_keys"   #
      table_row     77  #
      field         "profile_id"  #
      written       111  #
      overwritten   222  #
    end

    trait :sims_log_4 do
      # current_user_id  third_user.id
      connected_at  42           #
      table_name    "profile_keys"   #
      table_row     88  #
      field         "profile_id"  #
      written       333  #
      overwritten   444  #
    end

    trait :sims_log_5 do
      # current_user_id  third_user.id
      connected_at  42           #
      table_name    "profile_keys"   #
      table_row     99  #
      field         "profile_id"  #
      written       333  #
      overwritten   444  #
    end

    trait :sims_log_table_row_1 do
      # #<SimilarsLog id: 3973, connected_at: 5, current_user_id: 5, table_name: "trees", table_row: 47, field: "profile_id", written: 38, overwritten: 42, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,

    #  current_user_id  user.id
      connected_at  77           #
      table_name    "profile_keys"   #
      table_row     100  #
      field         "profile_id"  #
      written       333  #
      overwritten   444  #
    end

    trait :sims_log_table_row_2 do
    #  current_user_id  user.id
      connected_at  77           #
      table_name    "profile_keys"   #
      table_row     100  #
      field         "is_profile_id"  #
      written       333  #
      overwritten   444  #
    end

    trait :sims_log_table_row_3 do
      #  current_user_id  user.id
      connected_at  77           #
      table_name    "profile_keys"   #
      table_row     100  #
      field         "profile_id"  #
      written       333  #
      overwritten   444  #
    end

    trait :sims_log_connection_id do
      current_user_id  7
      connected_at  77           #
      table_name    "profile_keys"   #
      table_row     100  #
      field         "profile_id"  #
      written       333  #
      overwritten   444  #
    end






  end

end