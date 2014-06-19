class AddFieldsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :profile_deathday, :datetime
    add_column :profiles, :country, :string
    add_column :profiles, :city, :string
  end
end
