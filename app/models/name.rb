class Name < ActiveRecord::Base

  validates :name,
            presence: true,
            uniqueness: true

  # Нельзя сохранить имя, не указав пол
  # 1 - муж, 0 - жен
  validates :sex_id, inclusion: [0, 1]


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
