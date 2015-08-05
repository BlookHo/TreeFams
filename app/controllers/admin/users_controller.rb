class Admin::UsersController < Admin::AdminController


  def index
    @users = User.order('id DESC').page params[:page]
  end



  def login_as
    user = User.where(id: params[:user_id]).first
    if user
      flash[:notice] = "Вы вошли как #{user.name}"
      session[:user_id] = user.id
    else
      flash[:alert] = "Пользователь не найден"
    end
    redirect_to :home
  end


  def destroy
    user = User.where(id: params[:id]).first
    if (user)
      ids = user.connected_users
      ids.each do |user_id|
        User.find(user_id).destroy
      end
      flash[:notice] = "Удалено #{ids.size} пользователей"
    else
      flash[:alert] = "Пользователь не найден"
    end
    redirect_to :back
  end

end
