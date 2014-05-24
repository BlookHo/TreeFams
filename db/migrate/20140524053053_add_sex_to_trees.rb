class AddSexToTrees < ActiveRecord::Migration
  def change

    add_column :trees, :is_sex_id, :integer

  end
end
