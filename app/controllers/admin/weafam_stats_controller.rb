class Admin::WeafamStatsController < Admin::AdminController


  def index
    @stats = WeafamStat.page params[:page]
  end
  # order('id DESC').


  # def login_as
  #   user = User.where(id: params[:user_id]).first
  #   if user
  #     flash[:notice] = "Вы вошли как #{user.name}"
  #     session[:user_id] = user.id
  #   else
  #     flash[:alert] = "Пользователь не найден"
  #   end
  #   redirect_to :home
  # end

end
