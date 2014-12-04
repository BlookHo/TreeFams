class Name < ActiveRecord::Base

  validates :name,
            presence: true,
            uniqueness: true

  # Нельзя сохранить имя, не указав пол
  # 1 - муж, 0 - жен
  validates :sex_id, inclusion: [0, 1]

  # Пол имен синонимов должен соответствовать полу главного имени
  validate :children_sex

  def children_sex
    unless parent_name_id.nil?
      parent_name = Name.find(parent_name_id)
      errors.add(:sex_id, "Должен соответствовать главному имени") if parent_name.sex_id != sex_id
    end
  end


  # Имя, у которого есть синонимы нельзя сделать синонимом
  validate :allow_set_parent_name_id


  def allow_set_parent_name_id
    unless self.synonyms.empty?
      errors.add(:parent_name_id, "Имя у которого уже есть синонимы, нельзя сделать синонимом.")
    end
  end



  after_save :set_search_name_id
  def set_search_name_id
    if parent_name_id.nil?
      self.update_column(:search_name_id, self.id)
    else
      self.update_column(:search_name_id,  name.parent_name_id)
    end
  end



  has_one :parent_name,
          class_name: "Name",
          primary_key: :parent_name_id,
          foreign_key: :id


  has_many :synonyms,
           class_name: "Name",
           foreign_key: :parent_name_id


  # Сортировка по умолчанию по алфавиту
  default_scope { order('name') }

  # Только главные имена
  scope :parent_names, -> { where(parent_name_id: nil) }

  # Только мужские
  scope :males, -> { where(sex_id: 1) }

  # Только женские
  scope :females, -> { where(sex_id: 0) }


  # Утвержденные админом
  # scope :approved, -> { where(is_approved: true) }

  # Ожидают утверждения
  # scope :pending, -> { where(is_approved: false) }


  def to_name
    name.try(:mb_chars).try(:capitalize)
  end

end
