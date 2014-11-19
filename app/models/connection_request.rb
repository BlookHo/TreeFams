class ConnectionRequest < ActiveRecord::Base

  belongs_to :user
  #attr_accessor :user_id, :with_user_id, :connection_id, :confirm, :done, :created_at
  validates_presence_of :user_id, :with_user_id, :connection_id, :message => "Должно присутствовать в ConnectionRequest"
  validates_numericality_of :user_id, :with_user_id, :connection_id, :only_integer => true, :message => "ID объединяемых Юзеров: должны быть целым числом в ConnectionRequest"
  validates_numericality_of :user_id, :with_user_id, :connection_id, :greater_than => 0, :message => "ID объединяемых Юзеров: должны быть больше 0 в ConnectionRequest"

  validates_inclusion_of :confirm, :in => [nil, 0, 1], :message => "Значение поля подтверждения объединения: должно быть [nil, 0, 1] в ConnectionRequest"

  validates_inclusion_of :done, :in => [true, false]

end
