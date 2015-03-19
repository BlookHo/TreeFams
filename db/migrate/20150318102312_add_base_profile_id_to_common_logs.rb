class AddBaseProfileIdToCommonLogs < ActiveRecord::Migration
  def change
    add_column :common_logs, :base_profile_id, :integer
  end
end
