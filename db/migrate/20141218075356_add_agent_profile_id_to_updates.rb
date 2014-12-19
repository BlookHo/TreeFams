class AddAgentProfileIdToUpdates < ActiveRecord::Migration
  def change
    add_column :updates_feeds, :agent_profile_id, :integer
  end
end
