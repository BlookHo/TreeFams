class ConnectedUser < ActiveRecord::Base

  validates_presence_of :user_id, :with_user_id,
                        :message => "Должно присутствовать в ConnectedUser"
  validates_numericality_of :user_id, :with_user_id, :only_integer => true,
                        :message => "ID автора сообщения или получателя сообщения должны быть целым числом в ConnectedUser"
  validates_numericality_of :user_id, :with_user_id, :greater_than => 0,
                        :message => "ID автора сообщения или получателя сообщения должны быть больше 0 в ConnectedUser"
  validate :connect_users_ids_not_equal  # :user_id  AND :with_user_id

  # custom validation
  def connect_users_ids_not_equal
    self.errors.add(:connected_users, 'Юзеры IDs в одном ряду не должны быть равны в ConnectedUser.') if self.user_id == self.with_user_id
  end

  belongs_to :user

  scope :connected_users_ids, -> (connected_user) {where(user_id: connected_user.id).pluck(:with_user_id)}
  scope :connected_with_users_ids, -> (connected_user) {where(with_user_id: connected_user.id).pluck(:user_id)}

end
