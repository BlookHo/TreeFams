class SignupController < ApplicationController

  layout 'application.new'

  # {family =>{"author"=>{"name"=>"Алексей", "sex_id"=>1, "id"=>28}, "father"=>{"name"=>"Сергей", "sex_id"=>1, "id"=>422}, "mother"=>{"name"=>"Алла", "sex_id"=>0, "id"=>31}, "brothers"=>nil, "sisters"=>nil, "sons"=>nil, "daughters"=>nil, "email"=>"maria@maria.com", "signup"=>{"author"=>{"name"=>"Алексей", "sex_id"=>1, "id"=>28}, "father"=>{"name"=>"Сергей", "sex_id"=>1, "id"=>422}, "mother"=>{"name"=>"Алла", "sex_id"=>0, "id"=>31}, "brothers"=>nil, "sisters"=>nil, "sons"=>nil, "daughters"=>nil, "email"=>"maria@maria.com"}}

  def index
    # render js application
  end

  def create
    @data = params['family'].compact
    user = create_user
  end

  private

  def create_user
    user = User.create_with_email( @data["email"] )
    user.profile = create_profile( @data["author"].merge(tree_id: user.id) )
    @data.except('author', 'email').each do |key, value|
      if value.class == Array
        value.each do |v|
          create_keys(key, v, user)
        end
      else
        create_keys(value)
      end
    end
  end


  def create_profile(data)
    logger.info "==========="
    logger.info data
    logger.info "==========="
    Profile.create({
      name_id:  data['id'],
      sex_id:   data['sex_id'],
      tree_id:  data['tree_id']
    })
  end


  def create_keys(relation_name, data, user)
    ProfileKey.add_new_profile(
      user.profile,
      Relation.name_to_id(relation_name),
      create_profile(data.merge(tree_id: user.id)),
      exclusions_hash: nil,
      tree_ids: user.get_connected_users)
  end

  # Relation.name_to_id('sisters')
  #
  # ProfileKey.add_new_profile(@base_profile,
  #     @profile, @profile.relation_id,
  #     exclusions_hash: @profile.answers_hash,
  #     tree_ids: current_user.get_connected_users)

end
