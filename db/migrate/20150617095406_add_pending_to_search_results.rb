class AddPendingToSearchResults < ActiveRecord::Migration
  def change

    add_column :search_results, :pending_connect, :integer, default: 0

  end
end
