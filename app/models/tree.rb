class Tree < ActiveRecord::Base
  belongs_to :profile, foreign_key: "is_profile_id"
  belongs_to :name, foreign_key: "is_name_id"
end
