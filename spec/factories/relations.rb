FactoryGirl.define do

  factory :relation, class: Relation do
    relation                "Автор"
    relation_id             0 #
    relation_rod_padej      "Автора"
    reverse_relation_id     0
    reverse_relation        "Автор"
    origin_profile_sex_id   1

    trait :relation_2 do
      relation                "Автор"
      relation_id             0 #
      relation_rod_padej      "Автора"
      reverse_relation_id     0
      reverse_relation        "Автор"
      origin_profile_sex_id   0
    end
    trait :relation_3 do
      relation                "Отец"
      relation_id             1 #
      relation_rod_padej      "Отца"
      reverse_relation_id     3
      reverse_relation        "Сын"
      origin_profile_sex_id   1
    end
# 1;"Автор";"2015-01-23 07:09:51.415785";"2015-01-23 07:09:51.415785";0;"Автора";0;"Автор";1
# 2;"Автор";"2015-01-23 07:09:51.428355";"2015-01-23 07:09:51.428355";0;"Автора";0;"Автор";0
# 3;"Отец";"2015-01-23 07:09:51.440736";"2015-01-23 07:09:51.440736";1;"Отца";3;"Сын";1

    trait :relation_4 do
      relation                "Отец"
      relation_id             1 #
      relation_rod_padej      "Отца"
      reverse_relation_id     4
      reverse_relation        "Дочь"
      origin_profile_sex_id   0
    end
    trait :relation_5 do
      relation                "Мать"
      relation_id             2 #
      relation_rod_padej      "Матери"
      reverse_relation_id     3
      reverse_relation        "Сын"
      origin_profile_sex_id   1
    end
    trait :relation_6 do
      relation                "Мать"
      relation_id             2 #
      relation_rod_padej      "Матери"
      reverse_relation_id     4
      reverse_relation        "Дочь"
      origin_profile_sex_id   0
    end
# 4;"Отец";"2015-01-23 07:09:51.451647";"2015-01-23 07:09:51.451647";1;"Отца";4;"Дочь";0
# 5;"Мать";"2015-01-23 07:09:51.461945";"2015-01-23 07:09:51.461945";2;"Матери";3;"Сын";1
# 6;"Мать";"2015-01-23 07:09:51.472814";"2015-01-23 07:09:51.472814";2;"Матери";4;"Дочь";0

    trait :relation_7 do
      relation                "Сын"
      relation_id             3 #
      relation_rod_padej      "Сына"
      reverse_relation_id     1
      reverse_relation        "Отец"
      origin_profile_sex_id   1
    end
    trait :relation_8 do
      relation                "Сын"
      relation_id             3 #
      relation_rod_padej      "Сына"
      reverse_relation_id     2
      reverse_relation        "Мать"
      origin_profile_sex_id   0
    end
    trait :relation_9 do
      relation                "Дочь"
      relation_id             4 #
      relation_rod_padej      "Дочери"
      reverse_relation_id     1
      reverse_relation        "Отец"
      origin_profile_sex_id   1
    end
# 7;"Сын";"2015-01-23 07:09:51.484857";"2015-01-23 07:09:51.484857";3;"Сына";1;"Отец";1
# 8;"Сын";"2015-01-23 07:09:51.496109";"2015-01-23 07:09:51.496109";3;"Сына";2;"Мать";0
# 9;"Дочь";"2015-01-23 07:09:51.506089";"2015-01-23 07:09:51.506089";4;"Дочери";1;"Отец";1

    trait :relation_10 do
      relation                "Дочь"
      relation_id             4 #
      relation_rod_padej      "Дочери"
      reverse_relation_id     2
      reverse_relation        "Мать"
      origin_profile_sex_id   0
    end
    trait :relation_11 do
      relation                "Брат"
      relation_id             5 #
      relation_rod_padej      "Брата"
      reverse_relation_id     5
      reverse_relation        "Брат"
      origin_profile_sex_id   1
    end
    trait :relation_12 do
      relation                "Брат"
      relation_id             5 #
      relation_rod_padej      "Брата"
      reverse_relation_id     6
      reverse_relation        "Сестра"
      origin_profile_sex_id   0
    end
# 10;"Дочь";"2015-01-23 07:09:51.517234";"2015-01-23 07:09:51.517234";4;"Дочери";2;"Мать";0
# 11;"Брат";"2015-01-23 07:09:51.528895";"2015-01-23 07:09:51.528895";5;"Брата";5;"Брат";1
# 12;"Брат";"2015-01-23 07:09:51.540184";"2015-01-23 07:09:51.540184";5;"Брата";6;"Сестра";0

    trait :relation_13 do
      relation                "Сестра"
      relation_id             6 #
      relation_rod_padej      "Сестры"
      reverse_relation_id     5
      reverse_relation        "Брат"
      origin_profile_sex_id   1
    end
    trait :relation_14 do
      relation                "Сестра"
      relation_id             6 #
      relation_rod_padej      "Сестры"
      reverse_relation_id     6
      reverse_relation        "Сестра"
      origin_profile_sex_id   0
    end
    trait :relation_15 do
      relation                "Муж"
      relation_id             7 #
      relation_rod_padej      "Мужа"
      reverse_relation_id     8
      reverse_relation        "Жена"
      origin_profile_sex_id   0
    end
# 13;"Сестра";"2015-01-23 07:09:51.55217";"2015-01-23 07:09:51.55217";6;"Сестры";5;"Брат";1
# 14;"Сестра";"2015-01-23 07:09:51.562638";"2015-01-23 07:09:51.562638";6;"Сестры";6;"Сестра";0
# 15;"Муж";"2015-01-23 07:09:51.573673";"2015-01-23 07:09:51.573673";7;"Мужа";8;"Жена";0

    trait :relation_16 do
      relation                "Жена"
      relation_id             8 #
      relation_rod_padej      "Жены"
      reverse_relation_id     7
      reverse_relation        "Муж"
      origin_profile_sex_id   1
    end
    trait :relation_17 do
      relation                "Дед по Отцу"
      relation_id             91#
      relation_rod_padej      "Деда"
      reverse_relation_id     111
      reverse_relation        "Внук"
      origin_profile_sex_id   1
    end
    trait :relation_18 do
      relation                "Дед по Отцу"
      relation_id             91#
      relation_rod_padej      "Деда"
      reverse_relation_id     121
      reverse_relation        "Внучка"
      origin_profile_sex_id   0
    end
# 16;"Жена";"2015-01-23 07:09:51.583896";"2015-01-23 07:09:51.583896";8;"Жены";7;"Муж";1
# 17;"Дед по Отцу";"2015-01-23 07:09:51.594931";"2015-01-23 07:09:51.594931";91;"Деда";111;"Внук";1
# 18;"Дед по Отцу";"2015-01-23 07:09:51.607";"2015-01-23 07:09:51.607";91;"Деда";121;"Внучка";0

    trait :relation_19 do
      relation                "Бабка по Отцу"
      relation_id             101
      relation_rod_padej      "Бабки"
      reverse_relation_id     111
      reverse_relation        "Внук"
      origin_profile_sex_id   1
    end
    trait :relation_20 do
      relation                "Бабка по Отцу"
      relation_id             101
      relation_rod_padej      "Бабки"
      reverse_relation_id     121
      reverse_relation        "Внучка"
      origin_profile_sex_id   0
    end
    trait :relation_21 do
      relation                "Внук по Отцу"
      relation_id             111
      relation_rod_padej      "Внука"
      reverse_relation_id     91
      reverse_relation        "Дед"
      origin_profile_sex_id   1
    end
# 19;"Бабка по Отцу";"2015-01-23 07:09:51.617108";"2015-01-23 07:09:51.617108";101;"Бабки";111;"Внук";1
# 20;"Бабка по Отцу";"2015-01-23 07:09:51.628054";"2015-01-23 07:09:51.628054";101;"Бабки";121;"Внучка";0
# 21;"Внук по Отцу";"2015-01-23 07:09:51.640543";"2015-01-23 07:09:51.640543";111;"Внука";91;"Дед";1

    trait :relation_22 do
      relation                "Внук по Отцу"
      relation_id             111
      relation_rod_padej      "Внука"
      reverse_relation_id     101
      reverse_relation        "Бабка"
      origin_profile_sex_id   0
    end
    trait :relation_23 do
      relation                "Внучка по Отцу"
      relation_id             121
      relation_rod_padej      "Внучки"
      reverse_relation_id     91
      reverse_relation        "Дед"
      origin_profile_sex_id   1
    end
    trait :relation_24 do
      relation                "Внучка по Отцу"
      relation_id             121
      relation_rod_padej      "Внучки"
      reverse_relation_id     101
      reverse_relation        "Бабка"
      origin_profile_sex_id   0
    end
# 22;"Внук по Отцу";"2015-01-23 07:09:51.650758";"2015-01-23 07:09:51.650758";111;"Внука";101;"Бабка";0
# 23;"Внучка по Отцу";"2015-01-23 07:09:51.661578";"2015-01-23 07:09:51.661578";121;"Внучки";91;"Дед";1
# 24;"Внучка по Отцу";"2015-01-23 07:09:51.673852";"2015-01-23 07:09:51.673852";121;"Внучки";101;"Бабка";0


    trait :relation_25 do
      relation                "Дед по Матери"
      relation_id             92
      relation_rod_padej      "Деда"
      reverse_relation_id     112
      reverse_relation        "Внук"
      origin_profile_sex_id   1
    end
    trait :relation_26 do
      relation                "Дед по Матери"
      relation_id             92
      relation_rod_padej      "Деда"
      reverse_relation_id     122
      reverse_relation        "Внучка"
      origin_profile_sex_id   0
    end
    trait :relation_27 do
      relation                "Бабка по Матери"
      relation_id             102
      relation_rod_padej      "Бабки"
      reverse_relation_id     112
      reverse_relation        "Внук"
      origin_profile_sex_id   1
    end
# 25;"Дед по Матери";"2015-01-23 07:09:51.683745";"2015-01-23 07:09:51.683745";92;"Деда";112;"Внук";1
# 26;"Дед по Матери";"2015-01-23 07:09:51.705687";"2015-01-23 07:09:51.705687";92;"Деда";122;"Внучка";0
# 27;"Бабка по Матери";"2015-01-23 07:09:51.715599";"2015-01-23 07:09:51.715599";102;"Бабки";112;"Внук";1

    trait :relation_28 do
      relation                "Бабка по Матери"
      relation_id             102
      relation_rod_padej      "Бабки"
      reverse_relation_id     122
      reverse_relation        "Внучка"
      origin_profile_sex_id   0
    end
    trait :relation_29 do
      relation                "Внук по Матери"
      relation_id             112
      relation_rod_padej      "Внука"
      reverse_relation_id     92
      reverse_relation        "Дед"
      origin_profile_sex_id   1
    end
    trait :relation_30 do
      relation                "Внук по Матери"
      relation_id             112
      relation_rod_padej      "Внука"
      reverse_relation_id     102
      reverse_relation        "Бабка"
      origin_profile_sex_id   0
    end
# 28;"Бабка по Матери";"2015-01-23 07:09:51.725787";"2015-01-23 07:09:51.725787";102;"Бабки";122;"Внучка";0
# 29;"Внук по Матери";"2015-01-23 07:09:51.737094";"2015-01-23 07:09:51.737094";112;"Внука";92;"Дед";1
# 30;"Внук по Матери";"2015-01-23 07:09:51.748142";"2015-01-23 07:09:51.748142";112;"Внука";102;"Бабка";0

    trait :relation_31 do
      relation                "Внучка по Матери"
      relation_id             122
      relation_rod_padej      "Внучки"
      reverse_relation_id     92
      reverse_relation        "Дед"
      origin_profile_sex_id   1
    end
    trait :relation_32 do
      relation                "Внучка по Матери"
      relation_id             122
      relation_rod_padej      "Внучки"
      reverse_relation_id     102
      reverse_relation        "Бабка"
      origin_profile_sex_id   0
    end
    trait :relation_33 do
      relation                "Свекр"
      relation_id             13
      relation_rod_padej      "Свекра"
      reverse_relation_id     17
      reverse_relation        "Невестка"
      origin_profile_sex_id   0
    end
# 31;"Внучка по Матери";"2015-01-23 07:09:51.759961";"2015-01-23 07:09:51.759961";122;"Внучки";92;"Дед";1
# 32;"Внучка по Матери";"2015-01-23 07:09:51.770251";"2015-01-23 07:09:51.770251";122;"Внучки";102;"Бабка";0
# 33;"Свекр";"2015-01-23 07:09:51.781509";"2015-01-23 07:09:51.781509";13;"Свекра";17;"Невестка";0

    trait :relation_34 do
      relation                "Свекровь"
      relation_id             14
      relation_rod_padej      "Свекрови"
      reverse_relation_id     17
      reverse_relation        "Невестка"
      origin_profile_sex_id   0
    end
    trait :relation_35 do
      relation                "Тесть"
      relation_id             15
      relation_rod_padej      "Тестя"
      reverse_relation_id     18
      reverse_relation        "Зять"
      origin_profile_sex_id   1
    end
    trait :relation_36 do
      relation                "Теща"
      relation_id             16
      relation_rod_padej      "Тещи"
      reverse_relation_id     18
      reverse_relation        "Зять"
      origin_profile_sex_id   1
    end
# 34;"Свекровь";"2015-01-23 07:09:51.793331";"2015-01-23 07:09:51.793331";14;"Свекрови";17;"Невестка";0
# 35;"Тесть";"2015-01-23 07:09:51.804497";"2015-01-23 07:09:51.804497";15;"Тестя";18;"Зять";1
# 36;"Теща";"2015-01-23 07:09:51.814441";"2015-01-23 07:09:51.814441";16;"Тещи";18;"Зять";1


    trait :relation_37 do
      relation                "Невестка"
      relation_id             17
      relation_rod_padej      "Невестки"
      reverse_relation_id     13
      reverse_relation        "Свекр"
      origin_profile_sex_id   1
    end
    trait :relation_38 do
      relation                "Невестка"
      relation_id             17
      relation_rod_padej      "Невестки"
      reverse_relation_id     14
      reverse_relation        "Свекровь"
      origin_profile_sex_id   0
    end
    trait :relation_39 do
      relation                "Зять"
      relation_id             18
      relation_rod_padej      "Зятя"
      reverse_relation_id     15
      reverse_relation        "Тесть"
      origin_profile_sex_id   1
    end
# 37;"Невестка";"2015-01-23 07:09:51.825499";"2015-01-23 07:09:51.825499";17;"Невестки";13;"Свекр";1
# 38;"Невестка";"2015-01-23 07:09:51.837898";"2015-01-23 07:09:51.837898";17;"Невестки";14;"Свекровь";0
# 39;"Зять";"2015-01-23 07:09:51.848046";"2015-01-23 07:09:51.848046";18;"Зятя";15;"Тесть";1

    trait :relation_40 do
      relation                "Зять"
      relation_id             18
      relation_rod_padej      "Зятя"
      reverse_relation_id     16
      reverse_relation        "Теща"
      origin_profile_sex_id   0
    end
    trait :relation_41 do
      relation                "Дядя по Отцу"
      relation_id             191
      relation_rod_padej      "Дяди"
      reverse_relation_id     211
      reverse_relation        "Племянник"
      origin_profile_sex_id   1
    end
    trait :relation_42 do
      relation                "Дядя по Отцу"
      relation_id             191
      relation_rod_padej      "Дяди"
      reverse_relation_id     221
      reverse_relation        "Племянница"
      origin_profile_sex_id   0
    end
# 40;"Зять";"2015-01-23 07:09:51.859216";"2015-01-23 07:09:51.859216";18;"Зятя";16;"Теща";0
# 41;"Дядя по Отцу";"2015-01-23 07:09:51.870378";"2015-01-23 07:09:51.870378";191;"Дяди";211;"Племянник";1
# 42;"Дядя по Отцу";"2015-01-23 07:09:51.881405";"2015-01-23 07:09:51.881405";191;"Дяди";221;"Племянница";0

    trait :relation_43 do
      relation                "Тетя по Отцу"
      relation_id             201
      relation_rod_padej      "Тети"
      reverse_relation_id     211
      reverse_relation        "Племянник"
      origin_profile_sex_id   1
    end
    trait :relation_44 do
      relation                "Тетя по Отцу"
      relation_id             201
      relation_rod_padej      "Тети"
      reverse_relation_id     221
      reverse_relation        "Племянница"
      origin_profile_sex_id   0
    end
    trait :relation_45 do
      relation                "Племянник по Отцу"
      relation_id             211
      relation_rod_padej      "Племянника"
      reverse_relation_id     191
      reverse_relation        "Дядя"
      origin_profile_sex_id   1
    end
# 43;"Тетя по Отцу";"2015-01-23 07:09:51.892572";"2015-01-23 07:09:51.892572";201;"Тети";211;"Племянник";1
# 44;"Тетя по Отцу";"2015-01-23 07:09:51.903695";"2015-01-23 07:09:51.903695";201;"Тети";221;"Племянница";0
# 45;"Племянник по Отцу";"2015-01-23 07:09:51.91469";"2015-01-23 07:09:51.91469";211;"Племянника";191;"Дядя";1

    trait :relation_46 do
      relation                "Племянник по Отцу"
      relation_id             211
      relation_rod_padej      "Племянника"
      reverse_relation_id     201
      reverse_relation        "Тетя"
      origin_profile_sex_id   0
    end
    trait :relation_47 do
      relation                "Племянница по Отцу"
      relation_id             221
      relation_rod_padej      "Племянницы"
      reverse_relation_id     191
      reverse_relation        "Дядя"
      origin_profile_sex_id   1
    end
    trait :relation_48 do
      relation                "Племянница по Отцу"
      relation_id             221
      relation_rod_padej      "Племянницы"
      reverse_relation_id     201
      reverse_relation        "Тетя"
      origin_profile_sex_id   0
    end
# 46;"Племянник по Отцу";"2015-01-23 07:09:51.926478";"2015-01-23 07:09:51.926478";211;"Племянника";201;"Тетя";0
# 47;"Племянница по Отцу";"2015-01-23 07:09:51.937476";"2015-01-23 07:09:51.937476";221;"Племянницы";191;"Дядя";1
# 48;"Племянница по Отцу";"2015-01-23 07:09:51.948709";"2015-01-23 07:09:51.948709";221;"Племянницы";201;"Тетя";0

    trait :relation_49 do
      relation                "Дядя по Матери"
      relation_id             192
      relation_rod_padej      "Дяди"
      reverse_relation_id     212
      reverse_relation        "Племянник"
      origin_profile_sex_id   1
    end
    trait :relation_50 do
      relation                "Дядя по Матери"
      relation_id             192
      relation_rod_padej      "Дяди"
      reverse_relation_id     222
      reverse_relation        "Племянница"
      origin_profile_sex_id   0
    end
    trait :relation_51 do
      relation                "Тетя по Матери"
      relation_id             202
      relation_rod_padej      "Тети"
      reverse_relation_id     212
      reverse_relation        "Племянник"
      origin_profile_sex_id   1
    end
# 49;"Дядя по Матери";"2015-01-23 07:09:51.959809";"2015-01-23 07:09:51.959809";192;"Дяди";212;"Племянник";1
# 50;"Дядя по Матери";"2015-01-23 07:09:51.97079";"2015-01-23 07:09:51.97079";192;"Дяди";222;"Племянница";0
# 51;"Тетя по Матери";"2015-01-23 07:09:51.982237";"2015-01-23 07:09:51.982237";202;"Тети";212;"Племянник";1

    trait :relation_52 do
      relation                "Тетя по Матери"
      relation_id             202
      relation_rod_padej      "Тети"
      reverse_relation_id     222
      reverse_relation        "Племянница"
      origin_profile_sex_id   0
    end
    trait :relation_53 do
      relation                "Племянник по Матери"
      relation_id             212
      relation_rod_padej      "Племянника"
      reverse_relation_id     192
      reverse_relation        "Дядя"
      origin_profile_sex_id   1
    end
    trait :relation_54 do
      relation                "Племянник по Матери"
      relation_id             212
      relation_rod_padej      "Племянника"
      reverse_relation_id     202
      reverse_relation        "Тетя"
      origin_profile_sex_id   0
    end
# 52;"Тетя по Матери";"2015-01-23 07:09:51.993236";"2015-01-23 07:09:51.993236";202;"Тети";222;"Племянница";0
# 53;"Племянник по Матери";"2015-01-23 07:09:52.003733";"2015-01-23 07:09:52.003733";212;"Племянника";192;"Дядя";1
# 54;"Племянник по Матери";"2015-01-23 07:09:52.014734";"2015-01-23 07:09:52.014734";212;"Племянника";202;"Тетя";0

    trait :relation_55 do
      relation                "Племянница по Матери"
      relation_id             222
      relation_rod_padej      "Племянницы"
      reverse_relation_id     192
      reverse_relation        "Дядя"
      origin_profile_sex_id   1
    end
    trait :relation_56 do
      relation                "Племянница по Матери"
      relation_id             222
      relation_rod_padej      "Племянницы"
      reverse_relation_id     202
      reverse_relation        "Тетя"
      origin_profile_sex_id   0
    end
# 55;"Племянница по Матери";"2015-01-23 07:09:52.0264";"2015-01-23 07:09:52.0264";222;"Племянницы";192;"Дядя";1
# 56;"Племянница по Матери";"2015-01-23 07:09:52.037";"2015-01-23 07:09:52.037";222;"Племянницы";202;"Тетя";0



  end


end
#
