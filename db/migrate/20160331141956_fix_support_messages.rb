class FixSupportMessages < ActiveRecord::Migration
  def change
    remove_column :support_messages, :is_readed
    add_column :support_messages, :new, :boolean, default: true
  end
end
