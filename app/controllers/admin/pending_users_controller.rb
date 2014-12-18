class Admin::PendingUsersController < Admin::AdminController

  def index
    @pending_users = PendingUser.all
  end


  def edit
    @pending_user = PendingUser.find(params[:id])
    @data = JSON.parse(@pending_user.data)
  end


end
