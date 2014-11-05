module ProfileApiCircles
  extend ActiveSupport::Concern

  def circles(current_user = nil, max_distance = 5)
    @results = []
    @max_distance = max_distance
    @current_distance = 1

    tree_id = self.tree_id
    user_ids = User.find(tree_id).get_connected_users

    center_node = center_node(current_user, user_ids)

    # Первый круг
    circle = get_circle(user_ids: user_ids, profile_id: self.id)
    except_ids = circle.map {|r| r.is_profile_id }.push(self.id)
    @results << circle_to_hash(circle: circle, distance: 1, target: self.id, current_user: current_user)

    collect_circles(user_ids: user_ids,
                      circle: circle,
                  except_ids: except_ids,
                current_user: current_user,
                current_distance: 1)

    return  @results.unshift(center_node).flatten
  end




  def collect_circles(user_ids: user_ids, circle: circle, except_ids: except_ids, current_user: current_user, current_distance: current_distance )
    # return if @current_distance >= @max_distance
    current_distance += 1
    circle.each do |key|
      current_circle = get_circle(user_ids: user_ids, profile_id: key.is_profile_id, except_ids: except_ids)
      current_except_ids = current_circle.map {|r| r.is_profile_id }.push(key.is_profile_id)
      @results << circle_to_hash(circle: current_circle, distance: current_distance, target: key.is_profile_id, current_user: current_user)


      if current_circle.size > 0
        collect_circles(user_ids: user_ids,
                          circle: current_circle,
                      except_ids: current_except_ids,
                    current_user: current_user,
                current_distance: current_distance)
      end
    end
    # @current_distance += 1
  end




  def get_circle(user_ids: user_ids, profile_id: profile_id, except_ids: [])
    ProfileKey.where(user_id: user_ids, profile_id: profile_id)
              .where("relation_id < ?", 9)
              .where.not(is_profile_id: except_ids)
              .order('relation_id')
              .includes(:name).to_a.uniq(&:is_profile_id)
  end




  def center_node(current_user, user_ids)
    {
      id: self.id,
      name: self.name.name,
      relation: "Центр круга",
      relation_id: 0,
      distance: 0,
      current_user_profile: current_user.try(:profile_id) == self.id,
      icon: self.icon_path,
      has_rights: (user_ids.include? self.tree_id)
    }
  end



  def circle_to_hash(circle: circle, distance: distance, target: nil, current_user: current_user)
    results = []
    circle.each do |key|
      results << {
        id: key.is_profile_id,
        name: key.name.name,
        sex_id: key.name.sex_id,
        relation: key.relation.relation,
        relation_id: key.relation_id,
        target: target.nil? ? self.id : target,
        distance: distance,
        current_user_profile: current_user.try(:profile_id) == key.is_profile_id,
        icon: key.is_profile.icon_path
      }
    end
    return results
  end


end
