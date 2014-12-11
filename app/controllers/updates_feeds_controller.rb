class UpdatesFeedsController < ApplicationController

  # GET /updates_feeds
  # GET /updates_feeds.json
  def index
    @updates_feeds = UpdatesFeed.all
  end



end
