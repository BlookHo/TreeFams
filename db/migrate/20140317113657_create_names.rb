class CreateNames < ActiveRecord::Migration
  def change
    create_table :names do |t|
      t.string  :name
      t.boolean :only_male
      t.timestamps
    end
  end
end
