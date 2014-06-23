class Tree < ActiveRecord::Base
  belongs_to :profile
  belongs_to :name, foreign_key: "is_name_id"
end
