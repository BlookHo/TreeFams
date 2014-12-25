class ProfileData < ActiveRecord::Base

    belongs_to  :profile
    belongs_to  :creator,
                :foreign_key => :creator_id,
                :class_name => User


    has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/


    def to_name
      self.profile.to_name
    end

    def location
      [country, city].reject { |c| c.blank? }.join(', ')
    end

    def human_birth_day
      birth_date
    end

    def avatar_url(size)
      avatar.present? ? avatar.url(size) : profile.icon_path
    end

end
