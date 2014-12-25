class AddAvatarToProfileData < ActiveRecord::Migration
  def self.up
    add_attachment :profile_data, :avatar
  end

  def self.down
    remove_attachment :profile_data, :avatar
  end
end
