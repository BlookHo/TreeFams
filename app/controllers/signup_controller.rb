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
      user = User.create_user_account_with_json_data(@data)
      # Send welcome email
      UserMailer.welcome_mail(user).deliver
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
      pu = PendingUser.create(data: @data.to_json)
      pu.send_new_pending_user_message_to_slack
      render json: { status: 'ok', redirect: '/pending' }
    else
      render json: { errors: user.errors.messages }
    end

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
