class Name < ActiveRecord::Base
  validates :name,
            presence: true,
            uniqueness: true

  validates :only_male, presence: true

end
