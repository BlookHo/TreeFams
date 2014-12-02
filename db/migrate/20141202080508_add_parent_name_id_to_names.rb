class AddParentNameIdToNames < ActiveRecord::Migration
  def change
    add_column :names, :parent_name_id, :integer, default: nil
  end
end
