class ChangeBirthdayDatetimeToStringInProfileDatas < ActiveRecord::Migration
  def change
    change_column :profile_data, :birthday, :string
  end
end
