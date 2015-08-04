class CreateCounters < ActiveRecord::Migration
  def change
    create_table :counters do |t|
      t.integer :invites          , default: 0
      t.integer :disconnects      , default: 0

      t.timestamps
    end
  end
end
