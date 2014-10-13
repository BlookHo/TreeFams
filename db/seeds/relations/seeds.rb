
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
# New relations
{relation_id: 9, relation: 'Дед', relation_rod_padej: 'Деда', origin_profile_sex_id: 1,  reverse_relation_id: 11, reverse_relation: 'Внук'},
{relation_id: 9, relation: 'Дед', relation_rod_padej: 'Деда', origin_profile_sex_id: 0,  reverse_relation_id: 12, reverse_relation: 'Внучка'},
{relation_id: 10, relation: 'Бабка', relation_rod_padej: 'Бабки', origin_profile_sex_id: 1,  reverse_relation_id: 11, reverse_relation: 'Внук'},
{relation_id: 10, relation: 'Бабка', relation_rod_padej: 'Бабки', origin_profile_sex_id: 0,  reverse_relation_id: 12, reverse_relation: 'Внучка'},

{relation_id: 11, relation: 'Внук', relation_rod_padej: 'Внука', origin_profile_sex_id: 1,  reverse_relation_id: 9, reverse_relation: 'Дед'},
{relation_id: 11, relation: 'Внук', relation_rod_padej: 'Внука', origin_profile_sex_id: 0,  reverse_relation_id: 10, reverse_relation: 'Бабка'},
{relation_id: 12, relation: 'Внучка', relation_rod_padej: 'Внучки', origin_profile_sex_id: 1,  reverse_relation_id: 9, reverse_relation: 'Дед'},
{relation_id: 12, relation: 'Внучка', relation_rod_padej: 'Внучки', origin_profile_sex_id: 0,  reverse_relation_id: 10, reverse_relation: 'Бабка'}


# муж/жена: добавить для однополых браков?


            ])
