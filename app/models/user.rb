class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # User profile
  has_one :profile

  def name
    profile.name.name
  end

end
