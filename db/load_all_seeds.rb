Dir["#{Rails.root}/db/seeds/*/*.rb"].each do |seed|
  load seed
end
