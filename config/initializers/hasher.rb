class Hash
  def &(other)
    reject { |k, v| !(other.include?(k) && other[k] == v) }
  end

end


# "EXCLUDE DUPLICATES"
# Extract duplicates hashes from input hash
def duplicates_out(start_hash)
  # Initaialize empty hash
  duplicates = {}
  uniqs = start_hash

  # Collect duplicates
  start_hash.each_with_index do |(k, v), index|
    start_hash.each do |key, value|
      next if k == key
      intersection = start_hash[key] & start_hash[k]
      if duplicates.has_key?(key)
        duplicates[key][intersection.keys.first] = intersection[intersection.keys.first] if !intersection.empty?
      else
        duplicates[key] = intersection if !intersection.empty?
      end
    end
  end

  # Collect uniqs
  duplicates.each do |key, value|
    value.each do |k, v|
      uniqs[key].delete_if { |kk,vv|  kk == k && vv = v }
    end
  end

  return uniqs, duplicates
end



# "EXCLUDE DUPLICATES"
# Extract duplicates hashes from input hash
def collect_trees_profiles(start_hash)

  results = {}
  start_hash.each do |key, value|
    value.each do |k, v|
      if results.has_key? k
        results[k].push v
      else
        results[k] = [v]
      end
    end
  end
  return results

end

