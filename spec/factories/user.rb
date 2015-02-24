FactoryGirl.define do
  factory :user do          # For 2 connected trees test - 1st. Tree = 1
    admin false
    profile_id 63
    email "petr_andr@pe.pe"
    password 'qwertyuiop'

    trait :wrong_email do
      email "petr_and"
    end

    trait :user_2 do        # For 2 connected trees test - 2nd. Tree = 2
      profile_id 66
      email "andrey@an.an"
      password '11111'
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

  factory :other_user, class: User do #
    profile_id 31
    email "mail_2@pe.pe"
    password '1111'
  end

  factory :third_user, class: User do #
    profile_id 44
    email "olga@ol.ol"
    password '1111'
  end

  factory :four_user, class: User do #
    profile_id 55
    email "boris@bo.bo"
    password '1111'
  end



end
