class AddIndexToSearchResults < ActiveRecord::Migration
  def change

    add_index :connection_logs, :current_user_id
    add_index :connection_logs, :with_user_id

    add_index :connection_requests, :user_id
    add_index :connection_requests, :with_user_id

    add_index :connected_users, :user_id
    add_index :connected_users, :with_user_id

    add_index :common_logs, :user_id
    add_index :common_logs, :profile_id

    add_index :deletion_logs, :current_user_id
    add_index :deletion_logs, :log_number

    add_index :log_types, :type_number

    add_index :profile_data, :profile_id

    add_index :profiles, :name_id

    add_index :relations, :relation_id

    add_index :search_results, :user_id
    add_index :search_results, :profile_id

    add_index :similars_founds, :first_profile_id



  end
end
