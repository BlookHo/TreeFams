class CreateProfileKeys < ActiveRecord::Migration
  def change
    create_table :profile_keys do |t|
      t.integer :user_id
      t.integer :profile_id
      t.integer :name_id
      t.integer :relation_id
      t.integer :is_profile_id
      t.integer :is_name_id

      t.timestamps
    end
  end
end
