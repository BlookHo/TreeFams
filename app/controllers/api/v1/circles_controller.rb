module Api
  module V1
    class CirclesController < ApiController

      respond_to :json

      # /api/v1/circles
      # принмает параметры:
      # profile_id - id центрального профиля, для которого будут собраны круги родственников
      # fixed: путь возвращается к первому валдельцу дерева
      # access_token - токен текущено пользователя
      #
      # ответ в формате json
      # {circles:[], path:[]}

      def show
        profile = Profile.find(params[:profile_id])
        max_distance = params[:max_distance]

        results_circles = profile.circles(api_current_user, max_distance)

        tree_owner_ids = profile.owner_user.get_connected_users
        tree_owner_profile_id = get_tree_owner_user(tree_owner_ids).profile_id

        # Если автор в центре, то путь к нему собирется из его круга (пути нет, собственно)
        if (profile.id == current_user.profile_id)
          path = find_path(from_profile_id: tree_owner_profile_id, data: results_circles)
        else
          path = find_path(from_profile_id: tree_owner_profile_id, data: profile.circles(api_current_user, 10))
        end

        circle_author = find_current_circle_author(path)

        respond_with circles: results_circles,
                     path: path,
                     tree_owner_ids: tree_owner_ids,
                     cirlce_author: circle_author
      end




      def get_tree_owner_user(tree_owner_ids)
        if tree_owner_ids.include? api_current_user.id
          user =  api_current_user
        else
          user = User.find(tree_owner_ids.first)
        end
        return user
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

      # Возвращяет профиль и отношение
      # к текущему центральному профилю
      # Можно рассматривать как текщий путь минус один шаг назад
      # возвращяет id профиля и его отношение к текущему профилю в центре
      # используется для генерации вопросов при добавлении нестандартных отношений
      def find_current_circle_author(path)
        if path.size <= 1
          {
            author_profile_id: path.first[:id],
            base_relation_id: 0,
          }
        else
          {
            author_profile_id: path[path.size - 2][:id],
            base_relation_id: path[path.size - 2][:is_relation_id],
          }
        end
      end


      def find_path(from_profile_id: from_profile_id, data: data)
        path = []
        path << data.select { |d| d[:id] == from_profile_id }.first
        while path.last[:target]
          path << data.select {|d| d[:id] == path.last[:target]}.first
        end
        return path
      end


    end
  end
end
