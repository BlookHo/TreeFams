class ChangeFieldTypeInRelations < ActiveRecord::Migration
  def change

    add_column :relations, :origin_profile_sex_id, :integer


  end
end
