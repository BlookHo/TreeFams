class ConnectedUser < ActiveRecord::Base
  belongs_to :user

  scope :connected_users_ids, -> (connected_user) {where(user_id: connected_user.id).pluck(:with_user_id)}
  scope :connected_with_users_ids, -> (connected_user) {where(with_user_id: connected_user.id).pluck(:user_id)}

end
