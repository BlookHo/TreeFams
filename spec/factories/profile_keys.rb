FactoryGirl.define do

  factory :profile_key do

    # validation

    trait :profile_key_good do
      user_id         1
      profile_id      63
      name_id         40
      relation_id     1
      is_profile_id   64
      is_name_id      90
    end
    trait :big_IDs do
      user_id         100000000
      profile_id      6333333333
      name_id         4044
      relation_id     111
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


    # For 1 tree test WITH SIMILARS. Tree connected of [1, 2]
    trait :profile_key_w_sims_1 do       # For 2 connected trees test - 1st. Tree = 1. User = 1. Profile = 63
      user_id         1
      profile_id      63
      name_id         40
      relation_id     1
      is_profile_id   64
      is_name_id      90
    end
    trait :profile_key_w_sims_2 do
      user_id         1
      profile_id      64
      name_id         90
      relation_id     3
      is_profile_id   63
      is_name_id      40
    end
    trait :profile_key_w_sims_3 do
      user_id         1
      profile_id      63
      name_id         40
      relation_id     2
      is_profile_id   65
      is_name_id      345
    end
    # user prof name rel is_pr is_nm
    # 365;7;63;40;1;64;90;"2015-02-18 11:53:19.681029";"2015-02-18 11:53:19.681029";40;90
    # 366;7;64;90;3;63;40;"2015-02-18 11:53:19.729441";"2015-02-18 11:53:19.729441";90;40
    # 367;7;63;40;2;65;345;"2015-02-18 11:53:19.855804";"2015-02-18 11:53:19.855804";40;345

    trait :profile_key_w_sims_4 do
      user_id         1
      profile_id      65
      name_id         345
      relation_id     3
      is_profile_id   63
      is_name_id      40
    end
    trait :profile_key_w_sims_5 do
      user_id         1
      profile_id      64
      name_id         90
      relation_id     8
      is_profile_id   65
      is_name_id      345
    end
    trait :profile_key_w_sims_6 do
      user_id         1
      profile_id      65
      name_id         345
      relation_id     7
      is_profile_id   64
      is_name_id      90
    end
    # 368;7;65;345;3;63;40;"2015-02-18 11:53:19.871503";"2015-02-18 11:53:19.871503";345;40
    # 369;7;64;90;8;65;345;"2015-02-18 11:53:19.922793";"2015-02-18 11:53:19.922793";90;345
    # 370;7;65;345;7;64;90;"2015-02-18 11:53:19.940046";"2015-02-18 11:53:19.940046";345;90

    trait :profile_key_w_sims_7 do
      user_id         1
      profile_id      63
      name_id         40
      relation_id     5
      is_profile_id   66
      is_name_id      370
    end
    trait :profile_key_w_sims_8 do
      user_id         1
      profile_id      66
      name_id         370
      relation_id     5
      is_profile_id   63
      is_name_id      40
    end
    trait :profile_key_w_sims_9 do
      user_id         1
      profile_id      64
      name_id         90
      relation_id     3
      is_profile_id   66
      is_name_id      370
    end
    # 371;7;63;40;5;66;370;"2015-02-18 11:53:20.066599";"2015-02-21 11:23:58.440376";40;370
    # 372;7;66;370;5;63;40;"2015-02-18 11:53:20.081937";"2015-02-21 11:23:57.079065";370;40
    # 373;7;64;90;3;66;370;"2015-02-18 11:53:20.113039";"2015-02-21 11:23:58.124145";90;370

    trait :profile_key_w_sims_10 do
      user_id         1
      profile_id      66
      name_id         370
      relation_id     1
      is_profile_id   64
      is_name_id      90
    end
    trait :profile_key_w_sims_11 do
      user_id         1
      profile_id      65
      name_id         345
      relation_id     3
      is_profile_id   66
      is_name_id      370
    end
    trait :profile_key_w_sims_12 do
      user_id         1
      profile_id      66
      name_id         370
      relation_id     2
      is_profile_id   65
      is_name_id      345
    end
    # 374;7;66;370;1;64;90;"2015-02-18 11:53:20.130586";"2015-02-21 11:23:56.991468";370;90
    # 375;7;65;345;3;66;370;"2015-02-18 11:53:20.156424";"2015-02-21 11:23:58.419139";345;370
    # 376;7;66;370;2;65;345;"2015-02-18 11:53:20.176538";"2015-02-21 11:23:56.964928";370;345

    trait :profile_key_w_sims_13 do
      user_id         1
      profile_id      63
      name_id         40
      relation_id     8
      is_profile_id   67
      is_name_id      173
    end
    trait :profile_key_w_sims_14 do
      user_id         1
      profile_id      67
      name_id         173
      relation_id     7
      is_profile_id   63
      is_name_id      40
    end
    trait :profile_key_w_sims_15 do
      user_id         1
      profile_id      64
      name_id         90
      relation_id     17
      is_profile_id   67
      is_name_id      173
    end
    # 377;7;63;40;8;67;173;"2015-02-18 11:53:20.308688";"2015-02-18 11:53:20.308688";40;173
    # 378;7;67;173;7;63;40;"2015-02-18 11:53:20.328209";"2015-02-18 11:53:20.328209";173;40
    # 379;7;64;90;17;67;173;"2015-02-18 11:53:20.360991";"2015-02-18 11:53:20.360991";90;173

    trait :profile_key_w_sims_16 do
      user_id         1
      profile_id      67
      name_id         173
      relation_id     13
      is_profile_id   64
      is_name_id      90
    end
    trait :profile_key_w_sims_17 do
      user_id         1
      profile_id      65
      name_id         345
      relation_id     17
      is_profile_id   67
      is_name_id      173
    end
    trait :profile_key_w_sims_18 do
      user_id         1
      profile_id      67
      name_id         173
      relation_id     14
      is_profile_id   65
      is_name_id      345
    end
    # 380;7;67;173;13;64;90;"2015-02-18 11:53:20.386188";"2015-02-18 11:53:20.386188";173;90
    # 381;7;65;345;17;67;173;"2015-02-18 11:53:20.410797";"2015-02-18 11:53:20.410797";345;173
    # 382;7;67;173;14;65;345;"2015-02-18 11:53:20.431637";"2015-02-18 11:53:20.431637";173;345

    trait :profile_key_w_sims_19 do
      user_id         1
      profile_id      64
      name_id         90
      relation_id     1
      is_profile_id   68
      is_name_id      343
    end
    trait :profile_key_w_sims_20 do
      user_id         1
      profile_id      68
      name_id         343
      relation_id     3
      is_profile_id   64
      is_name_id      90
    end
    trait :profile_key_w_sims_21 do
      user_id         1
      profile_id      63
      name_id         40
      relation_id     91
      is_profile_id   68
      is_name_id      343
    end
    # 383;7;64;90;1;68;343;"2015-02-18 11:53:20.573416";"2015-02-18 11:53:20.573416";90;343
    # 384;7;68;343;3;64;90;"2015-02-18 11:53:20.595791";"2015-02-18 11:53:20.595791";343;90
    # 385;7;63;40;91;68;343;"2015-02-18 11:53:20.620471";"2015-02-18 11:53:20.620471";40;343

    trait :profile_key_w_sims_22 do
      user_id         1
      profile_id      68
      name_id         343
      relation_id     111
      is_profile_id   63
      is_name_id      40
    end
    trait :profile_key_w_sims_23 do
      user_id         1
      profile_id      66
      name_id         370
      relation_id     91
      is_profile_id   68
      is_name_id      343
    end
    trait :profile_key_w_sims_24 do
      user_id         1
      profile_id      68
      name_id         343
      relation_id     111
      is_profile_id   66
      is_name_id      370
    end
    # 386;7;68;343;111;63;40;"2015-02-18 11:53:20.64192";"2015-02-18 11:53:20.64192";343;40
    # 387;7;66;370;91;68;343;"2015-02-18 11:53:20.674319";"2015-02-21 11:23:57.178939";370;343
    # 388;7;68;343;111;66;370;"2015-02-18 11:53:20.698218";"2015-02-21 11:23:58.186214";343;370

    trait :profile_key_w_sims_25 do
      user_id         1
      profile_id      65
      name_id         345
      relation_id     13
      is_profile_id   68
      is_name_id      343
    end
    trait :profile_key_w_sims_26 do
      user_id         1
      profile_id      68
      name_id         343
      relation_id     17
      is_profile_id   65
      is_name_id      345
    end
    trait :profile_key_w_sims_27 do
      user_id         1
      profile_id      64
      name_id         90
      relation_id     2
      is_profile_id   69
      is_name_id      293
    end
    # 389;7;65;345;13;68;343;"2015-02-18 11:53:20.723407";"2015-02-18 11:53:20.723407";345;343
    # 390;7;68;343;17;65;345;"2015-02-18 11:53:20.741257";"2015-02-18 11:53:20.741257";343;345
    # 391;7;64;90;2;69;293;"2015-02-18 11:53:20.900634";"2015-02-18 11:53:20.900634";90;293

    trait :profile_key_w_sims_28 do
      user_id         1
      profile_id      69
      name_id         293
      relation_id     3
      is_profile_id   64
      is_name_id      90
    end
    trait :profile_key_w_sims_29 do
      user_id         1
      profile_id      68
      name_id         343
      relation_id     8
      is_profile_id   69
      is_name_id      293
    end
    trait :profile_key_w_sims_30 do
      user_id         1
      profile_id      69
      name_id         293
      relation_id     7
      is_profile_id   68
      is_name_id      343
    end
    # 392;7;69;293;3;64;90;"2015-02-18 11:53:20.919793";"2015-02-18 11:53:20.919793";293;90
    # 393;7;68;343;8;69;293;"2015-02-18 11:53:20.946135";"2015-02-18 11:53:20.946135";343;293
    # 394;7;69;293;7;68;343;"2015-02-18 11:53:20.964022";"2015-02-18 11:53:20.964022";293;343

    trait :profile_key_w_sims_31 do
      user_id         1
      profile_id      63
      name_id         40
      relation_id     101
      is_profile_id   69
      is_name_id      293
    end
    trait :profile_key_w_sims_32 do
      user_id         1
      profile_id      69
      name_id         293
      relation_id     111
      is_profile_id   63
      is_name_id      40
    end
    trait :profile_key_w_sims_33 do
      user_id         1
      profile_id      66
      name_id         370
      relation_id     101
      is_profile_id   69
      is_name_id      293
    end
    # 395;7;63;40;101;69;293;"2015-02-18 11:53:20.988417";"2015-02-18 11:53:20.988417";40;293
    # 396;7;69;293;111;63;40;"2015-02-18 11:53:21.008831";"2015-02-18 11:53:21.008831";293;40
    # 397;7;66;370;101;69;293;"2015-02-18 11:53:21.039386";"2015-02-21 11:23:57.368448";370;293

    trait :profile_key_w_sims_34 do
      user_id         1
      profile_id      69
      name_id         293
      relation_id     111
      is_profile_id   66
      is_name_id      370
    end
    trait :profile_key_w_sims_35 do
      user_id         1
      profile_id      65
      name_id         345
      relation_id     14
      is_profile_id   69
      is_name_id      293
    end
    trait :profile_key_w_sims_36 do
      user_id         1
      profile_id      69
      name_id         293
      relation_id     17
      is_profile_id   65
      is_name_id      345
    end
    # 398;7;69;293;111;66;370;"2015-02-18 11:53:21.066973";"2015-02-21 11:23:58.214856";293;370
    # 399;7;65;345;14;69;293;"2015-02-18 11:53:21.095959";"2015-02-18 11:53:21.095959";345;293
    # 400;7;69;293;17;65;345;"2015-02-18 11:53:21.123641";"2015-02-18 11:53:21.123641";293;345

    trait :profile_key_w_sims_37 do
      user_id         1
      profile_id      66
      name_id         370
      relation_id     8
      is_profile_id   70
      is_name_id      354
    end
    trait :profile_key_w_sims_38 do
      user_id         1
      profile_id      70
      name_id         354
      relation_id     7
      is_profile_id   66
      is_name_id      370
    end
    trait :profile_key_w_sims_39 do
      user_id         1
      profile_id      64
      name_id         90
      relation_id     17
      is_profile_id   70
      is_name_id      354
    end
    # 401;7;66;370;8;70;354;"2015-02-18 11:55:30.944104";"2015-02-21 11:23:57.446452";370;354
    # 402;7;70;354;7;66;370;"2015-02-18 11:55:30.959518";"2015-02-21 11:23:58.29606";354;370
    # 403;7;64;90;17;70;354;"2015-02-18 11:55:30.991727";"2015-02-21 11:23:57.547495";90;354

    trait :profile_key_w_sims_40 do
      user_id         1
      profile_id      70
      name_id         354
      relation_id     13
      is_profile_id   64
      is_name_id      90
    end
    trait :profile_key_w_sims_41 do
      user_id         1
      profile_id      65
      name_id         345
      relation_id     17
      is_profile_id   70
      is_name_id      354
    end
    trait :profile_key_w_sims_42 do
      user_id         1
      profile_id      70
      name_id         354
      relation_id     14
      is_profile_id   65
      is_name_id      345
    end
    # 404;7;70;354;13;64;90;"2015-02-18 11:55:31.021875";"2015-02-21 11:23:56.612483";354;90
    # 405;7;65;345;17;70;354;"2015-02-18 11:55:31.043502";"2015-02-21 11:23:57.719679";345;354
    # 406;7;70;354;14;65;345;"2015-02-18 11:55:31.061781";"2015-02-21 11:23:56.521264";354;345

    trait :profile_key_w_sims_43 do
      user_id         2
      profile_id      66
      name_id         370
      relation_id     1
      is_profile_id   64
      is_name_id      90
    end
    trait :profile_key_w_sims_44 do
      user_id         2
      profile_id      64
      name_id         90
      relation_id     3
      is_profile_id   66
      is_name_id      370
    end
    trait :profile_key_w_sims_45 do
      user_id         2
      profile_id      66
      name_id         370
      relation_id     2
      is_profile_id   65
      is_name_id      345
    end
    # 407;8;66;370;1;64;90;"2015-02-18 11:57:30.329845";"2015-02-21 11:23:57.154571";370;90
    # 408;8;64;90;3;66;370;"2015-02-18 11:57:30.348618";"2015-02-21 11:23:58.391008";90;370
    # 409;8;66;370;2;65;345;"2015-02-18 11:57:30.480003";"2015-02-21 11:23:57.095578";370;345

    trait :profile_key_w_sims_46 do
      user_id         2
      profile_id      65
      name_id         345
      relation_id     3
      is_profile_id   66
      is_name_id      370
    end
    trait :profile_key_w_sims_47 do
      user_id         2
      profile_id      64
      name_id         90
      relation_id     8
      is_profile_id   65
      is_name_id      345
    end
    trait :profile_key_w_sims_48 do
      user_id         2
      profile_id      65
      name_id         345
      relation_id     7
      is_profile_id   64
      is_name_id      90
    end
    # 410;8;65;345;3;66;370;"2015-02-18 11:57:30.493994";"2015-02-21 11:23:58.157106";345;370
    # 411;8;64;90;8;65;345;"2015-02-18 11:57:30.525661";"2015-02-18 11:59:35.910091";90;345
    # 412;8;65;345;7;64;90;"2015-02-18 11:57:30.554548";"2015-02-18 11:59:35.762875";345;90

    trait :profile_key_w_sims_49 do
      user_id         2
      profile_id      66
      name_id         370
      relation_id     5
      is_profile_id   63
      is_name_id      40
    end
    trait :profile_key_w_sims_50 do
      user_id         2
      profile_id      63
      name_id         40
      relation_id     5
      is_profile_id   66
      is_name_id      370
    end
    trait :profile_key_w_sims_51 do
      user_id         2
      profile_id      64
      name_id         90
      relation_id     3
      is_profile_id   63
      is_name_id      40
    end
    # 413;8;66;370;5;63;40;"2015-02-18 11:57:30.701302";"2015-02-21 11:23:57.399324";370;40
    # 414;8;63;40;5;66;370;"2015-02-18 11:57:30.713989";"2015-02-21 11:23:58.337442";40;370
    # 415;8;64;90;3;63;40;"2015-02-18 11:57:30.74355";"2015-02-18 11:59:36.295437";90;40

    trait :profile_key_w_sims_52 do
      user_id         2
      profile_id      63
      name_id         40
      relation_id     1
      is_profile_id   64
      is_name_id      90
    end
    trait :profile_key_w_sims_53 do
      user_id         2
      profile_id      65
      name_id         345
      relation_id     3
      is_profile_id   63
      is_name_id      40
    end
    trait :profile_key_w_sims_54 do
      user_id         2
      profile_id      63
      name_id         40
      relation_id     2
      is_profile_id   65
      is_name_id      345
    end
    # 416;8;63;40;1;64;90;"2015-02-18 11:57:30.763737";"2015-02-18 11:59:35.791434";40;90
    # 417;8;65;345;3;63;40;"2015-02-18 11:57:30.788601";"2015-02-18 11:59:36.320912";345;40
    # 418;8;63;40;2;65;345;"2015-02-18 11:57:30.811266";"2015-02-18 11:59:35.934465";40;345

    trait :profile_key_w_sims_55 do
      user_id         2
      profile_id      66
      name_id         370
      relation_id     8
      is_profile_id   70
      is_name_id      354
    end
    trait :profile_key_w_sims_56 do
      user_id         2
      profile_id      70
      name_id         354
      relation_id     7
      is_profile_id   66
      is_name_id      370
    end
    trait :profile_key_w_sims_57 do
      user_id         2
      profile_id      64
      name_id         90
      relation_id     17
      is_profile_id   70
      is_name_id      354
    end
    # 419;8;66;370;8;70;354;"2015-02-18 11:57:30.939333";"2015-02-21 11:23:57.746165";370;354
    # 420;8;70;354;7;66;370;"2015-02-18 11:57:30.961643";"2015-02-21 11:23:58.36287";354;370
    # 421;8;64;90;17;70;354;"2015-02-18 11:57:30.992366";"2015-02-21 11:23:57.690997";90;354

    trait :profile_key_w_sims_58 do
      user_id         2
      profile_id      70
      name_id         354
      relation_id     13
      is_profile_id   64
      is_name_id      90
    end
    trait :profile_key_w_sims_59 do
      user_id         2
      profile_id      65
      name_id         345
      relation_id     17
      is_profile_id   70
      is_name_id      354
    end
    trait :profile_key_w_sims_60 do
      user_id         2
      profile_id      70
      name_id         354
      relation_id     14
      is_profile_id   65
      is_name_id      345
    end
    # 422;8;70;354;13;64;90;"2015-02-18 11:57:31.023905";"2015-02-21 11:23:56.586127";354;90
    # 423;8;65;345;17;70;354;"2015-02-18 11:57:31.104175";"2015-02-21 11:23:57.772343";345;354
    # 424;8;70;354;14;65;345;"2015-02-18 11:57:31.163686";"2015-02-21 11:23:56.639689";354;345

    trait :profile_key_w_sims_61 do
      user_id         2
      profile_id      64
      name_id         90
      relation_id     1
      is_profile_id   68
      is_name_id      343
    end
    trait :profile_key_w_sims_62 do
      user_id         2
      profile_id      68
      name_id         343
      relation_id     3
      is_profile_id   64
      is_name_id      90
    end
    trait :profile_key_w_sims_63 do
      user_id         2
      profile_id      66
      name_id         370
      relation_id     91
      is_profile_id   68
      is_name_id      343
    end
    # 425;8;64;90;1;68;343;"2015-02-18 11:57:31.342106";"2015-02-18 11:59:36.150714";90;343
    # 426;8;68;343;3;64;90;"2015-02-18 11:57:31.358097";"2015-02-18 11:59:35.829473";343;90
    # 427;8;66;370;91;68;343;"2015-02-18 11:57:31.38663";"2015-02-21 11:23:57.125138";370;343

    trait :profile_key_w_sims_64 do
      user_id         2
      profile_id      68
      name_id         343
      relation_id     111
      is_profile_id   66
      is_name_id      370
    end
    trait :profile_key_w_sims_65 do
      user_id         2
      profile_id      63
      name_id         40
      relation_id     91
      is_profile_id   68
      is_name_id      343
    end
    trait :profile_key_w_sims_66 do
      user_id         2
      profile_id      68
      name_id         343
      relation_id     111
      is_profile_id   63
      is_name_id      40
    end
    # 428;8;68;343;111;66;370;"2015-02-18 11:57:31.40731";"2015-02-21 11:23:58.241556";343;370
    # 429;8;63;40;91;68;343;"2015-02-18 11:57:31.43371";"2015-02-18 11:59:36.197293";40;343
    # 430;8;68;343;111;63;40;"2015-02-18 11:57:31.463893";"2015-02-18 11:59:36.346099";343;40

    trait :profile_key_w_sims_67 do
      user_id         2
      profile_id      65
      name_id         345
      relation_id     13
      is_profile_id   68
      is_name_id      343
    end
    trait :profile_key_w_sims_68 do
      user_id         2
      profile_id      68
      name_id         343
      relation_id     17
      is_profile_id   65
      is_name_id      345
    end
    trait :profile_key_w_sims_69 do
      user_id         2
      profile_id      64
      name_id         90
      relation_id     2
      is_profile_id   69
      is_name_id      293
    end
    # 431;8;65;345;13;68;343;"2015-02-18 11:57:31.487575";"2015-02-18 11:59:36.223439";345;343
    # 432;8;68;343;17;65;345;"2015-02-18 11:57:31.507597";"2015-02-18 11:59:35.974719";343;345
    # 433;8;64;90;2;69;293;"2015-02-18 11:57:31.663118";"2015-02-18 11:59:35.623609";90;293

    trait :profile_key_w_sims_70 do
      user_id         2
      profile_id      69
      name_id         293
      relation_id     3
      is_profile_id   64
      is_name_id      90
    end
    trait :profile_key_w_sims_71 do
      user_id         2
      profile_id      68
      name_id         343
      relation_id     8
      is_profile_id   69
      is_name_id      293
    end
    trait :profile_key_w_sims_72 do
      user_id         2
      profile_id      69
      name_id         293
      relation_id     7
      is_profile_id   68
      is_name_id      343
    end
    # 434;8;69;293;3;64;90;"2015-02-18 11:57:31.683746";"2015-02-18 11:59:35.858936";293;90
    # 435;8;68;343;8;69;293;"2015-02-18 11:57:31.716264";"2015-02-18 11:59:35.648645";343;293
    # 436;8;69;293;7;68;343;"2015-02-18 11:57:31.746264";"2015-02-18 11:59:36.24496";293;343

    trait :profile_key_w_sims_73 do
      user_id         2
      profile_id      66
      name_id         370
      relation_id     101
      is_profile_id   69
      is_name_id      293
    end
    trait :profile_key_w_sims_74 do
      user_id         2
      profile_id      69
      name_id         293
      relation_id     111
      is_profile_id   66
      is_name_id      370
    end
    trait :profile_key_w_sims_75 do
      user_id         2
      profile_id      63
      name_id         40
      relation_id     101
      is_profile_id   69
      is_name_id      293
    end
    # 437;8;66;370;101;69;293;"2015-02-18 11:57:31.782976";"2015-02-21 11:23:57.024534";370;293
    # 438;8;69;293;111;66;370;"2015-02-18 11:57:31.810209";"2015-02-21 11:23:58.268868";293;370
    # 439;8;63;40;101;69;293;"2015-02-18 11:57:31.83225";"2015-02-18 11:59:35.697173";40;293

    trait :profile_key_w_sims_76 do
      user_id         2
      profile_id      69
      name_id         293
      relation_id     111
      is_profile_id   63
      is_name_id      40
    end
    trait :profile_key_w_sims_77 do
      user_id         2
      profile_id      65
      name_id         345
      relation_id     14
      is_profile_id   69
      is_name_id      293
    end
    trait :profile_key_w_sims_78 do
      user_id         2
      profile_id      69
      name_id         293
      relation_id     17
      is_profile_id   65
      is_name_id      345
    end
    # 440;8;69;293;111;63;40;"2015-02-18 11:57:31.852654";"2015-02-18 11:59:36.362915";293;40
    # 441;8;65;345;14;69;293;"2015-02-18 11:57:31.879728";"2015-02-18 11:59:35.721681";345;293
    # 442;8;69;293;17;65;345;"2015-02-18 11:57:31.90894";"2015-02-18 11:59:35.996628";293;345

    trait :profile_key_w_sims_79 do
      user_id         1
      profile_id      70
      name_id         354
      relation_id     6
      is_profile_id   78
      is_name_id      173
    end
    trait :profile_key_w_sims_80 do
      user_id         1
      profile_id      78
      name_id         173
      relation_id     6
      is_profile_id   70
      is_name_id      354
    end
    trait :profile_key_w_sims_81 do
      user_id         1
      profile_id      70
      name_id         354
      relation_id     1
      is_profile_id   79
      is_name_id      351
    end
    # 443;7;70;354;6;78;173;"2015-02-18 12:51:09.15134";"2015-02-21 11:23:58.0745";354;173
    # 444;7;78;173;6;70;354;"2015-02-18 12:51:09.170889";"2015-02-21 11:23:57.81895";173;354
    # 445;7;70;354;1;79;351;"2015-02-18 12:53:34.040206";"2015-02-21 11:23:57.934518";354;351

    trait :profile_key_w_sims_82 do
      user_id         1
      profile_id      79
      name_id         351
      relation_id     4
      is_profile_id   70
      is_name_id      354
    end
    trait :profile_key_w_sims_83 do
      user_id         1
      profile_id      78
      name_id         173
      relation_id     1
      is_profile_id   79
      is_name_id      351
    end
    trait :profile_key_w_sims_84 do
      user_id         1
      profile_id      79
      name_id         351
      relation_id     4
      is_profile_id   78
      is_name_id      173
    end
    # 446;7;79;351;4;70;354;"2015-02-18 12:53:34.061098";"2015-02-21 11:23:57.839921";351;354
    # 447;7;78;173;1;79;351;"2015-02-18 12:53:34.091936";"2015-02-21 11:23:57.88378";173;351
    # 448;7;79;351;4;78;173;"2015-02-18 12:53:34.124876";"2015-02-21 11:23:58.093571";351;173

    trait :profile_key_w_sims_85 do
      user_id         1
      profile_id      66
      name_id         370
      relation_id     15
      is_profile_id   79
      is_name_id      351
    end
    trait :profile_key_w_sims_86 do
      user_id         1
      profile_id      79
      name_id         351
      relation_id     18
      is_profile_id   66
      is_name_id      370
    end
    trait :profile_key_w_sims_87 do
      user_id         1
      profile_id      79
      name_id         351
      relation_id     8
      is_profile_id   80
      is_name_id      187
    end
    # 449;7;66;370;15;79;351;"2015-02-18 12:53:34.154678";"2015-02-21 11:23:57.905091";370;351
    # 450;7;79;351;18;66;370;"2015-02-18 12:53:34.175033";"2015-02-21 11:23:58.464534";351;370
    # 451;7;79;351;8;80;187;"2015-02-18 12:56:08.904901";"2015-02-21 11:23:57.965341";351;187

    trait :profile_key_w_sims_88 do
      user_id         1
      profile_id      80
      name_id         187
      relation_id     7
      is_profile_id   79
      is_name_id      351
    end
    trait :profile_key_w_sims_89 do
      user_id         1
      profile_id      70
      name_id         354
      relation_id     2
      is_profile_id   80
      is_name_id      187
    end
    trait :profile_key_w_sims_90 do
      user_id         1
      profile_id      80
      name_id         187
      relation_id     4
      is_profile_id   70
      is_name_id      354
    end
    # 452;7;80;187;7;79;351;"2015-02-18 12:56:08.924515";"2015-02-21 11:23:57.865416";187;351
    # 453;7;70;354;2;80;187;"2015-02-18 12:56:08.952808";"2015-02-21 11:23:58.024506";354;187
    # 454;7;80;187;4;70;354;"2015-02-18 12:56:08.974606";"2015-02-21 11:23:57.797229";187;354

    trait :profile_key_w_sims_91 do
      user_id         1
      profile_id      78
      name_id         173
      relation_id     2
      is_profile_id   80
      is_name_id      187
    end
    trait :profile_key_w_sims_92 do
      user_id         1
      profile_id      80
      name_id         187
      relation_id     4
      is_profile_id   78
      is_name_id      173
    end
    trait :profile_key_w_sims_93 do
      user_id         1
      profile_id      67
      name_id         173
      relation_id     6
      is_profile_id   81
      is_name_id      354
    end
    # 455;7;78;173;2;80;187;"2015-02-18 12:56:08.997598";"2015-02-21 11:23:57.986646";173;187
    # 456;7;80;187;4;78;173;"2015-02-18 12:56:09.019516";"2015-02-21 11:23:58.052711";187;173
    # 457;7;67;173;6;81;354;"2015-02-18 12:57:04.688556";"2015-02-18 12:57:04.688556";173;354

    trait :profile_key_w_sims_94 do
      user_id         1
      profile_id      81
      name_id         354
      relation_id     6
      is_profile_id   67
      is_name_id      173
    end
    trait :profile_key_w_sims_95 do
      user_id         1
      profile_id      67
      name_id         173
      relation_id     1
      is_profile_id   82
      is_name_id      351
    end
    trait :profile_key_w_sims_96 do
      user_id         1
      profile_id      82
      name_id         351
      relation_id     4
      is_profile_id   67
      is_name_id      173
    end
    # 458;7;81;354;6;67;173;"2015-02-18 12:57:04.703745";"2015-02-18 12:57:04.703745";354;173
    # 459;7;67;173;1;82;351;"2015-02-18 12:58:04.972054";"2015-02-18 12:58:04.972054";173;351
    # 460;7;82;351;4;67;173;"2015-02-18 12:58:04.990838";"2015-02-18 12:58:04.990838";351;173

    trait :profile_key_w_sims_97 do
      user_id         1
      profile_id      81
      name_id         354
      relation_id     1
      is_profile_id   82
      is_name_id      351
    end
    trait :profile_key_w_sims_98 do
      user_id         1
      profile_id      82
      name_id         351
      relation_id     4
      is_profile_id   81
      is_name_id      354
    end
    trait :profile_key_w_sims_99 do
      user_id         1
      profile_id      63
      name_id         40
      relation_id     15
      is_profile_id   82
      is_name_id      351
    end
    # 461;7;81;354;1;82;351;"2015-02-18 12:58:05.010502";"2015-02-18 12:58:05.010502";354;351
    # 462;7;82;351;4;81;354;"2015-02-18 12:58:05.033602";"2015-02-18 12:58:05.033602";351;354
    # 463;7;63;40;15;82;351;"2015-02-18 12:58:05.054748";"2015-02-18 12:58:05.054748";40;351

    trait :profile_key_w_sims_100 do
      user_id         1
      profile_id      82
      name_id         351
      relation_id     18
      is_profile_id   63
      is_name_id      40
    end
    trait :profile_key_w_sims_101 do
      user_id         1
      profile_id      81
      name_id         354
      relation_id     2
      is_profile_id   83
      is_name_id      187
    end
    trait :profile_key_w_sims_102 do
      user_id         1
      profile_id      83
      name_id         187
      relation_id     4
      is_profile_id   81
      is_name_id      354
    end
    # 464;7;82;351;18;63;40;"2015-02-18 12:58:05.075258";"2015-02-18 12:58:05.075258";351;40
    # 465;7;81;354;2;83;187;"2015-02-18 13:02:25.399689";"2015-02-18 13:02:25.399689";354;187
    # 466;7;83;187;4;81;354;"2015-02-18 13:02:25.427422";"2015-02-18 13:02:25.427422";187;354

    trait :profile_key_w_sims_103 do
      user_id         1
      profile_id      82
      name_id         351
      relation_id     8
      is_profile_id   83
      is_name_id      187
    end
    trait :profile_key_w_sims_104 do
      user_id         1
      profile_id      83
      name_id         187
      relation_id     7
      is_profile_id   82
      is_name_id      351
    end
    trait :profile_key_w_sims_105 do
      user_id         1
      profile_id      67
      name_id         173
      relation_id     2
      is_profile_id   83
      is_name_id      187
    end
    # 467;7;82;351;8;83;187;"2015-02-18 13:02:25.454887";"2015-02-18 13:02:25.454887";351;187
    # 468;7;83;187;7;82;351;"2015-02-18 13:02:25.471583";"2015-02-18 13:02:25.471583";187;351
    # 469;7;67;173;2;83;187;"2015-02-18 13:02:25.498877";"2015-02-18 13:02:25.498877";173;187

    trait :profile_key_w_sims_106 do
      user_id         1
      profile_id      83
      name_id         187
      relation_id     4
      is_profile_id   67
      is_name_id      173
    end
    trait :profile_key_w_sims_107 do
      user_id         1
      profile_id      81
      name_id         354
      relation_id     7
      is_profile_id   84
      is_name_id      370
    end
    trait :profile_key_w_sims_108 do
      user_id         1
      profile_id      84
      name_id         370
      relation_id     8
      is_profile_id   81
      is_name_id      354
    end
    # 470;7;83;187;4;67;173;"2015-02-18 13:02:25.517845";"2015-02-18 13:02:25.517845";187;173
    # 471;7;81;354;7;84;370;"2015-02-18 13:05:00.027496";"2015-02-18 13:05:00.027496";354;370
    # 472;7;84;370;8;81;354;"2015-02-18 13:05:00.047736";"2015-02-18 13:05:00.047736";370;354

    trait :profile_key_w_sims_109 do
      user_id         1
      profile_id      82
      name_id         351
      relation_id     18
      is_profile_id   84
      is_name_id      370
    end
    trait :profile_key_w_sims_110 do
      user_id         1
      profile_id      84
      name_id         370
      relation_id     15
      is_profile_id   82
      is_name_id      351
    end
    trait :profile_key_w_sims_111 do
      user_id         1
      profile_id      83
      name_id         187
      relation_id     18
      is_profile_id   84
      is_name_id      370
    end
    trait :profile_key_w_sims_112 do
      user_id         1
      profile_id      84
      name_id         370
      relation_id     16
      is_profile_id   83
      is_name_id      187
    end
    # 473;7;82;351;18;84;370;"2015-02-18 13:05:00.072887";"2015-02-18 13:05:00.072887";351;370
    # 474;7;84;370;15;82;351;"2015-02-18 13:05:00.098164";"2015-02-18 13:05:00.098164";370;351
    # 475;7;83;187;18;84;370;"2015-02-18 13:05:00.117445";"2015-02-18 13:05:00.117445";187;370
    # 476;7;84;370;16;83;187;"2015-02-18 13:05:00.14066";"2015-02-18 13:05:00.14066";370;187

    # For 2 connected trees test - 2nd. Tree = 2. User = 2. Profile = 66

  end

end


# After Connected

# 365;7;63;40;1;64;90
# 366;7;64;90;3;63;40
# 367;7;63;40;2;65;345
# 368;7;65;345;3;63;40
# 369;7;64;90;8;65;345
# 370;7;65;345;7;64;90
# 371;7;63;40;5; 84;370  X
# 372;7; 84;370;5;63;40   X
# 373;7;64;90;3; 84;370  X
# 374;7; 84;370;1;64;90   X

# 375;7;65;345;3; 84;370  X
# 376;7; 84;370;2;65;345   X
# 377;7;63;40;8;67;173
# 378;7;67;173;7;63;40
# 379;7;64;90;17;67;173
# 380;7;67;173;13;64;90
# 381;7;65;345;17;67;173
# 382;7;67;173;14;65;345
# 383;7;64;90;1;68;343
# 384;7;68;343;3;64;90

# 385;7;63;40;91;68;343
# 386;7;68;343;111;63;40
# 387;7; 84;370;91;68;343  X
# 388;7;68;343;111;84;370
# 389;7;65;345;13;68;343
# 390;7;68;343;17;65;345
# 391;7;64;90;2;69;293
# 392;7;69;293;3;64;90
# 393;7;68;343;8;69;293
# 394;7;69;293;7;68;343

# 395;7;63;40;101;69;293
# 396;7;69;293;111;63;40
# 397;7; 84;370;101;69;293  X
# 398;7;69;293;111;84;370
# 399;7;65;345;14;69;293
# 400;7;69;293;17;65;345
# 401;7;84;370;8;81;354
# 402;7;81;354;7; 84;370  X
# 403;7;64;90;17;81;354
# 404;7;81;354;13;64;90

# 405;7;65;345;17;81;354
# 406;7;81;354;14;65;345
# 407;8;84;370;1;64;90
# 408;8;64;90;3;84;370
# 409;8;84;370;2;65;345
# 410;8;65;345;3;84;370
# 411;8;64;90;8;65;345
# 412;8;65;345;7;64;90
# 413;8;84;370;5;63;40
# 414;8;63;40;5;84;370
# 415;8;64;90;3;63;40
# 416;8;63;40;1;64;90
# 417;8;65;345;3;63;40
# 418;8;63;40;2;65;345
# 419;8;84;370;8;81;354
# 420;8;81;354;7;84;370
# 421;8;64;90;17;81;354
# 422;8;81;354;13;64;90
# 423;8;65;345;17;81;354
# 424;8;81;354;14;65;345
# 425;8;64;90;1;68;343
# 426;8;68;343;3;64;90
# 427;8;84;370;91;68;343
# 428;8;68;343;111;84;370
# 429;8;63;40;91;68;343
# 430;8;68;343;111;63;40
# 431;8;65;345;13;68;343
# 432;8;68;343;17;65;345
# 433;8;64;90;2;69;293
# 434;8;69;293;3;64;90
# 435;8;68;343;8;69;293
# 436;8;69;293;7;68;343
# 437;8;84;370;101;69;293
# 438;8;69;293;111;84;370
# 439;8;63;40;101;69;293
# 440;8;69;293;111;63;40
# 441;8;65;345;14;69;293
# 442;8;69;293;17;65;345
# 443;7;81;354;6;67;173
# 444;7;67;173;6;81;354
# 445;7;81;354;1;82;351
# 446;7;82;351;4;81;354
# 447;7;67;173;1;82;351
# 448;7;82;351;4;67;173
# 449;7;84;370;15;82;351
# 450;7;82;351;18;84;370
# 451;7;82;351;8;83;187
# 452;7;83;187;7;82;351
# 453;7;81;354;2;83;187
# 454;7;83;187;4;81;354
# 455;7;67;173;2;83;187
# 456;7;83;187;4;67;173
# 457;7;67;173;6;81;354
# 458;7;81;354;6;67;173
# 459;7;67;173;1;82;351
# 460;7;82;351;4;67;173
# 461;7;81;354;1;82;351
# 462;7;82;351;4;81;354
# 463;7;63;40;15;82;351
# 464;7;82;351;18;63;40
# 465;7;81;354;2;83;187
# 466;7;83;187;4;81;354
# 467;7;82;351;8;83;187
# 468;7;83;187;7;82;351
# 469;7;67;173;2;83;187
# 470;7;83;187;4;67;173
# 471;7;81;354;7;84;370
# 472;7;84;370;8;81;354
# 473;7;82;351;18;84;370
# 474;7;84;370;15;82;351
# 475;7;83;187;18;84;370
# 476;7;84;370;16;83;187


# After DisConnected

# 365;7;63;40;1;64;90
# 366;7;64;90;3;63;40
# 367;7;63;40;2;65;345
# 368;7;65;345;3;63;40
# 369;7;64;90;8;65;345
# 370;7;65;345;7;64;90
# 371;7;63;40;5;66;370

# 372;7;66;370;5;63;40
# 373;7;64;90;3;66;370
# 374;7;66;370;1;64;90
# 375;7;65;345;3;66;370
# 376;7;66;370;2;65;345
# 377;7;63;40;8;67;173
# 378;7;67;173;7;63;40
# 379;7;64;90;17;67;173
# 380;7;67;173;13;64;90
# 381;7;65;345;17;67;173
# 382;7;67;173;14;65;345
# 383;7;64;90;1;68;343
# 384;7;68;343;3;64;90
# 385;7;63;40;91;68;343
# 386;7;68;343;111;63;40
# 387;7;66;370;91;68;343
# 388;7;68;343;111;66;370
# 389;7;65;345;13;68;343
# 390;7;68;343;17;65;345
# 391;7;64;90;2;69;293
# 392;7;69;293;3;64;90
# 393;7;68;343;8;69;293
# 394;7;69;293;7;68;343
# 395;7;63;40;101;69;293
# 396;7;69;293;111;63;40
# 397;7;66;370;101;69;293
# 398;7;69;293;111;66;370
# 399;7;65;345;14;69;293
# 400;7;69;293;17;65;345
# 401;7;66;370;8;70;354
# 402;7;70;354;7; 66;370  X
# 403;7;64;90;17;70;354
# 404;7;70;354;13;64;90
# 405;7;65;345;17;70;354
# 406;7;70;354;14;65;345
# 407;8;66;370;1;64;90
# 408;8;64;90;3;66;370
# 409;8;66;370;2;65;345
# 410;8;65;345;3;66;370
# 411;8;64;90;8;65;345
# 412;8;65;345;7;64;90
# 413;8;66;370;5;63;40
# 414;8;63;40;5;66;370
# 415;8;64;90;3;63;40
# 416;8;63;40;1;64;90
# 417;8;65;345;3;63;40
# 418;8;63;40;2;65;345
# 419;8;66;370;8;70;354
# 420;8;70;354;7;66;370
# 421;8;64;90;17;70;354
# 422;8;70;354;13;64;90
# 423;8;65;345;17;70;354
# 424;8;70;354;14;65;345
# 425;8;64;90;1;68;343
# 426;8;68;343;3;64;90
# 427;8;66;370;91;68;343
# 428;8;68;343;111;66;370
# 429;8;63;40;91;68;343
# 430;8;68;343;111;63;40
# 431;8;65;345;13;68;343
# 432;8;68;343;17;65;345
# 433;8;64;90;2;69;293
# 434;8;69;293;3;64;90
# 435;8;68;343;8;69;293
# 436;8;69;293;7;68;343
# 437;8;66;370;101;69;293
# 438;8;69;293;111;66;370
# 439;8;63;40;101;69;293
# 440;8;69;293;111;63;40
# 441;8;65;345;14;69;293
# 442;8;69;293;17;65;345
# 443;7;70;354;6;78;173
# 444;7;78;173;6;70;354
# 445;7;70;354;1;79;351
# 446;7;79;351;4;70;354
# 447;7;78;173;1;79;351
# 448;7;79;351;4;78;173
# 449;7;66;370;15;79;351
# 450;7;79;351;18;66;370
# 451;7;79;351;8;80;187
# 452;7;80;187;7;79;351
# 453;7;70;354;2;80;187
# 454;7;80;187;4;70;354
# 455;7;78;173;2;80;187
# 456;7;80;187;4;78;173
# 457;7;67;173;6;81;354
# 458;7;81;354;6;67;173
# 459;7;67;173;1;82;351
# 460;7;82;351;4;67;173
# 461;7;81;354;1;82;351
# 462;7;82;351;4;81;354
# 463;7;63;40;15;82;351
# 464;7;82;351;18;63;40
# 465;7;81;354;2;83;187
# 466;7;83;187;4;81;354
# 467;7;82;351;8;83;187
# 468;7;83;187;7;82;351
# 469;7;67;173;2;83;187
# 470;7;83;187;4;67;173
# 471;7;81;354;7;84;370
# 472;7;84;370;8;81;354
# 473;7;82;351;18;84;370
# 474;7;84;370;15;82;351
# 475;7;83;187;18;84;370
# 476;7;84;370;16;83;187
