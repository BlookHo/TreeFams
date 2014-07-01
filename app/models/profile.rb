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


  def full_name
    [self.to_name, self.surname].join(' ')
  end

  # Ближний круг для профиля в дереве юзера
  # по записям в ProfileKey
  def circle(user_id)

    results = ProfileKey.where(user_id: user_id, profile_id: self.id).order('relation_id').includes(:name)

    # http://stackoverflow.com/questions/801824/clean-way-to-find-activerecord-objects-by-id-in-the-order-specified

    # result_hash = results.each_with_object({}) {|result,result_hash| result_hash[result.id] = result }
    # ids.map {|id| result_hash[id]}

    # position_list =
    # sorted_result = position_list.collect {|position_id| result.detect {|p| puts position_id } }
    # # logger.info "========== Position list"
    # # logger.info position_list
    # logger.info "========== CIRCLE"
    # logger.info  result.each {|c| puts "#{c.id} - #{c.relation_id}"}
    # logger.info "========== Sorted CIRCLE"
    # logger.info  sorted_result.each {|c| puts "#{c.id} - #{c.relation_id}"}

    return results
  end

  # На выходе ближний круг для профиля в дереве user_id
  # по записям в Tree
  def tree_circle(user_id, profile_id)
    Tree.where(user_id: user_id, profile_id: profile_id).order('relation_id').includes(:name)
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
