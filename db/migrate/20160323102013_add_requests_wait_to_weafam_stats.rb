class AddRequestsWaitToWeafamStats < ActiveRecord::Migration
  def change
    add_column :weafam_stats, :requests_wait, :integer   , default: 0
  end
end
