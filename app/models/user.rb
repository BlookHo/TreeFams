class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  # User profile
  has_one :profile

  # Nearest circle profiles
  has_many :profile_keys
  # has_many :profiles, through: :profile_keys, :source => :profile_id


  def name
    profile.name.name
  end
end
