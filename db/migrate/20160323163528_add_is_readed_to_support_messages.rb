class AddIsReadedToSupportMessages < ActiveRecord::Migration
  def change
    add_column :support_messages, :is_readed, :boolean, default: true
  end
end
