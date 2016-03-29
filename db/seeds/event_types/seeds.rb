# encoding: utf-8

EventType.delete_all
EventType.reset_pk_sequence
EventType.create([

{type: 1, name: 'регистрация'},
{type: 2, name: 'вход'},
{type: 3, name: 'выход'},
{type: 4, name: 'создание профиля'},
{type: 5, name: 'переименование'},
{type: 6, name: 'удаление'},
{type: 7, name: 'фамилия'},
{type: 8, name: 'биография'},
{type: 9, name: 'день рождения'},
{type: 10, name: 'страна'},
{type: 11, name: 'город'},
{type: 12, name: 'аватар'},
{type: 13, name: 'фото'},
{type: 14, name: 'дата смерти'},
{type: 15, name: 'первая фамилия'},
{type: 16, name: 'место рождения'},
{type: 17, name: 'запрос на объединение'},
{type: 18, name: 'объединение'},
{type: 19, name: 'похожие'},
{type: 20, name: 'объединение похожих'},
{type: 21, name: 'сообщение'},
{type: 22, name: 'приглашение'},
{type: 23, name: 'пост'},
{type: 24, name: 'поиск'},
{type: 25, name: 'количество профилей'},
{type: 26, name: 'откат'}

               ])
