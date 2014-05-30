class AddSexIdToNames < ActiveRecord::Migration
  def change
    add_column :names, :sex_id, :integer


    Name.all.each do |n|
      n.only_male ? n.sex_id = 1 : n.sex_id = 0
      n.is_approved = true
      n.save
    end
  end
end
