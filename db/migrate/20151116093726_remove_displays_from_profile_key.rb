class RemoveDisplaysFromProfileKey < ActiveRecord::Migration
  def change
    remove_column :profile_keys, :display_name_id
    remove_column :profile_keys, :is_display_name_id


  end
end
