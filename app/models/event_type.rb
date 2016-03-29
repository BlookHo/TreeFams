class EventType < ActiveRecord::Base


  validates_presence_of :type_number, :name, :message => "Должно присутствовать в EventType"

  validates_numericality_of :type_number, :greater_than => 0,  :message => "Должнo быть больше 0 в EventType"
  validates_numericality_of :type_number, :only_integer => true, :message => "Должнo быть целым числом в EventType"

  validates_inclusion_of :type_number, :in => [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26],
                         :message => "Должнo быть числом в диапазоне [1,2,3,4,5,6,7] в EventType"
  # validates_inclusion_of :table_name, :in => ["adds_logs", "deletions_logs", "similars_logs", "connections_logs",
  #                                             "renames_logs", "sign_ups", "rollbacks common_logs", "home in rails"],
  #                        :message => "Должнo быть именем из заданного списка в EventType"
  validates :name, format: { with: /\A[a-zA-Zа-яА-Я]+\z/, message: "only allows letters" }


  #  event_type:, read: bool
  #  user_id: email: profile_id:

  #  agent_user_id: int
  #
  # agent_profile_id
  # agent_profile_data: string
  #

  # profiles_qty: int
  #
  # log_type:   log_id
  # /

#
#  event_type: i, user_id: i, email: str,
# profile_id: i, (user.profile)
#
#  agent_profile_id: i,
#      agent_profile_data: stri,
#
#
#      read: bool,
#
#   #
#   # {type_number: 1, name: 'регистрация'},
#
#   user_id:
#   email:
#
#   #     {type_number: 2, name: 'вход'},
#       user_id:
#       email:
#
#   #     {type_number: 3, name: 'выход'},
#       user_id:
#       email:
#
#   #     {type_number: 4, name: 'создание профиля'},
#       user_id:
#       email:
#      agent_profile_id: i,
#      agent_profile_data: stri, (name - string)
#
#
#   #     {type_number: 5, name: 'переименование'},
#      agent_profile_id: i,
#      agent_profile_data: stri,
#
#
#   #     {type_number: 6, name: 'удаление'},
#      agent_profile_id: i,
#      agent_profile_data: stri,
#
#   #     {type_number: 7, name: 'фамилия'},
#      agent_profile_id: i,
#      agent_profile_data: stri,
#
#   #     {type_number: 8, name: 'биография'},
#   #     {type_number: 9, name: 'день рождения'},
#   #     {type_number: 10, name: 'страна'},
#   #     {type_number: 11, name: 'город'},
#   #     {type_number: 12, name: 'аватар'},
#   #     {type_number: 13, name: 'фото'},
#   #     {type_number: 14, name: 'дата смерти'},
#   #     {type_number: 15, name: 'первая фамилия'},
#   #     {type_number: 16, name: 'место рождения'},
#      agent_profile_id: i,
#      agent_profile_data: stri,
#
#   #     {type_number: 17, name: 'запрос на объединение'},
#      agent_user_id: i,
#
#   #     {type_number: 18, name: 'объединение'},
#      agent_user_id: i,
#   #     {type_number: 19, name: 'похожие'},
#      agent_user_id: i,
#   #     {type_number: 20, name: 'объединение похожих'},
#      agent_user_id: i,
#   #     {type_number: 21, name: 'сообщение'},
#      agent_user_id: i,
#   #     {type_number: 22, name: 'приглашение'},
#      agent_user_id: i,
#   #     {type_number: 23, name: 'пост'},
#
#   #     {type_number: 24, name: 'поиск'},
#      agent_user_id: i,
#   #     {type_number: 25, name: 'количество профилей'},
#   profiles_qty
#   #     {type_number: 26, name: 'откат'}
#   log_type: in
#           log_id:
#
#
#
#   #
#





end
