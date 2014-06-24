class ProfileKey < ActiveRecord::Base
  include AddProfileLogic
  belongs_to :profile, dependent: :destroy
  belongs_to :user
  belongs_to :name, foreign_key: :is_name_id
end
