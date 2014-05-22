class RemoveColumnInRelations < ActiveRecord::Migration
  def change

    remove_column :relations, :origin_profile_sex

  end
end
