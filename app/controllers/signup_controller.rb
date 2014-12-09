class SignupController < ApplicationController

  layout 'application.new'

  before_filter :already_logged_in?

  # data
  # {"family" =>{"author"=>{"name"=>"Алексей", "sex_id"=>1, "id"=>28, "search_name_id" => nil},"father"=>{"name"=>"Сергей", "sex_id"=>1, "id"=>422}, "mother"=>{"name"=>"Алла", "sex_id"=>0, "id"=>31}, "brothers"=>nil, "sisters"=>nil, "sons"=>nil, "daughters"=>nil, "email"=>"maria@maria.com", "signup"=>{"author"=>{"name"=>"Алексей", "sex_id"=>1, "id"=>28}, "father"=>{"name"=>"Сергей", "sex_id"=>1, "id"=>422}, "mother"=>{"name"=>"Алла", "sex_id"=>0, "id"=>31}, "wife"=>"", "brothers"=>nil, "sisters"=>nil, "sons"=>nil, "daughters"=>nil, "email"=>"maria@maria.com"}}}

  def index
    # just render js application
  end


  def create
    # @data = params['family'].compact
    @data = prepare_data(params['family'].compact)

    logger.info "======PREPARE DATA incoming data"
    logger.info @data

    user = User.new( email: @data["email"] )
    user.valid?
    if user.errors.messages[:email].nil?
      user = create_user
      session[:user_id] = user.id
      render json: { status: 'ok' }
    else
      render json: { errors: user.errors.messages }
    end
  end



  private

  def create_user
    user = User.create_with_email( @data["email"] )
    user.profile = create_profile( @data["author"].merge(tree_id: user.id) )
    @data.except('author', 'email').each do |key, value|
      if value.kind_of? Array # brothres, sisters
        value.each do |v|
          create_keys(key, v, user)
        end
      else
        create_keys( key, value, user )
      end
    end
    return user
  end


  def create_profile(data)
    Profile.create({
      name_id:          data['search_name_id'],
      display_name_id:  data['id'],
      sex_id:           data['sex_id'],
      tree_id:          data['tree_id']
    })
  end


  def create_keys(relation_name, data, user)
    logger.info "============ In create_keys ==================DDDDDDDD"
    logger.info "user.profile.sex_id = #{user.profile.sex_id}"

    logger.info "======= CREATE RELATION==========FOR="
    logger.info Relation.name_to_id(relation_name)
    logger.info "======= CREATE RELATION==========END="

    ProfileKey.add_new_profile(user.profile.sex_id,
      user.profile,
      create_profile(data.merge(tree_id: user.id)),
      Relation.name_to_id(relation_name),
      exclusions_hash: nil,
      tree_ids: user.get_connected_users
    )
  end


  def already_logged_in?
    redirect_to :home if current_user
  end


  def prepare_data(data)
    proc = Proc.new { |k, v| v.kind_of?(Hash) ? (v.delete_if(&proc); nil) : v.blank? };
    data.delete_if(&proc)
  end



end
