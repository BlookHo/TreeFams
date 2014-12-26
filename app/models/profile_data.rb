class ProfileData < ActiveRecord::Base

    belongs_to  :profile
    belongs_to  :creator,
                :foreign_key => :creator_id,
                :class_name => User


    has_attached_file :avatar,
                      :styles => { :medium => "300x300>", :thumb => "100x100>", :round_thumb => "100x100>" },
                      :convert_options => {:round_thumb => Proc.new{self.convert_options}}

    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/


    def self.convert_options(px = 50)
      trans = ""
      trans << " \\( +clone  -alpha extract "
      trans << "-draw 'fill black polygon 0,0 0,#{px} #{px},0 fill white circle #{px},#{px} #{px},0' "
      trans << "\\( +clone -flip \\) -compose Multiply -composite "
      trans << "\\( +clone -flop \\) -compose Multiply -composite "
      trans << "\\) -alpha off -compose CopyOpacity -composite "
    end


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
      has_avatar? ? avatar.url(size) : profile.icon_path
    end

    def has_avatar?
      avatar.present?
    end


    def self.connect!(profiles_to_rewrite, profiles_to_destroy)
      profiles_to_destroy.each_with_index do |profile_id_to_destroy, index|
        ProfileData.where(profile_id: profile_id_to_destroy).each do |data|
          data.update_column(profile_id, profiles_to_rewrite[index])
        end
      end
    end

end
