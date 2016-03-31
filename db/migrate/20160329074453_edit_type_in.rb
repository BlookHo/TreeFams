class EditTypeIn < ActiveRecord::Migration
  def change

    remove_column :event_types, :type
    add_column :event_types, :type_number,      :integer


  end
end
