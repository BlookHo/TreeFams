class CreateCommonLogs < ActiveRecord::Migration
  def change
    create_table :common_logs do |t|
      t.integer :user_id
      t.integer :log_type
      t.integer :log_id
      t.integer :profile_id

      t.timestamps
    end
  end
end
