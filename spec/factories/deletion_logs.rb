FactoryGirl.define do

  # CORRECT
  factory :deletion_log, class: DeletionLog  do
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

    trait :table_tree_deleted do   # корректная ситуация
      table_name      "trees"
      field           "deleted"
    end

    trait :table_pr_key_deleted do   # корректная ситуация
      table_name      "profile_keys"
      field           "deleted"
    end


    # validation of UNCORRECT

    trait :uncorrect_type do
      log_type 10
    end

    trait :uncorrect_user do
      user_id  3.5
      log_type  3
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
