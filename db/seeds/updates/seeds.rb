# encoding: utf-8


UpdatesEvent.delete_all
UpdatesEvent.reset_pk_sequence
UpdatesEvent.create([


{name: ' отправлен запрос на объединение деревьев от пользователя по имени ', image: 'updates/connect_request.png'},
{name: ' проведено объединение с ', image: 'updates/connection_tree.png'},
{name: ' пометил как избранного профиль с именем ', image: 'updates/fav_choose.png'},
{name: ' в дерево родни добавлен новый профиль с именем ', image: 'updates/add_profile.png'},
{name: ' на сайт приглашен новый пользователь по имени ', image: 'updates/invitation.png'},
{name: 'Новые данные в профиле родственнике', image: 'updates/new_profile_data.png'},
{name: 'Событие у родственника', image: 'updates/family_event.png'},
{name: ' Количество родни в твоем дереве (размер дерева) превысило 25 человек!', image: 'updates/tree_vol_25.png'},
{name: ' Количество родни в твоем дереве (размер дерева) превысило 50 человек!', image: 'updates/tree_vol_50.png'},
{name: ' Количество родни в твоем дереве (размер дерева) превысило 100 человек!', image: 'updates/tree_vol_100.png'}







])

