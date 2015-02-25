module ProfileApiCircles
  extend ActiveSupport::Concern

  def circles(current_user = nil, max_distance)

    @results = []
    @max_distance = max_distance.to_i
    @except_ids = []
    @current_distance = 1

    logger.info "START CIRCLES WITH: max_distance: #{@max_distance} ==============="

    tree_id = self.tree_id

    # user_ids = User.find(tree_id).get_connected_users
    # ???
    # user_ids = []
    center_node = center_node(current_user)

    # первое колено
    first_circle = get_circle(profile_id: self.id)
    @results << circle_to_hash(circle: first_circle, target: self.id, current_user: current_user)


    if @current_distance >= @max_distance
      return  @results.unshift(center_node).flatten
    else
      @except_ids << first_circle.map {|r| r.is_profile_id }.push(self.id)
      @except_ids.uniq!
      collect_circles(circle: first_circle, current_user: current_user)
    end

    # Первый круг
    # circle = get_circle(user_ids: user_ids, profile_id: self.id)
    # @except_ids << circle.map {|r| r.is_profile_id }.push(self.id)
    # @results << circle_to_hash(circle: circle, distance: 1, target: self.id, current_user: current_user)


    # collect_circles(circle: circle, current_user: current_user)

    return  @results.unshift(center_node).flatten
  end


  # NEW


  def collect_circles(circle: circle, current_user: current_user)

    logger.info "BEFORE: current_distance: #{@current_distance} ==============="
    logger.info "BEFORE: max_distance: #{@max_distance} ==============="
    logger.info "COMPARE: distances: #{ @current_distance >= @max_distance } ==============="

    if @current_distance >= @max_distance
      logger.info "STOP STOP STOP"
      return nil
    end

    circle.each do |key|

      logger.info "INSIDE: current_distance: #{@current_distance} ==============="
      logger.info "INSIDE: max_distance: #{@max_distance} ==============="

      current_circle = get_circle(profile_id: key.is_profile_id, except_ids: @except_ids)
      @except_ids << current_circle.map {|r| r.is_profile_id }.push(key.is_profile_id)
      @results << circle_to_hash(circle: current_circle, target: key.is_profile_id, current_user: current_user)

      @except_ids.uniq!

      if current_circle.size > 0 and @current_distance < @max_distance
        collect_circles(
                        circle: current_circle,
                        current_user: current_user)
      end
    end
    @current_distance += 1

    logger.info "AFTER: current_distance: #{@current_distance} ==============="
    logger.info "AFTRE: max_distance: #{@max_distance} ==============="
  end





  def ORG_collect_circles(user_ids: user_ids, circle: circle, except_ids: except_ids, current_user: current_user, current_distance: current_distance )
    return if current_distance >= @max_distance
    current_distance += 1
    circle.each do |key|
      logger.info("====run get_circle==============MAX==dist: #{@max_distance}============================")
      logger.info("====run get_circle================dist: #{current_distance}============================")
      current_circle = get_circle(user_ids: user_ids, profile_id: key.is_profile_id, except_ids: @except_ids)
      @except_ids << current_circle.map {|r| r.is_profile_id }.push(key.is_profile_id)
      @results << circle_to_hash(circle: current_circle, distance: current_distance, target: key.is_profile_id, current_user: current_user)
      @except_ids.uniq!

      if current_circle.size > 0
        collect_circles(user_ids: user_ids,
                        circle: current_circle,
                        except_ids: @except_ids,
                        current_user: current_user,
                        current_distance: current_distance)
      end
    end
    @current_distance += 1
  end




  def get_circle(profile_id: profile_id, except_ids: [])
    ProfileKey.where("profile_id = ? AND relation_id < 9", profile_id).distinct
              .where.not(is_profile_id: @except_ids)
              .order('relation_id')
  end


  def org_get_circle(user_ids: user_ids, profile_id: profile_id, except_ids: [])
    ProfileKey.where(user_id: user_ids, profile_id: profile_id).distinct
              .where("relation_id < ?", 9)
              .where.not(is_profile_id: @except_ids).distinct
              .order('relation_id')
              .includes(:name, :profile).to_a.uniq(&:is_profile_id)
  end



  def center_node(current_user)
    {
      id: self.id,
      name: self.to_name,
      display_name: self.full_name,
      relation: "Центр круга",
      relation_id: 0,
      is_relation: nil,
      is_relation_id: nil,
      distance: 0,
      current_user_profile: current_user.try(:profile_id) == self.id,
      icon: self.icon_path,
      avatar: self.avatar_path(:round_thumb),
      # has_rights: (user_ids.include? self.tree_id),
      user_id: (self.user_id ? self.user_id : false)
    }
  end



  def org_center_node(current_user, user_ids)
    {
      id: self.id,
      name: self.to_name,
      display_name: self.full_name,
      relation: "Центр круга",
      relation_id: 0,
      is_relation: nil,
      is_relation_id: nil,
      distance: 0,
      current_user_profile: current_user.try(:profile_id) == self.id,
      icon: self.icon_path,
      avatar: self.avatar_path(:round_thumb),
      has_rights: (user_ids.include? self.tree_id),
      user_id: (self.user_id ? self.user_id : false)
    }
  end



  def circle_to_hash(circle: circle, target: nil, current_user: current_user)
    results = []
    circle.each do |key|
      is_rel = Relation.reverse_by_name_id(name_id: key.name_id, relation_id: key.relation_id)
      results << {
        id: key.is_profile_id,
        name: key.name.name,
        display_name: key.full_name,
        sex_id: key.name.sex_id,
        relation: key.relation.relation,
        relation_id: key.relation_id,
        is_relation: Relation.name_by_id(is_rel),
        is_relation_id: is_rel,
        target: target.nil? ? self.id : target,
        distance: @current_distance,
        current_user_profile: current_user.try(:profile_id) == key.is_profile_id,
        icon: key.is_profile.icon_path,
        avatar: key.is_profile.avatar_path(:round_thumb),
        user_id: (key.is_profile.user_id ? key.is_profile.user_id : false)
      }
    end
    return results
  end



  def ORG_circle_to_hash(circle: circle, distance: distance, target: nil, current_user: current_user)
    results = []
    circle.each do |key|
      is_rel = Relation.reverse_by_name_id(name_id: key.name_id, relation_id: key.relation_id)
      results << {
        id: key.is_profile_id,
        name: key.name.name,
        display_name: key.full_name,
        sex_id: key.name.sex_id,
        relation: key.relation.relation,
        relation_id: key.relation_id,
        is_relation: Relation.name_by_id(is_rel),
        is_relation_id: is_rel,
        target: target.nil? ? self.id : target,
        distance: distance,
        current_user_profile: current_user.try(:profile_id) == key.is_profile_id,
        icon: key.is_profile.icon_path,
        avatar: key.is_profile.avatar_path(:round_thumb),
        user_id: (key.is_profile.user_id ? key.is_profile.user_id : false)
      }
    end
    return results
  end


end
