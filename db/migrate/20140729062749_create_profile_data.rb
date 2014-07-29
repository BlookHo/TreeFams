class CreateProfileData < ActiveRecord::Migration
  def change
    create_table :profile_data do |t|
      t.integer :profile_id
      t.integer :creator_id

      t.string  :middle_name
      t.string  :last_name
      t.string  :country_id
      t.string  :city_id
      t.text    :biography

      t.timestamps
    end
  end
end
