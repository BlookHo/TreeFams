class AddDeletedToTreeAndProfileKey < ActiveRecord::Migration
  def change
    add_column :trees, :deleted, :integer, default: 0
    add_column :profile_keys, :deleted, :integer, default: 0
  end
end
