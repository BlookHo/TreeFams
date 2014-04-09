# encoding: utf-8


User.delete_all       # 1 admin + 4 start trees
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
{profile_id: 27, admin: false, email: 'rr@rr.rr', password: '555555', password_confirmation: '555555' }


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
{user_id: 3, name_id: 45, email: 'ww@ww.ww', sex_id: 0 },
# 16
{user_id: 0, name_id: 123, email: '', sex_id: 0 },
# 17
{user_id: 0, name_id: 477, email: '', sex_id: 0 },
# 18
{user_id: 0, name_id: 453, email: '', sex_id: 0 },
# 19
{user_id: 0, name_id: 97, email: '', sex_id: 0 },
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
{user_id: 0, name_id: 352, email: '', sex_id: 0 }

])


Tree.delete_all       # 1 admin + 4 start trees
Tree.reset_pk_sequence
Tree.create([

# 1 - Tree 1
{user_id: 1, profile_id: 2, relation_id: 1, connected: false },
# 2
{user_id: 1, profile_id: 3, relation_id: 2, connected: false },
# 3
{user_id: 1, profile_id: 4, relation_id: 8, connected: false },
# 4
{user_id: 1, profile_id: 5, relation_id: 3, connected: false },
# 5
{user_id: 1, profile_id: 6, relation_id: 3, connected: false },

# 6 - Tree 2
{user_id: 2, profile_id: 8, relation_id: 1, connected: false },
{user_id: 2, profile_id: 9, relation_id: 2, connected: false },
{user_id: 2, profile_id: 10, relation_id: 6, connected: false },
{user_id: 2, profile_id: 11, relation_id: 6, connected: false },
{user_id: 2, profile_id: 12, relation_id: 8, connected: false },
{user_id: 2, profile_id: 13, relation_id: 4, connected: false },
{user_id: 2, profile_id: 14, relation_id: 4, connected: false },

# 6 - Tree 3
{user_id: 3, profile_id: 16, relation_id: 1, connected: false },
{user_id: 3, profile_id: 17, relation_id: 2, connected: false },
{user_id: 3, profile_id: 18, relation_id: 8, connected: false },
{user_id: 3, profile_id: 19, relation_id: 3, connected: false },
{user_id: 3, profile_id: 20, relation_id: 4, connected: false },
{user_id: 3, profile_id: 21, relation_id: 4, connected: false },

# 6 - Tree 4
{user_id: 4, profile_id: 23, relation_id: 1, connected: false },
{user_id: 4, profile_id: 24, relation_id: 2, connected: false },
{user_id: 4, profile_id: 25, relation_id: 5, connected: false },
{user_id: 4, profile_id: 26, relation_id: 6, connected: false },

# 6 - Tree 5
{user_id: 5, profile_id: 28, relation_id: 1, connected: false },
{user_id: 5, profile_id: 29, relation_id: 2, connected: false },
{user_id: 5, profile_id: 30, relation_id: 5, connected: false },
{user_id: 5, profile_id: 31, relation_id: 7, connected: false },
{user_id: 5, profile_id: 32, relation_id: 4, connected: false },
{user_id: 5, profile_id: 33, relation_id: 4, connected: false }





])





