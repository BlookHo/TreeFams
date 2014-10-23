module Api
  module V1
    class SearchController < ApiController

      respond_to :json

      def index
        respond_with api_current_user
      end

    end
  end
end
