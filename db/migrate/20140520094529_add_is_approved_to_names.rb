class AddIsApprovedToNames < ActiveRecord::Migration
  def change
    add_column :names, :is_approved, :boolean, default: false
  end
end
