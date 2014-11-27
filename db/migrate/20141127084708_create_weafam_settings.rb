class CreateWeafamSettings < ActiveRecord::Migration
  def change
    create_table :weafam_settings do |t|
      t.integer :certain_koeff, :null => false

      t.timestamps
    end
  end
end
