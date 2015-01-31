class CreateSimilarsFounds < ActiveRecord::Migration
  def change
    create_table :similars_founds do |t|
      t.integer :user_id, :null => false
      t.integer :first_profile_id, :null => false
      t.integer :second_profile_id, :null => false

      t.timestamps
    end
  end
end
