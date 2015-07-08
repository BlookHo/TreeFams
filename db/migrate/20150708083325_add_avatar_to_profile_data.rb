class AddAvatarToProfileData < ActiveRecord::Migration
  def change
    add_column :profile_data, :avatar_mongo_id, :string
  end
end
