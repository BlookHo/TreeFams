class User < ActiveRecord::Base
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

  has_secure_password

  validates :email,
            :uniqueness => true,
            :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }


  # User profile
  has_one :profile,  dependent: :destroy
  has_many :trees,   dependent: :destroy


  def name
    profile.name.name
  end


  private

  def self.create_with_email(email)
    self.create(email: email, password: User.generate_password, password_confirmation: User.generate_password)
  end

  def self.generate_password
    '1111'
  end


end
