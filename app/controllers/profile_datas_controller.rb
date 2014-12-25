class ProfileDatasController < ApplicationController

  before_filter :logged_in?


  def create
    @profile_data = ProfileData.new(profile_data_params)
    @profile_data.creator_id = current_user.id
    if @profile_data.save
      redirect_to :back, notice: "Информация о родственнике сохранена"
    else
      redirect_to :back, alert: "Ошибка при сохранении информации о родственнике"
    end
  end


  def update
    @profile_data = ProfileData.find(params[:id])
    if @profile_data.creator_id != current_user.id
      return redirect_to :back, notice: "Вы не можете менять чужую информацию о родстеннике"
    end
    if @profile_data.update_attributes(profile_data_params)
      redirect_to :back, notice: "Информация сохранена"
    else
      redirect_to :back, alert: "Ошибка при сохранении информации о родственнике"
    end
  end


  private

  def profile_data_params
    params[:profile_data].permit(
      :last_name,
      :middle_name,
      :profile_id,
      :birth_date,
      :country,
      :city,
      :avatar
    )
  end

end
