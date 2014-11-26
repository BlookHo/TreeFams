

# {
#   "author"=>{"name"=>"Александр", "sex_id"=>1, "id"=>27},
#   "father"=>{"name"=>"Давид", "sex_id"=>1, "id"=>147},
#   "mother"=>{"name"=>"Лариса", "sex_id"=>0, "id"=>262},
#   "sisters"=>[{"name"=>"Виктория", "sex_id"=>0, "id"=>107}],
#   "brothers"=>[{"name"=>"Виктор", "sex_id"=>1, "id"=>107}],
#   "email"=>"david@mail.ru"
# }

namespace :faker do

  desc "Generate 5000 fake users"
  task :go => :environment do

    @male_names = Name.where(sex_id: 1)
    @female_names = Name.where(sex_id: 0)

    puts 'Welcome to Faker.'
    puts 'How many users you want to generate (1-1000):'
    @qt = STDIN.gets.chomp

    @qt.to_i.times do |time|
      create_user(generate_family)
      puts "User #{time} created."
    end

    puts "Complete."
  end



  def generate_family
    {
      author: generate_author,
      father: generate_male,
      mother: generate_female,
      sisters: generate_sisters,
      brothers: generate_brothers,
      sons: [generate_male],
      daughters: [generate_female],
      email: generate_email
    }
  end


  def generate_author
    if yes_or_no
      generate_male
    else
      generate_female
    end
  end


  def generate_brothers
    if yes_or_no
      [generate_male]
    else
      [generate_male, generate_male]
    end
  end


  def generate_sisters
    if yes_or_no
      [generate_female]
    else
      [generate_female, generate_female]
    end
  end


  def generate_male
    name = random_male_name
    return {name: name.name, sex_id: name.sex_id, id: name.id}
  end

  def generate_female
    name = random_female_name
    return {name: name.name, sex_id: name.sex_id, id: name.id}
  end


  def generate_email
    generate_token+'@bot-user.net'
  end

  def random_male_name
    rand_id = rand(@male_names.size)
    return @male_names[rand_id]
  end


  def random_female_name
    rand_id = rand(@female_names.size)
    return @female_names[rand_id]
  end


  def yes_or_no(koeff = 50)
    yes = Array.new(koeff, true)
    no = Array.new(100 - koeff, false)
    return (yes << no).flatten.shuffle.sample
  end


  def generate_token
    access_token = SecureRandom.hex
  end


  private



  def create_user(data)
    user = User.create_with_email( data[:email] )
    user.profile = create_profile( data[:author].merge(tree_id: user.id) )
    data.except(:author, :email).each do |key, value|
      if value.class == Array
        value.each do |v|
          create_keys(key, v, user)
        end
      else
        create_keys( key, value, user )
      end
    end
    user
  end


  def create_profile(data)
    Profile.create({
      name_id:  data[:id],
      sex_id:   data[:sex_id],
      tree_id:  data[:tree_id]
      })
  end


  def create_keys(relation_name, data, user)
    ProfileKey.add_new_profile(
    user.profile,
    create_profile(data.merge(tree_id: user.id)),
    Relation.name_to_id(relation_name.to_s),
    exclusions_hash: nil,
    tree_ids: user.get_connected_users
    )
  end



end
