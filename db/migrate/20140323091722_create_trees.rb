class CreateTrees < ActiveRecord::Migration
  def change
    create_table :trees do |t|
      t.integer :user_id
      t.integer :profile_id
      t.integer :relation_id
      t.boolean :connected, :default => false

      t.timestamps
    end
  end
end
