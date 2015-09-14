class Admin::WeafamStatsController < Admin::AdminController


  before_action :set_weafam_stat, only: [:show, :destroy]

  # GET /weafam_stats
  def index
    @weafam_stats = WeafamStat.order('id').page params[:page] # DESC
    # respond_to do |format|
    #   format.html
    #   format.csv { render text: @weafam_stats.to_csv }
    #   format.xls { send_data @weafam_stats.to_csv(col_sep: "\t") }
    # end
  end

  # GET we_all_family_stats_admin_weafam_stats_path(format: "xls")
  def we_all_family_stats
    @weafam_stats = WeafamStat.order('id')
    respond_to do |format|
      format.html
      format.xls
    end
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

  def weafam_stat_params
    params.require(:weafam_stat).permit(:users, :users_male, :users_female,
                                        :profiles, :profiles_male, :profiles_female,
                                        :trees, :invitations,
                                        :requests, :connections, :refuse_requests,
                                        :disconnections, :similars_found)
  end

end
