class AddOptionsToProfileDatas < ActiveRecord::Migration
  def change
    add_column :profile_data, :birth_date, :date
    add_column :profile_data, :country, :string
    add_column :profile_data, :city, :string

    remove_column :profile_data, :country_id
    remove_column :profile_data, :city_id
  end
end
