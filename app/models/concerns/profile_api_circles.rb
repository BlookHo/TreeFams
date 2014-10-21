module ProfileApiCircles
  extend ActiveSupport::Concern

  # Ближний круг профиля для построения графиков
  def circles(current_user_id: nil)
    user_ids = self.owner_user.get_connected_users
    results = ProfileKey.where(user_id: user_ids, profile_id: self.id).where("relation_id < ?", 9).order('relation_id').includes(:name).to_a.uniq(&:is_profile_id)

    # Ближний круг центрального профиля
    circles = profile_keys_to_hash(results, circle: 1)

    logger.info "CUrrent user id: #{current_user_id}"


    center_node = {
      id: self.id,
      name: self.name.name,
      relation: "Центр",
      relation_id: 0,
      circle: 0,
      current_user:  current_user_id == self.user_id
    }

    # Центральный профиль
    circles.unshift(center_node)


    except_ids =  results.map {|r| r.is_profile_id }
    except_ids << self.id


    results.each do |key|
      ad_results = ProfileKey.where(user_id: user_ids, profile_id: key.is_profile_id)
                             .where("relation_id < ?", 9)
                             .where.not(is_profile_id: except_ids)
                             .order('relation_id').includes(:name).to_a.uniq(&:is_profile_id)
      circles << profile_keys_to_hash(ad_results, circle: 2, target: key.is_profile_id, current_user_id: current_user_id)
    end

    return circles.flatten!
  end



  def profile_keys_to_hash(profile_keys, circle: circle, target: nil, current_user_id: current_user_id)
    results = []
    profile_keys.each do |key|
      results << {
        id: key.is_profile_id,
        name: key.name.name,
        sex_id: key.name.sex_id,
        relation: key.relation.relation,
        relation_id: key.relation_id,
        target: target.nil? ? self.id : target,
        circle: circle,
        current_user:  current_user_id == key.user_id
      }
    end
    return results
  end



end
