FactoryGirl.define do
  factory :profile_one, class: Profile do
   # id 38
    user_id nil
    name_id 354 # Ольга
    sex_id  0
    tree_id  5
    display_name_id  354
  end

  factory :profile_two, class: Profile do
    # id 42
    user_id nil
    name_id 354  # Ольга
    sex_id  0
    tree_id  4
    display_name_id  354
  end

  factory :profile_three, class: Profile do
    # id 41
    user_id nil
    name_id 351  # Олeг
    sex_id  1
    tree_id  4
    display_name_id  351
  end

  factory :profile_four, class: Profile do
    # id 40
    user_id nil
    name_id 351  # Олeг
    sex_id  1
    tree_id  5
    display_name_id  351
  end

end
