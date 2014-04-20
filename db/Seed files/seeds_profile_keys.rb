# encoding: utf-8


Profiles_keys.delete_all       # 1 admin + 7 start trees
Profiles_keys.reset_pk_sequence
Profiles_keys.create!([          # create! - для сообщений об ошибках если они есть


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
# NearCircle
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 3, is_profile_id: 2, to_name_id: 75, },
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 3, is_profile_id: 3, to_name_id: 362, },
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 7, is_profile_id: 4, to_name_id: 352, },
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 1, is_profile_id: 5, to_name_id: 231, },
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 1, is_profile_id: 6, to_name_id: 295, },

# Tree 1, Pfoile 2 - Вячеслав
# NearCircle
{user_id: 1, profile_id: 2, name_id: 75, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 1, profile_id: 2, name_id: 75, relation_id: 7, is_profile_id: 3, to_name_id: 362, },
{user_id: 1, profile_id: 2, name_id: 75, relation_id: 9, is_profile_id: 4, to_name_id: 352, },
{user_id: 1, profile_id: 2, name_id: 75, relation_id: 13, is_profile_id: 5, to_name_id: 231, },
{user_id: 1, profile_id: 2, name_id: 75, relation_id: 13, is_profile_id: 6, to_name_id: 295, },

# Tree 1, Pfoile 3 - Валентина
# NearCircle
{user_id: 1, profile_id: 3, name_id: 362, relation_id: 8, is_profile_id: 2, to_name_id: 75, },
{user_id: 1, profile_id: 3, name_id: 362, relation_id: 2, is_profile_id: 1, to_name_id: 16, },
{user_id: 1, profile_id: 3, name_id: 362, relation_id: 10, is_profile_id: 4, to_name_id: 352, },
{user_id: 1, profile_id: 3, name_id: 362, relation_id: 14, is_profile_id: 5, to_name_id: 231, },
{user_id: 1, profile_id: 3, name_id: 362, relation_id: 14, is_profile_id: 6, to_name_id: 295, },

# Tree 1, Pfoile 4 - Анна
# NearCircle
{user_id: 1, profile_id: 4, name_id: 352, relation_id: 1, is_profile_id: 2, to_name_id: 75, },
{user_id: 1, profile_id: 4, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 1, profile_id: 4, name_id: 352, relation_id: 1, is_profile_id: 3, to_name_id: 362, },
{user_id: 1, profile_id: 4, name_id: 352, relation_id: 1, is_profile_id: 5, to_name_id: 231, },
{user_id: 1, profile_id: 4, name_id: 352, relation_id: 1, is_profile_id: 6, to_name_id: 295, },

# Tree 1, Pfoile 5 - Петр
# NearCircle
{user_id: 1, profile_id: 5, name_id: 231, relation_id: 1, is_profile_id: 2, to_name_id: 75, },
{user_id: 1, profile_id: 5, name_id: 231, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 1, profile_id: 5, name_id: 231, relation_id: 1, is_profile_id: 3, to_name_id: 362, },
{user_id: 1, profile_id: 5, name_id: 231, relation_id: 1, is_profile_id: 4, to_name_id: 352, },
{user_id: 1, profile_id: 5, name_id: 231, relation_id: 1, is_profile_id: 6, to_name_id: 295, },

# Tree 1, Pfoile 6 - Федор
# NearCircle
{user_id: 1, profile_id: 6, name_id: 295, relation_id: 1, is_profile_id: 2, to_name_id: 75, },
{user_id: 1, profile_id: 6, name_id: 295, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 1, profile_id: 6, name_id: 295, relation_id: 1, is_profile_id: 3, to_name_id: 362, },
{user_id: 1, profile_id: 6, name_id: 295, relation_id: 1, is_profile_id: 4, to_name_id: 352, },
{user_id: 1, profile_id: 6, name_id: 295, relation_id: 1, is_profile_id: 5, to_name_id: 231, },



# Tree 2, Pfoile 7 - Author - Денис - 
# NearCircle
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 2, Pfoile 8 - Борис
# NearCircle
{user_id: 2, profile_id: 8, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 8, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 8, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 8, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 8, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 8, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 8, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 2, Pfoile 9 - Мария 
# NearCircle
{user_id: 2, profile_id: 9, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 9, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 9, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 9, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 9, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 9, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 9, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 2, Pfoile 10 - Мария
# NearCircle
{user_id: 2, profile_id: 10, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 10, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 10, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 10, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 10, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 10, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 10, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 2, Pfoile 11 - Татьяна
# NearCircle
{user_id: 2, profile_id: 11, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 11, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 11, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 11, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 11, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 11, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 11, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 2, Pfoile 12 - Виктория
# NearCircle
{user_id: 2, profile_id: 12, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 12, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 12, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 12, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 12, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 12, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 12, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 2, Pfoile 13 - Анна
# NearCircle
{user_id: 2, profile_id: 13, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 13, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 13, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 13, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 13, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 13, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 13, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 2, Pfoile 14 - Ольга
# NearCircle
{user_id: 2, profile_id: 14, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 14, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 14, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 14, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 14, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 14, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 2, profile_id: 14, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },



# Tree 3, Pfoile 15 - Author - Борис
# NearCircle
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 3, Pfoile 16 - Иван
# NearCircle
{user_id: 3, profile_id: 16, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 16, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 16, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 16, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 16, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 16, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 3, Pfoile 17 - Ольга
# NearCircle
{user_id: 3, profile_id: 17, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 17, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 17, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 17, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 17, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 17, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 3, Pfoile 18 - Мария
# NearCircle
{user_id: 3, profile_id: 18, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 18, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 18, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 18, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 18, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 18, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 3, Pfoile 19 - Денис
# NearCircle
{user_id: 3, profile_id: 19, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 19, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 19, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 19, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 19, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 19, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 3, Pfoile 20 - Мария
# NearCircle
{user_id: 3, profile_id: 20, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 20, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 20, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 20, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 20, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 20, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 3, Pfoile 21 - Татьяна
# NearCircle
{user_id: 3, profile_id: 21, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 21, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 21, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 21, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 21, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 3, profile_id: 21, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },



# Tree 4, Pfoile 22 - Author - Татьяна
# NearCircle
{user_id: 4, profile_id: 22, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 22, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 22, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 22, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 4, Pfoile 23 - Борис
# NearCircle
{user_id: 4, profile_id: 23, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 23, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 23, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 23, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 4, Pfoile 24 - Мария
# NearCircle
{user_id: 4, profile_id: 24, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 24, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 24, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 24, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 4, Pfoile 25 - Денис
# NearCircle
{user_id: 4, profile_id: 25, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 25, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 25, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 25, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 4, Pfoile 26 - Мария
# NearCircle
{user_id: 4, profile_id: 26, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 26, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 26, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 4, profile_id: 26, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },




# Tree 5, Pfoile 27 - Author - Виктория
# NearCircle
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 5, Pfoile 28 - Иван
# NearCircle
{user_id: 5, profile_id: 28, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 28, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 28, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 28, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 28, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 28, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 5, Pfoile 29 - Анна
# NearCircle
{user_id: 5, profile_id: 29, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 29, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 29, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 29, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 29, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 29, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 5, Pfoile 30 - Сергей
# NearCircle
{user_id: 5, profile_id: 30, name_id: 265, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 30, name_id: 265, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 30, name_id: 265, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 30, name_id: 265, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 30, name_id: 265, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 30, name_id: 265, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 5, Pfoile 31 - Денис
# NearCircle
{user_id: 5, profile_id: 31, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 31, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 31, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 31, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 31, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 31, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 5, Pfoile 32 - Ольга
# NearCircle
{user_id: 5, profile_id: 32, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 32, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 32, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 32, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 32, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 32, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 5, Pfoile 33 - Анна
# NearCircle
{user_id: 5, profile_id: 33, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 33, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 33, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 33, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 33, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 5, profile_id: 33, name_id: 352, relation_id: 1, is_profile_id: 1, to_name_id: 16, },






# Tree 6, Pfoile 34 - Author - Николай
# NearCircle
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 6, Pfoile 35 - Борис
# NearCircle
{user_id: 6, profile_id: 35, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 35, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 35, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 35, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 35, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 6, Pfoile 36 - Галина
# NearCircle
{user_id: 6, profile_id: 36, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 36, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 36, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 36, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 36, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 6, Pfoile 37 - Виктория
# NearCircle
{user_id: 6, profile_id: 37, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 37, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 37, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 37, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 37, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 6, Pfoile 38 - Петр
# NearCircle
{user_id: 6, profile_id: 38, name_id: 231, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 38, name_id: 231, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 38, name_id: 231, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 38, name_id: 231, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 38, name_id: 231, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 6, Pfoile 39 - Татьяна
# NearCircle
{user_id: 6, profile_id: 39, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 39, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 39, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 39, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 6, profile_id: 39, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },




# Tree 7, Pfoile 40 - Author - Борис
# NearCircle
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 7, Pfoile 41 - Иван
# NearCircle
{user_id: 7, profile_id: 41, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 41, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 41, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 41, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 41, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 41, name_id: 123, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 7, Pfoile 42 - Ольга
# NearCircle
{user_id: 7, profile_id: 42, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 42, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 42, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 42, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 42, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 42, name_id: 477, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 7, Pfoile 43 - Мария
# NearCircle
{user_id: 7, profile_id: 43, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 43, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 43, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 43, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 43, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 43, name_id: 453, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 7, Pfoile 44 - Денис
# NearCircle
{user_id: 7, profile_id: 44, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 44, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 44, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 44, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 44, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 44, name_id: 97, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 7, Pfoile 45 - Виктория
# NearCircle
{user_id: 7, profile_id: 45, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 45, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 45, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 45, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 45, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 45, name_id: 371, relation_id: 1, is_profile_id: 1, to_name_id: 16, },

# Tree 7, Pfoile 46 - Татьяна
# NearCircle
{user_id: 7, profile_id: 46, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 46, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 46, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 46, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 46, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, },
{user_id: 7, profile_id: 46, name_id: 506, relation_id: 1, is_profile_id: 1, to_name_id: 16, }



             ])

