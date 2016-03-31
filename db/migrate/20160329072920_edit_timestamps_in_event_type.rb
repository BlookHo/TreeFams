class EditTimestampsInEventType < ActiveRecord::Migration
  def change
    remove_column :event_types, :created_at
    remove_column :event_types, :updated_at

    add_timestamps :event_types


  end
end
