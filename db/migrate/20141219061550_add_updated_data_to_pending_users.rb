class AddUpdatedDataToPendingUsers < ActiveRecord::Migration
  def change
    add_column :pending_users, :updated_data, :text
  end
end
