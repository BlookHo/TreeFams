class AddUserIdInSearchServiceLogs < ActiveRecord::Migration
  def change

    add_column :search_service_logs, :user_id,      :integer

  end
end
