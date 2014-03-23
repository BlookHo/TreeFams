class SetDefaultsinNamesUsers < ActiveRecord::Migration
  def change

    change_column :names, :name_freq, :integer, :default => 0

    change_column :users, :admin, :boolean, :default => false
    change_column :users, :rating, :float, :default => 0.0


  end
end
