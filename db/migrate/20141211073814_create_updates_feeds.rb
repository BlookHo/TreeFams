class CreateUpdatesFeeds < ActiveRecord::Migration
  def change
    create_table :updates_feeds do |t|
      t.integer :user_id, :null => false
      t.integer :update_id, :null => false
      t.integer :agent_user_id

      t.timestamps
    end
  end
end
