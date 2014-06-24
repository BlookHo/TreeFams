class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :name
  has_many   :trees

  attr_accessor :profile_name, :relation_id

  before_save do
    self.sex_id = name.try(:sex_id)
  end

  def to_name
    name.try(:name).try(:mb_chars).try(:capitalize)
  end


  def circle(user_id)
    circle = []
    #<Tree id: nil, user_id: nil, profile_id: nil, relation_id: nil,
    # connected: false, created_at: nil, updated_at: nil, name_id: nil,
    # is_profile_id: nil, is_name_id: nil, is_sex_id: nil>
    # circle << Tree.new(
    #     user_id: user_id,
    #     profile_id: self.id,
    #     relation_id: 0,
    #     name_id: self.name_id,
    #     is_profile_id: 0,
    #     is_name_id: self.name_id,
    #     is_sex_id: self.sex_id)

    # circle << Tree.where(user_id: user_id, relation_id: 0).first

    ProfileKey.where(user_id: user_id, profile_id: self.id).includes(:name).each do |p_key|
      circle << p_key
    end
    return circle
  end

  # На выходе ближний круг для профиля в дереве user_id
  def dcircle(user_id)
    Tree.where(user_id: user_id, profile_id: self.id).includes(:name)
  end

  # На выходе - массив, аналогичный tree, который у нас сейчас формируется на старте.
  # [[ user_id, profile_id, name_id, relation_id , is_profile_id , is_name_id , is_sex_id  ]]
  def circle_as_array(user_id)
    circle(user_id).map {|t|  [t.user_id, t.profile_id, t.name_id, t.relation_id, t.is_profile_id, t.is_name_id, t.is_sex_id] }
  end

  def circle_as_hash(user_id)
    {
      mothers: mothers_hash(user_id),
      fathers: fathers_hash(user_id),
      sons: sons_hash(user_id),
      daughters: daughters_hash(user_id),
      brothers: brothers_hash(user_id),
      sisters: sisters_hash(user_id),
      husbands: husbands_hash(user_id),
      wives: wives_hash(user_id)
    }
  end


  def mothers(user_id)
    mothers = []
    circle(user_id).each do |m|
      mothers << m if m.relation_id == 2
    end
    return mothers
  end

  #  { profile_id => name_id, profile_id => name_id, ... }
  def mothers_hash(user_id)
    hash = {}
    mothers(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end


  def fathers(user_id)
    fathers = []
    circle(user_id).each do |m|
      fathers << m if m.relation_id == 1
    end
    return fathers
  end

  #  { profile_id => name_id, profile_id => name_id, ... }
  def fathers_hash(user_id)
    hash = {}
    fathers(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end


  def sons(user_id)
    sons = []
    circle(user_id).each do |m|
      sons << m if m.relation_id == 3
    end
    return sons
  end


  #  { profile_id => name_id, profile_id => name_id, ... }
  def sons_hash(user_id)
    hash = {}
    sons(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end



  def daughters(user_id)
    daughters = []
    circle(user_id).each do |m|
      daughters << m if m.relation_id == 4
    end
    return daughters
  end


  #  { profile_id => name_id, profile_id => name_id, ... }
  def daughters_hash(user_id)
    hash = {}
    daughters(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end


  def brothers(user_id)
    brothers = []
    circle(user_id).each do |m|
      brothers << m if m.relation_id == 5
    end
    return brothers
  end


  #  { profile_id => name_id, profile_id => name_id, ... }
  def brothers_hash(user_id)
    hash = {}
    brothers(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end


  def sisters(user_id)
    sisters = []
    circle(user_id).each do |m|
      sisters << m if m.relation_id == 6
    end
    return sisters
  end


  #  { profile_id => name_id, profile_id => name_id, ... }
  def sisters_hash(user_id)
    hash = {}
    sisters(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end



  def husbands(user_id)
    husbands = []
    circle(user_id).each do |m|
      husbands << m if m.relation_id == 7
    end
    return husbands
  end


  #  { profile_id => name_id, profile_id => name_id, ... }
  def husbands_hash(user_id)
    hash = {}
    husbands(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end


  def wives(user_id)
    wives = []
    circle(user_id).each do |m|
      wives << m if m.relation_id == 8
    end
    return wives
  end


  #  { profile_id => name_id, profile_id => name_id, ... }
  def wives_hash(user_id)
    hash = {}
    wives(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end






end
