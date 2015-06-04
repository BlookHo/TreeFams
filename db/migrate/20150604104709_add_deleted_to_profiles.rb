class AddDeletedToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :deleted, :integer, default: 0
  end
end
