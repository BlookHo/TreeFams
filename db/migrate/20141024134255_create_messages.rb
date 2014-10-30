class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :text
      t.integer :sender_id, :null => false
      t.integer :receiver_id, :null => false
      t.boolean :read, default: false
      t.boolean :sender_deleted, default: false
      t.boolean :receiver_deleted, default: false

      t.timestamps
    end
  end
end
