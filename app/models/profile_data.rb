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


  # @note Организация объединения (перезаписывания по алгоритму) записей ProfileData,
  # относящихся к соответствующим профилям
  # Алгоритм: 1. Определяем сколько у профилей заполненных полей в
  # 2. Определяем у кого больше - тот профиль и главный при перезаписывании данных
  # 3. Если одинаковое кол-во полей заполнено, то Главный - тот профиль, кот-й перезаписывается по алгоритму объединения
  # 4. Пустые поля заполняются полями Главного профиля.
  def self.connect_profiles_data(profiles_to_rewrite, profiles_to_destroy)

    fillness_arr_rewrite, fillness_arr_destroy = self.get_fillness_arrays(profiles_to_rewrite,profiles_to_destroy)
    new_data_row = {}
    profiles_to_rewrite.each_with_index do |one_profile_rewrite, index|

      data_rewrite = self.where(profile_id: one_profile_rewrite)
      data_destroy = self.where(profile_id: profiles_to_destroy[index])

      if !data_rewrite.blank? && !data_destroy.blank?
        ['last_name', 'biography', 'birthday', 'country', 'city', 'avatar_mongo_id'].each do |field|
          if !data_rewrite[0]["#{field}"].blank? && !data_destroy[0]["#{field}"].blank?
            # Both - not empty   Проверять, кто Главный, того и записывать
            fillness_arr_rewrite[index] >= fillness_arr_destroy[index] ?
                # Если оба равные, то записывать от data_rewrite
                new_data_row["#{field}"] = data_rewrite[0]["#{field}"] :
                new_data_row["#{field}"] = data_destroy[0]["#{field}"]

          elsif !data_rewrite[0]["#{field}"].blank? && data_destroy[0]["#{field}"].blank?
            # data_rewrite - not empty.   записывать от data_rewrite
            new_data_row["#{field}"] = data_rewrite[0]["#{field}"]

          elsif data_rewrite[0]["#{field}"].blank? && !data_destroy[0]["#{field}"].blank?
            # data_destroy - not empty.   записывать от data_destroy
            new_data_row["#{field}"] = data_destroy[0]["#{field}"]

          elsif data_rewrite[0]["#{field}"].blank? && data_destroy[0]["#{field}"].blank?
            # data_destroy - not empty.   записывать nil
            new_data_row["#{field}"] = nil
          end
        end

        ['photos'].each do |field|
          new_data_row["#{field}"] = data_rewrite[0]["#{field}"] + data_destroy[0]["#{field}"]
        end

        data_rewrite.each do |one_data_row|
          one_data_row.update_attributes(:last_name => new_data_row["last_name"],
                                         :biography => new_data_row["biography"],
                                         :birthday => new_data_row["birthday"],
                                         :country => new_data_row["country"],
                                         :city => new_data_row["city"],
                                         :avatar_mongo_id => new_data_row["avatar_mongo_id"],
                                         :photos => new_data_row["photos"],
                                         :updated_at => Time.now)
        end

        self.mark_deleted_profile_data(data_destroy)
        puts "In connect_profiles_data: Check rewrite, destroy = NOT blank "

      elsif data_rewrite.blank? && !data_destroy.blank?
        self.create(profile_id: one_profile_rewrite,
                    last_name: data_destroy[0]["last_name"],
                    biography: data_destroy[0]["biography"],
                    birthday: data_destroy[0]["birthday"],
                    country: data_destroy[0]["country"],
                    city: data_destroy[0]["city"],
                    avatar_mongo_id: data_destroy[0]["avatar_mongo_id"],
                    photos: data_destroy[0]["photos"] )
        self.mark_deleted_profile_data(data_destroy)
        puts "In connect_profiles_data: Check rewrite=blank "

      end
    end

  end


  # @note При объединении записей ProfileData - помечаем перезаписываемые ряды как удаленные
  def self.mark_deleted_profile_data(data_destroy)
    data_destroy.each do |row|
      row.update_attributes(:deleted => 1,:updated_at => Time.now)
    end
  end


  # @note Сбор массивов количеств заполненных полей для каждого из профиля
  # в соответствующих записях ProfileData
  def self.get_fillness_arrays(profiles_to_rewrite,profiles_to_destroy)
    fillness_arr_rewrite = self.check_fillness(profiles_to_rewrite)
    fillness_arr_destroy = self.check_fillness(profiles_to_destroy)
    puts "In connect_profiles_data: fillness_arr_rewrite = #{fillness_arr_rewrite},\nfillness_arr_destroy = #{fillness_arr_destroy} "
    return fillness_arr_rewrite, fillness_arr_destroy
  end


  # @note Подсчет количеств count заполненных полей и запись их в соотв-й массив
  def self.check_fillness(profiles_ids)
    fillness_arr = []
    profiles_ids.each_with_index do |one_profile_rewrite, index|
      count = 0
      profile_data_row = self.where(profile_id: one_profile_rewrite)
      if !profile_data_row.blank?
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
        if !profile_data_row[0]['avatar_mongo_id'].blank?
          count = count + 1
        end
        if !profile_data_row[0]['photos'].blank?
          count = count + 1
        end
      end
      fillness_arr[index] = count

    end
    return fillness_arr
  end


  # @note При разъединении деревьев - удаление ProfileData
  def self.destroy_profile_data(connected_users_data)
    # conn_users_destroy_data = {
    #     user_id: connection_common_log["user_id"], #    1,
    #     with_user_id: Profile.find(connection_common_log["base_profile_id"]).user_id,    #        3,
    #     connection_id: connection_common_log["log_id"]   #    3,
    # }

    user_id      = connected_users_data[:user_id]
    with_user_id = connected_users_data[:with_user_id]
    connected = ConnectedUser.where(user_id: user_id, with_user_id: with_user_id)
    profiles_rewrite = connected.pluck(:rewrite_profile_id)
    profiles_destroy = connected.pluck(:overwrite_profile_id)
    puts "In destroy_profile_data: profiles_rewrite = #{profiles_rewrite}, profiles_destroy = #{profiles_destroy}"

    self.profile_data_to_delete(profiles_rewrite, profiles_destroy)

  end


  # @note Удаление всех записей относящихся к разъединяемым профилям
  def self.profile_data_to_delete(profiles_rewrite, profiles_destroy)
    profiles_rewrite.each_with_index do |one_profile_rewrite, index|
      data_rewrite = self.where(profile_id: one_profile_rewrite)
      data_rewrite.map(&:destroy)
      data_destroy = self.where(profile_id: profiles_destroy[index])
      data_destroy.map(&:destroy)
    end
  end

end
