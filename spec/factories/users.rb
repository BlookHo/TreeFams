FactoryGirl.define do
  factory :user do          # For 2 connected trees test - 1st. Tree = 1
    admin false
    profile_id 63
    email "petr_andr@pe.pe"
    password 'qwertyuiop'
    connected_users {}


    trait :wrong_email do
      email "petr_and"
    end

    trait :user_2 do        # For 2 connected trees test - 2nd. Tree = 2
      profile_id 66
      email "andrey@an.an"
      password '11111'
    end

    trait :user_3 do
      profile_id 333
      email "mail_3@pe.pe"
    end

    trait :user_4 do
      profile_id 444
      email "mail_4@pe.pe"
      connected_users [4]
    end

    trait :user_5 do
      profile_id 555
      email "mail_5@pe.pe"
      connected_users [5]
    end

    trait :user_6 do
      profile_id 666
      email "mail_6@pe.pe"
    end

    trait :user_7 do
      profile_id 777
      email "mail_7@pe.pe"
    end

    trait :user_8 do
      profile_id 888
      email "mail_8@pe.pe"
    end

    trait :user_9 do              # before
      profile_id 85
      email "add_petr@pe.pe"
      connected_users [9]
    end
    trait :user_10 do  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      profile_id 93
      email "add_darja@da.da"
      connected_users nil   # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    end

    trait :user_11 do
      profile_id 99
      email "misha@da.da"
    end

    trait :user_12 do
      profile_id 193
      email "tolaa@da.da"
    end

    trait :user_13 do
      profile_id 295
      email "vera@da.da"
    end

    trait :current_user_1_connected do # For [1, 2] connected trees test
      profile_id 17
      email "alexey@al.al"
      password '11111'
      double 0
      connected_users [1,2]

    end
    trait :user_2_connected do        # For [1, 2] connected trees test
      profile_id 11
      email "aneta@an.an"
      password '11111'
      connected_users [1,2]
    end
    trait :user_3_to_connect do        # For [3] to be connected [1,2,3] trees test
      profile_id 22
      email "natali@na.na"
      password '11111'
      connected_users [3]
    end


  end

  factory :other_user, class: User do #
    profile_id 31
    email "mail_2@pe.pe"
    password '1111'
  end

  factory :third_user, class: User do #
    profile_id 44
    email "olga@ol.ol"
    password '1111'
  end

  factory :four_user, class: User do #
    profile_id 55
    email "boris@bo.bo"
    password '1111'
  end

  # For ProfileData destroy method test
  factory :user_profile_data, class: User do #

    id 155
    profile_id 559
    email "dimitrii@di.di"
    password '1111'

    trait :user_210 do
      id 210
      profile_id 22111
      email "andrew@an.an"
      password '1111'
    end

  end

  # For Search_results
  factory :user_search_results, class: User do #

    trait :user_34 do
      id 34
      profile_id 539
      email "aleksei@aa.aa"
      password '1111'
      connected_users [34]
    end

    trait :user_45 do
      id 45
      profile_id 645
      email "anna@an.an"
      password '1111'
      connected_users [45]
    end

    trait :user_46 do
      id 46
      profile_id 656
      email "petr_iva@pe.pe"
      password '1111'
      connected_users [46]
    end

    trait :user_47 do
      id 47
      profile_id 666
      email "fedor_iva@fe.fe"
      password '1111'
      connected_users [47]
    end

    trait :user_11 do
      id 11
      profile_id 666
      email "fuser_11@uu.uu"
      password '1111'
      connected_users [10,11,12]
    end

  end


end

# After Connected Similars
#
# 1;17
# 2;11
# 3;22
# 6;53
# 7;63
# 8;84
#

# After DisConnected Similars
#
# 1;17;FALSE
# 2;11;FALSE
# 3;22;FALSE
# 6;53;FALSE
# 7;63;FALSE
# 8;66;FALSE

# Before Add new Profile
# 9;85;FALSE;0
# 10;93;FALSE;0



