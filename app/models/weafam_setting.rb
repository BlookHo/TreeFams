class WeafamSetting < ActiveRecord::Base

  validates_presence_of     :certain_koeff, :message => "Должно присутствовать в WeafamSetting"
  validates_numericality_of :certain_koeff, :only_integer => true, :message => "Значения коэфф-та достоверности - должны быть целым числом в WeafamSetting"
  validates_numericality_of :certain_koeff, :greater_than => 0, :message => "Значения коэфф-та достоверности - должны быть больше 0 в WeafamSetting"


end
