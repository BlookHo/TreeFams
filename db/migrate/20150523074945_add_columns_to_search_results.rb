class AddColumnsToSearchResults < ActiveRecord::Migration
  def change

    add_column :search_results, :searched_profile_ids, :integer, array: true
    add_column :search_results, :counts, :integer, array: true

  end
end
