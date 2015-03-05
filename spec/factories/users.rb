FactoryGirl.define do
  factory :user do          # For 2 connected trees test - 1st. Tree = 1
    admin false
    profile_id 63
    email "petr_andr@pe.pe"
    password 'qwertyuiop'

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
    end

    trait :user_9 do              # before
      profile_id 85
      email "add_petr@pe.pe"
    end
    trait :user_10 do
      profile_id 93
      email "add_darja@da.da"
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

