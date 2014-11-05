module Api
  module V1
    class CirclesController < ApiController

      respond_to :json


      # /api/v1/circles
      # принмает параметры:
      # profile_id - id центрального профиля, для которого будут собраны круги родственников
      # path_from_profile_id - id профиля от котрого вернуть путь к центральному профилю
      # access_token - токен текущено пользователя
      #
      # ответ в формате json
      # {circles:[], path:[]}

      def show
        profile = Profile.find(params[:profile_id])
        circles = profile.circles(api_current_user)
        tree_owner_ids = profile.owner_user.get_connected_users
        path = find_path(from_profile_id: params[:path_from_profile_id].to_i, data: circles)
        respond_with circles: circles, path: path, tree_owner_ids: tree_owner_ids
      end



    #   [
    #    {:id=>5,  :name=>"Алексей",   :distance=>0},
    #    {:id=>6,  :name=>"Сергей",    :target=>5  },
    #    {:id=>7,  :name=>"Алла",      :target=>5  },
    #    {:id=>10, :name=>"Лука",      :target=>5  },
    #    {:id=>9,  :name=>"Макар",     :target=>5  },
    #    {:id=>8,  :name=>"Никита",    :target=>5  },
    #    {:id=>11, :name=>"Вероника",  :target=>5  },
    #    {:id=>12, :name=>"Федор",     :target=>6  },
    #    {:id=>24, :name=>"Валентина", :target=>6  },
    #    {:id=>25, :name=>"Александр", :target=>6  },
    #    {:id=>31, :name=>"Егор",      :target=>25 },
    #    {:id=>30, :name=>"Ксения",    :target=>25 }
    #  ]

      private

      def find_path(from_profile_id: from_profile_id, data: data)
        path = []
        path << data.select { |d| d[:id] == from_profile_id }.first
        while path.last[:target]
          path << data.select {|d| d[:id] == path.last[:target]}.first
        end
        return path
      end



      def tree_owners(profile)

      end


    end
  end
end
