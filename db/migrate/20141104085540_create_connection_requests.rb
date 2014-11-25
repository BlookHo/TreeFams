class CreateConnectionRequests < ActiveRecord::Migration
  def change
    create_table :connection_requests do |t|
      t.integer :user_id
      t.integer :with_user_id
      t.integer :confirm
      t.boolean :done, default: false

      t.timestamps
    end
  end
end
