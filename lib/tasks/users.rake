namespace :users do

  desc "Generate users access_token"
  task :token => :environment do
    User.all.each do |u|
      u.generate_access_token
      u.save
    end
  end
end
