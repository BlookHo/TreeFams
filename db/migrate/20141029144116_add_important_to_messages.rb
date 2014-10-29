class AddImportantToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :important, :boolean , default: false
  end
end
