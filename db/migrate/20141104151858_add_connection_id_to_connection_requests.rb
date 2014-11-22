class AddConnectionIdToConnectionRequests < ActiveRecord::Migration
  def change
    add_column :connection_requests, :connection_id, :integer
  end
end
