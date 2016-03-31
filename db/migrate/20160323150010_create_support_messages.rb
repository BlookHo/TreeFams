class CreateSupportMessages < ActiveRecord::Migration
  def change
    create_table :support_messages do |t|
      t.integer :user_id
      t.integer :support_id
      t.text    :body
      t.timestamps
    end
  end
end
