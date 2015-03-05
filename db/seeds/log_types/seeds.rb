# encoding: utf-8

LogType.delete_all
LogType.reset_pk_sequence
LogType.create([

{type_number: 1, table_name: 'adds_logs'},
{type_number: 2, table_name: 'deletions_logs'},
{type_number: 3, table_name: 'similars_logs'},
{type_number: 4, table_name: 'connections_logs'}

               ])
