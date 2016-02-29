class Admin::SearchServiceLogsController < Admin::AdminController

  before_action :set_search_service_log, only: [:show, :destroy]

  # GET /search_service_logs
  # @note: show search_service_logs rows in DESCend order
  def index
    @search_service_logs = SearchServiceLogs.order('id DESC').page params[:page]
    respond_to do |format|
      format.html
      # format.csv { send_data @weafam_stats.to_csv }
      # format.csv { render text: @weafam_stats.to_csv }
      # format.xls { send_data @weafam_stats.to_csv(col_sep: "\t") }
    end
  end

  # GET search_service_logs_admin_search_service_path(format: "xls")
  # SAVE file 'weafam_search_logs.xls'
  def weafam_search_logs
    @search_service_logs = SearchServiceLogs.order('id DESC')
    # respond_to do |format|
    #   format.html
    #   format.csv { render text: @search_service_logs.to_csv }
    #   #   format.xls { send_data @weafam_stats.to_csv(col_sep: "\t") }
    #   # format.xlsx {render xlsx: 'download',filename: "payments.xlsx"}
    #   format.xls { send_data @search_service_logs.to_csv(col_sep: "\t") }
    #   # format.xls
    # end
    respond_to do |format|
      format.xls {render xls: 'weafam_search_logs',filename: "weafam_search_logs.xls"}
    end

  end

  # GET /search_service_logs/1
  # GET /search_service_logs/1.json
  def show
  end

  # DELETE /search_service_logs/1
  # DELETE /search_service_logs/1.json
  def destroy
    @search_service_log.destroy
    respond_to do |format|
      format.html { redirect_to admin_search_service_logs_url, notice: 'SearchServiceLogs was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_search_service_log
    @search_service_log = SearchServiceLogs.find(params[:id])
  end

  def search_service_logs_params
    params.require(:search_service_log).permit( :name, :search_event, :time, :connected_users,
                                                 :searched_profiles, :ave_profile_search_time,
                                                 :all_tree_profiles, :all_profiles)
  end

end
