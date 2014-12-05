class AddDisplayNameIdToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :display_name_id, :integer
  end
end
