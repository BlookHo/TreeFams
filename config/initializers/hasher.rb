# Это должно быть в rails_root/lib
class Hash
  def &(other)
    reject { |k, v| !(other.include?(k) && other[k] == v) }
  end


  def compact
    delete_if { |k, v| v.nil? }
  end


end
