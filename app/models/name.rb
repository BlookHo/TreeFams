class Name < ActiveRecord::Base

  has_many :subnames

  # Имя не может быть пустым
  # и должно быть уникальным
  validates :name,
            presence: true,
            uniqueness: true

  # Нельзя сохранить имя, не указав пол
  # 1 - муж, 2 - жен
  validates :sex_id, inclusion: [0, 1]

  # Утвержденные админом
  scope :approved, -> { where(is_approved: true) }

  # Ожидают утверждения
  scope :pending, -> { where(is_approved: false) }

  # Только мужские
  scope :male, -> { where(sex_id: 1) }

  # Только женские
  scope :female, -> { where(sex_id: 0).where.not(name: "Не известно") }

  # Женский, включает имя "не известно"
  scope :female_extended, -> { where(sex_id: 0) }





  def to_name
    name.try(:mb_chars).try(:capitalize)
  end

end
