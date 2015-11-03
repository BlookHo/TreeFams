require 'faker'

FactoryGirl.define do

  factory :test_model_name, class: Name do |f|
    f.id {Faker::Number.number(3)}
    f.name { Faker::Name.first_name }
    f.only_male { [true, false].sample }
    f.name_freq { Faker::Number.number(6) }
    f.is_approved { [true, false].sample }
    f.sex_id {Faker::Number.between(0, 1)}
    # f.parent_name_id { Faker::Number.number(3) }
    # f.search_name_id {Faker::Number.number(3)}
  end


  factory :name  do

    trait :name_28 do
      id      28
      name    "Алексей"
      sex_id  1
    end
    trait :name_40 do
      id      40
      name    "Андрей"
      sex_id  1
    end
    trait :name_48 do
      id      48
      name    "Анна"
      sex_id  0
    end
    trait :name_82 do
      id      82
      name    "Валентина"
      sex_id  0
    end
    trait :name_90 do
      id      90
      name    "Василий"
      sex_id  1
    end
    trait :name_97 do
      id      97
      name    "Вера"
      sex_id  0
    end
    trait :name_110 do
      id      110
      name    "Владимир"
      sex_id  1
    end
    trait :name_122 do
      id      122
      name    "Вячеслав"
      sex_id  1
    end
    trait :name_147 do
      id      147
      name    "Дарья"
      sex_id  0
    end
    trait :name_173 do
      id      173
      name    "Елена"
      sex_id  0
    end
    trait :name_194 do
      id      194
      name    "Иван"
      sex_id  1
    end
    trait :name_249 do
      id      249
      name    "Ксения"
      sex_id  0
    end
    trait :name_293 do
      id      293
      name    "Мария"
      sex_id  0
    end
    trait :name_331 do
      id      331
      name    "Наталья"
      sex_id  0
    end
    trait :name_343 do
      id      343
      name    "Николай"
      sex_id  1
    end
    trait :name_345 do
      id      345
      name    "Нина"
      sex_id  0
    end
    trait :name_351 do
      id      351
      name    "Олег"
      sex_id  1
    end
    trait :name_354 do
      id      354
      name    "Ольга"
      sex_id  0
    end
    trait :name_361 do
      id      361
      name    "Павел"
      sex_id  1
    end
    trait :name_370 do
      id      370
      name    "Петр"
      sex_id  1
    end
    trait :name_412 do
      id      412
      name    "Светлана"
      sex_id  0
    end
    trait :name_419 do
      id      419
      name    "Семен"
      sex_id  1
    end
    trait :name_422 do
      id      422
      name    "Сергей"
      sex_id  1
    end
    trait :name_446 do
      id      446
      name    "Таисия"
      sex_id  0
    end
    trait :name_449 do
      id      449
      name    "Татьяна"
      sex_id  0
    end
    trait :name_465 do
      id      465
      name    "Федор"
      sex_id  1
    end


  end

end
