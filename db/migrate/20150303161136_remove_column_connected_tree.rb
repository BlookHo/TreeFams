class RemoveColumnConnectedTree < ActiveRecord::Migration
  def change

    remove_column :trees, :connected

  end
end
