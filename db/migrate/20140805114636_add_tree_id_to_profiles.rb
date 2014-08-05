class AddTreeIdToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :tree_id, :integer
  end
end
