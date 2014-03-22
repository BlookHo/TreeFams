class AddNameFreqNames < ActiveRecord::Migration
  def change

    add_column :names, :name_freq, :integer

  end
end
