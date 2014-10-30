class Message < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :text, :receiver_id, :sender_id, :message => "Должно присутствовать в Messages"
  validates_numericality_of :receiver_id, :sender_id, :only_integer => true, :message => "ID автора сообщения или получателя сообщения должны быть целым числом в Messages"
  validates_numericality_of :receiver_id, :sender_id, :greater_than => 0, :message => "ID автора сообщения или получателя сообщения должны быть больше 0 в Messages"

  validates_inclusion_of :read, :sender_deleted, :receiver_deleted, :in => [true, false]

  validates_length_of :text, :minimum => 2, :maximum => 420, :message => "Поле текста сообщения должно быть длиной от 2 до 420 символов в Messages"

end
