class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string    :email
      t.string    :password_digest
      t.datetime  :logged_at
      t.timestamps
    end
    # Create default admin
    Admin.new(:email => 'admin@admin.com', :password => 'admin', :password_confirmation => 'admin').save
  end
end
