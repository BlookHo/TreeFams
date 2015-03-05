class AddIndexToProfilekeys < ActiveRecord::Migration
  def change

    add_index :profile_keys, :user_id
    add_index :profile_keys, :profile_id

    add_index :trees, :user_id
    add_index :trees, :profile_id

    add_index :users, :profile_id

    add_index :similars_founds, :user_id

    add_index :profiles, :user_id

    add_index :names, :name
    add_index :names, :only_male

    add_index :similars_logs, :current_user_id

  end
end
