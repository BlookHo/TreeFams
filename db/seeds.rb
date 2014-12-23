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
  {name: ' Количество родни в твоем дереве (размер дерева) превысило 10 человек!',  image: 'updates/tree_vol_10.png'}, # № 8 -  10
  {name: ' Количество родни в твоем дереве (размер дерева) превысило 15 человек!',  image: 'updates/tree_vol_15.png'}, # 9-  15
  {name: ' Количество родни в твоем дереве (размер дерева) превысило 20 человек!',  image: 'updates/tree_vol_20.png'}, # 10-  20
  {name: ' Количество родни в твоем дереве (размер дерева) превысило 25 человек!',  image: 'updates/tree_vol_25.png'}, # 11-  25
  {name: ' Количество родни в твоем дереве (размер дерева) превысило 30 человек!',  image: 'updates/tree_vol_30.png'}, # 12-  30
  {name: ' Количество родни в твоем дереве (размер дерева) превысило 40 человек!',  image: 'updates/tree_vol_40.png'}, # 13-  40
  {name: ' Количество родни в твоем дереве (размер дерева) превысило 50 человек!',  image: 'updates/tree_vol_50.png'}, # 14-  50
  {name: ' Количество родни в твоем дереве (размер дерева) превысило 100 человек!', image: 'updates/tree_vol_100.png'},  # 15-  100
  {name: ' Количество родни в твоем дереве (размер дерева) превысило 150 человек!', image: 'updates/tree_vol_150.png'}  # 16-  150

  ])
