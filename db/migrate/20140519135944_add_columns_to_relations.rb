class AddColumnsToRelations < ActiveRecord::Migration
  def change

    add_column :relations, :relation_id, :integer
    add_column :relations, :relation_rod_padej, :string,   :default => ""
    add_column :relations, :origin_profile_sex, :boolean
    add_column :relations, :reverse_relation_id, :integer
    add_column :relations, :reverse_relation, :string,   :default => ""

  end
end
