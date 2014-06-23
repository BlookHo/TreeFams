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

  # На выходе ближний круг для профоля в дереве user_id
  def circle(user_id)
    Tree.where(user_id: user_id, profile_id: self.id).includes(:name)
  end

  # На выходе - массив, аналогичный tree, который у нас сейчас формируется на старте.
  # [[ user_id, profile_id, name_id, relation_id , is_profile_id , is_name_id , is_sex_id  ]]
  def circle_as_array(user_id)
    circle(user_id).map {|t|  [t.user_id, t.profile_id, t.name_id, t.relation_id, t.is_profile_id, t.is_name_id, t.is_sex_id] }
  end


end
