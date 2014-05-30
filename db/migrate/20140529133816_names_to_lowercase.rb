class NamesToLowercase < ActiveRecord::Migration
  def change
  end

  Name.all.each do |name|
    name.name = name.name.mb_chars.downcase
    name.save
  end
end
