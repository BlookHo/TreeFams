class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_id?

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
    end
  end

  # получаем из таблю настроек проекта значение коэфф-та достоверности
  # для управления рез-тами поиска и объединения
  # Чем больше значение, тем меньше рез-тов поиска
  # и тем больше НЕУЗНАННЫХ профилей при объединении.
  def get_certain_koeff
    @get_certain_koeff ||= WeafamSetting.first.certain_koeff
  end

  # Включение метода постраничного отображения в зависимости от класса
  # data - Array или AR
  # gem Kaminari
  # @param data [ActiveRecord Collection] записи из таблицы
  def pages_of(data, records_per_pages)
    unless data.kind_of?(Array)
      data.page(params[:page]).per(records_per_pages)
    else
      Kaminari.paginate_array(data).page(params[:page]).per(records_per_pages)
    end
  end

end
