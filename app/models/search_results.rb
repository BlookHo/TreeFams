class SearchResults < ActiveRecord::Base

  validates_presence_of :user_id, :found_user_id, :profile_id, :found_profile_id, :count, :found_profile_ids,
                        :searched_profile_ids, :counts,
                        :message => "Должно присутствовать в SearchResults"
  validates_numericality_of :user_id, :found_user_id, :profile_id, :found_profile_id, :count, :pending_connect,
                            :only_integer => true,
                            :message => "Должны быть целым числом в SearchResults"
  validates_numericality_of :user_id, :found_user_id, :profile_id, :found_profile_id, :count,
                            :greater_than => 0,
                            :message => "Должны быть больше 0 в SearchResults"
  validates_numericality_of :connection_id, :only_integer => true, :greater_than => 0, allow_nil: true,
                            :message => "Должно быть больше 0 и целым числом, если существует, в SearchResults"
  validates_inclusion_of :pending_connect, :in => [0, 1],
                         :message => ":pending_connect должно быть [0, 1] в SearchResults"

  # custom validation

  validate :count_value_more_certain  # :count

  def count_value_more_certain
    certain_koeff = 4 #WeafamSetting.first.certain_koeff
    self.errors.add(:search_results, 'Макс. кол-во отношений не должно быть меньше, чем настройка в WeafamSetting.') if self.count < certain_koeff
  end

  validate :searched_n_found_users_unequal  # :user_id  AND :found_user_id

  def searched_n_found_users_unequal
    self.errors.add(:search_results, 'Юзеры в одном ряду не должны быть равны в SearchResults.') if self.user_id == self.found_user_id
  end

  validate :search_found_profiles_unequal  # :profile_id  AND :found_profile_id

  def search_found_profiles_unequal
    self.errors.add(:search_results, 'Профили в одном ряду не должны быть равны в SearchResults.') if self.profile_id == self.found_profile_id
  end


  validate :validate_found_profile_ids
  validate :validate_searched_profile_ids
  validate :validate_counts

  def validate_found_profile_ids
    unless found_profile_ids.is_a?(Array) # || wdays.detect{|d| !(0..6).include?(d)}
      errors.add(:found_profile_ids, :invalid)
    end
  end

  def validate_searched_profile_ids
    unless searched_profile_ids.is_a?(Array)
      errors.add(:searched_profile_ids, :invalid)
    end
  end

  def validate_counts
    unless counts.is_a?(Array)
      errors.add(:counts, :invalid)
    end
  end


  # @note: Удаление SearchResults, относящихся к проведенному объединению между двумя деревьями
  def self.destroy_previous_results(who_connect_arr, with_whom_connect_arr)
    previous_results1 = self.where("user_id in (?)", who_connect_arr).where("found_user_id in (?)", with_whom_connect_arr)
    previous_results1.each(&:destroy) unless previous_results1.blank?
    previous_results2 = self.where("user_id in (?)", with_whom_connect_arr).where("found_user_id in (?)", who_connect_arr)
    previous_results2.each(&:destroy) unless previous_results2.blank?

  end









end
