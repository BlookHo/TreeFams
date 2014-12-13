# encoding: utf-8


UpdatesEvent.delete_all
UpdatesEvent.reset_pk_sequence
UpdatesEvent.create([


{name: 'Вам отправлен запрос на объединение с пользователем по имени ', image: 'updates/connect_request.png'},
{name: 'Объединился с пользователем по имени ', image: 'updates/connection_tree.png'},
{name: 'Выбор избранного', image: 'updates/fav_choose.png'},
{name: 'Добавлен профиль с именем ', image: 'updates/add_profile.png'},
{name: 'На сайт приглашен новый пользователь по имени ', image: 'updates/invitation.png'},
{name: 'Новые данные в профиле родственнике', image: 'updates/new_profile_data.png'},
{name: 'Событие у родственника', image: 'updates/family_event.png'},
{name: 'Количество родни в его дереве (размер дерева) превысило 25 человек', image: 'updates/tree_vol_25.png'},
{name: 'Количество родни в его дереве (размер дерева) превысило 50 человек', image: 'updates/tree_vol_50.png'},
{name: 'Количество родни в его дереве (размер дерева) превысило 100 человек', image: 'updates/tree_vol_100.png'}







])

