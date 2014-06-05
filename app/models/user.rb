class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # has_secure_password

  validates :email,
            :uniqueness => true,
            :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  # User profile
  has_one :profile
  has_many :trees

  def name
    profile.name.name
  end

  private

  def generate_hash
  end


end
