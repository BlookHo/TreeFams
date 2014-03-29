class AddColumnsToUser < ActiveRecord::Migration
  def change

    add_column :users, :email, :string,      :default => ""
    add_column :users, :password, :string,   :default => ""

  end
end
