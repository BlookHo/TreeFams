class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  # User profile
  has_one :profile

  # Nearest circle profiles
  has_many :profiles
end
