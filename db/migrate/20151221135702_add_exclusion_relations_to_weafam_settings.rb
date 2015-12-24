class AddExclusionRelationsToWeafamSettings < ActiveRecord::Migration
  def change


    add_column :weafam_settings, :exclusion_relations, :integer, array: true


  end
end
