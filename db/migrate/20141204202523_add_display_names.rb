class AddDisplayNames < ActiveRecord::Migration
  def change

    add_column :trees, :display_name_id, :integer
    add_column :trees, :is_display_name_id, :integer

    add_column :profile_keys, :display_name_id, :integer
    add_column :profile_keys, :is_display_name_id, :integer


  end
end
