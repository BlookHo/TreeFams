namespace :names do
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
end
