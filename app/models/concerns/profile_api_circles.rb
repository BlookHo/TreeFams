module ProfileApiCircles
  extend ActiveSupport::Concern

  # Ближний круг профиля для построения графиков
  def circles(current_user)
    user_ids = current_user.get_connected_users

    # Центральный профиль
    zero_circle = zero_circle(current_user)

    # Первый (ближний круг)
    second_circle = get_circle(user_ids: user_ids, profile_id: self.id)


    # Форматирование
    # Ближний круг центрального профиля
    circles = profile_keys_to_hash(second_circle, circle: 1, current_user: current_user)

    # Добавляем центральный профиль на ПЕРВУЮ ПОЗИЦИЮ
    # Центральный профиль (первая нода - центральная)
    circles.unshift(zero_circle)

    # Из второго круга исключаются профили, которые в первом круге
    except_ids =  second_circle.map {|r| r.is_profile_id }.push(self.id)


    # Для кождого профиля первого круга собирается его ближний круг, исключаю профили в предыдущем круге
    second_circle.each do |key|
      ad_results = get_circle(user_ids: user_ids, profile_id: key.is_profile_id, except_ids: except_ids)
      circles << profile_keys_to_hash(ad_results, circle: 2, target: key.is_profile_id, current_user: current_user)
    end

    return circles.flatten!
  end



  # Center profile
  def zero_circle(current_user)
    {
      id: self.id,
      name: self.name.name,
      relation: "Центр",
      relation_id: 0,
      circle: 0,
      current_user_profile: current_user.profile_id == self.id,
      icon: self.icon_path
    }
  end




  def get_circle(user_ids: user_ids, profile_id: profile_id, except_ids: [])
    ProfileKey.where(user_id: user_ids, profile_id: profile_id)
              .where("relation_id < ?", 9)
              .where.not(is_profile_id: except_ids)
              .order('relation_id')
              .includes(:name).to_a.uniq(&:is_profile_id)
  end




  # Форматирование рузультатов
  def profile_keys_to_hash(profile_keys, circle: circle, target: nil, current_user: current_user)
    results = []
    profile_keys.each do |key|
      logger.info "COnvert obj class: #{key.class}"
      results << {
        id: key.is_profile_id,
        name: key.name.name,
        sex_id: key.name.sex_id,
        relation: key.relation.relation,
        relation_id: key.relation_id,
        target: target.nil? ? self.id : target,
        circle: circle,
        current_user_profile: current_user.profile_id == key.is_profile_id,
        icon: key.is_profile.icon_path
      }
    end
    return results
  end



end
