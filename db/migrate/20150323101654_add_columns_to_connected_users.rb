class AddColumnsToConnectedUsers < ActiveRecord::Migration
  def change
    add_column :connected_users, :connection_id, :integer
    add_column :connected_users, :rewrite_profile_id, :integer
    add_column :connected_users, :overwrite_profile_id, :integer
  end
end
