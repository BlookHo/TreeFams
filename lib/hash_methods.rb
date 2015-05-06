
class SHash

  def method_missing(name, *args, &block)
    puts "method '#{name}' is missing, *args = #{args}, *block = #{block}"
    key = name#.to_s
    return self[key] if self.has_key? key
    puts "after return '#{name}' "
    super
  end

  def call_me
    puts "11. method for #{self} 'call_me' is running "
  end

end
