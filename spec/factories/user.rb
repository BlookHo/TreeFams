FactoryGirl.define do
  factory :user do
    admin false
    email "petr_andr@pe.pe"
    # email "new@nn.nn"
    password 'qwertyuiop'

    trait :wrong_email do
      email "petr_and"
    end

  end

  factory :good_user_profile, class: User do
    profile_id 1
    email "petr_andr@pe.pe"
    password '1111'
  end

end
