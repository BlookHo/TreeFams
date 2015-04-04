FactoryGirl.define do
  factory :connection_request, class: ConnectionRequest do #

    # 1
    user_id               9
    with_user_id          10
    connection_id         5
    confirm         5
    done    true

    # 2
    trait :connected_user_2 do
      user_id 3
    end

    # 3
    trait :connected_user_3 do
      user_id 4
      with_user_id 66
    end

    # 4
    trait :connected_user_4 do
      user_id 44
      with_user_id 5
    end

    # 5
    trait :connected_user_5 do
      user_id 2
      with_user_id 1
    end

    # 6
    trait :connected_user_6 do
      user_id 10
      with_user_id 11
    end


    trait :correct do
      user_id 1
      with_user_id 2
      connected             true
      connection_id         1
      rewrite_profile_id    85
      overwrite_profile_id  101
    end

    trait :correct_3_4 do
      user_id 3
      with_user_id 4
    end

    trait :correct_7_8 do
      user_id 7
      with_user_id 8
      connected             true
      connection_id         2
      rewrite_profile_id    66
      overwrite_profile_id  100
    end

    trait :user_id_nil do
      user_id nil
    end

    trait :big_IDs do
      user_id 100000000
      with_user_id 222222222
    end

    trait :ids_equal do
      user_id 225
      with_user_id 225
    end

    trait :one_id_less_zero do
      user_id -2
    end

    trait :other_id_less_zero do
      user_id 2000
      with_user_id -3
    end

    trait :one_id_Uninteger do
      user_id 10003
      with_user_id 3.5
    end

    trait :bad_profiles_fields_eual do
      # user_id 10003
      with_user_id 35
      rewrite_profile_id    85
      overwrite_profile_id  85
    end

    trait :conn_request_1_2 do
      user_id         1
      with_user_id    2
      connection_id   1
      confirm         1
      done            true
    end

    trait :conn_request_7_8 do
      user_id         7
      with_user_id    8
      connection_id   2
      confirm         1
      done            true
    end

    trait :conn_request_3_1 do
      user_id         3
      with_user_id    1
      connection_id   3
      confirm         nil
      done            false
    end

    trait :conn_request_3_2 do
      user_id         3
      with_user_id    2
      connection_id   3
      confirm         nil
      done            false
    end

    trait :conn_request_3_4 do
      user_id         3
      with_user_id    4
      connection_id   4
      confirm         1
      done            true
    end

    trait :conn_request_4_5 do
      user_id         4
      with_user_id    5
      connection_id   5
      confirm         1
      done            true
    end

    trait :conn_request_4_1 do
      user_id         4
      with_user_id    1
      connection_id   6
      confirm         nil
      done            false
    end

    trait :conn_request_4_2 do
      user_id         4
      with_user_id    2
      connection_id   6
      confirm         nil
      done            false
    end

    trait :conn_request_1_8 do
      user_id         1
      with_user_id    8
      connection_id   7
      confirm         nil
      done            false
    end

    trait :conn_request_1_7 do
      user_id         1
      with_user_id    7
      connection_id   7
      confirm         nil
      done            false
    end

    trait :conn_request_5_1 do
      user_id         5
      with_user_id    1
      connection_id   8
      confirm         nil
      done            false
    end

    trait :conn_request_5_2 do
      user_id         5
      with_user_id    2
      connection_id   8
      confirm         nil
      done            false
    end

    trait :conn_request_10_5 do
      user_id         10
      with_user_id    5
      connection_id   9
      confirm         nil
      done            false
    end


  end



end