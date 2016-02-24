class AddColumnsToSearchServiceLogs < ActiveRecord::Migration
  def change

    add_column :search_service_logs, :all_tree_profiles, :integer, default: 0
    add_column :search_service_logs, :all_profiles, :integer, default: 0

  end
end
