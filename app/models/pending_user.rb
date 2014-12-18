class PendingUser < ActiveRecord::Base
  enum status: [ :pending, :blocked ]



  def family
    result = []
    family_data = JSON.parse(self.data)

    family_data.each do |key, value|
      value.kind_of?(Array) ? value.each { |v| result << v } : result << value
    end
    return result
  end


end
