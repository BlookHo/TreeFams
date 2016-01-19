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
        # delete ConnectionRequest
        ConnectionRequest.where("user_id = ? OR with_user_id = ?", user_id, user_id).destroy_all
        # delete SearchResults
        SearchResults.where("user_id = ? OR found_user_id = ?", user_id, user_id).destroy_all
        # delete SimilarsFound
        SimilarsFound.where("user_id = ?", user_id).destroy_all
        # delete UpdateFeeds
   # UpdatesFeed.where("user_id = ? OR agent_user_id = ?", user_id, user_id).destroy_all
        # delete ConnectionLogs
        ConnectionLog.where("current_user_id = ? OR with_user_id = ?", user_id, user_id).destroy_all
        # delete SimilarsLog
        SimilarsLog.where("current_user_id = ?", user_id).destroy_all
        # delete CommonLog
        CommonLog.where("user_id = ?", user_id).destroy_all
        # delete Profiles
        Profile.where("tree_id = ?", user_id).destroy_all
        # all others
        User.find(user_id).destroy
      end
      flash[:notice] = "Удалено #{ids.size} пользователей"
    else
      flash[:alert] = "Пользователь не найден"
    end
    redirect_to :back
  end

end
