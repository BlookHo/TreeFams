class AddWhoMadeEventToUpdatesFeeds < ActiveRecord::Migration
  def change
    add_column :updates_feeds, :who_made_event, :integer
  end
end
