class ProfileData < ActiveRecord::Base

    belongs_to  :profile

    belongs_to  :creator,
                :foreign_key => :creator_id,
                :class_name => User

end
