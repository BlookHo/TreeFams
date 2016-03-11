class AddFieldsToProfileData < ActiveRecord::Migration
  def change
    add_column :profile_data, :deathdate,      :string
    add_column :profile_data, :prev_last_name, :string
    add_column :profile_data, :birth_place,    :string
  end
end
