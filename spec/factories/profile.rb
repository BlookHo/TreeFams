FactoryGirl.define do
  factory :profile_one, class: Profile do
    user_id nil
    name_id 354 # Ольга
    sex_id  0
    tree_id  5
    display_name_id  354
  end

  factory :profile_two, class: Profile do
    user_id nil
    name_id 354  # Ольга
    sex_id  0
    tree_id  4
    display_name_id  354
  end

  factory :profile_three, class: Profile do
    user_id nil
    name_id 351  # Олeг
    sex_id  1
    tree_id  4
    display_name_id  351
  end

  factory :profile_four, class: Profile do
    user_id nil
    name_id 351  # Олeг
    sex_id  1
    tree_id  5
    display_name_id  351
  end

  factory :profile do          # For 2 connected trees test [1, 2]

    trait :profile_63 do        # For 2 connected trees test - 1st. Tree = 1. User = 1.
      id 63
      user_id   1
      name_id   40
      sex_id    1
      tree_id   1
    end
    trait :profile_64 do
      id 64
      user_id   nil
      name_id   90
      sex_id    1
      # tree_id   1
    end
    # 63;7;"2015-02-18 11:53:19.475839";"2015-02-18 11:53:19.533272";40;1;7;40
    # 64;;"2015-02-18 11:53:19.564597";"2015-02-18 11:53:19.564597";90;1;7;90

    trait :profile_65 do
      id 65
      # user_id   nil
      name_id   345
      sex_id    0
      # tree_id   1
    end
    trait :profile_66 do    # For 2 connected trees test - 2nd. Tree = 2. User = 2.
      id 66
      user_id   2
      name_id   370
      sex_id    1
      # tree_id   1
    end
    # 65;;"2015-02-18 11:53:19.752213";"2015-02-18 11:53:19.752213";345;0;7;345
    # 66;8;"2015-02-18 11:53:19.966229";"2015-02-21 11:23:56.161504";370;1;7;370

    trait :profile_67 do
      id 67
      user_id   nil
      name_id   173
      sex_id    0
      # tree_id   1
    end
    trait :profile_68 do
      id 68
      # user_id   nil
      name_id   343
      sex_id    1
      # tree_id   1
    end
    # 67;;"2015-02-18 11:53:20.202033";"2015-02-18 11:53:20.202033";173;0;7;173
    # 68;;"2015-02-18 11:53:20.469564";"2015-02-18 11:53:20.469564";343;1;7;343

    trait :profile_69 do
      id 69
      # user_id   nil
      name_id   293
      sex_id    0
      # tree_id   1
    end
    trait :profile_70 do
      id 70
      # user_id   nil
      name_id   354
      sex_id    0
      # tree_id   1
    end
    # 69;;"2015-02-18 11:53:20.779024";"2015-02-18 11:53:20.779024";293;0;7;293
    # 70;;"2015-02-18 11:55:30.780192";"2015-02-18 11:55:30.780192";354;0;7;354

    trait :profile_78 do
      id 78
      # user_id   nil
      name_id   173
      sex_id    0
      # tree_id   1
    end
    trait :profile_79 do
      id 79
      # user_id   nil
      name_id   351
      sex_id    1
      # tree_id   1
    end
    # 78;;"2015-02-18 12:51:09.018631";"2015-02-18 12:51:09.018631";173;0;7;173
    # 79;;"2015-02-18 12:53:33.898579";"2015-02-18 12:53:33.898579";351;1;7;351

    trait :profile_80 do
      id 80
      # user_id   nil
      name_id   187
      sex_id    0
      # tree_id   1
    end
    trait :profile_81 do
      id 81
      # user_id   nil
      name_id   354
      sex_id    0
      # tree_id   1
    end
    # 80;;"2015-02-18 12:56:08.787504";"2015-02-18 12:56:08.787504";187;0;7;187
    # 81;;"2015-02-18 12:57:04.576695";"2015-02-18 12:57:04.576695";354;0;7;354

    trait :profile_82 do
      id 82
      # user_id   nil
      name_id   351
      sex_id    1
      # tree_id   1
    end
    trait :profile_83 do
      id 83
      # user_id   nil
      name_id   187
      sex_id    0
      # tree_id   1
    end
    trait :profile_84 do
      id 84
      # user_id   nil
      name_id   370
      sex_id    1
      # tree_id   1
    end
    # 82;;"2015-02-18 12:58:04.842485";"2015-02-18 12:58:04.842485";351;1;7;351
    # 83;;"2015-02-18 13:02:25.277551";"2015-02-18 13:02:25.277551";187;0;7;187
    # 84;;"2015-02-18 13:04:59.909606";"2015-02-21 11:23:56.137504";370;1;7;370

  end



end
