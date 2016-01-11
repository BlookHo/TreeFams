namespace :names do
  desc "Find and fix names duplicate"
  task :duplicate => :environment do
    puts "Find and fix names duplicate"
    result = Name.select("COUNT(name) as total, name").
             group(:name).
             having("COUNT(name) > 1").
             order(:name).
             map{|p| {p.name => {total: p.total, id: p.inspect}} }
    puts result
  end


  desc "Create downcase names seeds with sex_id and is_approved"
  task :seeds => :environment do
    file = File.open("#{Rails.root}/db/seeds/names/names_seeds.rb", "w+")
    file.write(
      "# encoding: utf-8
      Name.delete_all
      Name.reset_pk_sequence
      Name.create(["
    )

    # Name.all.order("name ASC").each do |name|
    # Keep names order!!!
    Name.all.each do |name|
      file.write(
        "{name: '#{name.name}', sex_id:#{name.sex_id}, name_freq: 0, is_approved: #{name.is_approved}, only_male: #{name.only_male}},\n"
      )
    end

    file.write("])")
    file.close
  end


  desc "Capitalize names"
  task :capitalize => :environment do
    Name.all.each do |name|
      name.update_attribute(:name, name.name.mb_chars.capitalize)
    end
  end
end
