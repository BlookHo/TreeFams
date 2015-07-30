class CreateWeafamStats < ActiveRecord::Migration
  
  def change
    create_table :weafam_stats do |t|
      t.integer :users          , default: 0
      t.integer :users_male     , default: 0
      t.integer :users_female   , default: 0
      t.integer :profiles       , default: 0
      t.integer :profiles_male  , default: 0
      t.integer :profiles_female, default: 0
      t.integer :trees          , default: 0
      t.integer :invitations    , default: 0
      t.integer :requests       , default: 0
      t.integer :connections    , default: 0
      t.integer :refuse_requests, default: 0
      t.integer :disconnections , default: 0
      t.integer :similars_found , default: 0

      t.timestamps
    end
  end
end
