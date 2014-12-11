class UpdatesEvent < ActiveRecord::Base

  validates_presence_of :name, :message => "Должно присутствовать в UpdatesEvent"






end
