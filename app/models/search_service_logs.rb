class SearchServiceLogs < ActiveRecord::Base

  #############################################################
  # Иванищев А.В. 2016
  # Сервисные Результаты поиска - время, события и т.п.
  #############################################################
  # Расчет параметров результатов поиска и сохранение в БД
  # @note: Here is the storage of SearchResults timing and events methods
  #############################################################

  validates_presence_of :name, :search_event, :time, :connected_users, :searched_profiles, :ave_profile_search_time,
                        :message => "Должно присутствовать в SearchServiceLogs"
  validates_numericality_of :search_event, :searched_profiles,
                            :only_integer => true,
                            :message => "Должны быть целым числом в SearchServiceLogs"
  validates_numericality_of :time, :ave_profile_search_time,
                            :message => "Должны быть числом в SearchServiceLogs"

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


  # @note: Store one row of search tome result for given data:
  # store_log_data = { search_event:            search_event,
  #                    time:                    search_time,
  #                    connected_users:         connected_users,
  #                    searched_profiles:       tree_profiles.size }
  def self.store_search_time_log(store_log_data)
    search_event      = store_log_data[:search_event]
    time              = store_log_data[:time]
    connected_users   = store_log_data[:connected_users]
    searched_profiles = store_log_data[:searched_profiles] # tree_profiles.size

    name = LogType.name_log_type(search_event)
    logger.info "In SearchServiceLogs model #store_search_time_log : name = #{name.inspect} "

    ave_profile_search_time = (time.fdiv(searched_profiles.to_f)).round(2)
    create({
           name:                    name,
           search_event:            search_event,
           time:                    time,
           connected_users:         connected_users,
           searched_profiles:       searched_profiles,
           ave_profile_search_time: ave_profile_search_time
       })
  end



end