class AddFoundProfileIdsSearchResult < ActiveRecord::Migration
  def change

    add_column :search_results, :found_profile_ids, :integer, array: true

  end
end
