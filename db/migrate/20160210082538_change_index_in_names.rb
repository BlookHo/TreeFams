class ChangeIndexInNames < ActiveRecord::Migration
  def change

    remove_index :names, column: :name

  end
end
