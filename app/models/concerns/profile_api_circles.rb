module ProfileApiCircles
  extend ActiveSupport::Concern


  def logus(title, obj)
    logger.info "==#{title}======================================="
    logger.info "==#{obj}========================================="
    logger.info "================================================="
  end

  def circles(current_user, max_distance)
    @max_distance = max_distance.to_i
    @current_distance = 1
    @results = []
    @except_ids = [[self.id]]

    @user_ids = User.find(self.tree_id).get_connected_users

    # Center profile node
    center_node = center_node(current_user)

    # First circle (for center profile)
    first_circle = get_circle(profile_id: self.id)
    @results << circle_to_hash(circle: first_circle, target: self.id, current_user: current_user)

    # Manualy increment first step
    @current_distance += 1

    # collect another cirlces by distance
    collect_circles(circle: first_circle, current_user: current_user)

    # Push center node at top of results (grpah starts from first node)
    return  @results.unshift(center_node).flatten #.uniq!
  end



  # Collect nesetd profile circles while mas_distance less then current_distance
  def collect_circles(circle: circle, current_user: current_user, locale_distance: nil )

    return if @current_distance > @max_distance

    circle.each do |key|
      current_circle = get_circle(profile_id: key.is_profile_id)

      distance = locale_distance.nil? ? @current_distance : locale_distance

      @results << circle_to_hash(circle: current_circle, target: key.is_profile_id, current_user: current_user, distance: distance)

      if current_circle.size > 0
        collect_circles(circle: current_circle, current_user: current_user, locale_distance: distance + 1)
      end
    end
    @current_distance += 1 if locale_distance.nil? # если locale_distance  nil = значит мы не в основном цикле
  end



  # Get circles data for profile
  def get_circle(profile_id: profile_id)
    pks = ProfileKey.where(user_id: @user_ids)
                    .where(profile_id: profile_id)
                    .where('relation_id < 9')
                    .where.not(is_profile_id: @except_ids.flatten.uniq)
                    .order('relation_id')
                    .includes(:name, :display_name, :is_profile, :relation)
                    .select(:profile_id, :is_profile_id, :relation_id, :name_id, :is_name_id, :is_display_name_id).distinct
    @except_ids << pks.map {|r| r.is_profile_id }
    return pks
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
  def circle_to_hash(circle: circle, target: nil, current_user: current_user, distance: distance)
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
        distance: distance || @current_distance,
        current_user_profile: current_user.try(:profile_id) == key.is_profile_id,
        avatar: key.is_profile.avatar_path(:round_thumb),
        user_id: (key.is_profile.user_id ? key.is_profile.user_id : false)
      }
    end
    return results
  end





  # def ORG_collect_circles(user_ids: user_ids, circle: circle, except_ids: except_ids, current_user: current_user, current_distance: current_distance )
  #   return if current_distance >= @max_distance
  #   current_distance += 1
  #   circle.each do |key|
  #     current_circle = get_circle(user_ids: user_ids, profile_id: key.is_profile_id, except_ids: except_ids)
  #     @except_ids << current_circle.map {|r| r.is_profile_id }.push(key.is_profile_id)
  #     @results << circle_to_hash(circle: current_circle, distance: current_distance, target: key.is_profile_id, current_user: current_user)
  #
  #
  #     if current_circle.size > 0
  #       current_except_ids = nil
  #       collect_circles(user_ids: user_ids,
  #       circle: current_circle,
  #       except_ids: current_except_ids,
  #       current_user: current_user,
  #       current_distance: current_distance)
  #     end
  #   end
  #   # @current_distance += 1
  # end


end
