module ProfileApiCircles
  extend ActiveSupport::Concern

  # Ближний круг профиля для построения графиков
  def circles
    user_ids = self.owner_user.get_connected_users
    results = ProfileKey.where(user_id: user_ids, profile_id: self.id).where("relation_id < ?", 9).order('relation_id').includes(:name).to_a.uniq(&:is_profile_id)

    circles = profile_keys_to_hash(results)

    results.each do |key|
      tree_circle(user_ids, key.is_profile_id).each do |member|
        circles << tree_to_hash(member)
      end
    end

    return circles
  end


  # На выходе ближний круг для профиля в дереве user_id
  # по записям в Tree
  def tree_circle(user_ids, profile_id)
    Tree.where(user_id: user_ids, profile_id: profile_id).order('relation_id').includes(:name)
  end


  def profile_keys_to_hash(profile_keys)
    results = []
    center = {
      id: self.id,
      name: self.name.name,
      relation: "Центр",
      relation_id: 0
    }

    results << center

    profile_keys.each do |key|
      results << {
        id: key.is_profile_id,
        name: key.name.name,
        sex_id: key.name.sex_id,
        relation: key.relation.relation,
        relation_id: key.relation_id,
        target: self.id
      }
    end
    return results
  end



  # [{"id":10,"user_id":2,"profile_id":6,"relation_id":1,"connected":false,"created_at":null,"updated_at":null,"name_id":422,"is_profile_id":12,"is_name_id":465,"is_sex_id":1}]
  def tree_to_hash(tree)
    {
      id: 'c-'+tree.is_profile_id.to_s,
      name: tree.name.name,
      sex_id: tree.is_sex_id,
      relation: tree.relation.relation,
      relation_id: tree.relation_id,
      target: tree.profile_id,
      circle: 2
    }
  end


end
