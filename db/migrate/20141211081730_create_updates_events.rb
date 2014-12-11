class CreateUpdatesEvents < ActiveRecord::Migration
  def change
    create_table :updates_events do |t|
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
