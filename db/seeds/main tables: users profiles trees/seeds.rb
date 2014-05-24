# encoding: utf-8


User.delete_all       # 1 admin + 7 start trees
User.reset_pk_sequence
User.create!([          # create! - для сообщений об ошибках если они есть

# 1
{profile_id: 1, admin: true, email: 'aa@aa.aa', password: '111111', password_confirmation: '111111' },
# 2
{profile_id: 7, admin: false, email: 'qq@qq.qq', password: '222222', password_confirmation: '222222' },
# 3
{profile_id: 15, admin: false, email: 'ww@ww.ww', password: '333333', password_confirmation: '333333' },
# 4
{profile_id: 22, admin: false, email: 'ee@ee.ee', password: '444444', password_confirmation: '444444' },
# 5
{profile_id: 27, admin: false, email: 'rr@rr.rr', password: '555555', password_confirmation: '555555' },
# 6
{profile_id: 34, admin: false, email: 'tt@tt.tt', password: '666666', password_confirmation: '666666' },
# 7
{profile_id: 40, admin: false, email: 'yy@yy.yy', password: '777777', password_confirmation: '777777' },
# 8
{profile_id: 47, admin: false, email: 'dd@dd.dd', password: '888888', password_confirmation: '888888' },
# 9
{profile_id: 59, admin: false, email: 'gg@gg.gg', password: '999999', password_confirmation: '999999' },
# 10
{profile_id: 63, admin: false, email: 'ss@ss.ss', password: '101010', password_confirmation: '101010' },
# 11
{profile_id: 69, admin: false, email: 'xx@xx.xx', password: '131313', password_confirmation: '131313' },
# 12
{profile_id: 77, admin: false, email: 'zz@zz.zz', password: '121212', password_confirmation: '121212' }



])



Profile.delete_all       # 1 admin + 4 start trees
Profile.reset_pk_sequence
Profile.create([

# 1 - Tree 1
{user_id: 1, name_id: 16, email: 'aa@aa.aa', sex_id: 1 },
# 2
{user_id: 0, name_id: 75, email: '', sex_id: 1 },
# 3
{user_id: 0, name_id: 362, email: '', sex_id: 0 },
# 4
{user_id: 0, name_id: 352, email: '', sex_id: 0 },
# 5
{user_id: 0, name_id: 231, email: '', sex_id: 1 },
# 6
{user_id: 0, name_id: 295, email: '', sex_id: 1 },

# 7 - Tree 2
{user_id: 2, name_id: 97, email: 'qq@qq.qq', sex_id: 1 },
# 8
{user_id: 0, name_id: 45, email: '', sex_id: 1 },
# 9
{user_id: 0, name_id: 453, email: '', sex_id: 0 },
# 10
{user_id: 0, name_id: 453, email: '', sex_id: 0 },
# 11
{user_id: 0, name_id: 506, email: '', sex_id: 0 },
# 12
{user_id: 0, name_id: 371, email: '', sex_id: 0 },
# 13
{user_id: 0, name_id: 352, email: '', sex_id: 0 },
# 14
{user_id: 0, name_id: 477, email: '', sex_id: 0 },

# 15 - Tree 3
{user_id: 3, name_id: 45, email: 'ww@ww.ww', sex_id: 1 },
# 16
{user_id: 0, name_id: 123, email: '', sex_id: 1 },
# 17
{user_id: 0, name_id: 477, email: '', sex_id: 0 },
# 18
{user_id: 0, name_id: 453, email: '', sex_id: 0 },
# 19
{user_id: 0, name_id: 97, email: '', sex_id: 1 },
# 20
{user_id: 0, name_id: 453, email: '', sex_id: 0 },
# 21
{user_id: 0, name_id: 506, email: '', sex_id: 0 },

# 22 - Tree 4
{user_id: 4, name_id: 506, email: 'ee@ee.ee', sex_id: 0 },
# 23
{user_id: 0, name_id: 45, email: '', sex_id: 1 },
# 24
{user_id: 0, name_id: 453, email: '', sex_id: 0 },
# 25
{user_id: 0, name_id: 97, email: '', sex_id: 1 },
# 26
{user_id: 0, name_id: 453, email: '', sex_id: 0 },

# 27 - Tree 5
{user_id: 5, name_id: 371, email: 'rr@rr.rr', sex_id: 0 },
# 28
{user_id: 0, name_id: 123, email: '', sex_id: 1 },
# 29
{user_id: 0, name_id: 352, email: '', sex_id: 0 },
# 30
{user_id: 0, name_id: 265, email: '', sex_id: 1 },
# 31
{user_id: 0, name_id: 97, email: '', sex_id: 1 },
# 32
{user_id: 0, name_id: 477, email: '', sex_id: 0 },
# 33
{user_id: 0, name_id: 352, email: '', sex_id: 0 },

# 34 - Tree 6
{user_id: 6, name_id: 212, email: 'tt@tt.tt', sex_id: 1 },
# 35
{user_id: 0, name_id: 45, email: '', sex_id: 1 },
# 36
{user_id: 0, name_id: 379, email: '', sex_id: 0 },
# 37
{user_id: 0, name_id: 371, email: '', sex_id: 0 },
# 38
{user_id: 0, name_id: 231, email: '', sex_id: 1 },
# 39
{user_id: 0, name_id: 506, email: '', sex_id: 0 },

# 40 - Tree 7
{user_id: 7, name_id: 45, email: 'yy@yy.yy', sex_id: 1 },
# 41
{user_id: 0, name_id: 123, email: '', sex_id: 1 },
# 42
{user_id: 0, name_id: 477, email: '', sex_id: 0 },
# 43
{user_id: 0, name_id: 453, email: '', sex_id: 0 },
# 44
{user_id: 0, name_id: 97, email: '', sex_id: 1 },
# 45
{user_id: 0, name_id: 371, email: '', sex_id: 0 },      # Вика 371
# 46
{user_id: 0, name_id: 506, email: '', sex_id: 0 },

# 47
{user_id: 8, name_id: 15, email: 'dd@dd.dd', sex_id: 1 },
# 48
{user_id: 0, name_id: 45, email: '', sex_id: 1 },
# 49
{user_id: 0, name_id: 453, email: '', sex_id: 0 },
# 50
{user_id: 0, name_id: 62, email: '', sex_id: 1 },
# 51
{user_id: 0, name_id: 97, email: '', sex_id: 1 },
# 52
{user_id: 0, name_id: 352, email: '', sex_id: 0 },
# 53
{user_id: 0, name_id: 477, email: '', sex_id: 0 },
# 54
{user_id: 0, name_id: 371, email: '', sex_id: 0 },
# 55
{user_id: 0, name_id: 45, email: '', sex_id: 1 },
# 56
{user_id: 0, name_id: 123, email: '', sex_id: 1 },
# 57
{user_id: 0, name_id: 453, email: '', sex_id: 0 },
# 58
{user_id: 0, name_id: 521, email: '', sex_id: 0 },

# 59
{user_id: 9, name_id: 352, email: 'gg@gg.gg', sex_id: 0 },
# 60
{user_id: 0, name_id: 97, email: '', sex_id: 1 },
# 61
{user_id: 0, name_id: 371, email: '', sex_id: 0 },
# 62
{user_id: 0, name_id: 477, email: '', sex_id: 0 },

# 63
{user_id: 10, name_id: 477, email: 'ss@ss.ss', sex_id: 0 },
# 64
{user_id: 0, name_id: 102, email: '', sex_id: 1 },
# 65
{user_id: 0, name_id: 506, email: '', sex_id: 0 },
# 66
{user_id: 0, name_id: 123, email: '', sex_id: 1 },
# 67
{user_id: 0, name_id: 265, email: '', sex_id: 1 },
# 68
{user_id: 0, name_id: 371, email: '', sex_id: 0 },


# 69
{user_id: 11, name_id: 265, email: 'xx@xx.xx', sex_id: 1 },
# 70
{user_id: 0, name_id: 123, email: '', sex_id: 1 },
# 71
{user_id: 0, name_id: 477, email: '', sex_id: 0 },
# 72
{user_id: 0, name_id: 371, email: '', sex_id: 0 },
# 73
{user_id: 0, name_id: 395, email: '', sex_id: 0 },
# 74
{user_id: 0, name_id: 97, email: '', sex_id: 1 },
# 75
{user_id: 0, name_id: 212, email: '', sex_id: 1 },
# 76
{user_id: 0, name_id: 453, email: '', sex_id: 0 },


# 77
{user_id: 12, name_id: 395, email: 'zz@zz.zz', sex_id: 0 },
# 78
{user_id: 0, name_id: 98, email: '', sex_id: 1 },
# 79
{user_id: 0, name_id: 467, email: '', sex_id: 0 },
# 80
{user_id: 0, name_id: 265, email: '', sex_id: 1 },
# 81
{user_id: 0, name_id: 97, email: '', sex_id: 1 },
# 82
{user_id: 0, name_id: 212, email: '', sex_id: 1 },
# 83
{user_id: 0, name_id: 453, email: '', sex_id: 0 },


# 84
{user_id: 0, name_id: 371, email: '', sex_id: 0 }

])


Tree.delete_all       # 1 admin + 4 start trees
Tree.reset_pk_sequence
Tree.create([


# LEGEND:
# user_id IS the Author
# user_id HAS profile_id AND name_id
# user_id HAS relation_id WHO IS is_profile_id WITH is_name_id

# 1 - Tree 1
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 0, is_profile_id: 1, is_name_id: 16, is_sex_id: 1, connected: false },
# 2
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 1, is_profile_id: 2, is_name_id: 75, is_sex_id: 1, connected: false },
# 3
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 2, is_profile_id: 3, is_name_id: 362, is_sex_id: 0, connected: false },
# 4
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 8, is_profile_id: 4, is_name_id: 352, is_sex_id: 0, connected: false },
# 5
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 3, is_profile_id: 5, is_name_id: 231, is_sex_id: 1, connected: false },
# 6
{user_id: 1, profile_id: 1, name_id: 16, relation_id: 3, is_profile_id: 6, is_name_id: 295, is_sex_id: 1, connected: false },

# 7 - Tree 2
{user_id: 2, profile_id: 7, relation_id: 0, connected: false },
{user_id: 2, profile_id: 8, relation_id: 1, connected: false },
{user_id: 2, profile_id: 9, relation_id: 2, connected: false },
{user_id: 2, profile_id: 10, relation_id: 6, connected: false },
{user_id: 2, profile_id: 11, relation_id: 6, connected: false },
{user_id: 2, profile_id: 12, relation_id: 8, connected: false },
{user_id: 2, profile_id: 13, relation_id: 4, connected: false },
{user_id: 2, profile_id: 14, relation_id: 4, connected: false },

# 15 - Tree 3
{user_id: 3, profile_id: 15, relation_id: 0, connected: false },
{user_id: 3, profile_id: 16, relation_id: 1, connected: false },
{user_id: 3, profile_id: 17, relation_id: 2, connected: false },
{user_id: 3, profile_id: 18, relation_id: 8, connected: false },
{user_id: 3, profile_id: 19, relation_id: 3, connected: false },
{user_id: 3, profile_id: 20, relation_id: 4, connected: false },
{user_id: 3, profile_id: 21, relation_id: 4, connected: false },

# 22 - Tree 4
{user_id: 4, profile_id: 22, name_id: 506, relation_id: 0, is_profile_id: 22, is_name_id: 506, is_sex_id: 0, connected: false },

{user_id: 4, profile_id: 22, name_id: 506, relation_id: 1, is_profile_id: 23, is_name_id: 45, is_sex_id: 1, connected: false },

{user_id: 4, profile_id: 22, name_id: 506, relation_id: 2, is_profile_id: 24, is_name_id: 453, is_sex_id: 0, connected: false },

{user_id: 4, profile_id: 22, name_id: 506, relation_id: 5, is_profile_id: 25, is_name_id: 97, is_sex_id: 1, connected: false },

{user_id: 4, profile_id: 22, name_id: 506, relation_id: 6, is_profile_id: 26, is_name_id: 453, is_sex_id: 0, connected: false },

# K Tree 4, Pfoile 84 - Виктория:    # к Денису - добавляем новый профиль: Жену Виктория
# При этом: в конец profiles_tree_arr добавляем   [80, 25, 97, "Денис", 1, 8, 84, 371, "Виктория", false]
{user_id: 4, profile_id: 25, name_id: 97, relation_id: 8, is_profile_id: 84, is_name_id: 371, is_sex_id: 0, connected: false },



# 27 - Tree 5
{user_id: 5, profile_id: 27, relation_id: 0, connected: false },
{user_id: 5, profile_id: 28, relation_id: 1, connected: false },
{user_id: 5, profile_id: 29, relation_id: 2, connected: false },
{user_id: 5, profile_id: 30, relation_id: 5, connected: false },
{user_id: 5, profile_id: 31, relation_id: 7, connected: false },
{user_id: 5, profile_id: 32, relation_id: 4, connected: false },
{user_id: 5, profile_id: 33, relation_id: 4, connected: false },

# 34 - Tree 6
{user_id: 6, profile_id: 34, relation_id: 0, connected: false },
{user_id: 6, profile_id: 35, relation_id: 1, connected: false },
{user_id: 6, profile_id: 36, relation_id: 2, connected: false },
{user_id: 6, profile_id: 37, relation_id: 8, connected: false },
{user_id: 6, profile_id: 38, relation_id: 3, connected: false },
{user_id: 6, profile_id: 39, relation_id: 4, connected: false },

# 40 - Tree 7
{user_id: 7, profile_id: 40, relation_id: 0, connected: false },
{user_id: 7, profile_id: 41, relation_id: 1, connected: false },
{user_id: 7, profile_id: 42, relation_id: 2, connected: false },
{user_id: 7, profile_id: 43, relation_id: 8, connected: false },
{user_id: 7, profile_id: 44, relation_id: 3, connected: false },
{user_id: 7, profile_id: 45, relation_id: 4, connected: false },
{user_id: 7, profile_id: 46, relation_id: 4, connected: false },


# 47 - Tree 8
{user_id: 8, profile_id: 47, relation_id: 0, connected: false },
{user_id: 8, profile_id: 48, relation_id: 1, connected: false },
{user_id: 8, profile_id: 49, relation_id: 2, connected: false },
{user_id: 8, profile_id: 50, relation_id: 5, connected: false },
{user_id: 8, profile_id: 51, relation_id: 5, connected: false },
{user_id: 8, profile_id: 52, relation_id: 6, connected: false },
{user_id: 8, profile_id: 53, relation_id: 6, connected: false },
{user_id: 8, profile_id: 54, relation_id: 8, connected: false },
{user_id: 8, profile_id: 55, relation_id: 3, connected: false },
{user_id: 8, profile_id: 56, relation_id: 3, connected: false },
{user_id: 8, profile_id: 57, relation_id: 4, connected: false },
{user_id: 8, profile_id: 58, relation_id: 4, connected: false },

# 59 - Tree 9
{user_id: 9, profile_id: 59, relation_id: 0, connected: false },
{user_id: 9, profile_id: 60, relation_id: 1, connected: false },
{user_id: 9, profile_id: 61, relation_id: 2, connected: false },
{user_id: 9, profile_id: 62, relation_id: 6, connected: false },

# 63- Tree 10
{user_id: 10, profile_id: 63, relation_id: 0, connected: false },
{user_id: 10, profile_id: 64, relation_id: 1, connected: false },
{user_id: 10, profile_id: 65, relation_id: 2, connected: false },
{user_id: 10, profile_id: 66, relation_id: 7, connected: false },
{user_id: 10, profile_id: 67, relation_id: 3, connected: false },
{user_id: 10, profile_id: 68, relation_id: 4, connected: false },

# 69 - Tree 11
{user_id: 11, profile_id: 69, relation_id: 0, connected: false },
{user_id: 11, profile_id: 70, relation_id: 1, connected: false },
{user_id: 11, profile_id: 71, relation_id: 2, connected: false },
{user_id: 11, profile_id: 72, relation_id: 6, connected: false },
{user_id: 11, profile_id: 73, relation_id: 8, connected: false },
{user_id: 11, profile_id: 74, relation_id: 3, connected: false },
{user_id: 11, profile_id: 75, relation_id: 3, connected: false },
{user_id: 11, profile_id: 76, relation_id: 4, connected: false },

# 77 - Tree 12
{user_id: 12, profile_id: 77, relation_id: 0, connected: false },
{user_id: 12, profile_id: 78, relation_id: 1, connected: false },
{user_id: 12, profile_id: 79, relation_id: 2, connected: false },
{user_id: 12, profile_id: 80, relation_id: 7, connected: false },
{user_id: 12, profile_id: 81, relation_id: 3, connected: false },
{user_id: 12, profile_id: 82, relation_id: 3, connected: false },
{user_id: 12, profile_id: 83, relation_id: 4, connected: false }


])
