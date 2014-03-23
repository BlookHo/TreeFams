class AddColumnsToProfile < ActiveRecord::Migration
  def change

    add_column :profiles, :name_id, :integer
    add_column :profiles, :surname, :string,   :default => ""
    add_column :profiles, :email, :string,   :default => ""
    add_column :profiles, :sex_id, :integer
    add_column :profiles, :avatar_id, :integer
    add_column :profiles, :country_id, :integer
    add_column :profiles, :city_id, :integer
    add_column :profiles, :profile_birthday, :datetime
    add_column :profiles, :about, :string,   :default => ""


  end
end
