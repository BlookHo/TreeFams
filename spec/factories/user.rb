FactoryGirl.define do
  factory :user do
    admin false
    email "petr_andr@pe.pe"
    password 'qwertyuiop'

    trait :wrong_email do
      email "petr_and"
    end
  end
end
