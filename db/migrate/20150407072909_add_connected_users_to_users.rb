class AddConnectedUsersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :connected_users, :integer, array: true, default: []
  end
end
