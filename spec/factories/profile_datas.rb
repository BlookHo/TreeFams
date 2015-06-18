FactoryGirl.define do
  factory :profile_data, class: ProfileData  do
    type_number  3
    table_name   "similars_logs"

    # validation
    trait :type_uncorrect do
      type_number 10
    end
    trait :table_uncorrect_name do
      type_number  3
      table_name   "bla-bla-bla"
    end
    trait :table_uncorrect_data do
      type_number  3
      table_name   77
    end
  end

end