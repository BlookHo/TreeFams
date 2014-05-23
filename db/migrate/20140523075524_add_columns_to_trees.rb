class AddColumnsToTrees < ActiveRecord::Migration
  def change

    add_column :trees, :name_id, :integer
    add_column :trees, :is_profile_id, :integer
    add_column :trees, :is_name_id, :integer


  end
end
