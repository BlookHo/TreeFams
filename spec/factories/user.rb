FactoryGirl.define do
  factory :user do                    # 5 tree
    admin false
    profile_id 77
    email "petr_andr@pe.pe"
    password 'qwertyuiop'
    trait :wrong_email do
      email "petr_and"
    end
  end

  factory :other_user, class: User do # 4 tree
    profile_id 31
    email "andrey@an.an"
    password '1111'
  end

  factory :third_user, class: User do # 8 tree
    profile_id 44
    email "olga@ol.ol"
    password '1111'
  end

  factory :four_user, class: User do # 10 tree
    profile_id 55
    email "boris@bo.bo"
    password '1111'
  end

  # factory :connected_user, class: ConnectedUser do #
  #
  #   # 1
  #   user_id 55
  #   with_user_id 2
  #   connected true
  #
  #   # 2
  #   trait :connected_user_2 do
  #     user_id 3
  #     # with_user_id 2
  #     # connected true
  #   end
  #
  #   # 3
  #   trait :connected_user_3 do
  #     user_id 2
  #     with_user_id 66
  #     # connected true
  #   end
  #
  #   # 4
  #   trait :connected_user_4 do
  #     user_id 4
  #     with_user_id 5
  #     # connected true
  #   end
  #
  #   # 5
  #   trait :connected_user_5 do
  #     user_id 5
  #     with_user_id 1
  #     # connected true
  #   end
  #
  #   # 6
  #   trait :connected_user_6 do
  #     user_id 10
  #     with_user_id 11
  #     # connected true
  #   end
  #
  #
  # end
  #






end
