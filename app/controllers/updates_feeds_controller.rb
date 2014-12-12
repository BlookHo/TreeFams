class UpdatesFeedsController < ApplicationController

  # GET /updates_feeds_path
  def index
    @updates_feeds = UpdatesFeed.select_updates(current_user)
    logger.info "In index: @updates_feeds = #{@updates_feeds} "

  end



end
