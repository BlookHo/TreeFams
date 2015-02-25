FactoryGirl.define do
  factory :tree do

    # Connected tree users [1, 2] with similars
    trait :tree1_with_sims_1  do   # User = 1. Tree = 1
      user_id         1
      profile_id      63
      relation_id     1
      name_id         40
      is_profile_id   64
      is_name_id      90
      is_sex_id       1
    end
    trait :tree1_with_sims_2 do
      relation_id     2
      is_profile_id   65
      is_name_id      345
      is_sex_id       0
    end
    trait :tree1_with_sims_3 do
      relation_id     5
      is_profile_id   66
      is_name_id      370
      is_sex_id       1
    end
                                                                          #  name is_pr is_nam is_sex
    # 57;7;63;1;FALSE;"2015-02-18 11:53:19.612469";"2015-02-18 11:53:19.612469";40;64;90;1;40;90 . Tree = 1
    # 58;7;63;2;FALSE;"2015-02-18 11:53:19.835164";"2015-02-18 11:53:19.835164";40;65;345;0;40;345
    # 59;7;63;5;FALSE;"2015-02-18 11:53:20.044469";"2015-02-21 11:23:56.472414";40;66;370;1;40;370

    trait :tree1_with_sims_4 do
      relation_id     8
      is_profile_id   67
      is_name_id      173
      is_sex_id       0
    end
    trait :tree1_with_sims_5 do
      profile_id      64
      relation_id     1
      name_id         90
      is_profile_id   68
      is_name_id      343
      is_sex_id       1
    end
    trait :tree1_with_sims_6 do
      relation_id     2
      is_profile_id   69
      is_name_id      293
      is_sex_id       0
    end
    trait :tree1_with_sims_7 do  # User = 2. Tree = 2
     profile_id      66
      relation_id     8
      name_id         370
      is_profile_id   70
      is_name_id      354
      is_sex_id       0
    end
    # 60;7;63;8;FALSE;"2015-02-18 11:53:20.286186";"2015-02-18 11:53:20.286186";40;67;173;0;40;173
    # 61;7;64;1;FALSE;"2015-02-18 11:53:20.55881";"2015-02-18 11:53:20.55881";90;68;343;1;90;343
    # 62;7;64;2;FALSE;"2015-02-18 11:53:20.873583";"2015-02-18 11:53:20.873583";90;69;293;0;90;293
    # 63;7;66;8;FALSE;"2015-02-18 11:55:30.892263";"2015-02-21 11:23:56.362571";370;70;354;0;370;354 . Tree = 2

    trait :tree1_with_sims_8 do
      user_id         2
      profile_id      66
      relation_id     1
      is_profile_id   64
      is_name_id      90
      is_sex_id       1
    end
    trait :tree1_with_sims_9 do
      relation_id     2
      is_profile_id   65
      is_name_id      345
      is_sex_id       0
    end
    trait :tree1_with_sims_10 do
      relation_id     5
      is_profile_id   63
      is_name_id      40
      is_sex_id       1
    end
    # 64;8;66;1;FALSE;"2015-02-18 11:57:30.313108";"2015-02-21 11:23:56.249257";370;64;90;1;370;90
    # 65;8;66;2;FALSE;"2015-02-18 11:57:30.453692";"2015-02-21 11:23:56.273256";370;65;345;0;370;345
    # 66;8;66;5;FALSE;"2015-02-18 11:57:30.674924";"2015-02-21 11:23:56.295973";370;63;40;1;370;40

    trait :tree1_with_sims_11 do
      relation_id     8
      is_profile_id   70
      is_name_id      354
      is_sex_id       0
    end
    trait :tree1_with_sims_12 do
      profile_id      64
      relation_id     1
      name_id         90
      is_profile_id   68
      is_name_id      343
      is_sex_id       1
    end
    trait :tree1_with_sims_13 do
      relation_id     2
      is_profile_id   69
      is_name_id      293
      is_sex_id       0
    end
    # 67;8;66;8;FALSE;"2015-02-18 11:57:30.924718";"2015-02-21 11:23:56.385322";370;70;354;0;370;354
    # 68;8;64;1;FALSE;"2015-02-18 11:57:31.321098";"2015-02-18 11:59:34.676374";90;68;343;1;90;343
    # 69;8;64;2;FALSE;"2015-02-18 11:57:31.64299";"2015-02-18 11:59:34.607702";90;69;293;0;90;293

    trait :tree1_with_sims_14 do
      user_id         1
      profile_id      70
      relation_id     6
        name_id         354
      is_profile_id   78
      is_name_id      173
      is_sex_id       0
    end
    trait :tree1_with_sims_15 do
      relation_id     1
      is_profile_id   79
      is_name_id      351
      is_sex_id       1
    end
    trait :tree1_with_sims_16 do
      profile_id      79
      relation_id     8
      name_id         351
      is_profile_id   80
      is_name_id      187
      is_sex_id       0
    end
    # 70;7;70;6;FALSE;"2015-02-18 12:51:09.133449";"2015-02-21 11:23:56.453657";354;78;173;0;354;173
    # 71;7;70;1;FALSE;"2015-02-18 12:53:34.019808";"2015-02-21 11:23:56.404379";354;79;351;1;354;351
    # 72;7;79;8;FALSE;"2015-02-18 12:56:08.886739";"2015-02-21 11:23:56.428963";351;80;187;0;351;187

    trait :tree1_with_sims_17 do
      profile_id      67
      relation_id     6
      name_id         173
      is_profile_id   81
      is_name_id      354
      is_sex_id       0
    end
    trait :tree1_with_sims_18 do
      relation_id     1
      is_profile_id   82
      is_name_id      351
      is_sex_id       1
    end
    # 73;7;67;6;FALSE;"2015-02-18 12:57:04.666688";"2015-02-18 12:57:04.666688";173;81;354;0;173;354
    # 74;7;67;1;FALSE;"2015-02-18 12:58:04.950424";"2015-02-18 12:58:04.950424";173;82;351;1;173;351

    trait :tree1_with_sims_19 do
      profile_id      81
      relation_id     2
      name_id         354
      is_profile_id   83
      is_name_id      187
      is_sex_id       0
    end
    trait :tree1_with_sims_20 do
      relation_id     7
      is_profile_id   84
      is_name_id      370
      is_sex_id       1
    end
    # 75;7;81;2;FALSE;"2015-02-18 13:02:25.373881";"2015-02-18 13:02:25.373881";354;83;187;0;354;187
    # 76;7;81;7;FALSE;"2015-02-18 13:05:00.010019";"2015-02-18 13:05:00.010019";354;84;370;1;354;370

  end

end


