module ActiveRecord
  class Base
    def warnings
      @warnings ||= ActiveModel::Errors.new(self)
    end
    def complete?
      warnings.clear
      valid?
      warnings.empty?
    end
  end
end
