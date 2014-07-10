class AddFieldsToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :middle_name,          :string
    add_column :profiles, :relation_description, :string
  end
end
