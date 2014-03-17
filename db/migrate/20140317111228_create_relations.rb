class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.string :relation

      t.timestamps
    end
  end
end
