namespace :db_pool do
  desc "Log AR pool size and clear unused connections"
  task :clear => :environment do
    current_size = ActiveRecord::Base.connection_pool.connections.size
    puts "== AR POOL SIZE LOG: current connections size: #{current_size}"
  end
end
