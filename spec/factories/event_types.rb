FactoryGirl.define do
  factory :event_type, class: EventType  do
    type_number  5
    name   "переименование"

    # validation
    trait :type_uncorrect do
      type_number 100
    end
    # trait :table_uncorrect_name do
    #   type_number  3
    #   name   "bla-bla-bla"
    # end
    trait :uncorrect_name do
      type_number  3
      name   77
    end
  end
    
end
