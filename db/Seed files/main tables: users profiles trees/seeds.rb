# encoding: utf-8


User.delete_all       # 1 admin + 4 start trees
User.reset_pk_sequence
User.create([

# 1
{profile_id: 0, admin: true, email: 'aa@aa.aa' },
# 2
{profile_id: 0, admin: false, email: 'qq@qq.qq' },
# 3
{profile_id: 0, admin: false, email: 'ww@ww.ww' },
# 4
{profile_id: 0, admin: false, email: 'ee@ee.ee' },
# 5
{profile_id: 0, admin: false, email: 'rr@rr.rr' }
# 6
#{profile_id: 0, admin: false, email: 'tt@tt.tt' }

])



Profile.delete_all       # 1 admin + 4 start trees
Profile.reset_pk_sequence
Profile.create([

# 1 - Tree 1
{user_id: 0, name_id: 0, email: 'aa@aa.aa', sex_id: 0 },
# 2
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 3
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 4
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 5
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 6
{user_id: 0, name_id: 0, email: '', sex_id: 0 },

# 7 - Tree 2
{user_id: 0, name_id: 0, email: 'qq@qq.qq', sex_id: 0 },
# 8
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 9
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 10
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 11
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 12
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 13
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 14
{user_id: 0, name_id: 0, email: '', sex_id: 0 },

# 15 - Tree 3
{user_id: 0, name_id: 0, email: 'ww@ww.ww', sex_id: 0 },
# 16
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 17
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 18
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 19
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 20
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 21
{user_id: 0, name_id: 0, email: '', sex_id: 0 },

# 22 - Tree 4
{user_id: 0, name_id: 0, email: 'ee@ee.ee', sex_id: 0 },
# 23
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 24
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 25
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 26
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 27
{user_id: 0, name_id: 0, email: '', sex_id: 0 },

# 28 - Tree 5
{user_id: 0, name_id: 0, email: 'rr@rr.rr', sex_id: 0 },
# 29
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 30
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 31
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 32
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 33
{user_id: 0, name_id: 0, email: '', sex_id: 0 },
# 34
{user_id: 0, name_id: 0, email: '', sex_id: 0 }

])


Tree.delete_all       # 1 admin + 4 start trees
Tree.reset_pk_sequence
Tree.create([

# 1 - Tree 1
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
# 2
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
# 3
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
# 4
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
# 5
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },

# 6 - Tree 2
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },

# 6 - Tree 3
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },

# 6 - Tree 4
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },

# 6 - Tree 5
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false },
{user_id: 0, profile_id: 0, relation_id: 0, connected: false }





])





