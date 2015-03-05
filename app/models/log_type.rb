class LogType < ActiveRecord::Base

  validates_presence_of :type_number, :table_name, :message => "Должно присутствовать в LogType"

  validates_numericality_of :type_number, :greater_than => 0,  :message => "Должнo быть больше 0 в LogType"
  validates_numericality_of :type_number, :only_integer => true, :message => "Должнo быть целым числом в LogType"

  validates_inclusion_of :type_number, :in => [1,2,3,4], :message => "Должнo быть числом в диапазоне [1,2,3,4] в LogType"
  validates_inclusion_of :table_name, :in => ["adds_logs", "deletions_logs", "similars_logs", "connections_logs"],
                         :message => "Должнo быть именем из заданного списка в LogType"

end
