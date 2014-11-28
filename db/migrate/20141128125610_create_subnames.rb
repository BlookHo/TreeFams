class CreateSubnames < ActiveRecord::Migration
  def change
    create_table :subnames do |t|
      t.integer :name_id
      t.string :title

      t.timestamps
    end
  end
end
