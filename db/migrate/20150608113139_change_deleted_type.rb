class ChangeDeletedType < ActiveRecord::Migration
  def change
    remove_column :profiles, :deleted
    add_column :profiles, :deleted, :boolean, default: false
  end
end
