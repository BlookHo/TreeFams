class ChangeFieldsInProfileData < ActiveRecord::Migration
  def change
    rename_column :profile_data, :birth_date, :birthday
    remove_column :profile_data, :creator_id
    remove_column :profile_data, :middle_name
    remove_attachment :profile_data, :avatar
  end
end
