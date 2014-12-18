class CreatePendingUsers < ActiveRecord::Migration
  def change
    create_table :pending_users do |t|
      t.integer :status, default: 0
      t.text :data
      t.timestamps
    end
  end
end
