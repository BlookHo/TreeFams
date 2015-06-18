class AddColumnToProfileData < ActiveRecord::Migration
  def change
    add_column :profile_data, :deleted, :integer, default: 0
  end
end
