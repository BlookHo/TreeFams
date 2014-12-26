########################################################


# Сброс делаем через админку:
# 1. Зайти в адинку /admin
# 2. Перейти в закладку 'Настройки'
# 3. Выбрать закладку 'сброс'
# 4. Для доавления сущностей, которые нужно чистить см: app/controllers/admin/resets_controller.rb


########################################################

# # Освежает: очищает все таблицы
# # (кроме системных: Names, SubNames, Relations, WeafamSettings)
#
# User.delete_all
# User.reset_pk_sequence
# User.create([])
#
#
# PendingUser.delete_all
# PendingUser.reset_pk_sequence
# PendingUser.create([])
#
#
# Profile.delete_all
# Profile.reset_pk_sequence
# Profile.create([])
#
#
# ProfileData.delete_all
# ProfileData.reset_pk_sequence
# ProfileData.create([])
#
#
# Tree.delete_all
# Tree.reset_pk_sequence
# Tree.create([])
#
#
# ProfileKey.delete_all
# ProfileKey.reset_pk_sequence
# ProfileKey.create([])
#
#
# ConnectionRequest.delete_all
# ConnectionRequest.reset_pk_sequence
# ConnectionRequest.create([])
#
#
# ConnectedUser.delete_all
# ConnectedUser.reset_pk_sequence
# ConnectedUser.create([])
#
#
# Message.delete_all
# Message.reset_pk_sequence
# Message.create([])
#
#
# UpdatesFeed.delete_all
# UpdatesFeed.reset_pk_sequence
# UpdatesFeed.create([])
#
#
