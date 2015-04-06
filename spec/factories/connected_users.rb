FactoryGirl.define do
  factory :connected_user, class: ConnectedUser do #

    # 1
    user_id               9
    with_user_id          10
    connected             true
    connection_id         5
    rewrite_profile_id    85
    overwrite_profile_id  101

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

    trait :connected_3_4 do
      user_id 3
      with_user_id 4
      connected             true
      connection_id         4
      rewrite_profile_id    66
      overwrite_profile_id  100
    end

    trait :connected_4_5 do
      user_id 4
      with_user_id 5
      connected             true
      connection_id         5
      rewrite_profile_id    166
      overwrite_profile_id  1300
    end





  end



end