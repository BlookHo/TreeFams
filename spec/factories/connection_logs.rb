FactoryGirl.define do
  factory :connection_log do

    # CORRECT
    connected_at 5
    current_user_id 15
    with_user_id 1
    table_name "profiles"
    table_row 225
    field "user_id" # or "trees"
    written 446
    overwritten 555


    trait :big_IDs do
      connected_at    3333333333
      with_user_id    1111111111
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
    #<ConnectionLog id: 754, connected_at: 25, current_user_id: 5, table_name: "users", table_row: 5, field: "profile_id", written: 52, overwritten: 34, created_at: "2015-01-26 18:08:49", updated_at: "2015-01-26 18:08:49">,
    trait :connections_log_1  do
      # current_user_id  user.id
      connected_at  40           #
      table_name    "profile_keys"   #
      table_row     55  #
      field         "profile_id"  #
      written       111  #
      overwritten   222  #
    end

    trait :connections_log_2 do
      # current_user_id  user.id
      connected_at  40           #
      table_name    "profile_keys"   #
      table_row     66  #
      field         "profile_id"  #
      written       111  #
      overwritten   222  #
    end

    trait :connections_log_3 do
      # current_user_id  other_user.id
      with_user_id    1111111111
      connected_at  41           #
      table_name    "profile_keys"   #
      table_row     77  #
      field         "profile_id"  #
      written       111  #
      overwritten   222  #
    end

    trait :connections_log_4 do
      # current_user_id  third_user.id
      # with_user_id    1111111111
      connected_at  42           #
      table_name    "profile_keys"   #
      table_row     88  #
      field         "profile_id"  #
      written       333  #
      overwritten   444  #
    end

    trait :connections_log_5 do
      # current_user_id  third_user.id
      connected_at  42           #
      table_name    "profile_keys"   #
      table_row     99  #
      field         "profile_id"  #
      written       333  #
      overwritten   444  #
    end

    trait :connections_log_table_row_1 do
      # #<SimilarsLog id: 3973, connected_at: 5, current_user_id: 5, table_name: "trees", table_row: 47, field: "profile_id", written: 38, overwritten: 42, created_at: "2015-02-12 10:55:31", updated_at: "2015-02-12 10:55:31">,

      #  current_user_id  user.id
      with_user_id    1111111111
      connected_at  77           #
      table_name    "profile_keys"   #
      table_row     100  #
      field         "profile_id"  #
      written       333  #
      overwritten   444  #
    end

    trait :connections_log_table_row_2 do
      #  current_user_id  user.id
      connected_at  77           #
      table_name    "profile_keys"   #
      table_row     100  #
      field         "is_profile_id"  #
      written       333  #
      overwritten   444  #
    end

    trait :connections_log_table_row_3 do
      #  current_user_id  user.id
      connected_at  77           #
      table_name    "profile_keys"   #
      table_row     100  #
      field         "profile_id"  #
      written       333  #
      overwritten   444  #
    end



  end

end

# After Connected

# 6766;5;8;"users";8;"profile_id";84
# 6767;5;8;"profiles";84;"user_id";8
# 6768;5;8;"profiles";84;"tree_id";7
# 6769;5;8;"profiles";66;"user_id";
# 6770;5;8;"trees";71;"profile_id";81
# 6771;5;8;"trees";70;"profile_id";81
# 6772;5;8;"trees";72;"profile_id";82
# 6773;5;8;"trees";64;"profile_id";84
# 6774;5;8;"trees";65;"profile_id";84
# 6775;5;8;"trees";66;"profile_id";84
# 6776;5;8;"trees";67;"profile_id";84
# 6777;5;8;"trees";63;"profile_id";84
# 6778;5;8;"trees";67;"is_profile_id";81
# 6779;5;8;"trees";63;"is_profile_id";81
# 6780;5;8;"trees";71;"is_profile_id";82
# 6781;5;8;"trees";72;"is_profile_id";83
# 6782;5;8;"trees";70;"is_profile_id";67
# 6783;5;8;"trees";59;"is_profile_id";84

# 6784;5;8;"profile_keys";402;"profile_id";81
# 6785;5;8;"profile_keys";420;"profile_id";81
# 6786;5;8;"profile_keys";424;"profile_id";81
# 6787;5;8;"profile_keys";406;"profile_id";81
# 6788;5;8;"profile_keys";404;"profile_id";81
# 6789;5;8;"profile_keys";422;"profile_id";81
# 6790;5;8;"profile_keys";445;"profile_id";81
# 6791;5;8;"profile_keys";453;"profile_id";81
# 6792;5;8;"profile_keys";443;"profile_id";81
# 6793;5;8;"profile_keys";451;"profile_id";82

# 6794;5;8;"profile_keys";448;"profile_id";82
# 6795;5;8;"profile_keys";446;"profile_id";82
# 6796;5;8;"profile_keys";450;"profile_id";82
# 6797;5;8;"profile_keys";456;"profile_id";83
# 6798;5;8;"profile_keys";454;"profile_id";83
# 6799;5;8;"profile_keys";452;"profile_id";83
# 6800;5;8;"profile_keys";455;"profile_id";67
# 6801;5;8;"profile_keys";444;"profile_id";67
# 6802;5;8;"profile_keys";447;"profile_id";67
# 6803;5;8;"profile_keys";376;"profile_id";84

# 6804;5;8;"profile_keys";374;"profile_id";84
# 6805;5;8;"profile_keys";372;"profile_id";84
# 6806;5;8;"profile_keys";397;"profile_id";84
# 6807;5;8;"profile_keys";413;"profile_id";84
# 6808;5;8;"profile_keys";437;"profile_id";84
# 6809;5;8;"profile_keys";387;"profile_id";84
# 6810;5;8;"profile_keys";427;"profile_id";84
# 6811;5;8;"profile_keys";401;"profile_id";84
# 6812;5;8;"profile_keys";419;"profile_id";84
# 6813;5;8;"profile_keys";407;"profile_id";84

# 6814;5;8;"profile_keys";409;"profile_id";84
# 6815;5;8;"profile_keys";449;"profile_id";84

# 6816;5;8;"profile_keys";403;"is_profile_id";81
# 6817;5;8;"profile_keys";401;"is_profile_id";81
# 6818;5;8;"profile_keys";419;"is_profile_id";81
# 6819;5;8;"profile_keys";421;"is_profile_id";81
# 6820;5;8;"profile_keys";423;"is_profile_id";81
# 6821;5;8;"profile_keys";405;"is_profile_id";81
# 6822;5;8;"profile_keys";446;"is_profile_id";81
# 6823;5;8;"profile_keys";454;"is_profile_id";81
# 6824;5;8;"profile_keys";444;"is_profile_id";81
# 6825;5;8;"profile_keys";447;"is_profile_id";82

# 6826;5;8;"profile_keys";449;"is_profile_id";82
# 6827;5;8;"profile_keys";452;"is_profile_id";82
# 6828;5;8;"profile_keys";445;"is_profile_id";82
# 6829;5;8;"profile_keys";453;"is_profile_id";83
# 6830;5;8;"profile_keys";451;"is_profile_id";83
# 6831;5;8;"profile_keys";455;"is_profile_id";83
# 6832;5;8;"profile_keys";443;"is_profile_id";67
# 6833;5;8;"profile_keys";448;"is_profile_id";67
# 6834;5;8;"profile_keys";456;"is_profile_id";67
# 6835;5;8;"profile_keys";373;"is_profile_id";84

# 6836;5;8;"profile_keys";398;"is_profile_id";84
# 6837;5;8;"profile_keys";388;"is_profile_id";84
# 6838;5;8;"profile_keys";420;"is_profile_id";84
# 6839;5;8;"profile_keys";408;"is_profile_id";84
# 6840;5;8;"profile_keys";410;"is_profile_id";84
# 6841;5;8;"profile_keys";414;"is_profile_id";84
# 6842;5;8;"profile_keys";428;"is_profile_id";84
# 6843;5;8;"profile_keys";438;"is_profile_id";84
# 6844;5;8;"profile_keys";402;"is_profile_id";84
# 6845;5;8;"profile_keys";450;"is_profile_id";84

# 6846;5;8;"profile_keys";371;"is_profile_id";84
# 6847;5;8;"profile_keys";375;"is_profile_id";84


# After DisConnected

# empty