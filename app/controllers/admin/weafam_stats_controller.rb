class Admin::WeafamStatsController < Admin::AdminController



  before_action :set_weafam_stat, only: [:show, :destroy]

  # GET /weafam_stats
  # GET /weafam_stats.json
  def index
    @weafam_stats = WeafamStat.page params[:page]  # order('id DESC').
  end


  # GET /weafam_stats/1
  # GET /weafam_stats/1.json
  def show
  end

  # DELETE /weafam_stats/1
  # DELETE /weafam_stats/1.json
  def destroy
    @weafam_stat.destroy
    respond_to do |format|
      format.html { redirect_to admin_weafam_stats_url, notice: 'WeafamStat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_weafam_stat
    @weafam_stat = WeafamStat.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # def weafam_stat_params
  #   params.require(:weafam_stat).permit(:profiles)
  # end


end
