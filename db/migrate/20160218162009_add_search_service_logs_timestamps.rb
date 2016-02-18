class AddSearchServiceLogsTimestamps < ActiveRecord::Migration
  def change

    add_timestamps :search_service_logs

  end
end
