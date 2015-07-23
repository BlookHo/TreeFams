class AddDeletedToProfileData < ActiveRecord::Migration
  def change
    unless column_exists? :profile_data, :deleted
      add_column :profile_data, :deleted, :integer, default: 0
    end
  end
end
