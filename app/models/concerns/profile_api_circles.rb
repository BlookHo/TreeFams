module ProfileApiCircles
  extend ActiveSupport::Concern

  def circles(current_user, max_distance)
    @max_distance = max_distance.to_i
    @current_distance = 1
    @results = []
    @except_ids = []

    # Center profile node
    center_node = center_node(current_user)

    # First circle (for center profile)
    first_circle = get_circle(profile_id: self.id)
    @results << circle_to_hash(circle: first_circle, target: self.id, current_user: current_user)
    @except_ids << first_circle.map {|r| r.is_profile_id }.push(self.id)

    # Other cirlces by distance
    collect_circles(circle: first_circle, current_user: current_user)

    # Push center node at top of results (grpah starts from first node)
    return  @results.unshift(center_node).flatten.uniq!
  end



  # Get circles data for profile
  def get_circle(profile_id: profile_id)
    ProfileKey.where("profile_id = ? AND relation_id < 9", profile_id)
              .where.not(is_profile_id: @except_ids.flatten.uniq!)
              .order('relation_id')
              .includes(:name, :display_name, :is_profile, :relation).distinct
  end



  # Format center profile for graph
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
      avatar: self.avatar_path(:round_thumb),
      # has_rights: (user_ids.include? self.tree_id),
      user_id: (self.user_id ? self.user_id : false)
    }
  end



  # Format profiles in cirlces for graph
  def circle_to_hash(circle: circle, target: nil, current_user: current_user)
    results = []
    circle.each do |key|
      is_rel = Relation.reverse_by_name_sex_id(sex_id: key.name.sex_id, relation_id: key.relation_id)
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
        avatar: key.is_profile.avatar_path(:round_thumb),
        user_id: (key.is_profile.user_id ? key.is_profile.user_id : false)
      }
    end
    return results
  end



  # Collect nesetd profile circles while mas_distance less then current_distance
  def collect_circles(circle: circle, current_user: current_user)
    return if @current_distance >= @max_distance
    circle.each do |key|
      current_circle = get_circle(profile_id: key.is_profile_id)
      @except_ids << current_circle.map {|r| r.is_profile_id }.push(key.is_profile_id)
      @results << circle_to_hash(circle: current_circle, target: key.is_profile_id, current_user: current_user)
      collect_circles(circle: current_circle, current_user: current_user) if current_circle.size > 0
    end
    @current_distance += 1
  end


end
