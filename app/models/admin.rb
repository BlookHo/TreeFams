class Admin < ActiveRecord::Base

  has_secure_password

  validates :password,
            :presence => true, :on => :create,
            :confirmation => true

  validates :email,
            :presence => true,
            :uniqueness => true,
            :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }


end
