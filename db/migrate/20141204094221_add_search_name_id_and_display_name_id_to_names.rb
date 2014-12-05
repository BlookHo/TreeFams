class AddSearchNameIdAndDisplayNameIdToNames < ActiveRecord::Migration
  def change
    add_column :names, :search_name_id,  :integer

    Name.all.each do |name|
      if name.parent_name_id.nil?
        name.update_column(:search_name_id,  name.id)
      else
        name.update_column(:search_name_id,  name.parent_name_id)
      end
    end

  end
end
