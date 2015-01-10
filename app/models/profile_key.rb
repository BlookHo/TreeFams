class ProfileKey < ActiveRecord::Base
  include ProfileKeysGeneration

  include SimilarsInitSearch # методы поиска стартовых пар похожих
  include SimilarsExclusions # методы учета отношений исключений

  include SearchHelper

  belongs_to :profile#, dependent: :destroy
  belongs_to :is_profile, foreign_key: :is_profile_id, class_name: Profile
  belongs_to :user
  belongs_to :name, foreign_key: :is_name_id
  belongs_to :display_name, class_name: Name, foreign_key: :is_display_name_id
  belongs_to :relation, primary_key: :relation_id


  def full_name
    [self.display_name.name, self.is_profile.last_name].join(' ')
  end

  # пересечение 2-х хэшей, у которых - значения = массивы
  def self.intersection(first, other)
    result = {}
    first.reject { |k, v| !(other.include?(k)) }.each do |k, v|
      intersect = other[k] & v
      result.merge!({k => intersect}) if !intersect.blank?
    end
    result
  end

  # пересечение 2-х хэшей, у которых - значения = массивы
  def self.unintersection(first, other)
    result = {}
    first.reject { |k, v| (other.include?(k)) }.each do |k, v|
     # intersect = other[k] & v
      result.merge!({k => v}) #if !intersect.blank?
    end
    result
  end

  # Наращивание массива значений Хаша для одного ключа
  # Если ключ - новый, то формирование новой пары.
  def self.growing_val_arr(hash, other_key, other_val )
    hash.keys.include?(other_key) ? hash[other_key] << other_val : hash.merge!({other_key => [other_val]})
    hash
  end



end
