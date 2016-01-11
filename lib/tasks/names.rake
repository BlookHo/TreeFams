namespace :names do
  desc "Find and fix names duplicate"
  task :duplicate => :environment do

    puts "Find and complex fix names duplicate"
    duplicate_names = Name.select("COUNT(name) as total, name").
               group(:name).
               having("COUNT(name) > 1").
               order(:name).
               map{|p| p.name }  # map{|p| {p.name => p.total} }

    duplicate_names.each do |duplicate_name|
      names = Name.where(name: duplicate_name).order('id ASC').to_a
      original_name = names.shift

      puts "Base name #{original_name.name}"
      puts "Base name id: #{original_name.id}"


      names.each do |name_to_fix|

        puts "Fix name #{original_name.name}"
        puts "Fix name id #{original_name.name}"

        Profile.where(name_id: name_to_fix.id).each {|p| p.update_column(:name_id, original_name.id)}

        ProfileKey.where(name_id: name_to_fix.id).each {|p| p.update_column(:name_id, original_name.id)}
        ProfileKey.where(is_name_id: name_to_fix.id).each {|p| p.update_column(:is_name_id, original_name.id)}

        Tree.where(name_id: name_to_fix.id).each {|p| p.update_column(:name_id, original_name.id)}
        Tree.where(is_name_id: name_to_fix.id).each {|p| p.update_column(:is_name_id, original_name.id)}

        Name.find(name_to_fix.id).destroy
      end

    end
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
