class SignupController < ApplicationController

  layout 'application.new'
  before_filter :already_logged_in?


  # Данный после чистки:
  # В данных нет новых имен:
  # data = {"author"=>{"name"=>"Алексей", "sex_id"=>1, "id"=>28, "search_name_id"=>28, "email"=>"me@me.ru"},
  #         "father"=>{"name"=>"Сергей", "sex_id"=>1, "id"=>422, "search_name_id"=>422},
  #         "mother"=>{"name"=>"Алла", "sex_id"=>0, "id"=>31, "search_name_id"=>31},
  #         "brothers"=>[{"name"=>"Никита", "sex_id"=>1, "id"=>340, "search_name_id"=>340, "parent_name"=>nil}]
  #         }


  def index
    # Render js application
  end


  def create
    @data = sanitize_data(params['family'].compact)
    has_new_names? ? create_pending_user : create_regular_user
  end


  def pending
    # Show pending message
  end


  private


  def create_regular_user
    user = User.new( email: @data["author"]["email"] )
    user.valid? # нужно дернуть метод, чтобы получить ошибки
    if user.errors.messages[:email].nil?
      user = create_user
      session[:user_id] = user.id
      render json: { status: 'ok', redirect: '/home' }
    else
      render json: { errors: user.errors.messages }
    end
  end



  def create_pending_user
    user = User.new( email: @data["author"]["email"] )
    user.valid? # нужно дернуть метод, чтобы получить ошибки
    if user.errors.messages[:email].nil?
      PendingUser.create(data: @data.to_json)
      render json: { status: 'ok', redirect: '/pending' }
    else
      render json: { errors: user.errors.messages }
    end

  end



  def create_user
    user = User.create_with_email( @data["author"]["email"] )
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
    ProfileKey.add_new_profile(user.profile.sex_id,
      user.profile,
      create_profile(data.merge(tree_id: user.id)),
      # Relation.name_to_id(relation_name),
      exclusions_hash: nil,
      tree_ids: user.get_connected_users
    )
  end



  def sanitize_data(data)
    proc = Proc.new { |k, v| v.kind_of?(Hash) ? (v.delete_if(&proc); nil) : v.blank? };
    data.delete_if(&proc)
  end



  def has_new_names?
    result = []
    @data.each do |key, value|
      if value.kind_of? Array
        value.each { |v| result << v.has_key?("new") }
      else
        result << value.has_key?("new")
      end
    end
    return result.include? true
  end


  def already_logged_in?
    redirect_to :home if current_user
  end




end
