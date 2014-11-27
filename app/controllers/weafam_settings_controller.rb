class WeafamSettingsController < ApplicationController
  before_action :set_weafam_setting, only: [:show, :edit, :update, :destroy]

  # GET /weafam_settings
  # GET /weafam_settings.json
  def index
    @weafam_settings = WeafamSetting.all
  end

  # GET /weafam_settings/1
  # GET /weafam_settings/1.json
  def show
  end

  # GET /weafam_settings/new
  def new
    @weafam_setting = WeafamSetting.new
  end

  # GET /weafam_settings/1/edit
  def edit
  end

  # POST /weafam_settings
  # POST /weafam_settings.json
  def create
    @weafam_setting = WeafamSetting.new(weafam_setting_params)

    respond_to do |format|
      if @weafam_setting.save
        format.html { redirect_to @weafam_setting, notice: 'Weafam setting was successfully created.' }
        format.json { render :show, status: :created, location: @weafam_setting }
      else
        format.html { render :new }
        format.json { render json: @weafam_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /weafam_settings/1
  # PATCH/PUT /weafam_settings/1.json
  def update
    respond_to do |format|
      if @weafam_setting.update(weafam_setting_params)
        format.html { redirect_to @weafam_setting, notice: 'Weafam setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @weafam_setting }
      else
        format.html { render :edit }
        format.json { render json: @weafam_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /weafam_settings/1
  # DELETE /weafam_settings/1.json
  def destroy
    @weafam_setting.destroy
    respond_to do |format|
      format.html { redirect_to weafam_settings_url, notice: 'Weafam setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_weafam_setting
      @weafam_setting = WeafamSetting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def weafam_setting_params
      params.require(:weafam_setting).permit(:certain_koeff)
    end
end
