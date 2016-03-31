namespace :logs do

  desc "Populate SearchServiceLogs with user_ud"
  task :update_search => :environment do
    SearchServiceLogs.all.each do |log|
      print '.'
      log.update_column(:user_id, log.connected_users[0])
    end
  end
end
