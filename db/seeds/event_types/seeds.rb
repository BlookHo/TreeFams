# encoding: utf-8

EventType.delete_all
EventType.reset_pk_sequence
EventType.create([

{type_number: 1, name: 'регистрация'},
{type_number: 2, name: 'вход'},
{type_number: 3, name: 'выход'},
{type_number: 4, name: 'создание профиля'},
{type_number: 5, name: 'переименование'},
{type_number: 6, name: 'удаление'},
{type_number: 7, name: 'фамилия'},
{type_number: 8, name: 'биография'},
{type_number: 9, name: 'день рождения'},
{type_number: 10, name: 'страна'},
{type_number: 11, name: 'город'},
{type_number: 12, name: 'аватар'},
{type_number: 13, name: 'фото'},
{type_number: 14, name: 'дата смерти'},
{type_number: 15, name: 'первая фамилия'},
{type_number: 16, name: 'место рождения'},
{type_number: 17, name: 'запрос на объединение'},
{type_number: 18, name: 'объединение'},
{type_number: 19, name: 'похожие'},
{type_number: 20, name: 'объединение похожих'},
{type_number: 21, name: 'сообщение'},
{type_number: 22, name: 'приглашение'},
{type_number: 23, name: 'пост'},
{type_number: 24, name: 'поиск'},
{type_number: 25, name: 'количество профилей'},
{type_number: 26, name: 'откат'}

               ])
