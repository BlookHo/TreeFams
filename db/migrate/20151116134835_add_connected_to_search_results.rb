class AddConnectedToSearchResults < ActiveRecord::Migration
  def change

    add_column :search_results, :searched_connected, :integer, array: true
    add_column :search_results, :founded_connected, :integer, array: true

  end
end
