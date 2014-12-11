class UpdatesFeedsController < ApplicationController
  before_action :set_update_feed, only: [:show, :edit, :update, :destroy]

  # GET /updates_feeds
  # GET /updates_feeds.json
  def index
    @updates_feeds = UpdatesFeed.all
  end

  # GET /updates_feeds/1
  # GET /updates_feeds/1.json
  def show
  end

  # GET /updates_feeds/new
  def new
    @updates_feed = UpdatesFeed.new
  end

  # GET /updates_feeds/1/edit
  def edit
  end

  # POST /updates_feeds
  # POST /updates_feeds.json
  def create
    @updates_feed = UpdatesFeed.new(update_feed_params)

    respond_to do |format|
      if @updates_feed.save
        format.html { redirect_to @updates_feed, notice: 'Update feed was successfully created.' }
        format.json { render :show, status: :created, location: @updates_feed }
      else
        format.html { render :new }
        format.json { render json: @updates_feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /updates_feeds/1
  # PATCH/PUT /updates_feeds/1.json
  def update
    respond_to do |format|
      if @updates_feed.update(update_feed_params)
        format.html { redirect_to @updates_feed, notice: 'Update feed was successfully updated.' }
        format.json { render :show, status: :ok, location: @updates_feed }
      else
        format.html { render :edit }
        format.json { render json: @updates_feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /updates_feeds/1
  # DELETE /updates_feeds/1.json
  def destroy
    @updates_feed.destroy
    respond_to do |format|
      format.html { redirect_to updates_feeds_url, notice: 'Update feed was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_update_feed
      @updates_feed = UpdatesFeed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def update_feed_params
      params.require(:update_feed).permit(:user_id, :update_id, :agent_user_id)
    end
end
