class AddConnRequestIdToSearchResults < ActiveRecord::Migration
  def change
    add_column :search_results, :connection_id, :integer

  end
end
