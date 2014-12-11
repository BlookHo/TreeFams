class UpdatesFeed < ActiveRecord::Base

  validates_presence_of :user_id, :update_id, :message => "Должно присутствовать в UpdatesFeed"
  validates_numericality_of :user_id, :update_id, :only_integer => true, :message => "ID автора нового события и ID события должны быть целым числом в UpdatesFeed"
  validates_numericality_of :user_id, :update_id, :greater_than => 0, :message => "ID автора нового события и ID события должны быть больше 0 в UpdatesFeed"



end
