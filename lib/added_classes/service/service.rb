class Service

  #############################################################
  # Иванищев А.В. 2016
  # @note: Сервисные (отладочные) Методы  - для ряда моделей и методов
  #############################################################

  # @note: service method in weekly email
  #   determine: whether at least one event necessary to send weekly email - exists
  # @input: events = { new_conn_requests_exists: @new_conn_requests_exists,
  #     new_connections_exists: @new_connections_exists,
  #     new_profiles_exists: @new_profiles_exists }
  # todo: place this into service class
  def self.check_all_events_exists?(events)
    events.each do |name, truefalse|
      return true if truefalse
    end
    false
  end




end
