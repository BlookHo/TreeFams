class UpdatesEventsController < ApplicationController
  before_action :set_updates_event, only: [:show, :edit, :update, :destroy]

  # GET /updates_events
  # GET /updates_events.json
  def index
    @updates_events = UpdatesEvent.all
  end

  # GET /updates_events/1
  # GET /updates_events/1.json
  def show
  end

  # GET /updates_events/new
  def new
    @updates_event = UpdatesEvent.new
  end

  # GET /updates_events/1/edit
  def edit
  end

  # POST /updates_events
  # POST /updates_events.json
  def create
    @updates_event = UpdatesEvent.new(updates_event_params)

    respond_to do |format|
      if @updates_event.save
        format.html { redirect_to @updates_event, notice: 'Updates event was successfully created.' }
        format.json { render :show, status: :created, location: @updates_event }
      else
        format.html { render :new }
        format.json { render json: @updates_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /updates_events/1
  # PATCH/PUT /updates_events/1.json
  def update
    respond_to do |format|
      if @updates_event.update(updates_event_params)
        format.html { redirect_to @updates_event, notice: 'Updates event was successfully updated.' }
        format.json { render :show, status: :ok, location: @updates_event }
      else
        format.html { render :edit }
        format.json { render json: @updates_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /updates_events/1
  # DELETE /updates_events/1.json
  def destroy
    @updates_event.destroy
    respond_to do |format|
      format.html { redirect_to updates_events_url, notice: 'Updates event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_updates_event
      @updates_event = UpdatesEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def updates_event_params
      params.require(:updates_event).permit(:name, :image)
    end
end
