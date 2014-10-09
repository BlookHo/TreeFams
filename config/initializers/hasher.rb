class Hash
  def &(other)
    reject { |k, v| !(other.include?(k) && other[k] == v) }
  end
end
