class CreateConnectedUsers < ActiveRecord::Migration
  def change
    create_table :connected_users do |t|
      t.integer :user_id
      t.integer :with_user_id
      t.boolean :connected, :default => false

      t.timestamps
    end
  end
end
