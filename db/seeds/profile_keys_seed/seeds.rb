# encoding: utf-8

#
#
#Relations.delete_all       #
#Relations.reset_pk_sequence
#Relations.create!([          # create! - для сообщений об ошибках если они есть
#
#
#
#
#
#                  ])
#
#


ProfileKey.delete_all       # 1 admin + 7 start trees
ProfileKey.reset_pk_sequence
ProfileKey.create!([          # create! - для сообщений об ошибках если они есть


# LEGEND:
# every TREE consist of several NEAR CIRCLES.
# every NEAR CIRCLES consist of profiles WITH relations
# every NEAR CIRCLES HAS central profile_id
# every central profile_id HAS SAVERAL is_profile_id WHO IS relation_id TO profile_id
# every profile_id and is_profile_id HAVE THEIR OWN NAMES with name_id
#
# user_id IS TREE NUMBER and is AUTHOR of this TREE
# IN TREE WITH NUMBER user_id EVERY profile_id HAS relation_id WHO IS is_profile_id
# in NEAR CIRCLE of profile_id
#
# IN TREE <user_id> EVERY <profile_id> HAS <relation_id> WHO IS <is_profile_id>

# Tree 1, Pfoile 1 - Author - Алексей
# NearCircle of profile_id: 1
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 1, is_profile_id: 2, is_name_id: 75 },
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 2, is_profile_id: 3, is_name_id: 362 },
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 8, is_profile_id: 4, is_name_id: 352 },
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 3, is_profile_id: 5, is_name_id: 231 },
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 3, is_profile_id: 6, is_name_id: 295 },

# Tree 1, Pfoile 2 - Вячеслав
# NearCircle
{user_id: 1, profile_id: 2, name_id: 75, relation_id: 3, is_profile_id: 1, is_name_id: 16 },
{user_id: 1, profile_id: 2, name_id: 75, relation_id: 8, is_profile_id: 3, is_name_id: 362 },
# Out of NearCircle of profile_id: 2
#{user_id: 1, profile_id: 2, name_id: 75, relation_id: 17, is_profile_id: 4, is_name_id: 352 },
#{user_id: 1, profile_id: 2, name_id: 75, relation_id: 15, is_profile_id: 5, is_name_id: 231 },
#{user_id: 1, profile_id: 2, name_id: 75, relation_id: 15, is_profile_id: 6, is_name_id: 295 },

# Tree 1, Pfoile 3 - Валентина
# NearCircle
{user_id: 1, profile_id: 3, name_id: 362, relation_id: 7, is_profile_id: 2, is_name_id: 75 },
{user_id: 1, profile_id: 3, name_id: 362, relation_id: 3, is_profile_id: 1, is_name_id: 16 },
# Out of NearCircle of profile_id: 3
#{user_id: 1, profile_id: 3, name_id: 362, relation_id: 17, is_profile_id: 4, is_name_id: 352 },
#{user_id: 1, profile_id: 3, name_id: 362, relation_id: 15, is_profile_id: 5, is_name_id: 231 },
#{user_id: 1, profile_id: 3, name_id: 362, relation_id: 15, is_profile_id: 6, is_name_id: 295 },

# Tree 1, Pfoile 4 - Анна
# NearCircle
{user_id: 1, profile_id: 4, name_id: 352, relation_id: 7, is_profile_id: 1, is_name_id: 16 },
{user_id: 1, profile_id: 4, name_id: 352, relation_id: 3, is_profile_id: 5, is_name_id: 231 },
{user_id: 1, profile_id: 4, name_id: 352, relation_id: 3, is_profile_id: 6, is_name_id: 295 },
# Out of NearCircle of profile_id: 4
#{user_id: 1, profile_id: 4, name_id: 352, relation_id: 1, is_profile_id: 2, is_name_id: 75 },
#{user_id: 1, profile_id: 4, name_id: 352, relation_id: 1, is_profile_id: 3, is_name_id: 362 },

# Tree 1, Pfoile 5 - Петр
# NearCircle
{user_id: 1, profile_id: 5, name_id: 231, relation_id: 1, is_profile_id: 1, is_name_id: 16 },
{user_id: 1, profile_id: 5, name_id: 231, relation_id: 2, is_profile_id: 4, is_name_id: 352 },
{user_id: 1, profile_id: 5, name_id: 231, relation_id: 5, is_profile_id: 6, is_name_id: 295 },
# Out of NearCircle of profile_id: 5
#{user_id: 1, profile_id: 5, name_id: 231, relation_id: 14, is_profile_id: 3, is_name_id: 362 },
#{user_id: 1, profile_id: 5, name_id: 231, relation_id: 13, is_profile_id: 2, is_name_id: 75 },

# Tree 1, Pfoile 6 - Федор
# NearCircle
{user_id: 1, profile_id: 6, name_id: 295, relation_id: 1, is_profile_id: 1, is_name_id: 16 },
{user_id: 1, profile_id: 6, name_id: 295, relation_id: 2, is_profile_id: 4, is_name_id: 352 },
{user_id: 1, profile_id: 6, name_id: 295, relation_id: 5, is_profile_id: 5, is_name_id: 231 },
# Out of NearCircle of profile_id: 6
#{user_id: 1, profile_id: 6, name_id: 295, relation_id: 13, is_profile_id: 2, is_name_id: 75 },
#{user_id: 1, profile_id: 6, name_id: 295, relation_id: 14, is_profile_id: 3, is_name_id: 362 },



# Tree 2, Pfoile 7 - Author - Денис - 
# NearCircle
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 1, is_profile_id: 8, is_name_id: 45 },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 2, is_profile_id: 9, is_name_id: 453 },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 6, is_profile_id: 10, is_name_id: 453 },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 6, is_profile_id: 11, is_name_id: 506 },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 8, is_profile_id: 12, is_name_id: 371 },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 4, is_profile_id: 13, is_name_id: 352 },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 4, is_profile_id: 14, is_name_id: 477 },

# Tree 2, Pfoile 8 - Борис
# NearCircle
{user_id: 2, profile_id: 8, name_id: 45, relation_id: 8, is_profile_id: 9, is_name_id: 453 },
{user_id: 2, profile_id: 8, name_id: 45, relation_id: 4, is_profile_id: 10, is_name_id: 453 },
{user_id: 2, profile_id: 8, name_id: 45, relation_id: 3, is_profile_id: 7, is_name_id: 97 },
{user_id: 2, profile_id: 8, name_id: 45, relation_id: 4, is_profile_id: 11, is_name_id: 506 },
# Out of NearCircle of profile_id: 8
#{user_id: 2, profile_id: 8, name_id: 45, relation_id: 17, is_profile_id: 12, is_name_id: 371 },
#{user_id: 2, profile_id: 8, name_id: 45, relation_id: 16, is_profile_id: 13, is_name_id: 352 },
#{user_id: 2, profile_id: 8, name_id: 45, relation_id: 16, is_profile_id: 14, is_name_id: 477 },

# Tree 2, Pfoile 9 - Мария 
# NearCircle
{user_id: 2, profile_id: 9, name_id: 453, relation_id: 3, is_profile_id: 7, is_name_id: 97 },
{user_id: 2, profile_id: 9, name_id: 453, relation_id: 7, is_profile_id: 8, is_name_id: 45 },
{user_id: 2, profile_id: 9, name_id: 453, relation_id: 4, is_profile_id: 10, is_name_id: 453 },
{user_id: 2, profile_id: 9, name_id: 453, relation_id: 4, is_profile_id: 11, is_name_id: 506 },
# Out of NearCircle of profile_id: 9
#{user_id: 2, profile_id: 9, name_id: 453, relation_id: 17, is_profile_id: 12, is_name_id: 371 },
#{user_id: 2, profile_id: 9, name_id: 453, relation_id: 16, is_profile_id: 13, is_name_id: 352 },
#{user_id: 2, profile_id: 9, name_id: 453, relation_id: 16, is_profile_id: 14, is_name_id: 477 },

# Tree 2, Pfoile 10 - Мария
# NearCircle
{user_id: 2, profile_id: 10, name_id: 453, relation_id: 1, is_profile_id: 8, is_name_id: 45 },
{user_id: 2, profile_id: 10, name_id: 453, relation_id: 2, is_profile_id: 9, is_name_id: 453 },
{user_id: 2, profile_id: 10, name_id: 453, relation_id: 5, is_profile_id: 7, is_name_id: 97 },
{user_id: 2, profile_id: 10, name_id: 453, relation_id: 6, is_profile_id: 11, is_name_id: 506 },
# Out of NearCircle of profile_id: 10
#{user_id: 2, profile_id: 10, name_id: 453, relation_id: 19, is_profile_id: 12, is_name_id: 371 },
#{user_id: 2, profile_id: 10, name_id: 453, relation_id: 21, is_profile_id: 13, is_name_id: 352 },
#{user_id: 2, profile_id: 10, name_id: 453, relation_id: 21, is_profile_id: 14, is_name_id: 477 },

# Tree 2, Pfoile 11 - Татьяна
# NearCircle
{user_id: 2, profile_id: 11, name_id: 506, relation_id: 1, is_profile_id: 8, is_name_id: 45 },
{user_id: 2, profile_id: 11, name_id: 506, relation_id: 2, is_profile_id: 9, is_name_id: 453 },
{user_id: 2, profile_id: 11, name_id: 506, relation_id: 5, is_profile_id: 7, is_name_id: 97 },
{user_id: 2, profile_id: 11, name_id: 506, relation_id: 6, is_profile_id: 10, is_name_id: 453 },
# Out of NearCircle of profile_id: 11
#{user_id: 2, profile_id: 11, name_id: 506, relation_id: 19, is_profile_id: 12, is_name_id: 371 },
#{user_id: 2, profile_id: 11, name_id: 506, relation_id: 21, is_profile_id: 13, is_name_id: 352 },
#{user_id: 2, profile_id: 11, name_id: 506, relation_id: 21, is_profile_id: 14, is_name_id: 477 },

# Tree 2, Pfoile 12 - Виктория
# NearCircle
{user_id: 2, profile_id: 12, name_id: 371, relation_id: 7, is_profile_id: 7, is_name_id: 97 },
{user_id: 2, profile_id: 12, name_id: 371, relation_id: 4, is_profile_id: 13, is_name_id: 352 },
{user_id: 2, profile_id: 12, name_id: 371, relation_id: 4, is_profile_id: 14, is_name_id: 477 },
# Out of NearCircle of profile_id: 12
#{user_id: 2, profile_id: 12, name_id: 371, relation_id: 9, is_profile_id: 8, is_name_id: 45 },
#{user_id: 2, profile_id: 12, name_id: 371, relation_id: 10, is_profile_id: 9, is_name_id: 453 },
#{user_id: 2, profile_id: 12, name_id: 371, relation_id: 25, is_profile_id: 10, is_name_id: 453 },
#{user_id: 2, profile_id: 12, name_id: 371, relation_id: 25, is_profile_id: 11, is_name_id: 506 },

# Tree 2, Pfoile 13 - Анна
# NearCircle
{user_id: 2, profile_id: 13, name_id: 352, relation_id: 1, is_profile_id: 7, is_name_id: 97 },
{user_id: 2, profile_id: 13, name_id: 352, relation_id: 2, is_profile_id: 12, is_name_id: 371 },
{user_id: 2, profile_id: 13, name_id: 352, relation_id: 6, is_profile_id: 14, is_name_id: 477 },
# Out of NearCircle of profile_id: 13
#{user_id: 2, profile_id: 13, name_id: 352, relation_id: 13, is_profile_id: 8, is_name_id: 45 },
#{user_id: 2, profile_id: 13, name_id: 352, relation_id: 14, is_profile_id: 9, is_name_id: 453 },
#{user_id: 2, profile_id: 13, name_id: 352, relation_id: 24, is_profile_id: 10, is_name_id: 453 },
#{user_id: 2, profile_id: 13, name_id: 352, relation_id: 24, is_profile_id: 11, is_name_id: 506 },

# Tree 2, Pfoile 14 - Ольга
# NearCircle
{user_id: 2, profile_id: 14, name_id: 477, relation_id: 1, is_profile_id: 7, is_name_id: 97 },
{user_id: 2, profile_id: 14, name_id: 477, relation_id: 2, is_profile_id: 12, is_name_id: 371 },
{user_id: 2, profile_id: 14, name_id: 477, relation_id: 6, is_profile_id: 13, is_name_id: 352 },
# Out of NearCircle of profile_id: 14
#{user_id: 2, profile_id: 14, name_id: 477, relation_id: 13, is_profile_id: 8, is_name_id: 45 },
#{user_id: 2, profile_id: 14, name_id: 477, relation_id: 14, is_profile_id: 9, is_name_id: 453 },
#{user_id: 2, profile_id: 14, name_id: 477, relation_id: 24, is_profile_id: 10, is_name_id: 453 },
#{user_id: 2, profile_id: 14, name_id: 477, relation_id: 24, is_profile_id: 11, is_name_id: 506 },



# Tree 3, Pfoile 15 - Author - Борис
# NearCircle
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 1, is_profile_id: 16, is_name_id: 123 },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 2, is_profile_id: 17, is_name_id: 477 },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 8, is_profile_id: 18, is_name_id: 453 },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 3, is_profile_id: 19, is_name_id: 97 },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 4, is_profile_id: 20, is_name_id: 453 },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 4, is_profile_id: 21, is_name_id: 506 },

# Tree 3, Pfoile 16 - Иван
# NearCircle
{user_id: 3, profile_id: 16, name_id: 123, relation_id: 8, is_profile_id: 17, is_name_id: 477 },
{user_id: 3, profile_id: 16, name_id: 123, relation_id: 3, is_profile_id: 15, is_name_id: 45 },
# Out of NearCircle of profile_id: 16
#{user_id: 3, profile_id: 16, name_id: 123, relation_id: 17, is_profile_id: 18, is_name_id: 453 },
#{user_id: 3, profile_id: 16, name_id: 123, relation_id: 15, is_profile_id: 19, is_name_id: 97 },
#{user_id: 3, profile_id: 16, name_id: 123, relation_id: 16, is_profile_id: 20, is_name_id: 453 },
#{user_id: 3, profile_id: 16, name_id: 123, relation_id: 16, is_profile_id: 21, is_name_id: 506 },

# Tree 3, Pfoile 17 - Ольга
# NearCircle
{user_id: 3, profile_id: 17, name_id: 477, relation_id: 7, is_profile_id: 16, is_name_id: 123 },
{user_id: 3, profile_id: 17, name_id: 477, relation_id: 3, is_profile_id: 15, is_name_id: 45 },
# Out of NearCircle of profile_id: 17
#{user_id: 3, profile_id: 17, name_id: 477, relation_id: 17, is_profile_id: 18, is_name_id: 453 },
#{user_id: 3, profile_id: 17, name_id: 477, relation_id: 15, is_profile_id: 19, is_name_id: 97 },
#{user_id: 3, profile_id: 17, name_id: 477, relation_id: 16, is_profile_id: 20, is_name_id: 453 },
#{user_id: 3, profile_id: 17, name_id: 477, relation_id: 16, is_profile_id: 21, is_name_id: 506 },

# Tree 3, Pfoile 18 - Мария
# NearCircle
{user_id: 3, profile_id: 18, name_id: 453, relation_id: 7, is_profile_id: 15, is_name_id: 45 },
{user_id: 3, profile_id: 18, name_id: 453, relation_id: 3, is_profile_id: 19, is_name_id: 97 },
{user_id: 3, profile_id: 18, name_id: 453, relation_id: 4, is_profile_id: 20, is_name_id: 453 },
{user_id: 3, profile_id: 18, name_id: 453, relation_id: 4, is_profile_id: 21, is_name_id: 506 },
# Out of NearCircle of profile_id: 17
#{user_id: 3, profile_id: 18, name_id: 453, relation_id: 9, is_profile_id: 16, is_name_id: 123 },
#{user_id: 3, profile_id: 18, name_id: 453, relation_id: 10, is_profile_id: 17, is_name_id: 477 },

# Tree 3, Pfoile 19 - Денис
# NearCircle
{user_id: 3, profile_id: 19, name_id: 97, relation_id: 1, is_profile_id: 15, is_name_id: 45 },
{user_id: 3, profile_id: 19, name_id: 97, relation_id: 2, is_profile_id: 18, is_name_id: 453 },
{user_id: 3, profile_id: 19, name_id: 97, relation_id: 6, is_profile_id: 20, is_name_id: 453 },
{user_id: 3, profile_id: 19, name_id: 97, relation_id: 6, is_profile_id: 21, is_name_id: 506 },
# Out of NearCircle of profile_id: 19
#{user_id: 3, profile_id: 19, name_id: 97, relation_id: 13, is_profile_id: 16, is_name_id: 123 },
#{user_id: 3, profile_id: 19, name_id: 97, relation_id: 14, is_profile_id: 17, is_name_id: 477 },

# Tree 3, Pfoile 20 - Мария
# NearCircle
{user_id: 3, profile_id: 20, name_id: 453, relation_id: 1, is_profile_id: 15, is_name_id: 45 },
{user_id: 3, profile_id: 20, name_id: 453, relation_id: 2, is_profile_id: 18, is_name_id: 453 },
{user_id: 3, profile_id: 20, name_id: 453, relation_id: 5, is_profile_id: 19, is_name_id: 97 },
{user_id: 3, profile_id: 20, name_id: 453, relation_id: 6, is_profile_id: 21, is_name_id: 506 },
# Out of NearCircle of profile_id: 20
#{user_id: 3, profile_id: 20, name_id: 453, relation_id: 13, is_profile_id: 16, is_name_id: 123 },
#{user_id: 3, profile_id: 20, name_id: 453, relation_id: 14, is_profile_id: 17, is_name_id: 477 },

# Tree 3, Pfoile 21 - Татьяна
# NearCircle
{user_id: 3, profile_id: 21, name_id: 506, relation_id: 1, is_profile_id: 15, is_name_id: 45 },
{user_id: 3, profile_id: 21, name_id: 506, relation_id: 2, is_profile_id: 18, is_name_id: 453 },
{user_id: 3, profile_id: 21, name_id: 506, relation_id: 5, is_profile_id: 19, is_name_id: 97 },
{user_id: 3, profile_id: 21, name_id: 506, relation_id: 6, is_profile_id: 20, is_name_id: 453 },
# Out of NearCircle of profile_id: 21
#{user_id: 3, profile_id: 21, name_id: 506, relation_id: 13, is_profile_id: 16, is_name_id: 123 },
#{user_id: 3, profile_id: 21, name_id: 506, relation_id: 14, is_profile_id: 17, is_name_id: 477 },



# Tree 4, Pfoile 22 - Author - Татьяна
# NearCircle
{user_id: 4, profile_id: 22, name_id: 506, relation_id: 1, is_profile_id: 23, is_name_id: 45 },
{user_id: 4, profile_id: 22, name_id: 506, relation_id: 2, is_profile_id: 24, is_name_id: 453 },
{user_id: 4, profile_id: 22, name_id: 506, relation_id: 5, is_profile_id: 25, is_name_id: 97 },
{user_id: 4, profile_id: 22, name_id: 506, relation_id: 6, is_profile_id: 26, is_name_id: 453 },

# Tree 4, Pfoile 23 - Борис
# NearCircle
{user_id: 4, profile_id: 23, name_id: 45, relation_id: 8, is_profile_id: 24, is_name_id: 453 },
{user_id: 4, profile_id: 23, name_id: 45, relation_id: 4, is_profile_id: 22, is_name_id: 506 },
{user_id: 4, profile_id: 23, name_id: 45, relation_id: 3, is_profile_id: 25, is_name_id: 97 },
{user_id: 4, profile_id: 23, name_id: 45, relation_id: 4, is_profile_id: 26, is_name_id: 453 },

# Tree 4, Pfoile 24 - Мария
# NearCircle
{user_id: 4, profile_id: 24, name_id: 453, relation_id: 7, is_profile_id: 23, is_name_id: 45 },
{user_id: 4, profile_id: 24, name_id: 453, relation_id: 4, is_profile_id: 22, is_name_id: 506 },
{user_id: 4, profile_id: 24, name_id: 453, relation_id: 3, is_profile_id: 25, is_name_id: 97 },
{user_id: 4, profile_id: 24, name_id: 453, relation_id: 4, is_profile_id: 26, is_name_id: 453 },

# Tree 4, Pfoile 25 - Денис
# NearCircle
{user_id: 4, profile_id: 25, name_id: 97, relation_id: 1, is_profile_id: 23, is_name_id: 45 },
{user_id: 4, profile_id: 25, name_id: 97, relation_id: 2, is_profile_id: 24, is_name_id: 453 },
{user_id: 4, profile_id: 25, name_id: 97, relation_id: 6, is_profile_id: 22, is_name_id: 506 },
{user_id: 4, profile_id: 25, name_id: 97, relation_id: 6, is_profile_id: 26, is_name_id: 453 },

# Tree 4, Pfoile 26 - Мария
# NearCircle
{user_id: 4, profile_id: 26, name_id: 453, relation_id: 1, is_profile_id: 23, is_name_id: 45 },
{user_id: 4, profile_id: 26, name_id: 453, relation_id: 2, is_profile_id: 24, is_name_id: 453 },
{user_id: 4, profile_id: 26, name_id: 453, relation_id: 6, is_profile_id: 22, is_name_id: 506 },
{user_id: 4, profile_id: 26, name_id: 453, relation_id: 5, is_profile_id: 25, is_name_id: 97 },

# TEST ADD NEW PROFILES
# Out of NearCircle of profile_id: 22

# Tree 4, Pfoile 84 - Виктория:          # к Денису - добавляем новый профиль: Жену Виктория
# При этом: в конец profiles_tree_arr добавляем   [80, 25, 97, "Денис", 1, 8, 84, 371, "Виктория", false]

#{user_id: 4, profile_id: 25 , name_id: 97, relation_id: 8, is_profile_id: 84, is_name_id: 371 },
#{user_id: 4, profile_id: 84 , name_id: 371, relation_id: 7, is_profile_id: 25, is_name_id: 97 },

# Tree 4, Pfoile 85 - Анна:          # к Денису - добавляем новый профиль: Дочь Анна
# При этом: в конец profiles_tree_arr добавляем        ,[81, 25, 97, "Денис", 1, 4, 85, 352, "Анна", false]

#{user_id: 4, profile_id: 25 , name_id: 97, relation_id: 4, is_profile_id: 85, is_name_id: 352 },
#{user_id: 4, profile_id: 84 , name_id: 371, relation_id: 4, is_profile_id: 85, is_name_id: 352 },

#{user_id: 4, profile_id: 85 , name_id: 352, relation_id: 1, is_profile_id: 25, is_name_id: 97 },
#{user_id: 4, profile_id: 85 , name_id: 352, relation_id: 2, is_profile_id: 84, is_name_id: 371 },




# Tree 5, Pfoile 27 - Author - Виктория
# NearCircle
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 1, is_profile_id: 28, is_name_id: 123 },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 2, is_profile_id: 29, is_name_id: 352 },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 5, is_profile_id: 30, is_name_id: 265 },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 7, is_profile_id: 31, is_name_id: 97 },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 4, is_profile_id: 32, is_name_id: 477 },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 4, is_profile_id: 33, is_name_id: 352 },

# Tree 5, Pfoile 28 - Иван
# NearCircle
{user_id: 5, profile_id: 28, name_id: 123, relation_id: 8, is_profile_id: 29, is_name_id: 352 },
{user_id: 5, profile_id: 28, name_id: 123, relation_id: 4, is_profile_id: 27, is_name_id: 371 },
{user_id: 5, profile_id: 28, name_id: 123, relation_id: 3, is_profile_id: 30, is_name_id: 265 },
# Out of NearCircle of profile_id: 28
#{user_id: 5, profile_id: 28, name_id: 123, relation_id: 18, is_profile_id: 31, is_name_id: 97 },
#{user_id: 5, profile_id: 28, name_id: 123, relation_id: 16, is_profile_id: 32, is_name_id: 477 },
#{user_id: 5, profile_id: 28, name_id: 123, relation_id: 16, is_profile_id: 33, is_name_id: 352 },

# Tree 5, Pfoile 29 - Анна
# NearCircle
{user_id: 5, profile_id: 29, name_id: 352, relation_id: 8, is_profile_id: 28, is_name_id: 123 },
{user_id: 5, profile_id: 29, name_id: 352, relation_id: 4, is_profile_id: 27, is_name_id: 371 },
{user_id: 5, profile_id: 29, name_id: 352, relation_id: 3, is_profile_id: 30, is_name_id: 265 },
# Out of NearCircle of profile_id: 29
#{user_id: 5, profile_id: 29, name_id: 352, relation_id: 18, is_profile_id: 31, is_name_id: 97 },
#{user_id: 5, profile_id: 29, name_id: 352, relation_id: 16, is_profile_id: 32, is_name_id: 477 },
#{user_id: 5, profile_id: 29, name_id: 352, relation_id: 16, is_profile_id: 33, is_name_id: 352 },

# Tree 5, Pfoile 30 - Сергей
# NearCircle
{user_id: 5, profile_id: 30, name_id: 265, relation_id: 1, is_profile_id: 28, is_name_id: 123 },
{user_id: 5, profile_id: 30, name_id: 265, relation_id: 2, is_profile_id: 29, is_name_id: 352 },
{user_id: 5, profile_id: 30, name_id: 265, relation_id: 6, is_profile_id: 27, is_name_id: 371 },
# Out of NearCircle of profile_id: 30
#{user_id: 5, profile_id: 30, name_id: 265, relation_id: 20, is_profile_id: 31, is_name_id: 97 },
#{user_id: 5, profile_id: 30, name_id: 265, relation_id: 21, is_profile_id: 32, is_name_id: 477 },
#{user_id: 5, profile_id: 30, name_id: 265, relation_id: 21, is_profile_id: 33, is_name_id: 352 },

# Tree 5, Pfoile 31 - Денис
# NearCircle
{user_id: 5, profile_id: 31, name_id: 97, relation_id: 8, is_profile_id: 27, is_name_id: 371 },
{user_id: 5, profile_id: 31, name_id: 97, relation_id: 4, is_profile_id: 32, is_name_id: 477 },
{user_id: 5, profile_id: 31, name_id: 97, relation_id: 4, is_profile_id: 33, is_name_id: 352 },
# Out of NearCircle of profile_id: 31
#{user_id: 5, profile_id: 31, name_id: 97, relation_id: 11, is_profile_id: 28, is_name_id: 123 },
#{user_id: 5, profile_id: 31, name_id: 97, relation_id: 12, is_profile_id: 29, is_name_id: 352 },
#{user_id: 5, profile_id: 31, name_id: 97, relation_id: 28, is_profile_id: 30, is_name_id: 265 },

# Tree 5, Pfoile 32 - Ольга
# NearCircle
{user_id: 5, profile_id: 32, name_id: 477, relation_id: 2, is_profile_id: 27, is_name_id: 371 },
{user_id: 5, profile_id: 32, name_id: 477, relation_id: 1, is_profile_id: 31, is_name_id: 97 },
{user_id: 5, profile_id: 32, name_id: 477, relation_id: 6, is_profile_id: 33, is_name_id: 352 },
# Out of NearCircle of profile_id: 32
#{user_id: 5, profile_id: 32, name_id: 477, relation_id: 23, is_profile_id: 30, is_name_id: 265 },
#{user_id: 5, profile_id: 32, name_id: 477, relation_id: 13, is_profile_id: 28, is_name_id: 123 },
#{user_id: 5, profile_id: 32, name_id: 477, relation_id: 14, is_profile_id: 29, is_name_id: 352 },

# Tree 5, Pfoile 33 - Анна
# NearCircle
{user_id: 5, profile_id: 33, name_id: 352, relation_id: 2, is_profile_id: 27, is_name_id: 371 },
{user_id: 5, profile_id: 33, name_id: 352, relation_id: 1, is_profile_id: 31, is_name_id: 97 },
{user_id: 5, profile_id: 33, name_id: 352, relation_id: 6, is_profile_id: 32, is_name_id: 477 },
# Out of NearCircle of profile_id: 33
#{user_id: 5, profile_id: 33, name_id: 352, relation_id: 23, is_profile_id: 30, is_name_id: 265 },
#{user_id: 5, profile_id: 33, name_id: 352, relation_id: 13, is_profile_id: 28, is_name_id: 123 },
#{user_id: 5, profile_id: 33, name_id: 352, relation_id: 14, is_profile_id: 29, is_name_id: 352 },


# Tree 6, Pfoile 34 - Author - Николай
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 1, is_profile_id: 35, is_name_id: 45 },
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 2, is_profile_id: 36, is_name_id: 379 },
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 8, is_profile_id: 37, is_name_id: 371 },
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 3, is_profile_id: 38, is_name_id: 231 },
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 4, is_profile_id: 39, is_name_id: 506 },
# Tree 6, Pfoile 35 - Борис
{user_id: 6, profile_id: 35, name_id: 45, relation_id: 8, is_profile_id: 36, is_name_id: 379 },
{user_id: 6, profile_id: 35, name_id: 45, relation_id: 3, is_profile_id: 34, is_name_id: 212 },
# Tree 6, Pfoile 36 - Галина
{user_id: 6, profile_id: 36, name_id: 45, relation_id: 7, is_profile_id: 35, is_name_id: 45 },
{user_id: 6, profile_id: 36, name_id: 45, relation_id: 3, is_profile_id: 34, is_name_id: 212 },
# Tree 6, Pfoile 37 - Виктория
{user_id: 6, profile_id: 37, name_id: 371, relation_id: 7, is_profile_id: 34, is_name_id: 212 },
{user_id: 6, profile_id: 37, name_id: 371, relation_id: 3, is_profile_id: 38, is_name_id: 231 },
{user_id: 6, profile_id: 37, name_id: 371, relation_id: 4, is_profile_id: 39, is_name_id: 506 },
# Tree 6, Pfoile 38 - Петр
{user_id: 6, profile_id: 38, name_id: 231, relation_id: 1, is_profile_id: 34, is_name_id: 212 },
{user_id: 6, profile_id: 38, name_id: 231, relation_id: 2, is_profile_id: 37, is_name_id: 371 },
{user_id: 6, profile_id: 38, name_id: 231, relation_id: 6, is_profile_id: 39, is_name_id: 506 },
# Tree 6, Pfoile 39 - Татьяна
{user_id: 6, profile_id: 39, name_id: 506, relation_id: 1, is_profile_id: 34, is_name_id: 212 },
{user_id: 6, profile_id: 39, name_id: 506, relation_id: 2, is_profile_id: 37, is_name_id: 371 },
{user_id: 6, profile_id: 39, name_id: 506, relation_id: 5, is_profile_id: 38, is_name_id: 231 },


# Tree 7, Pfoile 40 - Author - Борис
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 1, is_profile_id: 41, is_name_id: 123 },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 2, is_profile_id: 42, is_name_id: 477 },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 8, is_profile_id: 43, is_name_id: 453 },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 3, is_profile_id: 44, is_name_id: 97 },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 4, is_profile_id: 45, is_name_id: 371 },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 4, is_profile_id: 46, is_name_id: 506 },
# Tree 7, Pfoile 41 - Иван
{user_id: 7, profile_id: 41, name_id: 123, relation_id: 8, is_profile_id: 42, is_name_id: 477 },
{user_id: 7, profile_id: 41, name_id: 123, relation_id: 3, is_profile_id: 40, is_name_id: 45 },
# Tree 7, Pfoile 42 - Ольга
{user_id: 7, profile_id: 42, name_id: 477, relation_id: 7, is_profile_id: 41, is_name_id: 123 },
{user_id: 7, profile_id: 42, name_id: 477, relation_id: 3, is_profile_id: 40, is_name_id: 45 },
# Tree 7, Pfoile 43 - Мария
{user_id: 7, profile_id: 43, name_id: 453, relation_id: 7, is_profile_id: 40, is_name_id: 45 },
{user_id: 7, profile_id: 43, name_id: 453, relation_id: 3, is_profile_id: 44, is_name_id: 97 },
{user_id: 7, profile_id: 43, name_id: 453, relation_id: 4, is_profile_id: 45, is_name_id: 371 },
{user_id: 7, profile_id: 43, name_id: 453, relation_id: 4, is_profile_id: 46, is_name_id: 506 },
# Tree 7, Pfoile 44 - Денис
{user_id: 7, profile_id: 44, name_id: 97, relation_id: 1, is_profile_id: 40, is_name_id: 45 },
{user_id: 7, profile_id: 44, name_id: 97, relation_id: 2, is_profile_id: 43, is_name_id: 453 },
{user_id: 7, profile_id: 44, name_id: 97, relation_id: 6, is_profile_id: 45, is_name_id: 371 },
{user_id: 7, profile_id: 44, name_id: 97, relation_id: 6, is_profile_id: 46, is_name_id: 506 },
# Tree 7, Pfoile 45 - Виктория
{user_id: 7, profile_id: 45, name_id: 371, relation_id: 1, is_profile_id: 40, is_name_id: 45 },
{user_id: 7, profile_id: 45, name_id: 371, relation_id: 2, is_profile_id: 43, is_name_id: 453 },
{user_id: 7, profile_id: 45, name_id: 371, relation_id: 5, is_profile_id: 44, is_name_id: 97 },
{user_id: 7, profile_id: 45, name_id: 371, relation_id: 6, is_profile_id: 46, is_name_id: 506 },
# Tree 7, Pfoile 46 - Татьяна
{user_id: 7, profile_id: 46, name_id: 506, relation_id: 1, is_profile_id: 40, is_name_id: 45 },
{user_id: 7, profile_id: 46, name_id: 506, relation_id: 2, is_profile_id: 43, is_name_id: 453 },
{user_id: 7, profile_id: 46, name_id: 506, relation_id: 5, is_profile_id: 44, is_name_id: 97 },
{user_id: 7, profile_id: 46, name_id: 506, relation_id: 6, is_profile_id: 45, is_name_id: 371 },


# Tree 8, Profile 47 - Author - Александр
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 1, is_profile_id: 48, is_name_id: 45 },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 2, is_profile_id: 49, is_name_id: 453 },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 5, is_profile_id: 50, is_name_id: 62 },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 5, is_profile_id: 51, is_name_id: 97 },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 6, is_profile_id: 52, is_name_id: 352 },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 6, is_profile_id: 53, is_name_id: 477 },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 8, is_profile_id: 54, is_name_id: 371 },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 3, is_profile_id: 55, is_name_id: 45 },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 3, is_profile_id: 56, is_name_id: 123 },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 4, is_profile_id: 57, is_name_id: 453 },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 4, is_profile_id: 58, is_name_id: 521 },
# Tree 8, Pfoile 48 - Борис
{user_id: 8, profile_id: 48, name_id: 45, relation_id: 3, is_profile_id: 47, is_name_id: 15 },
{user_id: 8, profile_id: 48, name_id: 45, relation_id: 8, is_profile_id: 49, is_name_id: 453 },
{user_id: 8, profile_id: 48, name_id: 45, relation_id: 3, is_profile_id: 50, is_name_id: 62 },
{user_id: 8, profile_id: 48, name_id: 45, relation_id: 3, is_profile_id: 51, is_name_id: 97 },
{user_id: 8, profile_id: 48, name_id: 45, relation_id: 4, is_profile_id: 52, is_name_id: 352 },
{user_id: 8, profile_id: 48, name_id: 45, relation_id: 4, is_profile_id: 53, is_name_id: 477 },
# Tree 8, Pfoile 49 - Мария
{user_id: 8, profile_id: 49, name_id: 453, relation_id: 7, is_profile_id: 48, is_name_id: 45 },
{user_id: 8, profile_id: 49, name_id: 453, relation_id: 3, is_profile_id: 47, is_name_id: 15 },
{user_id: 8, profile_id: 49, name_id: 453, relation_id: 3, is_profile_id: 50, is_name_id: 62 },
{user_id: 8, profile_id: 49, name_id: 453, relation_id: 3, is_profile_id: 51, is_name_id: 97 },
{user_id: 8, profile_id: 49, name_id: 453, relation_id: 4, is_profile_id: 52, is_name_id: 352 },
{user_id: 8, profile_id: 49, name_id: 453, relation_id: 4, is_profile_id: 53, is_name_id: 477 },
# Tree 8, Pfoile 50 - Виктор
{user_id: 8, profile_id: 50, name_id: 62, relation_id: 1, is_profile_id: 48, is_name_id: 45 },
{user_id: 8, profile_id: 50, name_id: 62, relation_id: 2, is_profile_id: 49, is_name_id: 453 },
{user_id: 8, profile_id: 50, name_id: 62, relation_id: 5, is_profile_id: 47, is_name_id: 15 },
{user_id: 8, profile_id: 50, name_id: 62, relation_id: 5, is_profile_id: 51, is_name_id: 97 },
{user_id: 8, profile_id: 50, name_id: 62, relation_id: 6, is_profile_id: 52, is_name_id: 352 },
{user_id: 8, profile_id: 50, name_id: 62, relation_id: 6, is_profile_id: 53, is_name_id: 477 },
# Tree 8, Pfoile 51 - Денис
{user_id: 8, profile_id: 51, name_id: 97, relation_id: 1, is_profile_id: 48, is_name_id: 45 },
{user_id: 8, profile_id: 51, name_id: 97, relation_id: 2, is_profile_id: 49, is_name_id: 453 },
{user_id: 8, profile_id: 51, name_id: 97, relation_id: 5, is_profile_id: 47, is_name_id: 15 },
{user_id: 8, profile_id: 51, name_id: 97, relation_id: 5, is_profile_id: 50, is_name_id: 62 },
{user_id: 8, profile_id: 51, name_id: 97, relation_id: 6, is_profile_id: 52, is_name_id: 352 },
{user_id: 8, profile_id: 51, name_id: 97, relation_id: 6, is_profile_id: 53, is_name_id: 477 },
# Tree 8, Pfoile 52 - Анна
{user_id: 8, profile_id: 52, name_id: 352, relation_id: 1, is_profile_id: 48, is_name_id: 45 },
{user_id: 8, profile_id: 52, name_id: 352, relation_id: 2, is_profile_id: 49, is_name_id: 453 },
{user_id: 8, profile_id: 52, name_id: 352, relation_id: 5, is_profile_id: 47, is_name_id: 15 },
{user_id: 8, profile_id: 52, name_id: 352, relation_id: 5, is_profile_id: 50, is_name_id: 62 },
{user_id: 8, profile_id: 52, name_id: 352, relation_id: 5, is_profile_id: 51, is_name_id: 97 },
{user_id: 8, profile_id: 52, name_id: 352, relation_id: 6, is_profile_id: 53, is_name_id: 477 },
# Tree 8, Pfoile 53 - Ольга
{user_id: 8, profile_id: 53, name_id: 477, relation_id: 1, is_profile_id: 48, is_name_id: 45 },
{user_id: 8, profile_id: 53, name_id: 477, relation_id: 2, is_profile_id: 49, is_name_id: 453 },
{user_id: 8, profile_id: 53, name_id: 477, relation_id: 5, is_profile_id: 47, is_name_id: 15 },
{user_id: 8, profile_id: 53, name_id: 477, relation_id: 5, is_profile_id: 50, is_name_id: 62 },
{user_id: 8, profile_id: 53, name_id: 477, relation_id: 5, is_profile_id: 51, is_name_id: 97 },
{user_id: 8, profile_id: 53, name_id: 477, relation_id: 6, is_profile_id: 52, is_name_id: 352 },
# Tree 8, Pfoile 54 - Виктория
{user_id: 8, profile_id: 54, name_id: 371, relation_id: 3, is_profile_id: 55, is_name_id: 45 },
{user_id: 8, profile_id: 54, name_id: 371, relation_id: 4, is_profile_id: 57, is_name_id: 453 },
{user_id: 8, profile_id: 54, name_id: 371, relation_id: 7, is_profile_id: 47, is_name_id: 15 },
{user_id: 8, profile_id: 54, name_id: 371, relation_id: 3, is_profile_id: 56, is_name_id: 123 },
{user_id: 8, profile_id: 54, name_id: 371, relation_id: 4, is_profile_id: 58, is_name_id: 521 },
# Tree 8, Pfoile 55 - Борис
{user_id: 8, profile_id: 55, name_id: 45, relation_id: 2, is_profile_id: 54, is_name_id: 371 },
{user_id: 8, profile_id: 55, name_id: 45, relation_id: 6, is_profile_id: 57, is_name_id: 453 },
{user_id: 8, profile_id: 55, name_id: 45, relation_id: 1, is_profile_id: 47, is_name_id: 15 },
{user_id: 8, profile_id: 55, name_id: 45, relation_id: 5, is_profile_id: 56, is_name_id: 123 },
{user_id: 8, profile_id: 55, name_id: 45, relation_id: 6, is_profile_id: 58, is_name_id: 521 },
# Tree 8, Pfoile 56 - Иван
{user_id: 8, profile_id: 56, name_id: 123, relation_id: 2, is_profile_id: 54, is_name_id: 371 },
{user_id: 8, profile_id: 56, name_id: 123, relation_id: 6, is_profile_id: 57, is_name_id: 453 },
{user_id: 8, profile_id: 56, name_id: 123, relation_id: 1, is_profile_id: 47, is_name_id: 15 },
{user_id: 8, profile_id: 56, name_id: 123, relation_id: 5, is_profile_id: 55, is_name_id: 45 },
{user_id: 8, profile_id: 56, name_id: 123, relation_id: 6, is_profile_id: 58, is_name_id: 521 },
# Tree 8, Pfoile 57 - Мария
{user_id: 8, profile_id: 57, name_id: 453, relation_id: 2, is_profile_id: 54, is_name_id: 371 },
{user_id: 8, profile_id: 57, name_id: 453, relation_id: 5, is_profile_id: 56, is_name_id: 123 },
{user_id: 8, profile_id: 57, name_id: 453, relation_id: 1, is_profile_id: 47, is_name_id: 15 },
{user_id: 8, profile_id: 57, name_id: 453, relation_id: 5, is_profile_id: 55, is_name_id: 45 },
{user_id: 8, profile_id: 57, name_id: 453, relation_id: 6, is_profile_id: 58, is_name_id: 521 },
# Tree 8, Pfoile 58 - Юлия
{user_id: 8, profile_id: 58, name_id: 521, relation_id: 2, is_profile_id: 54, is_name_id: 371 },
{user_id: 8, profile_id: 58, name_id: 521, relation_id: 5, is_profile_id: 56, is_name_id: 123 },
{user_id: 8, profile_id: 58, name_id: 521, relation_id: 1, is_profile_id: 47, is_name_id: 15 },
{user_id: 8, profile_id: 58, name_id: 521, relation_id: 5, is_profile_id: 55, is_name_id: 45 },
{user_id: 8, profile_id: 58, name_id: 521, relation_id: 6, is_profile_id: 57, is_name_id: 453 },



# Tree 9, Pfoile 59 - Author - Анна
{user_id: 9, profile_id: 59, name_id: 352, relation_id: 1, is_profile_id: 60, is_name_id: 97 },
{user_id: 9, profile_id: 59, name_id: 352, relation_id: 2, is_profile_id: 61, is_name_id: 371 },
{user_id: 9, profile_id: 59, name_id: 352, relation_id: 6, is_profile_id: 62, is_name_id: 477 },
# Tree 9, Pfoile 60 - Денис
{user_id: 9, profile_id: 60, name_id: 97, relation_id: 4, is_profile_id: 59, is_name_id: 352 },
{user_id: 9, profile_id: 60, name_id: 97, relation_id: 8, is_profile_id: 61, is_name_id: 371 },
{user_id: 9, profile_id: 60, name_id: 97, relation_id: 4, is_profile_id: 62, is_name_id: 477 },
# Tree 9, Pfoile 61 - Виктория
{user_id: 9, profile_id: 61, name_id: 371, relation_id: 7, is_profile_id: 60, is_name_id: 97 },
{user_id: 9, profile_id: 61, name_id: 371, relation_id: 4, is_profile_id: 59, is_name_id: 352 },
{user_id: 9, profile_id: 61, name_id: 371, relation_id: 4, is_profile_id: 62, is_name_id: 477 },
# Tree 9, Pfoile 62- Ольга
{user_id: 9, profile_id: 62, name_id: 477, relation_id: 1, is_profile_id: 60, is_name_id: 97 },
{user_id: 9, profile_id: 62, name_id: 477, relation_id: 2, is_profile_id: 61, is_name_id: 371 },
{user_id: 9, profile_id: 62, name_id: 477, relation_id: 6, is_profile_id: 59, is_name_id: 352 },



# Tree 10, Pfoile 63 - Author - Ольга
{user_id: 10, profile_id: 63, name_id: 477, relation_id: 1, is_profile_id: 64, is_name_id: 102 },
{user_id: 10, profile_id: 63, name_id: 477, relation_id: 2, is_profile_id: 65, is_name_id: 506 },
{user_id: 10, profile_id: 63, name_id: 477, relation_id: 7, is_profile_id: 66, is_name_id: 123 },
{user_id: 10, profile_id: 63, name_id: 477, relation_id: 3, is_profile_id: 67, is_name_id: 265 },
{user_id: 10, profile_id: 63, name_id: 477, relation_id: 4, is_profile_id: 68, is_name_id: 371 },
# Tree 10, Pfoile 64 - Евгений
{user_id: 10, profile_id: 64, name_id: 102, relation_id: 4, is_profile_id: 63, is_name_id: 477 },
{user_id: 10, profile_id: 64, name_id: 102, relation_id: 8, is_profile_id: 65, is_name_id: 506},
# Tree 10, Pfoile 65 - Татьяна
{user_id: 10, profile_id: 65, name_id: 506, relation_id: 7, is_profile_id: 64, is_name_id: 102 },
{user_id: 10, profile_id: 65, name_id: 506, relation_id: 4, is_profile_id: 63, is_name_id: 477 },
# Tree 10, Pfoile 66- Иван
{user_id: 10, profile_id: 66, name_id: 123, relation_id: 8, is_profile_id: 63, is_name_id: 477 },
{user_id: 10, profile_id: 66, name_id: 123, relation_id: 3, is_profile_id: 67, is_name_id: 265 },
{user_id: 10, profile_id: 66, name_id: 123, relation_id: 4, is_profile_id: 68, is_name_id: 371 },
# Tree 10, Pfoile 67- Сергей
{user_id: 10, profile_id: 67, name_id: 265, relation_id: 2, is_profile_id: 63, is_name_id: 477 },
{user_id: 10, profile_id: 67, name_id: 265, relation_id: 1, is_profile_id: 66, is_name_id: 123 },
{user_id: 10, profile_id: 67, name_id: 265, relation_id: 6, is_profile_id: 68, is_name_id: 371 },
# Tree 10, Pfoile 68- Виктория
{user_id: 10, profile_id: 68, name_id: 371, relation_id: 2, is_profile_id: 63, is_name_id: 477 },
{user_id: 10, profile_id: 68, name_id: 371, relation_id: 1, is_profile_id: 66, is_name_id: 123 },
{user_id: 10, profile_id: 68, name_id: 371, relation_id: 5, is_profile_id: 67, is_name_id: 265 },



# Tree 11, Pfoile 69 - Author - Сергей
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 1, is_profile_id: 70, is_name_id: 123 },
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 2, is_profile_id: 71, is_name_id: 477 },
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 6, is_profile_id: 72, is_name_id: 371 },
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 8, is_profile_id: 73, is_name_id: 395 },
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 3, is_profile_id: 74, is_name_id: 97 },
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 3, is_profile_id: 75, is_name_id: 212 },
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 4, is_profile_id: 76, is_name_id: 453 },
# Tree 11, Pfoile 70 - Иван
{user_id: 11, profile_id: 70, name_id: 123, relation_id: 3, is_profile_id: 69, is_name_id: 265 },
{user_id: 11, profile_id: 70, name_id: 123, relation_id: 8, is_profile_id: 71, is_name_id: 477},
{user_id: 11, profile_id: 70, name_id: 123, relation_id: 4, is_profile_id: 72, is_name_id: 371 },
# Tree 11, Pfoile 71 - Ольга
{user_id: 11, profile_id: 71, name_id: 477, relation_id: 7, is_profile_id: 70, is_name_id: 123 },
{user_id: 11, profile_id: 71, name_id: 477, relation_id: 3, is_profile_id: 69, is_name_id: 265 },
{user_id: 11, profile_id: 71, name_id: 477, relation_id: 4, is_profile_id: 72, is_name_id: 371 },
# Tree 11, Pfoile 72- Виктория
{user_id: 11, profile_id: 72, name_id: 371, relation_id: 1, is_profile_id: 70, is_name_id: 123 },
{user_id: 11, profile_id: 72, name_id: 371, relation_id: 2, is_profile_id: 71, is_name_id: 477 },
{user_id: 11, profile_id: 72, name_id: 371, relation_id: 5, is_profile_id: 69, is_name_id: 265 },
# Tree 11, Pfoile 73- Елена
{user_id: 11, profile_id: 73, name_id: 395, relation_id: 7, is_profile_id: 69, is_name_id: 265 },
{user_id: 11, profile_id: 73, name_id: 395, relation_id: 3, is_profile_id: 74, is_name_id: 97 },
{user_id: 11, profile_id: 73, name_id: 395, relation_id: 3, is_profile_id: 75, is_name_id: 212 },
{user_id: 11, profile_id: 73, name_id: 395, relation_id: 4, is_profile_id: 76, is_name_id: 453 },
# Tree 11, Pfoile 74- Денис
{user_id: 11, profile_id: 74, name_id: 97, relation_id: 1, is_profile_id: 69, is_name_id: 265 },
{user_id: 11, profile_id: 74, name_id: 97, relation_id: 2, is_profile_id: 73, is_name_id: 395 },
{user_id: 11, profile_id: 74, name_id: 97, relation_id: 5, is_profile_id: 75, is_name_id: 212 },
{user_id: 11, profile_id: 74, name_id: 97, relation_id: 6, is_profile_id: 76, is_name_id: 453 },
# Tree 11, Pfoile 75- Николай
{user_id: 11, profile_id: 75, name_id: 212, relation_id: 1, is_profile_id: 69, is_name_id: 265 },
{user_id: 11, profile_id: 75, name_id: 212, relation_id: 2, is_profile_id: 73, is_name_id: 395 },
{user_id: 11, profile_id: 75, name_id: 212, relation_id: 5, is_profile_id: 74, is_name_id: 97 },
{user_id: 11, profile_id: 75, name_id: 212, relation_id: 6, is_profile_id: 76, is_name_id: 453 },
# Tree 11, Pfoile 76- Мария
{user_id: 11, profile_id: 76, name_id: 453, relation_id: 1, is_profile_id: 69, is_name_id: 265 },
{user_id: 11, profile_id: 76, name_id: 453, relation_id: 2, is_profile_id: 73, is_name_id: 395 },
{user_id: 11, profile_id: 76, name_id: 453, relation_id: 5, is_profile_id: 74, is_name_id: 97 },
{user_id: 11, profile_id: 76, name_id: 453, relation_id: 5, is_profile_id: 75, is_name_id: 212 },



# Tree 12, Pfoile 77 - Author - Елена
{user_id: 12, profile_id: 77, name_id: 395, relation_id: 1, is_profile_id: 78, is_name_id: 98 },
{user_id: 12, profile_id: 77, name_id: 395, relation_id: 2, is_profile_id: 79, is_name_id: 467 },
{user_id: 12, profile_id: 77, name_id: 395, relation_id: 7, is_profile_id: 80, is_name_id: 265 },
{user_id: 12, profile_id: 77, name_id: 395, relation_id: 3, is_profile_id: 81, is_name_id: 97 },
{user_id: 12, profile_id: 77, name_id: 395, relation_id: 3, is_profile_id: 82, is_name_id: 212 },
{user_id: 12, profile_id: 77, name_id: 395, relation_id: 4, is_profile_id: 83, is_name_id: 453 },
# Tree 12, Pfoile 78 - Дмитрий
{user_id: 12, profile_id: 78, name_id: 98, relation_id: 4, is_profile_id: 77, is_name_id: 395 },
{user_id: 12, profile_id: 78, name_id: 98, relation_id: 8, is_profile_id: 79, is_name_id: 467},
# Tree 12, Pfoile 79 - Наталья
{user_id: 12, profile_id: 79, name_id: 467, relation_id: 7, is_profile_id: 78, is_name_id: 98 },
{user_id: 12, profile_id: 79, name_id: 467, relation_id: 4, is_profile_id: 77, is_name_id: 395 },
# Tree 12, Pfoile 80- Сергей
{user_id: 12, profile_id: 80, name_id: 265, relation_id: 8, is_profile_id: 77, is_name_id: 395 },
{user_id: 12, profile_id: 80, name_id: 265, relation_id: 3, is_profile_id: 81, is_name_id: 97 },
{user_id: 12, profile_id: 80, name_id: 265, relation_id: 3, is_profile_id: 82, is_name_id: 212 },
{user_id: 12, profile_id: 80, name_id: 265, relation_id: 4, is_profile_id: 83, is_name_id: 453 },
# Tree 12, Pfoile 81- Денис
{user_id: 12, profile_id: 81, name_id: 97, relation_id: 2, is_profile_id: 77, is_name_id: 395 },
{user_id: 12, profile_id: 81, name_id: 97, relation_id: 1, is_profile_id: 80, is_name_id: 265 },
{user_id: 12, profile_id: 81, name_id: 97, relation_id: 5, is_profile_id: 82, is_name_id: 212 },
{user_id: 12, profile_id: 81, name_id: 97, relation_id: 6, is_profile_id: 83, is_name_id: 453 },
# Tree 12, Pfoile 82- Николай
{user_id: 12, profile_id: 82, name_id: 212, relation_id: 2, is_profile_id: 77, is_name_id: 395 },
{user_id: 12, profile_id: 82, name_id: 212, relation_id: 1, is_profile_id: 80, is_name_id: 265 },
{user_id: 12, profile_id: 82, name_id: 212, relation_id: 5, is_profile_id: 81, is_name_id: 97 },
{user_id: 12, profile_id: 82, name_id: 212, relation_id: 6, is_profile_id: 83, is_name_id: 453 },
# Tree 12, Pfoile 83- Мария
{user_id: 12, profile_id: 83, name_id: 453, relation_id: 2, is_profile_id: 77, is_name_id: 395 },
{user_id: 12, profile_id: 83, name_id: 453, relation_id: 1, is_profile_id: 80, is_name_id: 265 },
{user_id: 12, profile_id: 83, name_id: 453, relation_id: 5, is_profile_id: 81, is_name_id: 97 },
{user_id: 12, profile_id: 83, name_id: 453, relation_id: 5, is_profile_id: 82, is_name_id: 212 }



                   ])

