namespace :names do

  desc "Approve names with status 0"
  task :approve => :environment do
    Name.pending.each do |name|
      name.update_attribute(:status_id, 1)
    end
  end

  desc "Find and fix names duplicate"
  task :duplicates => :environment do

    Name.duplicates.each do |duplucate_name|
      names = Name.where(name: duplucate_name.name, sex_id: duplucate_name.sex_id).order('id ASC').to_a
      original_name = names.shift

      names.each do |name_to_fix|
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
