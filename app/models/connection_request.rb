class ConnectionRequest < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :user_id, :with_user_id, connection_id, :message => "Должно присутствовать в ConnectionRequest"
  validates_numericality_of :user_id, :with_user_id, connection_id, :only_integer => true, :message => "ID объединяемых Юзеров: должны быть целым числом в ConnectionRequest"
  validates_numericality_of :user_id, :with_user_id, connection_id, :greater_than => 0, :message => "ID объединяемых Юзеров: должны быть больше 0 в ConnectionRequest"

  validates_inclusion_of :confirm, :in => [nil, 0, 1], :message => "Значение поля подтверждения объединения: должно быть [nil, 0, 1] в ConnectionRequest"

  validates_inclusion_of :done, :in => [true, false]

  #validates_length_of :text, :minimum => 2, :maximum => 420, :message => "Поле текста сообщения должно быть длиной от 2 до 420 символов в Messages"

end
