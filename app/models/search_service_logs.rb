class SearchServiceLogs < ActiveRecord::Base

  #############################################################
  # Иванищев А.В. 2016
  # Сервисные Результаты поиска - время, события и т.п.
  #############################################################
  # Расчет параметров результатов поиска и сохранение в БД
  # @note: Here is the storage of SearchResults timing and events methods
  #############################################################

  validates_presence_of :name, :search_event, :time, :connected_users, :searched_profiles, :ave_profile_search_time,
                        :all_tree_profiles, :all_profiles, :user_id,
                        :message => "Должно присутствовать в SearchServiceLogs"
  validates_numericality_of :search_event, :searched_profiles, :all_tree_profiles, :all_profiles, :user_id,
                            :only_integer => true, :greater_than => 0,
                            :message => "Должны быть целым числом and > 0 в SearchServiceLogs"
  validates_numericality_of :time, :ave_profile_search_time,
                            :greater_than => 0,
                            :message => "Должны быть числом and > 0 в SearchServiceLogs"
  validates_inclusion_of :search_event, :in => [1,2,3,4,5,6,7,100],
                         :message => "Должнo быть числом в диапазоне [1,2,3,4,5,6,7, 100] в SearchServiceLogs"



  validate :validate_connected_users
  def validate_connected_users
    unless connected_users.is_a?(Array)
      errors.add(:connected_users, :invalid)
    end
  end

  #Scopes
  # use in self.one_result_destroy
  # scope :one_way_result, -> (user_id, found_user_id) {where("user_id in (?)", user_id).
  #                                                     where("found_user_id in (?)", found_user_id)}
  # scope :one_way_result,     -> (connected_users) {where("user_id in (?)", connected_users)}
  # scope :one_opp_way_result, -> (connected_users) {where("found_user_id in (?)", connected_users)}

  # @note: to generate the CSV data
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |search_log|
        csv << search_log.attributes.values_at(*column_names)
      end
    end
  end


  # @note: Store one row of search tome result for given data:
  # store_log_data = { search_event:            search_event,
  #                    time:                    search_time,
  #                    connected_users:         connected_users,
  #                    searched_profiles:       tree_profiles.size }
  #   name - created from LogType
  #   ave_profile_search_time - средняя длит-ть поиска на один профиль - вычисляется
  #   all_profiles - все профили на сайте - из статистики last row.
  def self.store_search_time_log(store_log_data)
    search_event      = store_log_data[:search_event]
    time              = store_log_data[:time]
    connected_users   = store_log_data[:connected_users]
    user_id           = store_log_data[:user_id]
    searched_profiles = store_log_data[:searched_profiles] # selected searched tree_profiles.size
    all_tree_profiles = store_log_data[:all_tree_profiles] # all profiles qty in tree

    name = LogType.name_log_type(search_event)
    logger.info "In SearchServiceLogs#store_search_time_log: Event name = #{name.inspect} "
    ave_profile_search_time = (time.fdiv(searched_profiles.to_f)).round(3)
    all_profiles = WeafamStat.last.profiles

    create({
           name:                    name,
           search_event:            search_event,
           time:                    time,
           connected_users:         connected_users,
           user_id:                 user_id,
           searched_profiles:       searched_profiles,
           ave_profile_search_time: ave_profile_search_time,
           all_tree_profiles:       all_tree_profiles,
           all_profiles:            all_profiles
           })
  end



end