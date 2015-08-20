class AddDoubleToUser < ActiveRecord::Migration
  def change
    add_column :users, :double, :integer, default: 0
  end
end
