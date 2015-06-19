class ProfileData < ActiveRecord::Base

  belongs_to  :profile
  # belongs_to  :creator,
  #             :foreign_key => :creator_id,
  #             :class_name => User


  # has_attached_file :avatar,
  #                   :styles => {:original => ["100%", :png], :medium => "300x300>", :thumb => "100x100>", :round_thumb => "100x100#" },
  #                   :convert_options => {:round_thumb => Proc.new{self.convert_options}}

  # has_attached_file :avatar,
  #                   :styles => {:original => ["100%", :png], :medium => "300x300#", :thumb => "100x100#", :round_thumb => "100x100#"},
  #                   :convert_options => {:round_thumb => Proc.new{self.convert_options}}

  # crop_attached_file :avatar

  # validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # def self.convert_options(px = 50)
  #   trans = ""
  #   trans << " \\( +clone  -alpha extract "
  #   trans << "-draw 'fill black polygon 0,0 0,#{px} #{px},0 fill white circle #{px},#{px} #{px},0' "
  #   trans << "\\( +clone -flip \\) -compose Multiply -composite "
  #   trans << "\\( +clone -flop \\) -compose Multiply -composite "
  #   trans << "\\) -alpha off -compose CopyOpacity -composite "
  # end

  def to_name
    self.profile.to_name
  end

  def location
    [country, city].reject { |c| c.blank? }.join(', ')
  end

  # def human_birth_day
  #   birth_date
  # end

  # def avatar_url(size)
  #   has_avatar? ? avatar.url(size) : profile.icon_path
  # end

  # def has_avatar?
  #   avatar.present?
  # end


  def self.c1connect!(profiles_to_rewrite, profiles_to_destroy)
    profiles_to_destroy.each_with_index do |profile_id_to_destroy, index|
      ProfileData.where(profile_id: profile_id_to_destroy).each do |data|
        data.update_column(profile_id, profiles_to_rewrite[index])
      end
    end
  end


  def self.connect_profiles_data(profiles_to_rewrite, profiles_to_destroy)

    fillness_arr_rewrite, fillness_arr_destroy = self.get_fillness_arrays(profiles_to_rewrite,profiles_to_destroy)

    new_profile_data_row = {}
    profiles_to_rewrite.each_with_index do |one_profile_rewrite, index|

      p_data_rewrite = self.where(profile_id: one_profile_rewrite)
      p_data_destroy = self.where(profile_id: profiles_to_destroy[index])

      if !p_data_rewrite.blank? && !p_data_rewrite.blank?
        ['last_name', 'biography', 'birthday', 'country', 'city'].each do |table_field|
          if !p_data_rewrite[0]["#{table_field}"].blank? && !p_data_destroy[0]["#{table_field}"].blank?
            # Both - not empty   Проверять, кто Главный, того и записывать
            if fillness_arr_rewrite[index] >= fillness_arr_destroy[index]
            # Если оба равные, то записывать от p_data_rewrite
              new_profile_data_row["#{table_field}"] = p_data_rewrite[0]["#{table_field}"]
            else
              new_profile_data_row["#{table_field}"] = p_data_destroy[0]["#{table_field}"]
            end
          elsif !p_data_rewrite[0]["#{table_field}"].blank? && p_data_destroy[0]["#{table_field}"].blank?
            # p_data_rewrite - not empty.   записывать от p_data_rewrite
            new_profile_data_row["#{table_field}"] = p_data_rewrite[0]["#{table_field}"]

          elsif p_data_rewrite[0]["#{table_field}"].blank? && !p_data_destroy[0]["#{table_field}"].blank?
            # p_data_destroy - not empty.   записывать от p_data_destroy
            new_profile_data_row["#{table_field}"] = p_data_destroy[0]["#{table_field}"]

          elsif p_data_rewrite[0]["#{table_field}"].blank? && p_data_destroy[0]["#{table_field}"].blank?
            # p_data_destroy - not empty.   записывать nil
            new_profile_data_row["#{table_field}"] = nil
          end
        end

        p_data_rewrite.each do |one_data_row|
          one_data_row.update_attributes(:last_name => new_profile_data_row["last_name"],
                                         :biography => new_profile_data_row["biography"],
                                         :birthday => new_profile_data_row["birthday"],
                                         :country => new_profile_data_row["country"],
                                         :city => new_profile_data_row["city"],
                                         :updated_at => Time.now)
        end

        p_data_destroy.each do |one_data_row|
          one_data_row.update_attributes(:deleted => 1,:updated_at => Time.now)
          # puts "In ProfileData.connect : one_data_row.deleted = #{one_data_row.deleted} "

        end

      end
    end
    puts "In connect_profiles_data: new_profile_data_row = #{new_profile_data_row} "

    # return new_profile_data_row
  end


  def self.create_profile_data




  end


  def self.get_fillness_arrays(profiles_to_rewrite,profiles_to_destroy)
    fillness_arr_rewrite = self.check_fillness(profiles_to_rewrite)
    fillness_arr_destroy = self.check_fillness(profiles_to_destroy)
    puts "In connect_profiles_data: fillness_arr_rewrite = #{fillness_arr_rewrite},\nfillness_arr_destroy = #{fillness_arr_destroy} "
    return fillness_arr_rewrite, fillness_arr_destroy
  end


  def self.check_fillness(profiles_ids)

    fillness_arr = []
    profiles_ids.each_with_index do |one_profile_rewrite, index|
      count = 0
      profile_data_row = self.where(profile_id: one_profile_rewrite)
      if !profile_data_row[0]['last_name'].blank?
        count = count + 1
      end
      if !profile_data_row[0]['biography'].blank?
        count = count + 1
      end
      if !profile_data_row[0]['birthday'].blank?
        count = count + 1
      end
      if !profile_data_row[0]['country'].blank?
        count = count + 1
      end
      if !profile_data_row[0]['city'].blank?
        count = count + 1
      end

      fillness_arr[index] = count

    end
    return fillness_arr

  end







end
