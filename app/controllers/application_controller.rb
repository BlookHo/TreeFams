class ApplicationController < ActionController::Base

  # Http server Authorization only in production
  if Rails.env =~ /production/
    http_basic_authenticate_with name: "interweb", password: "interweb"
  end


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  helper_method :current_user, :logged_id?


  before_filter do
    Member if Rails.env =~ /development/
  end



  def current_user
    begin
      @current_user ||= User.find(session[:user_id])
    rescue
      session[:user_id] = nil
    end
  end


  def logged_in?
    access_denied if !current_user
  end


  def access_denied
    respond_to do |format|
      format.html { redirect_to :root, :alert => 'Для просмотра этой страницы вам нужно войти на сайт!'}
      # format.js { render :template => '/shared/access_denied'}
    end
  end

end
