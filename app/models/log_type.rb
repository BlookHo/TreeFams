class LogType < ActiveRecord::Base

  validates_presence_of :type_number, :table_name, :message => "Должно присутствовать в LogType"

  validates_numericality_of :type_number, :greater_than => 0,  :message => "Должнo быть больше 0 в LogType"
  validates_numericality_of :type_number, :only_integer => true, :message => "Должнo быть целым числом в LogType"

  validates_inclusion_of :type_number, :in => [1,2,3,4], :message => "Должнo быть числом в диапазоне [1,2,3,4] в LogType"
  validates_inclusion_of :table_name, :in => ["adds_logs", "deletions_logs", "similars_logs", "connections_logs"],
                         :message => "Должнo быть именем из заданного списка в LogType"

  # Select name for current LogType
  def self.name_log_type(log_type)
    # logger.info "In LogType model name_log_type: log_type: #{log_type} "
    name_common_log = ""
    case log_type
      when 1
        name_common_log = "Добавлен профиль"
      when 2
        name_common_log = "Удален профиль"
      when 3
        name_common_log = "Объединение похожих"
      when 4
        name_common_log = "Объединение дерева"
      else
        logger.info "ERROR in LogType model: No name for log_type = #{log_type} "
    end
    name_common_log
  end




end
