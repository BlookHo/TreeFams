FactoryGirl.define do
  factory :profile_data, class: ProfileData  do
    # validation
    # CORRECT

    profile_id  3
    last_name   "Иванов"
    biography "Текст про Иванова"
    birthday '2015-06-18 11:28:09.738909'
    country "Россия"
    city    'Москва'
    photos ["qwerty.jpeg", "ytrewq.jpeg"]
    deleted 0

    trait :correct2 do
      profile_id  4
      last_name   "Иванов"
      biography "Второй Текст про Иванова"
      birthday '2015-06-18 11:28:09.738909'
      country "Россия"
      city    'Санкт-Петербург'
      photos ["qwerty.jpeg", "ytrewq.jpeg", "dfdfdf3434.jjj"]
      deleted 0
    end

    # Test Method ProfileData connect
    trait :connect_rewrite_1 do
      profile_id  5
      last_name   "Иванов"
      biography "Текст из 5 про Иванова"
      birthday '2015-06-18 11:28:09.738909'
      country "Россия"
      city    'Санкт-Петербург'
      photos ["qwerty.jpeg", "ytrewq.jpeg"]
      deleted 0
    end
    trait :connect_rewrite_2 do
      profile_id  6
      last_name   ""
      biography ""
      birthday '1961-06-18 11:28:09.738909'
      country "Россия"
      city    ''
      photos []
      deleted 0
    end
    trait :connect_rewrite_3 do
      profile_id  7
      last_name   "Иванов"
      biography ""
      birthday '2015-06-18 11:28:09.738909'
      country ""
      city    'Санкт-Петербург'
      photos []
      deleted 0
    end
    trait :connect_rewrite_4 do
      profile_id  8
      last_name   "ИвановИЧ"
      biography "Текст из 8 про Иванова"
      birthday ''
      country "Россия"
      city    'Санкт-Петербург'
      photos []
      deleted 0
    end

    trait :connect_destroy_1 do
      profile_id 10
      last_name   "Иванов"
      biography ""
      birthday '1988-06-18 11:28:09.738909'
      country "Белоруссия"
      city    ''
      photos ["qwerty.jpeg", "ytrewq.jpeg", "dfdfdf3434.jjj"]
      deleted 0
    end
    trait :connect_destroy_2 do
      profile_id 11
      last_name   "Иванов"
      biography "Текст из 11 про Иванова"
      birthday ''
      country "Молдавия"
      city    'Кишинев'
      photos []
      deleted 0
    end
    trait :connect_destroy_3 do
      profile_id 12
      last_name   ""
      biography "Текст из 12 "
      birthday '1998-08-10 11:28:09.738909'
      country "Россия"
      city    ''
      photos []
      deleted 0
    end
    trait :connect_destroy_4 do
      profile_id 13
      last_name   "Иванов"
      biography ""
      birthday ''
      country "Китай"
      city    ''
      photos []
      deleted 0
    end

    # UNCORRECT

    # trait :type_uncorrect do
    #   type_number 10
    # end
    # trait :table_uncorrect_name do
    #   type_number  3
    #   table_name   "bla-bla-bla"
    # end
    # trait :table_uncorrect_data do
    #   type_number  3
    #   table_name   77
    # end
  end

end
