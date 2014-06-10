class ProfileKey < ActiveRecord::Base
  belongs_to :profile, dependent: :destroy
  belongs_to :user
end
