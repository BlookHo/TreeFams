class PendingUser < ActiveRecord::Base
  enum status: [ :pending, :blocked, :approved ]

  scope :pending,  -> {where(status: 0)}
  scope :blocked,  -> {where(status: 1)}
  scope :approved, -> {where(status: 2)}


  def json_data
    updated_data.blank? ? JSON.parse(data) : JSON.parse(updated_data)
  end


  def block!
    update_column(:status, 1)
  end


  def approve!
    update_column(:status, 2)
  end


end
