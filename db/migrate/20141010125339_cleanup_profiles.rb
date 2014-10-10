class CleanupProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :surname
    remove_column :profiles, :email
    remove_column :profiles, :avatar_id
    remove_column :profiles, :country_id
    remove_column :profiles, :city_id
    remove_column :profiles, :profile_birthday
    remove_column :profiles, :about
    remove_column :profiles, :profile_deathday
    remove_column :profiles, :country
    remove_column :profiles, :city
    remove_column :profiles, :middle_name
    remove_column :profiles, :relation_description
  end
end
