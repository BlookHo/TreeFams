class Pool
  class << self
    def log
      current_size = ActiveRecord::Base.connection_pool.connections.size
      puts "== AR POOL SIZE LOG: current connections size: #{current_size}"
    end
  end
end
