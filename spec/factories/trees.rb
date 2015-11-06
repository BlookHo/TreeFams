FactoryGirl.define do

  factory :test_model_tree, class: Tree do |f|
    # let(:row) { FactoryGirl.create(:test_model_name).id }
    f.user_id { Faker::Number.number(5) }
    f.profile_id { Faker::Number.number(5) }
    f.name_id { Faker::Number.number(5) }
    f.relation_id { [1,2,3,4,5,6,7,8,91,92,101,102,111,112,121,122,13,14,15,16,17,18,191,192,
                     201,202,211,212,221,222].sample }

    # f.name_id { row.id }
    f.is_sex_id  {Faker::Number.between(0, 1)}
    f.is_profile_id  { Faker::Number.number(5) }
    f.is_name_id  { Faker::Number.number(5) }
    f.deleted  {Faker::Number.between(0, 1)}

    # association :name, factory: :test_model_name, name: "Федор"

  end


  factory :tree, class: Tree  do
    user_id         1
    profile_id      63
    name_id         40
    relation_id     1
    is_sex_id       1
    is_profile_id   64
    is_name_id      90

    # validation
    trait :big_IDs do
      user_id         100000000
      profile_id      6333333333
      name_id         4044
      relation_id     111
      is_sex_id       0
      is_profile_id   6466666666
      is_name_id      9099
    end
    trait :user_less_zero do
      user_id         -2
    end
    trait :profile_id_less_zero do
      user_id           2
      profile_id        -6
    end
    trait :name_id_less_zero do
      profile_id        6
      name_id           -4044
    end
    trait :relation_id_less_zero do
      name_id           404
      relation_id       -111
    end
    trait :is_profile_id_equ_zero do
      relation_id       110
      is_profile_id   0
    end
    trait :is_name_id_equ_zero do
      is_profile_id     1110
      is_name_id      0
    end
    trait :relation_wrong do
      relation_id       9
      is_name_id      1100
    end
    trait :profiles_wrong_equal do
      profile_id        6777
      relation_id       91
      is_profile_id     6777
    end
    trait :profile_non_integer do
      profile_id        6.777
      is_profile_id     6777
    end
    trait :is_sex_wrong do
      profile_id        8888
      is_sex_id         2
    end


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
      user_id         1
      profile_id      63
      relation_id     2
      name_id         40
      is_profile_id   65
      is_name_id      345
      is_sex_id       0
    end
    trait :tree1_with_sims_3 do
      user_id         1
      profile_id      63
      relation_id     5
      name_id         40
      is_profile_id   66
      is_name_id      370
      is_sex_id       1
    end
                                                                          #  name is_pr is_nam is_sex
    # 57;7;63;1;FALSE;"2015-02-18 11:53:19.612469";"2015-02-18 11:53:19.612469";40;64;90;1;40;90 . Tree = 1
    # 58;7;63;2;FALSE;"2015-02-18 11:53:19.835164";"2015-02-18 11:53:19.835164";40;65;345;0;40;345
    # 59;7;63;5;FALSE;"2015-02-18 11:53:20.044469";"2015-02-21 11:23:56.472414";40;66;370;1;40;370

    trait :tree1_with_sims_4 do
      user_id         1
      profile_id      63
      relation_id     8
      name_id         40
      is_profile_id   67
      is_name_id      173
      is_sex_id       0
    end
    trait :tree1_with_sims_5 do
      user_id         1
      profile_id      64
      relation_id     1
      name_id         90
      is_profile_id   68
      is_name_id      343
      is_sex_id       1
    end
    trait :tree1_with_sims_6 do
      user_id         1
      profile_id      64
      relation_id     2
      name_id         90
      is_profile_id   69
      is_name_id      293
      is_sex_id       0
    end
    trait :tree1_with_sims_7 do  # User = 2. Tree = 2
      user_id         1
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
      name_id         370
      is_profile_id   64
      is_name_id      90
      is_sex_id       1
    end
    trait :tree1_with_sims_9 do
      user_id         2
      profile_id      66
      relation_id     2
      name_id         370
      is_profile_id   65
      is_name_id      345
      is_sex_id       0
    end
    trait :tree1_with_sims_10 do
      user_id         2
      profile_id      66
      relation_id     5
      name_id         370
      is_profile_id   63
      is_name_id      40
      is_sex_id       1
    end
    # 64;8;66;1;FALSE;"2015-02-18 11:57:30.313108";"2015-02-21 11:23:56.249257";370;64;90;1;370;90
    # 65;8;66;2;FALSE;"2015-02-18 11:57:30.453692";"2015-02-21 11:23:56.273256";370;65;345;0;370;345
    # 66;8;66;5;FALSE;"2015-02-18 11:57:30.674924";"2015-02-21 11:23:56.295973";370;63;40;1;370;40

    trait :tree1_with_sims_11 do
      user_id         2
      profile_id      66
      relation_id     8
      name_id         370
      is_profile_id   70
      is_name_id      354
      is_sex_id       0
    end
    trait :tree1_with_sims_12 do
      user_id         2
      profile_id      64
      relation_id     1
      name_id         90
      is_profile_id   68
      is_name_id      343
      is_sex_id       1
    end
    trait :tree1_with_sims_13 do
      user_id         2
      profile_id      64
      relation_id     2
      name_id         90
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
      user_id         1
      profile_id      70
      relation_id     1
      name_id         354
      is_profile_id   79
      is_name_id      351
      is_sex_id       1
    end
    trait :tree1_with_sims_16 do
      user_id         1
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
      user_id         1
      profile_id      67
      relation_id     6
      name_id         173
      is_profile_id   81
      is_name_id      354
      is_sex_id       0
    end
    trait :tree1_with_sims_18 do
      user_id         1
      profile_id      67
      relation_id     1
      name_id         173
      is_profile_id   82
      is_name_id      351
      is_sex_id       1
    end
    # 73;7;67;6;FALSE;"2015-02-18 12:57:04.666688";"2015-02-18 12:57:04.666688";173;81;354;0;173;354
    # 74;7;67;1;FALSE;"2015-02-18 12:58:04.950424";"2015-02-18 12:58:04.950424";173;82;351;1;173;351

    trait :tree1_with_sims_19 do
      user_id         1
      profile_id      81
      relation_id     2
      name_id         354
      is_profile_id   83
      is_name_id      187
      is_sex_id       0
    end
    trait :tree1_with_sims_20 do
      user_id         1
      profile_id      81
      relation_id     7
      name_id         354
      is_profile_id   84
      is_name_id      370
      is_sex_id       1
    end
    # 75;7;81;2;FALSE;"2015-02-18 13:02:25.373881";"2015-02-18 13:02:25.373881";354;83;187;0;354;187
    # 76;7;81;7;FALSE;"2015-02-18 13:05:00.010019";"2015-02-18 13:05:00.010019";354;84;370;1;354;370

    # After Connected Similars
    # 1 57;7;63;1;FALSE;"2015-02-18 11:53:19.612469";"2015-02-18 11:53:19.612469";40;64;90;1
    # 2 58;7;63;2;FALSE;"2015-02-18 11:53:19.835164";"2015-02-18 11:53:19.835164";40;65;345;0
    # 3 59;7;63;5;FALSE;"2015-02-18 11:53:20.044469";"2015-02-27 09:37:43.599666";40; 84;370;1   X
    # 4 60;7;63;8;FALSE;"2015-02-18 11:53:20.286186";"2015-02-18 11:53:20.286186";40;67;173;0
    # 5 61;7;64;1;FALSE;"2015-02-18 11:53:20.55881";"2015-02-18 11:53:20.55881";90;68;343;1
    # 6 62;7;64;2;FALSE;"2015-02-18 11:53:20.873583";"2015-02-18 11:53:20.873583";90;69;293;0
    # 7 63;7; 84;8;FALSE;"2015-02-18 11:55:30.892263";"2015-02-27 09:37:43.513969";370; 81;354;0  X
    # 8 64;8; 84;1;FALSE;"2015-02-18 11:57:30.313108";"2015-02-27 09:37:43.392034";370;64;90;1   X
    # 9 65;8; 84;2;FALSE;"2015-02-18 11:57:30.453692";"2015-02-27 09:37:43.403089";370;65;345;0  X
    # 10 66;8; 84;5;FALSE;"2015-02-18 11:57:30.674924";"2015-02-27 09:37:43.426171";370;63;40;1   X
    # 11 67;8; 84;8;FALSE;"2015-02-18 11:57:30.924718";"2015-02-27 09:37:43.498512";370; 81;354;0  X
    # 12 68;8;64;1;FALSE;"2015-02-18 11:57:31.321098";"2015-02-18 11:59:34.676374";90;68;343;1
    # 13 69;8;64;2;FALSE;"2015-02-18 11:57:31.64299";"2015-02-18 11:59:34.607702";90;69;293;0
    # 14 70;7; 81;6;FALSE;"2015-02-18 12:51:09.133449";"2015-02-27 09:37:43.575021";354; 67;173;0  X
    # 15 71;7; 81;1;FALSE;"2015-02-18 12:53:34.019808";"2015-02-27 09:37:43.530906";354; 82;351;1  X
    # 16 72;7; 82;8;FALSE;"2015-02-18 12:56:08.886739";"2015-02-27 09:37:43.554387";351; 83;187;0  X
    # 17 73;7;67;6;FALSE;"2015-02-18 12:57:04.666688";"2015-02-18 12:57:04.666688";173;81;354;0
    # 18 74;7;67;1;FALSE;"2015-02-18 12:58:04.950424";"2015-02-18 12:58:04.950424";173;82;351;1
    # 19 75;7;81;2;FALSE;"2015-02-18 13:02:25.373881";"2015-02-18 13:02:25.373881";354;83;187;0
    # 20 76;7;81;7;FALSE;"2015-02-18 13:05:00.010019";"2015-02-18 13:05:00.010019";354;84;370;1


    # After DisConnected Similars
    # 57;7;63;1;FALSE;"2015-02-18 11:53:19.612469";"2015-02-18 11:53:19.612469";40;64;90;1
    # 58;7;63;2;FALSE;"2015-02-18 11:53:19.835164";"2015-02-18 11:53:19.835164";40;65;345;0
    # 59;7;63;5;FALSE;"2015-02-18 11:53:20.044469";"2015-02-27 09:52:29.471552";40; 66;370;1
    # 60;7;63;8;FALSE;"2015-02-18 11:53:20.286186";"2015-02-18 11:53:20.286186";40;67;173;0
    # 61;7;64;1;FALSE;"2015-02-18 11:53:20.55881";"2015-02-18 11:53:20.55881";90;68;343;1
    # 62;7;64;2;FALSE;"2015-02-18 11:53:20.873583";"2015-02-18 11:53:20.873583";90;69;293;0
    # 63;7; 66;8;FALSE;"2015-02-18 11:55:30.892263";"2015-02-27 09:52:29.383754";370; 70;354;0
    # 64;8; 66;1;FALSE;"2015-02-18 11:57:30.313108";"2015-02-27 09:52:29.25196";370;64;90;1
    # 65;8; 66;2;FALSE;"2015-02-18 11:57:30.453692";"2015-02-27 09:52:29.270948";370;65;345;0
    # 66;8; 66;5;FALSE;"2015-02-18 11:57:30.674924";"2015-02-27 09:52:29.296457";370;63;40;1
    # 67;8; 66;8;FALSE;"2015-02-18 11:57:30.924718";"2015-02-27 09:52:29.360949";370; 70;354;0
    # 68;8;64;1;FALSE;"2015-02-18 11:57:31.321098";"2015-02-18 11:59:34.676374";90;68;343;1
    # 69;8;64;2;FALSE;"2015-02-18 11:57:31.64299";"2015-02-18 11:59:34.607702";90;69;293;0
    # 70;7; 70;6;FALSE;"2015-02-18 12:51:09.133449";"2015-02-27 09:52:29.451511";354; 78;173;0
    # 71;7; 70;1;FALSE;"2015-02-18 12:53:34.019808";"2015-02-27 09:52:29.406632";354; 79;351;1
    # 72;7; 79;8;FALSE;"2015-02-18 12:56:08.886739";"2015-02-27 09:52:29.428834";351; 80;187;0
    # 73;7;67;6;FALSE;"2015-02-18 12:57:04.666688";"2015-02-18 12:57:04.666688";173;81;354;0
    # 74;7;67;1;FALSE;"2015-02-18 12:58:04.950424";"2015-02-18 12:58:04.950424";173;82;351;1
    # 75;7;81;2;FALSE;"2015-02-18 13:02:25.373881";"2015-02-18 13:02:25.373881";354;83;187;0
    # 76;7;81;7;FALSE;"2015-02-18 13:05:00.010019";"2015-02-18 13:05:00.010019";354;84;370;1


    # Before Add new Profile
    trait :add_tree9_1 do  # user_9 # 86
      user_id         9
      profile_id      85
      relation_id     1
      name_id         370
      is_profile_id   86
      is_name_id      28
      is_sex_id       1
    end
    trait :add_tree9_2 do # 87
      user_id         9
      profile_id      85
      relation_id     2
      name_id         370
      is_profile_id   87
      is_name_id      48
      is_sex_id       0
    end
    trait :add_tree9_3 do # before # 88
      user_id         9
      profile_id      85
      relation_id     5
      name_id         370
      is_profile_id   88
      is_name_id      465
      is_sex_id       1
    end
# 77;9;85;1;"2015-03-05 17:52:17.773019";"2015-03-05 17:52:17.773019";370;86;28;1
# 78;9;85;2;"2015-03-05 17:52:18.060618";"2015-03-05 17:52:18.060618";370;87;48;0
# 79;9;85;5;"2015-03-05 17:52:18.334334";"2015-03-05 17:52:18.334334";370;88;465;1


    trait :add_tree9_4 do # before # 89
      user_id         9
      profile_id      85
      relation_id     6
      name_id         370
      is_profile_id   89
      is_name_id      345
      is_sex_id       0
      deleted         1 # ###############################  for rollback destroy profile in CommonLog Spec
    end
    trait :add_tree9_5 do # before # 90
      user_id         9
      profile_id      85
      relation_id     3
      name_id         370
      is_profile_id   90
      is_name_id      343
      is_sex_id       1
      deleted         1 # ## 1 #############################  for rollback destroy profile in CommonLog Spec
    end
    trait :add_tree9_6 do # before  # 91
      user_id         9
      profile_id      85
      relation_id     4
      name_id         370
      is_profile_id   91
      is_name_id      446
      is_sex_id       0
      deleted         0  # ###############################
    end
# 80;9;85;6;"2015-03-05 17:52:18.62151";"2015-03-05 17:52:18.62151";370;89;345;0
# 81;9;85;3;"2015-03-05 17:52:18.944942";"2015-03-05 17:52:18.944942";370;90;343;1
# 82;9;85;4;"2015-03-05 17:52:19.319636";"2015-03-05 17:52:19.319636";370;91;446;0

    trait :add_tree9_7 do  # 85 - 8 - 92
      user_id         9
      profile_id      85
      relation_id     8
      name_id         370
      is_profile_id   92
      is_name_id      147
      is_sex_id       0
    end
# 83;9;85;8;"2015-03-05 17:52:19.772189";"2015-03-05 17:52:19.772189";370;92;147;0

    ######### USED ONLY IN RSPEC RENAME PROFILE IN: TREE-SPEC.RB AND PROFILE_KEY_SPEC.RB
    trait :add_tree9_8 do  # 92 - 7 - 85
      user_id         9
      profile_id      92
      relation_id     7
      name_id         147
      is_profile_id   85
      is_name_id      370
      is_sex_id       1
    end



    # For Common_Logs Tree 9
    # 77;9;85;1;"2015-03-05 17:52:17.773019";"2015-03-05 17:52:17.773019";370;86;28;1;370;28
    # 78;9;85;2;"2015-03-05 17:52:18.060618";"2015-03-05 17:52:18.060618";370;87;48;0;370;48
    # 79;9;85;5;"2015-03-05 17:52:18.334334";"2015-03-05 17:52:18.334334";370;88;465;1;370;465
    # 82;9;85;4;"2015-03-05 17:52:19.319636";"2015-03-05 17:52:19.319636";370;91;446;0;370;446
    # 83;9;85;8;"2015-03-05 17:52:19.772189";"2015-03-05 17:52:19.772189";370;92;147;0;370;147
    trait :add_tree9_172 do  # 172
      user_id         9
      profile_id      86
      relation_id     1
      name_id         28
      is_profile_id   172
      is_name_id      122
      is_sex_id       1
    end
    trait :add_tree9_173 do  # 173
      user_id         9
      profile_id      86
      relation_id     2
      name_id         28
      is_profile_id   173
      is_name_id      82
      is_sex_id       0
    end
    # 145;9;86;1;"2015-03-21 14:18:28.282098";"2015-03-21 14:18:28.282098";28;172;122;1;28;122
    # 146;9;86;2;"2015-03-21 14:18:44.302104";"2015-03-21 14:18:44.302104";28;173;82;0;28;82


    trait :add_tree10_1 do # user_9
      user_id         10
      profile_id      93
      relation_id     1
      name_id         147
      is_profile_id   94
      is_name_id      28
      is_sex_id       1
    end
    trait :add_tree10_2 do
      user_id         10
      profile_id      93
      relation_id     2
      name_id         147
      is_profile_id   95
      is_name_id      48
      is_sex_id       0
    end
    trait :add_tree10_3 do
      user_id         10
      profile_id      93
      relation_id     5
      name_id         147
      is_profile_id   96
      is_name_id      465
      is_sex_id       1
    end
    # 84;10;93;1;"2015-03-05 17:56:30.740093";"2015-03-05 17:56:30.740093";147;94;28;1
    # 85;10;93;2;"2015-03-05 17:56:30.921672";"2015-03-05 17:56:30.921672";147;95;48;0
    # 86;10;93;5;"2015-03-05 17:56:31.157669";"2015-03-05 17:56:31.157669";147;96;465;1


    trait :add_tree10_4 do
      user_id         10
      profile_id      93
      relation_id     6
      name_id         147
      is_profile_id   97
      is_name_id      345
      is_sex_id       0
    end
    trait :add_tree10_5 do
      user_id         10
      profile_id      93
      relation_id     3
      name_id         147
      is_profile_id   98
      is_name_id      343
      is_sex_id       1
    end
    trait :add_tree10_6 do
      user_id         10
      profile_id      93
      relation_id     4
      name_id         147
      is_profile_id   99
      is_name_id      446
      is_sex_id       0
    end
    # 87;10;93;6;"2015-03-05 17:56:31.473459";"2015-03-05 17:56:31.473459";147;97;345;0
    # 88;10;93;3;"2015-03-05 17:56:31.916489";"2015-03-05 17:56:31.916489";147;98;343;1
    # 89;10;93;4;"2015-03-05 17:56:32.392658";"2015-03-05 17:56:32.392658";147;99;446;0

    trait :add_tree10_7 do
      user_id         10
      profile_id      93
      relation_id     7
      name_id         147
      is_profile_id   100
      is_name_id      370
      is_sex_id       1
    end
# 90;10;93;7;"2015-03-05 17:56:32.953397";"2015-03-05 17:56:32.953397";147;100;370;1


# For Connection_Trees TEST

    factory :connection_trees, class: Tree  do  # 17 pr2
      user_id         1
      profile_id      17
      name_id         28
      relation_id     1
      is_profile_id   2
      is_sex_id       1
      is_name_id      122

      trait :connect_tree_1_pr3 do   # 17 pr3
        # user_id         1
        # profile_id      17
        # name_id         28
        relation_id     2
        is_profile_id   3
        is_sex_id       0
        is_name_id      82
      end

      trait :connect_tree_1_pr15 do   # 17 pr15
        # user_id         1
        # profile_id      17
        # name_id         28
        relation_id     3
        is_profile_id   15
        is_sex_id       1
        is_name_id      370
      end
    # 1;1;17;1;"2015-01-23 07:31:58.181791";"2015-01-23 12:54:09.172659";28;2;122;1;28
    # 2;1;17;2;"2015-01-23 07:31:58.432596";"2015-01-23 12:54:09.184552";28;3;82;0;28
    # 3;1;17;3;"2015-01-23 07:31:58.623986";"2015-01-23 12:54:09.309687";28;15;370;1;28

      trait :connect_tree_1_pr16  do   # 17 pr16
        # user_id         1
        # profile_id      17
        # name_id         28
        relation_id     3
        is_profile_id   16
        is_sex_id       1
        is_name_id      465
      end
      trait :connect_tree_1_pr11  do   # 17 pr11
        # user_id         1
        # profile_id      17
        # name_id         28
        relation_id     8
        is_profile_id   11
        is_sex_id       0
        is_name_id      48
      end
      trait :connect_tree_1_pr7   do   # 2  pr7
        user_id         1
        profile_id      2
        name_id         122
        relation_id     1
        is_profile_id   7
        is_sex_id       1
        is_name_id      90
      end
    # 4;1;17;3;"2015-01-23 07:31:58.876625";"2015-01-23 12:54:09.287704";28;16;465;1;28
    # 5;1;17;8;"2015-01-23 07:31:59.161437";"2015-01-23 12:54:09.330129";28;11;48;0;28
    # 6;1;2;1;"2015-01-23 07:31:59.537254";"2015-01-23 07:31:59.537254";122;7;90;1;122

      trait :connect_tree_1_pr8   do   # 2  pr8
        user_id         1
        profile_id      2
        name_id         122
        relation_id     2
        is_profile_id   8
        is_sex_id       0
        is_name_id      449
      end
      trait :connect_tree_1_pr9   do   # 3  pr9
        # user_id         1
         profile_id      3
         name_id         82
        relation_id     1
        is_profile_id   9
        is_sex_id       1
        is_name_id      361
      end
      trait :connect_tree_1_pr10  do   # 3  pr10
        # user_id         1
        profile_id      3
        name_id         82
        relation_id     2
        is_profile_id   10
        is_sex_id       0
        is_name_id      293
      end
    # 7;1;2;2;"2015-01-23 07:31:59.957739";"2015-01-23 07:31:59.957739";122;8;449;0;122
    # 8;1;3;1;"2015-01-23 07:32:00.256718";"2015-01-23 07:32:00.256718";82;9;361;1;82
    # 9;1;3;2;"2015-01-23 07:32:00.527583";"2015-01-23 07:32:00.527583";82;10;293;0;82

      trait :connect_tree_2_pr12  do   # 11 pr12
        user_id         2
        profile_id      11
        name_id         48
        relation_id     1
        is_profile_id   12
        is_sex_id       1
        is_name_id      343
      end
      trait :connect_tree_2_pr13  do   # 11 pr13
        user_id         2
        profile_id      11
        name_id         48
        relation_id     2
        is_profile_id   13
        is_sex_id       0
        is_name_id      82
      end
      trait :connect_tree_2_pr14  do   # 11 pr14
        user_id         2
        profile_id      11
        name_id         48
        relation_id     6
        is_profile_id   14
        is_sex_id       0
        is_name_id      331
      end
    # 10;2;11;1;"2015-01-23 07:37:32.888523";"2015-01-23 07:37:32.888523";48;12;343;1;516
    # 11;2;11;2;"2015-01-23 07:37:33.14772";"2015-01-23 07:37:33.14772";48;13;82;0;516
    # 12;2;11;6;"2015-01-23 07:37:33.32065";"2015-01-23 07:37:33.32065";48;14;331;0;516

      trait :connect_tree_2_pr15  do   # 11 pr15
        user_id         2
        profile_id      11
        name_id         48
        relation_id     3
        is_profile_id   15
        is_sex_id       1
        is_name_id      370
      end
      trait :connect_tree_2_pr16  do   # 11 pr16
        user_id         2
        profile_id      11
        name_id         48
        relation_id     3
        is_profile_id   16
        is_sex_id       1
        is_name_id      465
      end
      trait :connect_tree_2_pr17  do   # 11 pr17
        user_id         2
        profile_id      11
        name_id         48
        relation_id     7
        is_profile_id   17
        is_sex_id       1
        is_name_id      28
      end
    # 13;2;11;3;"2015-01-23 07:37:33.580355";"2015-01-23 07:37:33.580355";48;15;370;1;516
    # 14;2;11;3;"2015-01-23 07:37:33.848398";"2015-01-23 07:37:33.848398";48;16;465;1;516
    # 15;2;11;7;"2015-01-23 07:37:34.161849";"2015-01-23 07:37:34.161849";48;17;28;1;516

      trait :connect_tree_2_pr18  do   # 12 pr18
        user_id         2
        profile_id      12
        name_id         343
        relation_id     1
        is_profile_id   18
        is_sex_id       1
        is_name_id      194
      end
      trait :connect_tree_2_pr19  do   # 12 pr19
        user_id         2
        profile_id      12
        name_id         343
        relation_id     2
        is_profile_id   19
        is_sex_id       0
        is_name_id      48
      end
      trait :connect_tree_2_pr20  do   # 13 pr20
        user_id         2
        profile_id      13
        name_id         82
        relation_id     1
        is_profile_id   20
        is_sex_id       1
        is_name_id      110
      end
    # 16;2;12;1;"2015-01-23 07:37:34.483795";"2015-01-23 07:37:34.483795";343;18;194;1;343
    # 17;2;12;2;"2015-01-23 07:37:34.800557";"2015-01-23 07:37:34.800557";343;19;48;0;343
    # 18;2;13;1;"2015-01-23 07:37:35.251939";"2015-01-23 07:37:35.251939";82;20;110;1;82

      trait :connect_tree_2_pr21  do   # 13 pr21
        user_id         2
        profile_id      13
        name_id         82
        relation_id     2
        is_profile_id   21
        is_sex_id       0
        is_name_id      249
      end
      trait :connect_tree_3_pr23  do   # 22 pr23
        user_id         3
        profile_id      22
        name_id         331
        relation_id     1
        is_profile_id   23
        is_sex_id       1
        is_name_id      343
      end
      trait :connect_tree_3_pr24  do   # 22 pr24
        user_id         3
        profile_id      22
        name_id         331
        relation_id     2
        is_profile_id   24
        is_sex_id       0
        is_name_id      82
      end
    # 19;2;13;2;"2015-01-23 07:37:35.545505";"2015-01-23 07:37:35.545505";82;21;249;0;82
    # 20;3;22;1;"2015-01-23 07:47:59.896943";"2015-01-23 07:47:59.896943";331;23;343;1;331
    # 21;3;22;2;"2015-01-23 07:48:00.037166";"2015-01-23 07:48:00.037166";331;24;82;0;331

      trait :connect_tree_3_pr25  do   # 22 pr25
        user_id         3
        profile_id      22
        name_id         331
        relation_id     6
        is_profile_id   25
        is_sex_id       0
        is_name_id      48
      end
      trait :connect_tree_3_pr26  do   # 23 pr26
        user_id         3
        profile_id      23
        name_id         343
        relation_id     1
        is_profile_id   26
        is_sex_id       1
        is_name_id      194
      end
      trait :connect_tree_3_pr27  do   # 23 pr27
        user_id         3
        profile_id      23
        name_id         343
        relation_id     2
        is_profile_id   27
        is_sex_id       0
        is_name_id      48
      end
    # 22;3;22;6;"2015-01-23 07:48:00.232801";"2015-01-23 07:48:00.232801";331;25;48;0;331
    # 23;3;23;1;"2015-01-23 07:48:00.483977";"2015-01-23 07:48:00.483977";343;26;194;1;343
    # 24;3;23;2;"2015-01-23 07:48:00.775523";"2015-01-23 07:48:00.775523";343;27;48;0;343

      trait :connect_tree_3_pr28  do   # 24 pr28
        user_id         3
        profile_id      24
        name_id         82
        relation_id     1
        is_profile_id   28
        is_sex_id       1
        is_name_id      110
      end
      trait :connect_tree_3_pr29  do   # 24 pr29
        user_id         3
        profile_id      24
        name_id         82
        relation_id     2
        is_profile_id   29
        is_sex_id       0
        is_name_id      249
      end
      trait :connect_tree_1_pr14  do   # 11 pr14
        user_id         1
        profile_id      11
        name_id         48
        relation_id     6
        is_profile_id   14
        is_sex_id       0
        is_name_id      331
      end
    # 25;3;24;1;"2015-01-23 07:48:01.117288";"2015-01-23 07:48:01.117288";82;28;110;1;82
    # 26;3;24;2;"2015-01-23 07:48:01.404621";"2015-01-23 07:48:01.404621";82;29;249;0;82
    # 27;1;11;6;"2015-01-23 12:50:28.11907";"2015-01-23 12:54:09.353308";48;14;331;0;516

      trait :connect_tree_2_pr124 do   # 15 pr124
        user_id         2
        profile_id      15
        name_id         370
        relation_id     4
        is_profile_id   124
        is_sex_id       0
        is_name_id      446
      end
    # 92;2;15;4;"2015-03-14 11:11:17.977755";"2015-03-14 11:11:17.977755";370;124;446;0;370

    end

  end

end





