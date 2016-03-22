class RemoveUsersUnusedColumns < ActiveRecord::Migration
  def change
		remove_column :users, :admin
	 	remove_column :users, :rating
		remove_column :users, :sign_in_count
		remove_column :users, :last_sign_in_at
		remove_column :users, :current_sign_in_at
		remove_column :users, :last_sign_in_ip
	end
end
