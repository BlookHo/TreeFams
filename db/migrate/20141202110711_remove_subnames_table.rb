class RemoveSubnamesTable < ActiveRecord::Migration
  def change
    drop_table :subnames
  end
end
