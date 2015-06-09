class ChangeDeletedTypeToInteger < ActiveRecord::Migration
  def change
    remove_column :profiles, :deleted
    add_column :profiles, :deleted, :integer, default: 0
    end
end
