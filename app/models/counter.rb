class Counter < ActiveRecord::Base

  validates_presence_of      :invites, :disconnects, :message => "Должно присутствовать в Counter"
  validates_numericality_of  :invites, :disconnects, :only_integer => true, :message => "Значения - должны быть целым числом в Counter"
  validates_numericality_of  :invites, :disconnects, :greater_than_or_equal_to => 0, :message => "Значения - должны быть больше 0 в Counter"


  # @note: Инкремент значения при отправке приглашения
  def self.increment_invites
    counters = first
    counters.invites += 1
    counters.update_attributes(invites: counters.invites,:updated_at => Time.now)
  end

  # @note: Инкремент значения при разъединении
  def self.increment_disconnects
    counters = first
    counters.disconnects += 1
    counters.update_attributes(disconnects: counters.disconnects,:updated_at => Time.now)
  end






end
