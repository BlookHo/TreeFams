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
{user_id: 0, name_id: 453, email: '', sex_id: 0 }

#
## 84
#{user_id: 0, name_id: 371, email: '', sex_id: 0 }

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
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 0, is_profile_id: 7, is_name_id: 97, is_sex_id: 1, connected: false },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 1, is_profile_id: 8, is_name_id: 45, is_sex_id: 1, connected: false },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 2, is_profile_id: 9, is_name_id: 453, is_sex_id: 0, connected: false },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 6, is_profile_id: 10, is_name_id: 453, is_sex_id: 0, connected: false },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 6, is_profile_id: 11, is_name_id: 506, is_sex_id: 0, connected: false },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 8, is_profile_id: 12, is_name_id: 371, is_sex_id: 0, connected: false },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 4, is_profile_id: 13, is_name_id: 352, is_sex_id: 0, connected: false },
{user_id: 2, profile_id: 7, name_id: 97, relation_id: 4, is_profile_id: 14, is_name_id: 477, is_sex_id: 0, connected: false },

# 15 - Tree 3
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 0, is_profile_id: 15, is_name_id: 45, is_sex_id: 1, connected: false },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 1, is_profile_id: 16, is_name_id: 123, is_sex_id: 1, connected: false },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 2, is_profile_id: 17, is_name_id: 477, is_sex_id: 0, connected: false },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 8, is_profile_id: 18, is_name_id: 453, is_sex_id: 0, connected: false },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 3, is_profile_id: 19, is_name_id: 97, is_sex_id: 1, connected: false },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 4, is_profile_id: 20, is_name_id: 453, is_sex_id: 0, connected: false },
{user_id: 3, profile_id: 15, name_id: 45, relation_id: 4, is_profile_id: 21, is_name_id: 506, is_sex_id: 0, connected: false },

# 22 - Tree 4
{user_id: 4, profile_id: 22, name_id: 506, relation_id: 0, is_profile_id: 22, is_name_id: 506, is_sex_id: 0, connected: false },

{user_id: 4, profile_id: 22, name_id: 506, relation_id: 1, is_profile_id: 23, is_name_id: 45, is_sex_id: 1, connected: false },

{user_id: 4, profile_id: 22, name_id: 506, relation_id: 2, is_profile_id: 24, is_name_id: 453, is_sex_id: 0, connected: false },

{user_id: 4, profile_id: 22, name_id: 506, relation_id: 5, is_profile_id: 25, is_name_id: 97, is_sex_id: 1, connected: false },

{user_id: 4, profile_id: 22, name_id: 506, relation_id: 6, is_profile_id: 26, is_name_id: 453, is_sex_id: 0, connected: false },

# K Tree 4, Pfoile 84 - Виктория:    # к Денису - добавляем новый профиль: Жену Виктория
# При этом: в конец profiles_tree_arr добавляем   [80, 25, 97, "Денис", 1, 8, 84, 371, "Виктория", false]
#{user_id: 4, profile_id: 25, name_id: 97, relation_id: 8, is_profile_id: 84, is_name_id: 371, is_sex_id: 0, connected: false },



# 27 - Tree 5
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 0, is_profile_id: 27, is_name_id: 371, is_sex_id: 0, connected: false },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 1, is_profile_id: 28, is_name_id: 123, is_sex_id: 1, connected: false },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 2, is_profile_id: 29, is_name_id: 352, is_sex_id: 0, connected: false },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 5, is_profile_id: 30, is_name_id: 265, is_sex_id: 1, connected: false },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 7, is_profile_id: 31, is_name_id: 97, is_sex_id: 1, connected: false },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 4, is_profile_id: 32, is_name_id: 477, is_sex_id: 0, connected: false },
{user_id: 5, profile_id: 27, name_id: 371, relation_id: 4, is_profile_id: 33, is_name_id: 352, is_sex_id: 0, connected: false },

# 34 - Tree 6
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 0, is_profile_id: 34, is_name_id: 212, is_sex_id: 1, connected: false },
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 1, is_profile_id: 35, is_name_id: 45, is_sex_id: 1, connected: false },
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 2, is_profile_id: 36, is_name_id: 379, is_sex_id: 0, connected: false },
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 8, is_profile_id: 37, is_name_id: 371, is_sex_id: 0, connected: false },
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 3, is_profile_id: 38, is_name_id: 231, is_sex_id: 1, connected: false },
{user_id: 6, profile_id: 34, name_id: 212, relation_id: 4, is_profile_id: 39, is_name_id: 506, is_sex_id: 0, connected: false },

# 40 - Tree 7
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 0, is_profile_id: 40, is_name_id: 45, is_sex_id: 1, connected: false },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 1, is_profile_id: 41, is_name_id: 123, is_sex_id: 1, connected: false },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 2, is_profile_id: 42, is_name_id: 477, is_sex_id: 0, connected: false },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 8, is_profile_id: 43, is_name_id: 453, is_sex_id: 0, connected: false },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 3, is_profile_id: 44, is_name_id: 97, is_sex_id: 1, connected: false },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 4, is_profile_id: 45, is_name_id: 371, is_sex_id: 0, connected: false },
{user_id: 7, profile_id: 40, name_id: 45, relation_id: 4, is_profile_id: 46, is_name_id: 506, is_sex_id: 0, connected: false },


# 47 - Tree 8
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 0, is_profile_id: 47, is_name_id: 15, is_sex_id: 1, connected: false },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 1, is_profile_id: 48, is_name_id: 45, is_sex_id: 1, connected: false },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 2, is_profile_id: 49, is_name_id: 453, is_sex_id: 0, connected: false },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 5, is_profile_id: 50, is_name_id: 62, is_sex_id: 1, connected: false },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 5, is_profile_id: 51, is_name_id: 97, is_sex_id: 1, connected: false },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 6, is_profile_id: 52, is_name_id: 352, is_sex_id: 0, connected: false },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 6, is_profile_id: 53, is_name_id: 477, is_sex_id: 0, connected: false },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 8, is_profile_id: 54, is_name_id: 371, is_sex_id: 0, connected: false },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 3, is_profile_id: 55, is_name_id: 45, is_sex_id: 1, connected: false },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 3, is_profile_id: 56, is_name_id: 123, is_sex_id: 1, connected: false },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 4, is_profile_id: 57, is_name_id: 453, is_sex_id: 0, connected: false },
{user_id: 8, profile_id: 47, name_id: 15, relation_id: 4, is_profile_id: 58, is_name_id: 521, is_sex_id: 0, connected: false },

# 59 - Tree 9
{user_id: 9, profile_id: 59, name_id: 352, relation_id: 0, is_profile_id: 59, is_name_id: 352, is_sex_id: 0, connected: false },
{user_id: 9, profile_id: 59, name_id: 352, relation_id: 1, is_profile_id: 60, is_name_id: 97, is_sex_id: 1, connected: false },
{user_id: 9, profile_id: 59, name_id: 352, relation_id: 2, is_profile_id: 61, is_name_id: 371, is_sex_id: 0, connected: false },
{user_id: 9, profile_id: 59, name_id: 352, relation_id: 6, is_profile_id: 62, is_name_id: 477, is_sex_id: 0, connected: false },

# 63- Tree 10
{user_id: 10, profile_id: 63, name_id: 477, relation_id: 0, is_profile_id: 63, is_name_id: 477, is_sex_id: 0, connected: false },
{user_id: 10, profile_id: 63, name_id: 477, relation_id: 1, is_profile_id: 64, is_name_id: 102, is_sex_id: 1, connected: false },
{user_id: 10, profile_id: 63, name_id: 477, relation_id: 2, is_profile_id: 65, is_name_id: 506, is_sex_id: 0, connected: false },
{user_id: 10, profile_id: 63, name_id: 477, relation_id: 7, is_profile_id: 66, is_name_id: 123, is_sex_id: 1, connected: false },
{user_id: 10, profile_id: 63, name_id: 477, relation_id: 3, is_profile_id: 67, is_name_id: 265, is_sex_id: 1, connected: false },
{user_id: 10, profile_id: 63, name_id: 477, relation_id: 4, is_profile_id: 68, is_name_id: 371, is_sex_id: 0, connected: false },

# 69 - Tree 11
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 0, is_profile_id: 69, is_name_id: 265, is_sex_id: 1, connected: false },
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 1, is_profile_id: 70, is_name_id: 123, is_sex_id: 1, connected: false },
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 2, is_profile_id: 71, is_name_id: 477, is_sex_id: 0, connected: false },
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 6, is_profile_id: 72, is_name_id: 371, is_sex_id: 0, connected: false },
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 8, is_profile_id: 73, is_name_id: 395, is_sex_id: 0, connected: false },
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 3, is_profile_id: 74, is_name_id: 97, is_sex_id: 1, connected: false },
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 3, is_profile_id: 75, is_name_id: 212, is_sex_id: 1, connected: false },
{user_id: 11, profile_id: 69, name_id: 265, relation_id: 4, is_profile_id: 76, is_name_id: 453, is_sex_id: 0, connected: false },

# 77 - Tree 12
{user_id: 12, profile_id: 77, name_id: 395, relation_id: 0, is_profile_id: 77, is_name_id: 395, is_sex_id: 0, connected: false },
{user_id: 12, profile_id: 77, name_id: 395, relation_id: 1, is_profile_id: 78, is_name_id: 98, is_sex_id: 1, connected: false },
{user_id: 12, profile_id: 77, name_id: 395, relation_id: 2, is_profile_id: 79, is_name_id: 467, is_sex_id: 0, connected: false },
{user_id: 12, profile_id: 77, name_id: 395, relation_id: 7, is_profile_id: 80, is_name_id: 265, is_sex_id: 1, connected: false },
{user_id: 12, profile_id: 77, name_id: 395, relation_id: 3, is_profile_id: 81, is_name_id: 97, is_sex_id: 1, connected: false },
{user_id: 12, profile_id: 77, name_id: 395, relation_id: 3, is_profile_id: 82, is_name_id: 212, is_sex_id: 1, connected: false },
{user_id: 12, profile_id: 77, name_id: 395, relation_id: 4, is_profile_id: 83, is_name_id: 453, is_sex_id: 0, connected: false }


])


#
#@profiles_array: [[0, "Денис", 1], [1, "Борис", 1], [2, "Сусанна", 0], [6, "Ирина", 0], [6, "Наталья", 0], [8, "Виктория", 0], [4, "Дарья", 0], [4, "Екатерина", 0]].
#
#@author_ProfileKeys_arr - [["Денис", 1, "Борис", 1], ["Денис", 2, "Сусанна", 2], ["Денис", 6, "Ирина", 6], ["Денис", 6, "Наталья", 6], ["Денис", 8, "Виктория", 8], ["Денис", 4, "Дарья", 4], ["Денис", 4, "Екатерина", 4]] @wife_ProfileKeys_arr - [["Виктория", 7, "Денис", 0], ["Виктория", 4, "Дарья", 4], ["Виктория", 4, "Екатерина", 4]] @husband_ProfileKeys_arr - [] @son_ProfileKeys_arr - [] @sons_names_arr - @daugther_ProfileKeys_arr - [["Дарья", 1, "Денис", 0], ["Дарья", 2, "Виктория", 8], ["Екатерина", 1, "Денис", 0], ["Екатерина", 2, "Виктория", 8], ["Дарья", 6, "Екатерина", 4], ["Екатерина", 6, "Дарья", 4]] @daugthers_names_arr - ["Дарья", "Екатерина"]
#
#Исходный Массив профилей: @profiles_array: [[0, "Денис", 1], [1, "Борис", 1], [2, "Сусанна", 0], [6, "Ирина", 0], [6, "Наталья", 0], [8, "Виктория", 0], [4, "Дарья", 0], [4, "Екатерина", 0]]
#
#Массив профилей с id: [profile_id, Relation_id, name_id] : @profiles_arr_w_ids: [[84, "Денис", 97, 1, 0], [85, "Борис", 45, 1, 1], [86, "Сусанна", 503, 0, 2], [87, "Ирина", 409, 0, 6], [88, "Наталья", 467, 0, 6], [89, "Виктория", 371, 0, 8], [90, "Дарья", 385, 0, 4], [91, "Екатерина", 394, 0, 4]]
#
#@profile_id_hash: {84=>["Денис", 0], 85=>["Борис", 1], 86=>["Сусанна", 2], 87=>["Ирина", 6], 88=>["Наталья", 6], 89=>["Виктория", 8], 90=>["Дарья", 4], 91=>["Екатерина", 4]}
#
#@profiles_array: [[0, "Денис", 1], [1, "Борис", 1], [2, "Сусанна", 0]]. * Имя матери: Сусанна. Массив профилей БК: @profiles_array: [[0, "Денис", 1], [1, "Борис", 1], [2, "Сусанна", 0], [6, "Ирина", 0]]. * Имя сестры: Ирина. Массив профилей БК: @profiles_array: [[0, "Денис", 1], [1, "Борис", 1], [2, "Сусанна", 0], [6, "Ирина", 0], [6, "Наталья", 0]]. * Имя сестры: Наталья.
#    Массивы для ProfileKeys: @author_ProfileKeys_arr - [["Денис", 1, "Борис", 1], ["Денис", 2, "Сусанна", 2], ["Денис", 6, "Ирина", 6], ["Денис", 6, "Наталья", 6]] @father_ProfileKeys_arr - [["Борис", 3, "Денис", 0], ["Борис", 8, "Сусанна", 2], ["Борис", 4, "Ирина", 6], ["Борис", 4, "Наталья", 6]] @mother_ProfileKeys_arr - [["Сусанна", 7, "Борис", 1], ["Сусанна", 3, "Денис", 0], ["Сусанна", 4, "Ирина", 6], ["Сусанна", 4, "Наталья", 6]] @brother_ProfileKeys_arr - [] @sisters_names_arr - ["Ирина", "Наталья"] @sister_ProfileKeys_arr - [["Ирина", 1, "Борис", 1], ["Ирина", 2, "Сусанна", 2], ["Ирина", 5, "Денис", 0], ["Наталья", 1, "Борис", 1], ["Наталья", 2, "Сусанна", 2], ["Наталья", 5, "Денис", 0], ["Ирина", 6, "Наталья", 6], ["Наталья", 6, "Ирина", 6]]#
#@profiles_array: [[0, "Денис", 1], [1, "Борис", 1], [2, "Сусанна", 0], [6, "Ирина", 0], [6, "Наталья", 0], [8, "Виктория", 0], [4, "Дарья", 0], [4, "Екатерина", 0]]. * Имя дочери: Екатерина.
#    Массивы для ProfileKeys: @author_ProfileKeys_arr - [["Денис", 1, "Борис", 1], ["Денис", 2, "Сусанна", 2], ["Денис", 6, "Ирина", 6], ["Денис", 6, "Наталья", 6], ["Денис", 8, "Виктория", 8], ["Денис", 4, "Дарья", 4], ["Денис", 4, "Екатерина", 4]] @wife_ProfileKeys_arr - [["Виктория", 7, "Денис", 0], ["Виктория", 4, "Дарья", 4], ["Виктория", 4, "Екатерина", 4]] @husband_ProfileKeys_arr - [] @son_ProfileKeys_arr - [] @sons_names_arr - @daugther_ProfileKeys_arr - [["Дарья", 1, "Денис", 0], ["Дарья", 2, "Виктория", 8], ["Екатерина", 1, "Денис", 0], ["Екатерина", 2, "Виктория", 8], ["Дарья", 6, "Екатерина", 4], ["Екатерина", 6, "Дарья", 4]] @daugthers_names_arr - ["Дарья", "Екатерина"]
#Массив профилей с id: [profile_id, Relation_id, name_id] : @profiles_arr_w_ids: [[84, "Денис", 97, 1, 0], [85, "Борис", 45, 1, 1], [86, "Сусанна", 503, 0, 2], [87, "Ирина", 409, 0, 6], [88, "Наталья", 467, 0, 6], [89, "Виктория", 371, 0, 8], [90, "Дарья", 385, 0, 4], [91, "Екатерина", 394, 0, 4]]
#@profile_id_hash: {84=>["Денис", 0], 85=>["Борис", 1], 86=>["Сусанна", 2], 87=>["Ирина", 6], 88=>["Наталья", 6], 89=>["Виктория", 8], 90=>["Дарья", 4], 91=>["Екатерина", 4]}
#





#
#@profiles_array: [[0, "Ирина", 0], [1, "Борис", 1], [2, "Сусанна", 0], [5, "Денис", 1]]. * Имя брата: Денис. Массив профилей БК: @profiles_array: [[0, "Ирина", 0], [1, "Борис", 1], [2, "Сусанна", 0], [5, "Денис", 1], [6, "Наталья", 0]]. * Имя сестры: Наталья.
#
#    Массивы для ProfileKeys: @author_ProfileKeys_arr - [["Ирина", 1, "Борис", 1], ["Ирина", 2, "Сусанна", 2], ["Ирина", 5, "Денис", 5], ["Ирина", 6, "Наталья", 6]] @father_ProfileKeys_arr - [["Борис", 3, "Ирина", 0], ["Борис", 8, "Сусанна", 2], ["Борис", 3, "Денис", 5], ["Борис", 4, "Наталья", 6]] @mother_ProfileKeys_arr - [["Сусанна", 7, "Борис", 1], ["Сусанна", 3, "Ирина", 0], ["Сусанна", 3, "Денис", 5], ["Сусанна", 4, "Наталья", 6]] @brother_ProfileKeys_arr - [["Денис", 1, "Борис", 1], ["Денис", 2, "Сусанна", 2], ["Денис", 5, "Ирина", 0], ["Денис", 6, "Наталья", 6]] @sisters_names_arr - ["Наталья"] @sister_ProfileKeys_arr - [["Наталья", 5, "Денис", 5], ["Наталья", 1, "Борис", 1], ["Наталья", 2, "Сусанна", 2], ["Наталья", 5, "Ирина", 0]]
#
#@profiles_array: [[0, "Ирина", 0], [1, "Борис", 1], [2, "Сусанна", 0], [5, "Денис", 1], [6, "Наталья", 0], [7, "Михаил", 1]]. * Имя мужа: Михаил.
#
#    Массивы для ProfileKeys: @author_ProfileKeys_arr - [["Ирина", 1, "Борис", 1], ["Ирина", 2, "Сусанна", 2], ["Ирина", 5, "Денис", 5], ["Ирина", 6, "Наталья", 6], ["Ирина", 7, "Михаил", 7]] @husband_ProfileKeys_arr - [["Михаил", 8, "Ирина", 0]]
#
#@profiles_array: [[0, "Ирина", 0], [1, "Борис", 1], [2, "Сусанна", 0], [5, "Денис", 1], [6, "Наталья", 0], [7, "Михаил", 1], [3, "Иван", 1]]. * Имя сына: Иван.
#
#    Массивы для ProfileKeys: @author_ProfileKeys_arr - [["Ирина", 1, "Борис", 1], ["Ирина", 2, "Сусанна", 2], ["Ирина", 5, "Денис", 5], ["Ирина", 6, "Наталья", 6], ["Ирина", 7, "Михаил", 7], ["Ирина", 3, "Иван", 3]] @wife_ProfileKeys_arr - [["", 3, "Иван", 3]] @husband_ProfileKeys_arr - [["Михаил", 8, "Ирина", 0]] @son_ProfileKeys_arr - [["Иван", 1, "Ирина", 0], ["Иван", 2, "", 8]] @sons_names_arr - ["Иван"]
#

#@profiles_array: [[0, "Ирина", 0], [1, "Борис", 1], [2, "Сусанна", 0], [5, "Денис", 1]]. * Имя брата: Денис. Массив профилей БК: @profiles_array: [[0, "Ирина", 0], [1, "Борис", 1], [2, "Сусанна", 0], [5, "Денис", 1], [6, "Наталья", 0]]. * Имя сестры: Наталья.
#    Массивы для ProfileKeys: @author_ProfileKeys_arr - [["Ирина", 1, "Борис", 1], ["Ирина", 2, "Сусанна", 2], ["Ирина", 5, "Денис", 5], ["Ирина", 6, "Наталья", 6]] @father_ProfileKeys_arr - [["Борис", 4, "Ирина", 0], ["Борис", 8, "Сусанна", 2], ["Борис", 3, "Денис", 5], ["Борис", 4, "Наталья", 6]] @mother_ProfileKeys_arr - [["Сусанна", 7, "Борис", 1], ["Сусанна", 4, "Ирина", 0], ["Сусанна", 3, "Денис", 5], ["Сусанна", 4, "Наталья", 6]] @brother_ProfileKeys_arr - [["Денис", 1, "Борис", 1], ["Денис", 2, "Сусанна", 2], ["Денис", 6, "Ирина", 0], ["Денис", 6, "Наталья", 6]] @sisters_names_arr - ["Наталья"] @sister_ProfileKeys_arr - [["Наталья", 5, "Денис", 5], ["Наталья", 1, "Борис", 1], ["Наталья", 2, "Сусанна", 2], ["Наталья", 6, "Ирина", 0]]
#@profiles_array: [[0, "Ирина", 0], [1, "Борис", 1], [2, "Сусанна", 0], [5, "Денис", 1], [6, "Наталья", 0], [7, "Михаил", 1], [3, "Иван", 1]]. * Имя сына: Иван.
#    Массивы для ProfileKeys: @author_ProfileKeys_arr - [["Ирина", 1, "Борис", 1], ["Ирина", 2, "Сусанна", 2], ["Ирина", 5, "Денис", 5], ["Ирина", 6, "Наталья", 6], ["Ирина", 7, "Михаил", 7], ["Ирина", 3, "Иван", 3]] @wife_ProfileKeys_arr - [] @husband_ProfileKeys_arr - [["Михаил", 8, "Ирина", 0], ["Михаил", 3, "Иван", 3]] @son_ProfileKeys_arr - [["Иван", 2, "Ирина", 0], ["Иван", 1, "Михаил", 7]] @sons_names_arr - ["Иван"]
#Исходный Массив профилей: @profiles_array: [[0, "Ирина", 0], [1, "Борис", 1], [2, "Сусанна", 0], [5, "Денис", 1], [6, "Наталья", 0], [7, "Михаил", 1], [3, "Иван", 1]]
#Массив профилей с id: [profile_id, Relation_id, name_id] : @profiles_arr_w_ids: [[92, "Ирина", 409, 0, 0], [93, "Борис", 45, 1, 1], [94, "Сусанна", 503, 0, 2], [95, "Денис", 97, 1, 5], [96, "Наталья", 467, 0, 6], [97, "Михаил", 196, 1, 7], [98, "Иван", 123, 1, 3]]
#@profile_id_hash: {92=>["Ирина", 0], 93=>["Борис", 1], 94=>["Сусанна", 2], 95=>["Денис", 5], 96=>["Наталья", 6], 97=>["Михаил", 7], 98=>["Иван", 3]}
#
#
#@profiles_array: [[0, "Иван", 1], [1, "Михаил", 1], [2, "Ирина", 0]]. * Имя матери: Ирина.
#    Массивы для ProfileKeys: @author_ProfileKeys_arr - [["Иван", 1, "Михаил", 1], ["Иван", 2, "Ирина", 2]] @father_ProfileKeys_arr - [["Михаил", 3, "Иван", 0], ["Михаил", 8, "Ирина", 2]] @mother_ProfileKeys_arr - [["Ирина", 7, "Михаил", 1], ["Ирина", 3, "Иван", 0]]
#Исходный Массив профилей: @profiles_array: [[0, "Иван", 1], [1, "Михаил", 1], [2, "Ирина", 0]]
#Массив профилей с id: [profile_id, Relation_id, name_id] : @profiles_arr_w_ids: [[99, "Иван", 123, 1, 0], [100, "Михаил", 196, 1, 1], [101, "Ирина", 409, 0, 2]]
#@profile_id_hash: {99=>["Иван", 0], 100=>["Михаил", 1], 101=>["Ирина", 2]}

#
#@profiles_array: [[0, "Михаил", 1], [1, "Вячеслав", 1], [2, "Елена", 0], [5, "Вячеслав", 1], [5, "Анатолий", 1]]. * Имя брата: Анатолий.
#    Массивы для ProfileKeys: @author_ProfileKeys_arr - [["Михаил", 1, "Вячеслав", 1], ["Михаил", 2, "Елена", 2], ["Михаил", 5, "Вячеслав", 5], ["Михаил", 5, "Анатолий", 5]] @father_ProfileKeys_arr - [["Вячеслав", 3, "Михаил", 0], ["Вячеслав", 8, "Елена", 2], ["Вячеслав", 3, "Вячеслав", 5], ["Вячеслав", 3, "Анатолий", 5]] @mother_ProfileKeys_arr - [["Елена", 7, "Вячеслав", 1], ["Елена", 3, "Михаил", 0], ["Елена", 3, "Вячеслав", 5], ["Елена", 3, "Анатолий", 5]] @brothers_names_arr - ["Вячеслав", "Анатолий"] @brother_ProfileKeys_arr - [["Вячеслав", 1, "Вячеслав", 1], ["Вячеслав", 2, "Елена", 2], ["Вячеслав", 5, "Михаил", 0], ["Анатолий", 1, "Вячеслав", 1], ["Анатолий", 2, "Елена", 2], ["Анатолий", 5, "Михаил", 0], ["Вячеслав", 5, "Анатолий", 5], ["Анатолий", 5, "Вячеслав", 5]]
#@profiles_array: [[0, "Михаил", 1], [1, "Вячеслав", 1], [2, "Елена", 0], [5, "Вячеслав", 1], [5, "Анатолий", 1], [8, "Ирина", 0], [3, "Иван", 1]]. * Имя сына: Иван.
#    Массивы для ProfileKeys: @author_ProfileKeys_arr - [["Михаил", 1, "Вячеслав", 1], ["Михаил", 2, "Елена", 2], ["Михаил", 5, "Вячеслав", 5], ["Михаил", 5, "Анатолий", 5], ["Михаил", 8, "Ирина", 8], ["Михаил", 3, "Иван", 3]] @wife_ProfileKeys_arr - [["Ирина", 7, "Михаил", 0], ["Ирина", 3, "Иван", 3]] @husband_ProfileKeys_arr - [] @son_ProfileKeys_arr - [["Иван", 1, "Михаил", 0], ["Иван", 2, "Ирина", 8]] @sons_names_arr - ["Иван"]
#Исходный Массив профилей: @profiles_array: [[0, "Михаил", 1], [1, "Вячеслав", 1], [2, "Елена", 0], [5, "Вячеслав", 1], [5, "Анатолий", 1], [8, "Ирина", 0], [3, "Иван", 1]]
#Массив профилей с id: [profile_id, Relation_id, name_id] : @profiles_arr_w_ids: [[102, "Михаил", 196, 1, 0], [103, "Вячеслав", 75, 1, 1], [104, "Елена", 395, 0, 2], [105, "Вячеслав", 75, 1, 5], [106, "Анатолий", 20, 1, 5], [107, "Ирина", 409, 0, 8], [108, "Иван", 123, 1, 3]]
#@profile_id_hash: {102=>["Михаил", 0], 103=>["Вячеслав", 1], 104=>["Елена", 2], 105=>["Вячеслав", 5], 106=>["Анатолий", 5], 107=>["Ирина", 8], 108=>["Иван", 3]}




