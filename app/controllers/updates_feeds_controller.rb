class UpdatesFeedsController < ApplicationController

  # GET /updates_feeds_path
  # Переход к выбору обновлений для показа тебе: current_user
  def index
    @view_update_data = UpdatesFeed.select_updates(current_user)
    logger.info "In index: @view_update_data = #{@view_update_data} "

  end



end
