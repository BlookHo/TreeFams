class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :name

  attr_accessor :profile_name, :relation_id

  def to_name
    name.try(:name).try(:mb_chars).try(:capitalize)
  end

end
