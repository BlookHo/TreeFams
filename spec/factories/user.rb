FactoryGirl.define do
  factory :user do                    # 5 tree
    admin false
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

end
