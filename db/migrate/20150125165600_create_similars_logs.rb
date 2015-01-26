class CreateSimilarsLogs < ActiveRecord::Migration
  def change
    create_table :similars_logs do |t|
      t.integer :connected_at
      t.integer :current_user_id
      t.string :table_name
      t.integer :table_row
      t.string :field
      t.integer :written
      t.integer :overwritten

      t.timestamps
    end
  end
end
