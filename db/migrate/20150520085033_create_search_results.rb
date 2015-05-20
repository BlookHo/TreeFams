class CreateSearchResults < ActiveRecord::Migration
  def change
    create_table :search_results do |t|
      t.integer :user_id
      t.integer :found_user_id
      t.integer :profile_id
      t.integer :found_profile_id
      t.integer :count

      t.timestamps
    end
  end
end
