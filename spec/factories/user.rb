FactoryGirl.define do
  factory :user do                    # 5 tree
    admin false
    profile_id 77
    email "petr_andr@pe.pe"
    password 'qwertyuiop'

    trait :wrong_email do
      email "petr_and"
    end

    trait :user_2 do
      profile_id 222
      email "mail_2@pe.pe"
    end

    trait :user_3 do
      profile_id 333
      email "mail_3@pe.pe"
    end

    trait :user_4 do
      profile_id 444
      email "mail_4@pe.pe"
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



end
