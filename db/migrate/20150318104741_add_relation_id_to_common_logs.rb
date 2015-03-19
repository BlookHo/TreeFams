class AddRelationIdToCommonLogs < ActiveRecord::Migration
  def change
    add_column :common_logs, :relation_id, :integer

  end
end
