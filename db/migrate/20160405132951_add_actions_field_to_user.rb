class AddActionsFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :actions, :integer
  end
end
