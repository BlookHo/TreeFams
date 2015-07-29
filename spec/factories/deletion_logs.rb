FactoryGirl.define do

  # CORRECT
  factory :deletion_log   do # class: DeletionLog
    log_number 3
    current_user_id 9
    table_name "trees"
    table_row 8
    field "deleted"
    written 1
    overwritten 0

    trait :big_IDs do
      log_number    3333333333
      current_user_id 1000000000
      table_row       5555555555
      written         1
      overwritten     0
    end

    trait :table_tree_deleted do
      table_name      "trees"
      field           "deleted"
    end

    trait :table_pr_key_deleted do
      table_name      "profile_keys"
      field           "deleted"
    end


    # validation of UNCORRECT
    trait :uncorrect_log_number do
      log_number 10.8
    end

    trait :uncorrect_table_row do
      table_row  3.5
      log_number 108
    end

    trait :uncorrect_table_name do
      table_row  35
      table_name  "users"
    end

    trait :uncorrect_user do
      table_name  "trees"
      current_user_id  3.9
    end

    trait :uncorrect_written do
      current_user_id  309
      written  2
    end

    trait :uncorrect_written_and_overwritten do
      overwritten  1
      written  1
    end



    # rollback_destroy_one_profile - in common_log_spec
    trait :deletion_pr_id_1_tree do
      log_number 2
      current_user_id 9
      table_name "trees"
      table_row 8
      field "deleted"
      written 1
      overwritten 0
    end

    trait :deletion_pr_id_1_profile_key_1 do
      log_number 2
      current_user_id 9
      table_name "profile_keys"
      table_row 55
      field "deleted"
      written 1
      overwritten 0
    end

    trait :deletion_pr_id_1_profile_key_2 do
      log_number 2
      current_user_id 9
      table_name "profile_keys"
      table_row 56
      field "deleted"
      written 1
      overwritten 0
    end

    trait :deletion_pr_id_1_profile_key_3 do
      log_number 2
      current_user_id 9
      table_name "profile_keys"
      table_row 57
      field "deleted"
      written 1
      overwritten 0
    end

    trait :deletion_pr_id_1_profile_key_4 do
      log_number 2
      current_user_id 9
      table_name "profile_keys"
      table_row 58
      field "deleted"
      written 1
      overwritten 0
    end

  end
end
