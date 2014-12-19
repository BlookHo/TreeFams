
Relation.delete_all
Relation.reset_pk_sequence
Relation.create([

  {relation_id: 0, relation: 'Автор', relation_rod_padej: 'Автора', origin_profile_sex_id: 1, reverse_relation_id: 0, reverse_relation: 'Автор'},
  {relation_id: 0, relation: 'Автор', relation_rod_padej: 'Автора', origin_profile_sex_id: 0,  reverse_relation_id: 0, reverse_relation: 'Автор'},
  {relation_id: 1, relation: 'Отец', relation_rod_padej: 'Отца', origin_profile_sex_id: 1,  reverse_relation_id: 3, reverse_relation: 'Сын'},
  {relation_id: 1, relation: 'Отец', relation_rod_padej: 'Отца', origin_profile_sex_id: 0,  reverse_relation_id: 4, reverse_relation: 'Дочь'},
  {relation_id: 2, relation: 'Мать', relation_rod_padej: 'Матери', origin_profile_sex_id: 1,  reverse_relation_id: 3, reverse_relation: 'Сын'},
  {relation_id: 2, relation: 'Мать', relation_rod_padej: 'Матери', origin_profile_sex_id: 0,  reverse_relation_id: 4, reverse_relation: 'Дочь'},
  {relation_id: 3, relation: 'Сын', relation_rod_padej: 'Сына', origin_profile_sex_id: 1,  reverse_relation_id: 1, reverse_relation: 'Отец'},
  {relation_id: 3, relation: 'Сын', relation_rod_padej: 'Сына', origin_profile_sex_id: 0,  reverse_relation_id: 2, reverse_relation: 'Мать'},
  {relation_id: 4, relation: 'Дочь', relation_rod_padej: 'Дочери', origin_profile_sex_id: 1,  reverse_relation_id: 1, reverse_relation: 'Отец'},
  {relation_id: 4, relation: 'Дочь', relation_rod_padej: 'Дочери', origin_profile_sex_id: 0,  reverse_relation_id: 2, reverse_relation: 'Мать'},
  {relation_id: 5, relation: 'Брат', relation_rod_padej: 'Брата', origin_profile_sex_id: 1,  reverse_relation_id: 5, reverse_relation: 'Брат'},
  {relation_id: 5, relation: 'Брат', relation_rod_padej: 'Брата', origin_profile_sex_id: 0,  reverse_relation_id: 6, reverse_relation: 'Сестра'},
  {relation_id: 6, relation: 'Сестра', relation_rod_padej: 'Сестры', origin_profile_sex_id: 1,  reverse_relation_id: 5, reverse_relation: 'Брат'},
  {relation_id: 6, relation: 'Сестра', relation_rod_padej: 'Сестры', origin_profile_sex_id: 0,  reverse_relation_id: 6, reverse_relation: 'Сестра'},
  {relation_id: 7, relation: 'Муж', relation_rod_padej: 'Мужа', origin_profile_sex_id: 0,  reverse_relation_id: 8, reverse_relation: 'Жена'},
  {relation_id: 8, relation: 'Жена', relation_rod_padej: 'Жены', origin_profile_sex_id: 1,  reverse_relation_id: 7, reverse_relation: 'Муж'},


  {relation_id: 91, relation: 'Дед по Отцу', relation_rod_padej: 'Деда', origin_profile_sex_id: 1,  reverse_relation_id: 111, reverse_relation: 'Внук'},
  {relation_id: 91, relation: 'Дед по Отцу', relation_rod_padej: 'Деда', origin_profile_sex_id: 0,  reverse_relation_id: 121, reverse_relation: 'Внучка'},
  {relation_id: 101, relation: 'Бабка по Отцу', relation_rod_padej: 'Бабки', origin_profile_sex_id: 1,  reverse_relation_id: 111, reverse_relation: 'Внук'},
  {relation_id: 101, relation: 'Бабка по Отцу', relation_rod_padej: 'Бабки', origin_profile_sex_id: 0,  reverse_relation_id: 121, reverse_relation: 'Внучка'},


  {relation_id: 111, relation: 'Внук по Отцу', relation_rod_padej: 'Внука', origin_profile_sex_id: 1,  reverse_relation_id: 91, reverse_relation: 'Дед'},
  {relation_id: 111, relation: 'Внук по Отцу', relation_rod_padej: 'Внука', origin_profile_sex_id: 0,  reverse_relation_id: 101, reverse_relation: 'Бабка'},
  {relation_id: 121, relation: 'Внучка по Отцу', relation_rod_padej: 'Внучки', origin_profile_sex_id: 1,  reverse_relation_id: 91, reverse_relation: 'Дед'},
  {relation_id: 121, relation: 'Внучка по Отцу', relation_rod_padej: 'Внучки', origin_profile_sex_id: 0,  reverse_relation_id: 101, reverse_relation: 'Бабка'},


  {relation_id: 92, relation: 'Дед по Матери', relation_rod_padej: 'Деда', origin_profile_sex_id: 1,  reverse_relation_id: 112, reverse_relation: 'Внук'},
  {relation_id: 92, relation: 'Дед по Матери', relation_rod_padej: 'Деда', origin_profile_sex_id: 0,  reverse_relation_id: 122, reverse_relation: 'Внучка'},
  {relation_id: 102, relation: 'Бабка по Матери', relation_rod_padej: 'Бабки', origin_profile_sex_id: 1,  reverse_relation_id: 112, reverse_relation: 'Внук'},
  {relation_id: 102, relation: 'Бабка по Матери', relation_rod_padej: 'Бабки', origin_profile_sex_id: 0,  reverse_relation_id: 122, reverse_relation: 'Внучка'},


  {relation_id: 112, relation: 'Внук по Матери', relation_rod_padej: 'Внука', origin_profile_sex_id: 1,  reverse_relation_id: 92, reverse_relation: 'Дед'},
  {relation_id: 112, relation: 'Внук по Матери', relation_rod_padej: 'Внука', origin_profile_sex_id: 0,  reverse_relation_id: 102, reverse_relation: 'Бабка'},
  {relation_id: 122, relation: 'Внучка по Матери', relation_rod_padej: 'Внучки', origin_profile_sex_id: 1,  reverse_relation_id: 92, reverse_relation: 'Дед'},
  {relation_id: 122, relation: 'Внучка по Матери', relation_rod_padej: 'Внучки', origin_profile_sex_id: 0,  reverse_relation_id: 102, reverse_relation: 'Бабка'},


  {relation_id: 13, relation: 'Свекр', relation_rod_padej: 'Свекра', origin_profile_sex_id: 0,  reverse_relation_id: 17, reverse_relation: 'Невестка'},
  {relation_id: 14, relation: 'Свекровь', relation_rod_padej: 'Свекрови', origin_profile_sex_id: 0,  reverse_relation_id: 17, reverse_relation: 'Невестка'},
  {relation_id: 15, relation: 'Тесть', relation_rod_padej: 'Тестя', origin_profile_sex_id: 1,  reverse_relation_id: 18, reverse_relation: 'Зять'},
  {relation_id: 16, relation: 'Теща', relation_rod_padej: 'Тещи', origin_profile_sex_id: 1,  reverse_relation_id: 18, reverse_relation: 'Зять'},


  {relation_id: 17, relation: 'Невестка', relation_rod_padej: 'Невестки', origin_profile_sex_id: 1,  reverse_relation_id: 13, reverse_relation: 'Свекр'},
  {relation_id: 17, relation: 'Невестка', relation_rod_padej: 'Невестки', origin_profile_sex_id: 0,  reverse_relation_id: 14, reverse_relation: 'Свекровь'},
  {relation_id: 18, relation: 'Зять', relation_rod_padej: 'Зятя', origin_profile_sex_id: 1,  reverse_relation_id: 15, reverse_relation: 'Тесть'},
  {relation_id: 18, relation: 'Зять', relation_rod_padej: 'Зятя', origin_profile_sex_id: 0,  reverse_relation_id: 16, reverse_relation: 'Теща'},


  {relation_id: 191, relation: 'Дядя по Отцу', relation_rod_padej: 'Дяди', origin_profile_sex_id: 1,  reverse_relation_id: 211, reverse_relation: 'Племянник'},
  {relation_id: 191, relation: 'Дядя по Отцу', relation_rod_padej: 'Дяди', origin_profile_sex_id: 0,  reverse_relation_id: 221, reverse_relation: 'Племянница'},
  {relation_id: 201, relation: 'Тетя по Отцу', relation_rod_padej: 'Тети', origin_profile_sex_id: 1,  reverse_relation_id: 211, reverse_relation: 'Племянник'},
  {relation_id: 201, relation: 'Тетя по Отцу', relation_rod_padej: 'Тети', origin_profile_sex_id: 0,  reverse_relation_id: 221, reverse_relation: 'Племянница'},


  {relation_id: 211, relation: 'Племянник по Отцу', relation_rod_padej: 'Племянника', origin_profile_sex_id: 1,  reverse_relation_id: 191, reverse_relation: 'Дядя'},
  {relation_id: 211, relation: 'Племянник по Отцу', relation_rod_padej: 'Племянника', origin_profile_sex_id: 0,  reverse_relation_id: 201, reverse_relation: 'Тетя'},
  {relation_id: 221, relation: 'Племянница по Отцу', relation_rod_padej: 'Племянницы', origin_profile_sex_id: 1,  reverse_relation_id: 191, reverse_relation: 'Дядя'},
  {relation_id: 221, relation: 'Племянница по Отцу', relation_rod_padej: 'Племянницы', origin_profile_sex_id: 0,  reverse_relation_id: 201, reverse_relation: 'Тетя'},


  {relation_id: 192, relation: 'Дядя по Матери', relation_rod_padej: 'Дяди', origin_profile_sex_id: 1,  reverse_relation_id: 212, reverse_relation: 'Племянник'},
  {relation_id: 192, relation: 'Дядя по Матери', relation_rod_padej: 'Дяди', origin_profile_sex_id: 0,  reverse_relation_id: 222, reverse_relation: 'Племянница'},
  {relation_id: 202, relation: 'Тетя по Матери', relation_rod_padej: 'Тети', origin_profile_sex_id: 1,  reverse_relation_id: 212, reverse_relation: 'Племянник'},
  {relation_id: 202, relation: 'Тетя по Матери', relation_rod_padej: 'Тети', origin_profile_sex_id: 0,  reverse_relation_id: 222, reverse_relation: 'Племянница'},


  {relation_id: 212, relation: 'Племянник по Матери', relation_rod_padej: 'Племянника', origin_profile_sex_id: 1,  reverse_relation_id: 192, reverse_relation: 'Дядя'},
  {relation_id: 212, relation: 'Племянник по Матери', relation_rod_padej: 'Племянника', origin_profile_sex_id: 0,  reverse_relation_id: 202, reverse_relation: 'Тетя'},
  {relation_id: 222, relation: 'Племянница по Матери', relation_rod_padej: 'Племянницы', origin_profile_sex_id: 1,  reverse_relation_id: 192, reverse_relation: 'Дядя'},
  {relation_id: 222, relation: 'Племянница по Матери', relation_rod_padej: 'Племянницы', origin_profile_sex_id: 0,  reverse_relation_id: 202, reverse_relation: 'Тетя'}


  ])
  
