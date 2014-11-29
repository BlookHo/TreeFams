# Освежает: очищает все таблицы
# (кроме системных: Names, SubNames, Relations, WeafamSettings)

User.delete_all
User.reset_pk_sequence
User.create([
            ])

Profile.delete_all
Profile.reset_pk_sequence
Profile.create([
               ])

ProfileData.delete_all
ProfileData.reset_pk_sequence
ProfileData.create([
                   ])

Tree.delete_all
Tree.reset_pk_sequence
Tree.create([
            ])

ProfileKey.delete_all
ProfileKey.reset_pk_sequence
ProfileKey.create([
                  ])

ConnectionRequest.delete_all
ConnectionRequest.reset_pk_sequence
ConnectionRequest.create([
                         ])

ConnectedUser.delete_all
ConnectedUser.reset_pk_sequence
ConnectedUser.create([
                     ])

Message.delete_all
Message.reset_pk_sequence
Message.create([
                ])


