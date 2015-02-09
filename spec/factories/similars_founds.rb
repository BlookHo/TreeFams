FactoryGirl.define do
  factory :similars_found do

    user_id 1
    first_profile_id 2
    second_profile_id 3

    trait :user_id_nil do
      user_id nil
    end

    trait :big_IDs do
      user_id 100000000
      first_profile_id 222222222
      second_profile_id 999999999
    end

    trait :ids_equal do
      first_profile_id 225
      second_profile_id 225
    end

    trait :one_id_less_zero do
      first_profile_id -2
    end

    trait :other_id_less_zero do
      first_profile_id 2000
      second_profile_id -3
    end

    trait :one_id_Uninteger do
      user_id 10003
      second_profile_id 3.5
    end

    # Return Good data
    trait :sims_pair_1  do
      first_profile_id 38   # 5 tree
      second_profile_id 42  # 4 tree
    end

    trait :sims_pair_2 do
      first_profile_id 41   # 5 tree
      second_profile_id 40  # 4 tree
    end

    trait :sims_pair_3 do
      first_profile_id 55   # 8 tree
      second_profile_id 66  # 8 tree
    end

  end





end
