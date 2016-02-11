class AddStatusToNames < ActiveRecord::Migration
  def change
		add_column :names, :status_id, :integer, default: 0
		add_index  :names, :status_id
  end
end
