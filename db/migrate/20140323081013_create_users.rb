class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :profile_id
      t.boolean :admin
      t.float :rating

      t.timestamps
    end
  end
end
