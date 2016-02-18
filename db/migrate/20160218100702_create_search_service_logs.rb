class CreateSearchServiceLogs < ActiveRecord::Migration
  def change
    create_table :search_service_logs do |t|
      t.string  :name
      t.integer :search_event
      t.float   :time,                         default: 0.00
      t.integer :connected_users, array: true, default: []
      t.integer :searched_profiles
      t.float   :ave_profile_search_time,      default: 0.00
    end
  end
end
