class LogType < ActiveRecord::Base

  validates_presence_of :type_number, :table_name, :message => "Должно присутствовать в LogType"

  validates_numericality_of :type_number, :greater_than => 0,  :message => "Должнo быть больше 0 в LogType"
  validates_numericality_of :type_number, :only_integer => true, :message => "Должнo быть целым числом в LogType"

  validates_inclusion_of :type_number, :in => [1,2,3,4,5,6,7,100], :message => "Должнo быть числом в диапазоне [1,2,3,4,5,6,7] в LogType"
  validates_inclusion_of :table_name, :in => ["adds_logs", "deletions_logs", "similars_logs", "connections_logs",
                                              "renames_logs", "sign_ups", "rollbacks common_logs", "home in rails"],
                         :message => "Должнo быть именем из заданного списка в LogType"

  # Select name for current LogType
  def self.name_log_type(log_type)
    # logger.info "In LogType model name_log_type: log_type: #{log_type} "
    # name_event = ""
    case log_type
      when 1
        name_event = "Добавлен профиль"
      when 2
        name_event = "Удален профиль"
      when 3
        name_event = "Объединение похожих"
      when 4
        name_event = "Объединение деревьев"
      when 5
        name_event = "Переименован профиль"
      when 6
        name_event = "Зарегистрирован новый юзер"
      when 7
        name_event = "Откат истории дерева"
      else
        name_event = "home in rails"
        # logger.info "home in rails  event = #{log_type} "
    end
    name_event
  end




end
