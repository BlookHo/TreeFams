class CreateLogTypes < ActiveRecord::Migration
  def change
    create_table :log_types do |t|
      t.integer :type
      t.string :table_name

      t.timestamps
    end
  end
end
