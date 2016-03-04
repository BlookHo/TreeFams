class AddPhotosToProfileData < ActiveRecord::Migration
  def change
    add_column :profile_data, :photos, :string, array: true, default: []
  end
end
