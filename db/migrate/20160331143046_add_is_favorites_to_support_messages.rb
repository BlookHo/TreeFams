class AddIsFavoritesToSupportMessages < ActiveRecord::Migration
  def change
    add_column :support_messages, :is_favorites, :boolean, default: false
  end
end
