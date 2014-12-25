# Это должно быть в rails_root/lib
class Hash

  def &(other)
    reject { |k, v| !(other.include?(k) && other[k] == v) }
  end


  def compact
    delete_if { |k, v| v.nil? }
  end


end




class Hasher
  # пересечение 2-х хэшей, у которых - значения = массивы
  # вида: { key => [int, int, ..], }
  def self.intersection(first, other)
    result = {}
    first.reject { |k, v| !(other.include?(k)) }.each do |k, v|
      result.merge!({k => (other[k] & v)})
    end
    result
  end
end
