class RenameColumnInLogTypes < ActiveRecord::Migration
  def change

    rename_column :log_types, :type, :type_number

  end
end
