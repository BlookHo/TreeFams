class ProfileKey < ActiveRecord::Base
  include AddProfileLogic
  belongs_to :profile #, dependent: :destroy
  belongs_to :is_profile, foreign_key: :is_profile_id, class_name: Profile
  belongs_to :user
  belongs_to :name, foreign_key: :is_name_id
end
