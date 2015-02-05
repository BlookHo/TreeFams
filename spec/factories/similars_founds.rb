FactoryGirl.define do
  factory :similars_found do

    user_id 1
    first_profile_id 2
    second_profile_id 3

    trait :user_id_nil do
      user_id nil
      # first_profile_id 22222222
      # second_profile_id 333333333
    end

    trait :big_IDs do
      user_id 100000000
      first_profile_id 222222222
      second_profile_id 999999999
    end

    trait :ids_equal do
      user_id 10003
      first_profile_id 225
      second_profile_id 225
    end

    trait :one_id_less_zero do
      user_id 10003
      first_profile_id -2
      second_profile_id 3
    end

    trait :other_id_less_zero do
      user_id 10003
      first_profile_id 2000
      second_profile_id -3
    end

    trait :one_id_Uninteger do
      user_id 10003
      first_profile_id 22
      second_profile_id 3.5
    end


  end





end
