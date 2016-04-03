class AddFieldsToSupportMessages < ActiveRecord::Migration
  def change
    add_column :support_messages, :is_welcome, :boolean, default: false
    add_column :support_messages, :is_mass, :boolean, default: false
  end
end
