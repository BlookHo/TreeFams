class Admin::AdminController < ApplicationController

  layout 'layouts/admin'

  before_filter :logged?
  helper_method :current_admin

  private

  def logged?
    access_denied unless current_admin
  end

  def current_admin
    @current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id]
  end

  def access_denied
    redirect_to admin_login_path, :alert => "У вас нет доступа к запрашиваемой странице"
  end

end
