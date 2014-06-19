class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :name



  def to_name
    name.name.mb_chars.capitalize
  end

end
