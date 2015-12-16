class AddCertainConnectToWeafamSettings < ActiveRecord::Migration
  def change

    add_column :weafam_settings, :certain_connect, :integer, default: 4

  end
end
