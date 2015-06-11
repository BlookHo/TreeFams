FactoryGirl.define do

  factory :profile_one, class: Profile do
    user_id 1
    name_id 354 # Ольга
    sex_id  1
    tree_id  5
    display_name_id  354
    deleted  0

    trait :big_IDs do
      id 644444
      user_id   2222222
      name_id   9000
      sex_id    1
      tree_id   111111
      deleted  0

    end

    trait :without_user_id do
      id 644
      user_id   nil
      name_id   900
      sex_id    1
      tree_id   111
      deleted  0

    end

  end

  factory :profile_two, class: Profile do
    user_id nil
    name_id 354  # Ольга
    sex_id  0
    tree_id  4
    display_name_id  354
    deleted  0
  end

  factory :profile_three, class: Profile do
    user_id 3
    name_id 351  # Олeг
    sex_id  1
    tree_id  4
    display_name_id  351
    deleted  0
  end

  factory :profile_four, class: Profile do
    user_id nil
    name_id 351  # Олeг
    sex_id  1
    tree_id  5
    display_name_id  351
    deleted  0
  end

  factory :profile, class: Profile do          # For 2 connected trees test [1, 2]

    trait :profile_63 do        # For 2 connected trees test - 1st. Tree = 1. User = 1.
      id 63
      user_id   1
      name_id   40
      sex_id    1
      tree_id   1
      deleted  0
    end
    trait :profile_64 do
      id 64
      user_id   nil
      name_id   90
      sex_id    1
      tree_id   1
      deleted  0
    end
    # 63;7;"2015-02-18 11:53:19.475839";"2015-02-18 11:53:19.533272";40;1;7;40
    # 64;;"2015-02-18 11:53:19.564597";"2015-02-18 11:53:19.564597";90;1;7;90

    trait :profile_65 do
      id 65
      # user_id   nil
      name_id   345
      sex_id    0
      tree_id   1
      deleted  0
    end
    trait :profile_66 do    # For 2 connected trees test - 2nd. Tree = 2. User = 2.
      id 66
      user_id   2
      name_id   370
      sex_id    1
      tree_id   1
      deleted  0
    end
    # 65;;"2015-02-18 11:53:19.752213";"2015-02-18 11:53:19.752213";345;0;7;345
    # 66;8;"2015-02-18 11:53:19.966229";"2015-02-21 11:23:56.161504";370;1;7;370

    trait :profile_67 do
      id 67
       user_id   nil
      name_id   173
      sex_id    0
      tree_id   1
      deleted  0
    end
    trait :profile_68 do
      id 68
      # user_id   nil
      name_id   343
      sex_id    1
      tree_id   1
      deleted  0
    end
    # 67;;"2015-02-18 11:53:20.202033";"2015-02-18 11:53:20.202033";173;0;7;173
    # 68;;"2015-02-18 11:53:20.469564";"2015-02-18 11:53:20.469564";343;1;7;343

    trait :profile_69 do
      id 69
      # user_id   nil
      name_id   293
      sex_id    0
      tree_id   1
      deleted  0
    end
    trait :profile_70 do
      id 70
      # user_id   nil
      name_id   354
      sex_id    0
      tree_id   1
      deleted  0
    end
    # 69;;"2015-02-18 11:53:20.779024";"2015-02-18 11:53:20.779024";293;0;7;293
    # 70;;"2015-02-18 11:55:30.780192";"2015-02-18 11:55:30.780192";354;0;7;354

    trait :profile_78 do
      id 78
      # user_id   nil
      name_id   173
      sex_id    0
      tree_id   1
      deleted  0
    end
    trait :profile_79 do
      id 79
      # user_id   nil
      name_id   351
      sex_id    1
      tree_id   1
      deleted  0
    end
    # 78;;"2015-02-18 12:51:09.018631";"2015-02-18 12:51:09.018631";173;0;7;173
    # 79;;"2015-02-18 12:53:33.898579";"2015-02-18 12:53:33.898579";351;1;7;351

    trait :profile_80 do
      id 80
      # user_id   nil
      name_id   187
      sex_id    0
      tree_id   1
      deleted  0
    end
    trait :profile_81 do
      id 81
      # user_id   nil
      name_id   354
      sex_id    0
      tree_id   1
      deleted  0
    end
    # 80;;"2015-02-18 12:56:08.787504";"2015-02-18 12:56:08.787504";187;0;7;187
    # 81;;"2015-02-18 12:57:04.576695";"2015-02-18 12:57:04.576695";354;0;7;354

    trait :profile_82 do
      id 82
      # user_id   nil
      name_id   351
      sex_id    1
      tree_id   1
      deleted  0
    end
    trait :profile_83 do
      id 83
      # user_id   nil
      name_id   187
      sex_id    0
      tree_id   1
      deleted  0
    end
    trait :profile_84 do
      id 84
      # user_id   nil
      name_id   370
      sex_id    1
      tree_id   1
      deleted  0
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
      deleted  0
    end
    trait :add_profile_86 do
      id 86
      user_id   nil
      name_id   28
      sex_id    1
      tree_id   9
      deleted  0
    end
    trait :add_profile_87 do
      id 87
      user_id   nil
      name_id   48
      sex_id    0
      tree_id   9
      deleted  0
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
      deleted  0
    end
    trait :add_profile_89 do # before
      id 89
      user_id   nil
      name_id   345
      sex_id    0
      tree_id   9
      deleted  0
    end
    trait :add_profile_90 do # before
      id 90
      user_id   nil
      name_id   343
      sex_id    1
      tree_id   9
      deleted  0
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
      deleted  0
    end
    trait :add_profile_92 do
      id 92
      user_id   nil
      name_id   147
      sex_id    0
      tree_id   9
      deleted  0
    end
    # 91;;"2015-03-05 17:52:19.201909";"2015-03-05 17:52:19.201909";446;0;9;446
    # 92;;"2015-03-05 17:52:19.668259";"2015-03-05 17:52:19.668259";147;0;9;147


    trait :add_profile_93 do  # user_10
      id 93
      user_id   10
      name_id   147
      sex_id    0
      tree_id   10
      deleted  0
    end
    trait :add_profile_94 do
      id 94
      user_id   nil
      name_id   28
      sex_id    1
      tree_id   10
      deleted  0
    end
    trait :add_profile_95 do
      id 95
      user_id   nil
      name_id   48
      sex_id    0
      tree_id   10
      deleted  0
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
      deleted  0
    end
    trait :add_profile_97 do
      id 97
      user_id   nil
      name_id   345
      sex_id    0
      tree_id   10
      deleted  0
    end
    trait :add_profile_98 do
      id 98
      user_id   nil
      name_id   343
      sex_id    1
      tree_id   10
      deleted  0
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
      deleted  0
    end
    trait :add_profile_100 do
      id 100
      user_id   nil
      name_id   370
      sex_id    1
      tree_id   10
      deleted  0
    end
    # 99;;"2015-03-05 17:56:32.29124";"2015-03-05 17:56:32.29124";446;0;10;446
    # 100;;"2015-03-05 17:56:32.835348";"2015-03-05 17:56:32.835348";370;1;10;370

    # profiles to Add
    trait :add_profile_101 do  # Семен
      id 101
      user_id   nil
      name_id   419
      sex_id    1
      tree_id   9 #
      deleted  0
    end
    trait :add_profile_102 do  # Светлана
      id 102
      user_id   nil
      name_id   412
      sex_id    0
      tree_id   9  #
      deleted  0
    end

    # For Common_Logs Tree 9

    trait :add_profile_172 do  # Вячеслав
      id 172
      user_id   nil
      name_id   122
      sex_id    1
      tree_id   9 #
      deleted  0
    end
    trait :add_profile_173 do  # Валентина
      id 173
      user_id   nil
      name_id   82
      sex_id    0
      tree_id   9  #
      deleted  0
    end
    # 172;;"2015-03-21 14:18:28.192824";"2015-03-21 14:18:28.192824";122;1;9;122
    # 173;;"2015-03-21 14:18:44.147049";"2015-03-21 14:18:44.147049";82;0;9;82


  end


  #for add del logs

  # 85;9;"2015-03-05 17:52:17.536001";"2015-03-05 17:52:17.633286";370;1;9
  # 86;;"2015-03-05 17:52:17.702448";"2015-03-05 17:52:17.702448";28;1;9
  # 87;;"2015-03-05 17:52:17.979356";"2015-03-05 17:52:17.979356";48;0;9
  # 88;;"2015-03-05 17:52:18.23326";"2015-03-05 17:52:18.23326";465;1;9
  # 89;;"2015-03-05 17:52:18.532318";"2015-03-05 17:52:18.532318";345;0;9
  # 90;;"2015-03-05 17:52:18.843907";"2015-03-05 17:52:18.843907";343;1;9
  # 91;;"2015-03-05 17:52:19.201909";"2015-03-05 17:52:19.201909";446;0;9
  # 92;;"2015-03-05 17:52:19.668259";"2015-03-05 17:52:19.668259";147;0;9
  # 93;10;"2015-03-05 17:56:30.580363";"2015-03-05 17:56:30.641443";147;0;10
  # 94;;"2015-03-05 17:56:30.681683";"2015-03-05 17:56:30.681683";28;1;10
  # 95;;"2015-03-05 17:56:30.818424";"2015-03-05 17:56:30.818424";48;0;10
  # 96;;"2015-03-05 17:56:31.071608";"2015-03-05 17:56:31.071608";465;1;10
  # 97;;"2015-03-05 17:56:31.365143";"2015-03-05 17:56:31.365143";345;0;10
  # 98;;"2015-03-05 17:56:31.761053";"2015-03-05 17:56:31.761053";343;1;10
  # 99;;"2015-03-05 17:56:32.29124";"2015-03-05 17:56:32.29124";446;0;10
  # 100;;"2015-03-05 17:56:32.835348";"2015-03-05 17:56:32.835348";370;1;10

  # For Common_Logs Tree 9

  # 168;;"2015-03-21 12:07:38.52559";"2015-03-21 12:07:38.52559";110;1;10;110
  # 169;;"2015-03-21 12:08:00.215097";"2015-03-21 12:08:00.215097";97;0;10;97
  # 170;;"2015-03-21 12:08:25.525604";"2015-03-21 12:08:25.525604";28;1;10;28
  # 171;;"2015-03-21 12:08:42.482498";"2015-03-21 12:08:42.482498";48;0;10;48
  # 172;;"2015-03-21 14:18:28.192824";"2015-03-21 14:18:28.192824";122;1;9;122
  # 173;;"2015-03-21 14:18:44.147049";"2015-03-21 14:18:44.147049";82;0;9;82


  factory :connect_profile, class: Profile do   # For Cinnection Trees TEST: 2 connected trees test [1, 2]


      # id 1     # user_4   # before
      user_id   nil
      name_id   370
      sex_id    1
      tree_id   4
      deleted  0

      trait :connect_profile_2  do   # 2
        # id 86
        user_id   nil
        name_id   122
        sex_id    1
        tree_id   1
        deleted  0
      end
      trait :connect_profile_3  do   # 3
        # id 86
        # user_id   nil
        name_id   82
        sex_id    0
        tree_id   1
        deleted  0
      end
      trait :connect_profile_7  do   # 7
        id 7
        # user_id   nil
        name_id   90
        sex_id    1
        tree_id   1
        deleted  0
      end
      # 2;;"2015-01-23 07:31:58.060264";"2015-01-23 07:31:58.060264";122;1;1;122
      # 3;;"2015-01-23 07:31:58.344427";"2015-01-23 07:31:58.344427";82;0;1;82
      # 7;;"2015-01-23 07:31:59.414155";"2015-01-23 07:31:59.414155";90;1;1;90

      trait :connect_profile_8  do   # 8
        id 8
        # user_id   nil
        name_id   449
        sex_id    0
        tree_id   1
        deleted  0
      end
      trait :connect_profile_9  do   # 9
        id 9
        # user_id   nil
        name_id   361
        sex_id    1
        tree_id   1
        deleted  0
      end
      trait :connect_profile_10 do   # 10
        id 10
        # user_id   nil
        name_id   293
        sex_id    0
        tree_id   1
        deleted  0
      end
      # 8;;"2015-01-23 07:31:59.860816";"2015-01-23 07:31:59.860816";449;0;1;449
      # 9;;"2015-01-23 07:32:00.169704";"2015-01-23 07:32:00.169704";361;1;1;361
      # 10;;"2015-01-23 07:32:00.422691";"2015-01-23 07:32:00.422691";293;0;1;293


      trait :connect_profile_11 do   # 11
        id 11
        user_id   2
        name_id   48
        sex_id    0
        tree_id   2
        deleted  0
      end
      trait :connect_profile_12 do   # 12
        id 12
        user_id   nil
        name_id   343
        sex_id    1
        tree_id   2
        deleted  0
      end
      trait :connect_profile_13 do   # 13
        id 13
        user_id   nil
        name_id   82
        sex_id    0
        tree_id   2
        deleted  0
      end
      # 11;2;"2015-01-23 07:37:32.790612";"2015-01-23 07:37:32.809612";48;0;2;516
      # 12;;"2015-01-23 07:37:32.842851";"2015-01-23 07:37:32.842851";343;1;2;343
      # 13;;"2015-01-23 07:37:33.071763";"2015-01-23 07:37:33.071763";82;0;2;82


      trait :connect_profile_14 do   # 14
        id 14
        user_id   nil
        name_id   331
        sex_id    0
        tree_id   2
        deleted  0
      end
      trait :connect_profile_15 do   # 15
        id 15
        user_id   nil
        name_id   370
        sex_id    1
        tree_id   2
        deleted  0
      end
      trait :connect_profile_16 do   # 16
        id 16
        user_id   nil
        name_id   465
        sex_id    1
        tree_id   2
        deleted  0
      end
      # 14;;"2015-01-23 07:37:33.246236";"2015-01-23 07:37:33.246236";331;0;2;331
      # 15;;"2015-01-23 07:37:33.477205";"2015-01-23 07:37:33.477205";370;1;2;370
      # 16;;"2015-01-23 07:37:33.768574";"2015-01-23 07:37:33.768574";465;1;2;465


      trait :connect_profile_17 do   # 17
        id 17
        user_id   1
        name_id   28
        sex_id    1
        tree_id   1
        deleted  0
      end
      trait :connect_profile_18 do   # 18
        id 18
        user_id   nil
        name_id   194
        sex_id    1
        tree_id   2
        deleted  0
      end
      trait :connect_profile_19 do   # 19
        id 19
        user_id   nil
        name_id   48
        sex_id    0
        tree_id   2
        deleted  0
      end
      # 17;1;"2015-01-23 07:37:34.089346";"2015-01-23 07:37:34.089346";28;1;1;28
      # 18;;"2015-01-23 07:37:34.388327";"2015-01-23 07:37:34.388327";194;1;2;194
      # 19;;"2015-01-23 07:37:34.722199";"2015-01-23 07:37:34.722199";48;0;2;48


      trait :connect_profile_20 do   # 20
        id 20
        user_id   nil
        name_id   110
        sex_id    1
        tree_id   2
        deleted  0
      end
      trait :connect_profile_21 do   # 21
        id 21
        user_id   nil
        name_id   249
        sex_id    0
        tree_id   2
        deleted  0
      end
      trait :connect_profile_22 do   # 22
        id 22
        user_id   3
        name_id   331
        sex_id    0
        tree_id   3
        deleted  0
      end
      # 20;;"2015-01-23 07:37:35.175336";"2015-01-23 07:37:35.175336";110;1;2;110
      # 21;;"2015-01-23 07:37:35.446917";"2015-01-23 07:37:35.446917";249;0;2;249
      # 22;3;"2015-01-23 07:47:59.810321";"2015-01-23 07:47:59.82969";331;0;3;331


      trait :connect_profile_23 do   # 23
        id 23
        user_id   nil
        name_id   343
        sex_id    1
        tree_id   3
        deleted  0
      end
      trait :connect_profile_24 do   # 24
        id 24
        user_id   nil
        name_id   82
        sex_id    0
        tree_id   3
        deleted  0
      end
      trait :connect_profile_25 do   # 25
        id 25
        user_id   nil
        name_id   48
        sex_id    0
        tree_id   3
        deleted  0
      end
      # 23;;"2015-01-23 07:47:59.853552";"2015-01-23 07:47:59.853552";343;1;3;343
      # 24;;"2015-01-23 07:47:59.967496";"2015-01-23 07:47:59.967496";82;0;3;82
      # 25;;"2015-01-23 07:48:00.145801";"2015-01-23 07:48:00.145801";48;0;3;516


      trait :connect_profile_26 do   # 26
        id 26
        user_id   nil
        name_id   194
        sex_id    1
        tree_id   3
        deleted  0
      end
      trait :connect_profile_27 do   # 27
        id 27
        user_id   nil
        name_id   48
        sex_id    0
        tree_id   3
        deleted  0
      end
      trait :connect_profile_28 do   # 28
        id 28
        user_id   nil
        name_id   110
        sex_id    1
        tree_id   3
        deleted  0
      end
      # 26;;"2015-01-23 07:48:00.389447";"2015-01-23 07:48:00.389447";194;1;3;194
      # 27;;"2015-01-23 07:48:00.703992";"2015-01-23 07:48:00.703992";48;0;3;48
      # 28;;"2015-01-23 07:48:01.020452";"2015-01-23 07:48:01.020452";110;1;3;110


      trait :connect_profile_29 do   # 29
        id 29
        user_id   nil
        name_id   249
        sex_id    0
        tree_id   3
        deleted  0
      end
      # 29;;"2015-01-23 07:48:01.321049";"2015-01-23 07:48:01.321049";249;0;3;249

  end


end




