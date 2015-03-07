FactoryGirl.define do

  factory :profile_one, class: Profile do
    user_id nil
    name_id 354 # Ольга
    sex_id  0
    tree_id  5
    display_name_id  354

    trait :big_IDs do
      id 644444
      user_id   2222222
      name_id   90000
      sex_id    1
      tree_id   111111
    end

    trait :without_user_id do
      id 644
      user_id   nil
      name_id   900
      sex_id    1
      tree_id   111
    end





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

  factory :profile, class: Profile do          # For 2 connected trees test [1, 2]

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
      tree_id   1
    end
    # 63;7;"2015-02-18 11:53:19.475839";"2015-02-18 11:53:19.533272";40;1;7;40
    # 64;;"2015-02-18 11:53:19.564597";"2015-02-18 11:53:19.564597";90;1;7;90

    trait :profile_65 do
      id 65
      # user_id   nil
      name_id   345
      sex_id    0
      tree_id   1
    end
    trait :profile_66 do    # For 2 connected trees test - 2nd. Tree = 2. User = 2.
      id 66
      user_id   2
      name_id   370
      sex_id    1
      tree_id   1
    end
    # 65;;"2015-02-18 11:53:19.752213";"2015-02-18 11:53:19.752213";345;0;7;345
    # 66;8;"2015-02-18 11:53:19.966229";"2015-02-21 11:23:56.161504";370;1;7;370

    trait :profile_67 do
      id 67
       user_id   nil
      name_id   173
      sex_id    0
      tree_id   1
    end
    trait :profile_68 do
      id 68
      # user_id   nil
      name_id   343
      sex_id    1
      tree_id   1
    end
    # 67;;"2015-02-18 11:53:20.202033";"2015-02-18 11:53:20.202033";173;0;7;173
    # 68;;"2015-02-18 11:53:20.469564";"2015-02-18 11:53:20.469564";343;1;7;343

    trait :profile_69 do
      id 69
      # user_id   nil
      name_id   293
      sex_id    0
      tree_id   1
    end
    trait :profile_70 do
      id 70
      # user_id   nil
      name_id   354
      sex_id    0
      tree_id   1
    end
    # 69;;"2015-02-18 11:53:20.779024";"2015-02-18 11:53:20.779024";293;0;7;293
    # 70;;"2015-02-18 11:55:30.780192";"2015-02-18 11:55:30.780192";354;0;7;354

    trait :profile_78 do
      id 78
      # user_id   nil
      name_id   173
      sex_id    0
      tree_id   1
    end
    trait :profile_79 do
      id 79
      # user_id   nil
      name_id   351
      sex_id    1
      tree_id   1
    end
    # 78;;"2015-02-18 12:51:09.018631";"2015-02-18 12:51:09.018631";173;0;7;173
    # 79;;"2015-02-18 12:53:33.898579";"2015-02-18 12:53:33.898579";351;1;7;351

    trait :profile_80 do
      id 80
      # user_id   nil
      name_id   187
      sex_id    0
      tree_id   1
    end
    trait :profile_81 do
      id 81
      # user_id   nil
      name_id   354
      sex_id    0
      tree_id   1
    end
    # 80;;"2015-02-18 12:56:08.787504";"2015-02-18 12:56:08.787504";187;0;7;187
    # 81;;"2015-02-18 12:57:04.576695";"2015-02-18 12:57:04.576695";354;0;7;354

    trait :profile_82 do
      id 82
      # user_id   nil
      name_id   351
      sex_id    1
      tree_id   1
    end
    trait :profile_83 do
      id 83
      # user_id   nil
      name_id   187
      sex_id    0
      tree_id   1
    end
    trait :profile_84 do
      id 84
      # user_id   nil
      name_id   370
      sex_id    1
      tree_id   1
    end
    # 82;;"2015-02-18 12:58:04.842485";"2015-02-18 12:58:04.842485";351;1;7;351
    # 83;;"2015-02-18 13:02:25.277551";"2015-02-18 13:02:25.277551";187;0;7;187
    # 84;;"2015-02-18 13:04:59.909606";"2015-02-21 11:23:56.137504";370;1;7;370

    # After Connected Similars

    # 63;7;"2015-02-18 11:53:19.475839";"2015-02-18 11:53:19.533272";40;1;7
    # 64;;"2015-02-18 11:53:19.564597";"2015-02-18 11:53:19.564597";90;1;7
    # 65;;"2015-02-18 11:53:19.752213";"2015-02-18 11:53:19.752213";345;0;7
    # 66;;"2015-02-18 11:53:19.966229";"2015-02-27 07:50:08.392771";370;1;7
    # 67;;"2015-02-18 11:53:20.202033";"2015-02-18 11:53:20.202033";173;0;7
    # 68;;"2015-02-18 11:53:20.469564";"2015-02-18 11:53:20.469564";343;1;7
    # 69;;"2015-02-18 11:53:20.779024";"2015-02-18 11:53:20.779024";293;0;7
    # 70;;"2015-02-18 11:55:30.780192";"2015-02-18 11:55:30.780192";354;0;7
    # 78;;"2015-02-18 12:51:09.018631";"2015-02-18 12:51:09.018631";173;0;7
    # 79;;"2015-02-18 12:53:33.898579";"2015-02-18 12:53:33.898579";351;1;7
    # 80;;"2015-02-18 12:56:08.787504";"2015-02-18 12:56:08.787504";187;0;7
    # 81;;"2015-02-18 12:57:04.576695";"2015-02-18 12:57:04.576695";354;0;7
    # 82;;"2015-02-18 12:58:04.842485";"2015-02-18 12:58:04.842485";351;1;7
    # 83;;"2015-02-18 13:02:25.277551";"2015-02-18 13:02:25.277551";187;0;7
    # 84;8;"2015-02-18 13:04:59.909606";"2015-02-27 09:37:43.193764";370;1;7

    # After DisConnected Similars

    # 63;7;"2015-02-18 11:53:19.475839";"2015-02-18 11:53:19.533272";40;1;7
    # 64;;"2015-02-18 11:53:19.564597";"2015-02-18 11:53:19.564597";90;1;7
    # 65;;"2015-02-18 11:53:19.752213";"2015-02-18 11:53:19.752213";345;0;7
    # 66;8;"2015-02-18 11:53:19.966229";"2015-02-27 09:52:29.160826";370;1;7
    # 67;;"2015-02-18 11:53:20.202033";"2015-02-18 11:53:20.202033";173;0;7
    # 68;;"2015-02-18 11:53:20.469564";"2015-02-18 11:53:20.469564";343;1;7
    # 69;;"2015-02-18 11:53:20.779024";"2015-02-18 11:53:20.779024";293;0;7
    # 70;;"2015-02-18 11:55:30.780192";"2015-02-18 11:55:30.780192";354;0;7
    # 78;;"2015-02-18 12:51:09.018631";"2015-02-18 12:51:09.018631";173;0;7
    # 79;;"2015-02-18 12:53:33.898579";"2015-02-18 12:53:33.898579";351;1;7
    # 80;;"2015-02-18 12:56:08.787504";"2015-02-18 12:56:08.787504";187;0;7
    # 81;;"2015-02-18 12:57:04.576695";"2015-02-18 12:57:04.576695";354;0;7
    # 82;;"2015-02-18 12:58:04.842485";"2015-02-18 12:58:04.842485";351;1;7
    # 83;;"2015-02-18 13:02:25.277551";"2015-02-18 13:02:25.277551";187;0;7
    # 84;;"2015-02-18 13:04:59.909606";"2015-02-27 09:52:29.138577";370;1;7

  end

  factory :add_profile, class: Profile do          # For 2 connected trees test [1, 2]


    # Before Add new Profile
    trait :add_profile_85 do  # user_9   # before
      id 85
      user_id   9
      name_id   370
      sex_id    1
      tree_id   9
    end
    trait :add_profile_86 do
      id 86
      user_id   nil
      name_id   28
      sex_id    1
      tree_id   9
    end
    trait :add_profile_87 do
      id 87
      user_id   nil
      name_id   48
      sex_id    0
      tree_id   9
    end
    # 85;9;"2015-03-05 17:52:17.536001";"2015-03-05 17:52:17.633286";370;1;9;370
    # 86;;"2015-03-05 17:52:17.702448";"2015-03-05 17:52:17.702448";28;1;9;28
    # 87;;"2015-03-05 17:52:17.979356";"2015-03-05 17:52:17.979356";48;0;9;48

    trait :add_profile_88 do # before
      id 88
      user_id   9
      name_id   465
      sex_id    1
      tree_id   9
    end
    trait :add_profile_89 do # before
      id 89
      user_id   nil
      name_id   345
      sex_id    0
      tree_id   9
    end
    trait :add_profile_90 do # before
      id 90
      user_id   nil
      name_id   343
      sex_id    1
      tree_id   9
    end
    # 88;;"2015-03-05 17:52:18.23326";"2015-03-05 17:52:18.23326";465;1;9;465
    # 89;;"2015-03-05 17:52:18.532318";"2015-03-05 17:52:18.532318";345;0;9;345
    # 90;;"2015-03-05 17:52:18.843907";"2015-03-05 17:52:18.843907";343;1;9;343

    trait :add_profile_91 do # before
      id 91
      user_id   nil
      name_id   446
      sex_id    0
      tree_id   9
    end
    trait :add_profile_92 do
      id 92
      user_id   nil
      name_id   147
      sex_id    0
      tree_id   9
    end
    # 91;;"2015-03-05 17:52:19.201909";"2015-03-05 17:52:19.201909";446;0;9;446
    # 92;;"2015-03-05 17:52:19.668259";"2015-03-05 17:52:19.668259";147;0;9;147


    trait :add_profile_93 do  # user_10
      id 93
      user_id   10
      name_id   147
      sex_id    0
      tree_id   10
    end
    trait :add_profile_94 do
      id 94
      user_id   nil
      name_id   28
      sex_id    1
      tree_id   10
    end
    trait :add_profile_95 do
      id 95
      user_id   nil
      name_id   48
      sex_id    0
      tree_id   10
    end
    # 93;10;"2015-03-05 17:56:30.580363";"2015-03-05 17:56:30.641443";147;0;10;147
    # 94;;"2015-03-05 17:56:30.681683";"2015-03-05 17:56:30.681683";28;1;10;28
    # 95;;"2015-03-05 17:56:30.818424";"2015-03-05 17:56:30.818424";48;0;10;48

    trait :add_profile_96 do
      id 96
      user_id   nil
      name_id   465
      sex_id    1
      tree_id   10
    end
    trait :add_profile_97 do
      id 97
      user_id   nil
      name_id   345
      sex_id    0
      tree_id   10
    end
    trait :add_profile_98 do
      id 98
      user_id   nil
      name_id   343
      sex_id    1
      tree_id   10
    end
    # 96;;"2015-03-05 17:56:31.071608";"2015-03-05 17:56:31.071608";465;1;10;465
    # 97;;"2015-03-05 17:56:31.365143";"2015-03-05 17:56:31.365143";345;0;10;345
    # 98;;"2015-03-05 17:56:31.761053";"2015-03-05 17:56:31.761053";343;1;10;343

    trait :add_profile_99 do
      id 99
      user_id   nil
      name_id   446
      sex_id    0
      tree_id   10
    end
    trait :add_profile_100 do
      id 100
      user_id   nil
      name_id   370
      sex_id    1
      tree_id   10
    end
    # 99;;"2015-03-05 17:56:32.29124";"2015-03-05 17:56:32.29124";446;0;10;446
    # 100;;"2015-03-05 17:56:32.835348";"2015-03-05 17:56:32.835348";370;1;10;370

    # profiles to Add
    trait :add_profile_101 do  # Семен
      id 101
      user_id   nil
      name_id   419
      sex_id    1
      tree_id   10 # ?
    end
    trait :add_profile_102 do  # Светлана
      id 102
      user_id   nil
      name_id   412
      sex_id    0
      tree_id   10  # ?
    end





  end



end




