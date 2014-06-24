class ProfileKey < ActiveRecord::Base
  include AddProfileLogic
  belongs_to :profile, dependent: :destroy
  belongs_to :user
end
