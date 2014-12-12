class AddReadToUpdatesFeed < ActiveRecord::Migration
  def change
    add_column :updates_feeds, :read, :boolean
  end
end
