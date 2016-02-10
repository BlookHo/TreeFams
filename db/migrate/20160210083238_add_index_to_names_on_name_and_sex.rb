class AddIndexToNamesOnNameAndSex < ActiveRecord::Migration
  def change

    remove_index :names, column: :only_male

    add_index :names, [:name, :sex_id], unique: true


  end
end
