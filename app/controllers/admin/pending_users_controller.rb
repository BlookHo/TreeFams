class Admin::PendingUsersController < Admin::AdminController

  def index
    @pending_users = PendingUser.pending
  end

  def blocked
    @pending_users = PendingUser.blocked
    render template: 'admin/pending_users/index'
  end

  def approved
    @pending_users = PendingUser.approved
    render template: 'admin/pending_users/index'
  end


  def edit
    @pending_user = PendingUser.find(params[:id])
    @data = @pending_user.json_data
  end


  def update
    if update_member
      flash[:notice] = "Сохранено"
    else
      flash[:alert] = "Ошибка при сохранении: #{@error}"
    end
    redirect_to :back
  end


  def block
    PendingUser.find(params[:pending_user_id]).block!
    redirect_to :admin_pending_users, notice: "Пользователь заблокирован"
  end


  def reset
    pending_user = PendingUser.find(params[:pending_user_id])
    pending_user.update_column(:updated_data, nil)
    pending_user.reload
    redirect_to :back, notice: "Изменения отменены"
  end


  def approve
    pending_user = PendingUser.find(params[:pending_user_id])
    current_data = pending_user.json_data
    if has_new_names?(current_data)
      redirect_to :back, alert: "Ошибка. Есть не утвержденные имена."
    else
      create_user(current_data)
    end
  end



  private


  def create_user(data)
    user = User.new( email: data["author"]["email"] )
    user.valid? # нужно дернуть метод, чтобы получить ошибки
    if user.errors.messages[:email].nil?
      User.create_user_account_with_json_data(data)
      redirect_to :admin_pending_users, notice: "Пользователь утвержден. Аккаунт создан."
    else
      redirect_to :back, alert: "Ошибка. Пользователь с таким email уже зарегистрирован."
    end
  end


  def update_member
    begin
      pending_user = PendingUser.find(params[:id])
      name = Name.find(params[:name_id])
      current_data = pending_user.json_data
      if params[:index].blank?
        current_data[params[:relation]] = name.as_json(only: [:id, :name, :sex_id, :search_name_id])
      else
        current_data[params[:relation]][params[:index].to_i] = name.as_json(only: [:id, :name, :sex_id, :search_name_id])
      end
      pending_user.update_column(:updated_data, current_data.to_json)
    rescue Exception => e
      @error = e
      return false
    end
  end


  def has_new_names?(data)
    result = []
    data.each do |key, value|
      if value.kind_of? Array
        value.each { |v| result << v.has_key?("new") }
      else
        result << value.has_key?("new")
      end
    end
    return result.include? true
  end




end
