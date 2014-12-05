class Admin::SessionsController < Admin::AdminController

  skip_before_filter :logged?

  def new
  end

  def create
    admin = Admin.find_by_email(params[:email])
    if admin && admin.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to admin_root_url
    else
      flash.now.alert = "Нет доступа!"
      render "new"
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to root_url
  end


end
