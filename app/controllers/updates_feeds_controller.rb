class UpdatesFeedsController < ApplicationController

  # GET /updates_feeds_path
  # Подготовка массива обновлений для показа тебе: current_user
  # Пагинация
  def index
    view_update_data = UpdatesFeed.select_updates(current_user)
    @paged_update_data = pages_of(view_update_data, 10) # Пагинация - по 10 строк на стр.(?)
    #logger.info "In index: @@paged_update_data.size = #{@paged_update_data.size} "
  end


end
