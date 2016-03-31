class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :event_type
      t.boolean :read
      t.integer :user_id
      t.string  :email
      t.integer :profile_id
      t.string  :user_profile_data
      t.integer :agent_user_id
      t.integer :agent_profile_id
      t.string  :agent_profile_data
      t.integer :profiles_qty
      t.integer :log_type
      t.integer :log_id

      t.timestamps null: false
    end
  end
end
