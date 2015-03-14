# encoding: utf-8

CommonLog.delete_all
CommonLog.reset_pk_sequence
CommonLog.create([


{user_id: 1, log_type: 1, log_id: 1, profile_id: 1},
{user_id: 2, log_type: 1, log_id: 1, profile_id: 1},
{user_id: 3, log_type: 2, log_id: 1, profile_id: 1},
{user_id: 1, log_type: 1, log_id: 2, profile_id: 2},
{user_id: 2, log_type: 1, log_id: 2, profile_id: 1},
{user_id: 3, log_type: 1, log_id: 1, profile_id: 1},
{user_id: 1, log_type: 2, log_id: 1, profile_id: 1},
{user_id: 2, log_type: 1, log_id: 3, profile_id: 1},
{user_id: 3, log_type: 1, log_id: 1, profile_id: 1},
{user_id: 1, log_type: 1, log_id: 3, profile_id: 3},
{user_id: 2, log_type: 1, log_id: 4, profile_id: 1},
{user_id: 1, log_type: 2, log_id: 2, profile_id: 1},
{user_id: 3, log_type: 2, log_id: 1, profile_id: 1},
{user_id: 1, log_type: 1, log_id: 4, profile_id: 7},
{user_id: 2, log_type: 2, log_id: 1, profile_id: 1},
{user_id: 3, log_type: 1, log_id: 1, profile_id: 1},
{user_id: 4, log_type: 3, log_id: 1, profile_id: 1},
{user_id: 2, log_type: 1, log_id: 5, profile_id: 1},
{user_id: 3, log_type: 1, log_id: 1, profile_id: 1},
{user_id: 1, log_type: 4, log_id: 1, profile_id: 1},
{user_id: 4, log_type: 2, log_id: 1, profile_id: 1},
{user_id: 2, log_type: 4, log_id: 1, profile_id: 1},
{user_id: 1, log_type: 1, log_id: 5, profile_id: 8},
{user_id: 2, log_type: 2, log_id: 2, profile_id: 1},
{user_id: 1, log_type: 1, log_id: 6, profile_id: 9},
{user_id: 4, log_type: 1, log_id: 1, profile_id: 1},
{user_id: 3, log_type: 3, log_id: 1, profile_id: 4},
{user_id: 4, log_type: 1, log_id: 2, profile_id: 1},
{user_id: 1, log_type: 1, log_id: 7, profile_id: 121},
{user_id: 1, log_type: 1, log_id: 8, profile_id: 122},
{user_id: 1, log_type: 1, log_id: 9, profile_id: 123},
{user_id: 2, log_type: 1, log_id: 6, profile_id: 124}

                 ])
