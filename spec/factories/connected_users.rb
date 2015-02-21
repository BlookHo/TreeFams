FactoryGirl.define do
  factory :connected_user, class: ConnectedUser do #

    # 1
    user_id 55
    with_user_id 2
    connected true

    # 2
    trait :connected_user_2 do
      user_id 3
      # with_user_id 2
      # connected true
    end

    # 3
    trait :connected_user_3 do
      user_id 2
      with_user_id 66
      # connected true
    end

    # 4
    trait :connected_user_4 do
      user_id 4
      with_user_id 5
      # connected true
    end

    # 5
    trait :connected_user_5 do
      user_id 5
      with_user_id 1
      # connected true
    end

    # 6
    trait :connected_user_6 do
      user_id 10
      with_user_id 11
      # connected true
    end



    trait :correct do
      user_id 1
      with_user_id 2
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

  end



end